package cmd

import (
	"context"
	"crypto/tls"
	"database/sql"
	"errors"
	"fmt"
	"log"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"github.com/noi-techpark/it.bz.opendatahub.sparql/infrastructure/utils/odh-vkg-sync/internal/cmd/root"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
	"github.com/spf13/viper"
	"github.com/uptrace/bun"
	"github.com/uptrace/bun/dialect/pgdialect"
	"github.com/uptrace/bun/driver/pgdriver"
	"go.uber.org/zap"
)

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "odh-vkg-sync",
	Short: "Synchronize the replica of the ODH database",
	Long: `Synchronize the replica with the ODH mobility database,
by dumping and restoring data.`,
	PersistentPreRun: func(cmd *cobra.Command, args []string) {
		cmd.Flags().VisitAll(func(f *pflag.Flag) {
			if !f.Changed && viper.IsSet(f.Name) {
				cmd.Flags().Set(f.Name, fmt.Sprintf("%v", viper.Get(f.Name)))
			}
		})
	},
	Run: func(cmd *cobra.Command, args []string) {
		fields := zap.Fields(
			zap.String("application", "odh-vkg-sync"),
			zap.String("version", version),
		)

		var (
			log *zap.Logger
			err error
		)

		if debug {
			log, err = zap.NewDevelopment(fields)
		} else {
			log, err = zap.NewProduction(fields)
		}

		if err != nil {
			fmt.Printf(
				"{%q:%q,%q:%q,%q:%q,%q:%f,%q:%q,%q:%q}",
				"application", "odh-vkg-sync",
				"version", version,
				"level", "fatal",
				"ts", float64(time.Now().UnixMilli())/1000,
				"msg", "error initializing zap logger",
				"error", err.Error(),
			)
			os.Exit(1)
		}

		mobilityPassword, err := parseSecret(mobilityPasswordStr, mobilityPasswordFile)

		if err != nil {
			log.Warn(
				"error reading secret file",
				zap.Error(err),
				zap.String("key", "mobility.password-file"),
				zap.String("path", mobilityPasswordFile),
			)
		}

		log.Info("connecting to mobility database")

		mobilityDB, err := openDatabase(
			mobilityDSN,
			mobilityNetwork, mobilityAddr,
			mobilityUser, mobilityPassword, mobilityDatabase,
			mobilitySSLMode,
			mobilityDialTimeout, mobilityReadTimeout, mobilityWriteTimeout,
		)

		if err != nil {
			log.Fatal("error opening mobility database", zap.Error(err))
		}

		err = mobilityDB.Ping()

		if err != nil {
			log.Fatal("error connecting to the mobility database", zap.Error(err))
		}

		replicaPassword, err := parseSecret(replicaPasswordStr, replicaPasswordFile)

		if err != nil {
			log.Warn(
				"error reading secret file",
				zap.Error(err),
				zap.String("key", "replica.password-file"),
				zap.String("path", replicaPasswordFile),
			)
		}

		log.Info("connecting to replica database")

		replicaDB, err := openDatabase(
			replicaDSN,
			replicaNetwork, replicaAddr,
			replicaUser, replicaPassword, replicaDatabase,
			replicaSSLMode,
			replicaDialTimeout, replicaReadTimeout, replicaWriteTimeout,
		)

		if err != nil {
			log.Fatal("error opening replica database", zap.Error(err))
		}

		err = replicaDB.Ping()

		if err != nil {
			log.Fatal("error connecting to the replica databases", zap.Error(err))
		}

		app := root.NewApplication(log, root.Options{
			MobilityDB: mobilityDB,
			ReplicaDB:  replicaDB,
		})

		ctx, cancel := context.WithCancel(cmd.Context())

		go func() {
			exit := make(chan os.Signal, 1)
			signal.Notify(exit, syscall.SIGINT, syscall.SIGTERM)

			<-exit
			log.Info("received shutdown signal, cancelling application context")

			cancel()
		}()

		log.Info("synchronizing database")
		app.Synchronize(ctx)
		log.Info("synchronization finished, waiting for interval before next run", zap.Duration("interval", interval))

		for {
			select {
			case <-time.After(interval):
				log.Info("synchronizing database")
				app.Synchronize(ctx)
				log.Info("synchronization finished, waiting for interval before next run", zap.Duration("interval", interval))
			case <-ctx.Done():
				log.Info("application is quitting")
				break
			}
		}
	},
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

var cfgFile string

var (
	debug    bool
	interval time.Duration

	mobilityDSN          string
	mobilityNetwork      string
	mobilityAddr         string
	mobilityUser         string
	mobilityPasswordStr  string
	mobilityPasswordFile string
	mobilityDatabase     string
	mobilitySSLMode      string
	mobilityDialTimeout  time.Duration
	mobilityReadTimeout  time.Duration
	mobilityWriteTimeout time.Duration

	replicaDSN          string
	replicaNetwork      string
	replicaAddr         string
	replicaUser         string
	replicaPasswordStr  string
	replicaPasswordFile string
	replicaDatabase     string
	replicaSSLMode      string
	replicaDialTimeout  time.Duration
	replicaReadTimeout  time.Duration
	replicaWriteTimeout time.Duration
)

func init() {
	cobra.OnInitialize(initConfig)

	rootCmd.Flags().StringVar(&cfgFile, "config", "", "config file (default is ./odh-vkg-sync.yaml)")

	rootCmd.Flags().BoolVar(&debug, "debug", false, "enable debug mode with enhanced logs")
	rootCmd.Flags().DurationVar(&interval, "internal", 5*time.Minute, "duration to wait between synchronization runs")

	rootCmd.Flags().StringVar(&mobilityDSN, "mobility.dsn", "", "mobility database DSN")
	rootCmd.Flags().StringVar(&mobilityNetwork, "mobility.network", "tcp", "mobility database network")
	rootCmd.Flags().StringVar(&mobilityAddr, "mobility.addr", "", "mobility database address")
	rootCmd.Flags().StringVar(&mobilityUser, "mobility.user", "", "mobility database user")
	rootCmd.Flags().StringVar(&mobilityPasswordStr, "mobility.password", "", "mobility user password")
	rootCmd.Flags().StringVar(&mobilityPasswordFile, "mobility.password-file", "", "mobility user password file")
	rootCmd.Flags().StringVar(&mobilityDatabase, "mobility.database", "", "mobility database name")
	rootCmd.Flags().StringVar(&mobilitySSLMode, "mobility.ssl-mode", "require", "mobility database ssl mode (verify-full|require|disable)")
	rootCmd.Flags().DurationVar(&mobilityDialTimeout, "mobility.timeout.dial", 5*time.Second, "mobility timeout for establishing new connections")
	rootCmd.Flags().DurationVar(&mobilityReadTimeout, "mobility.timeout.read", 10*time.Second, "mobility timeout for socket reads")
	rootCmd.Flags().DurationVar(&mobilityWriteTimeout, "mobility.timeout.write", 5*time.Second, "mobility timeout for socket writes")

	rootCmd.Flags().StringVar(&replicaDSN, "replica.dsn", "", "replica database DSN")
	rootCmd.Flags().StringVar(&replicaNetwork, "replica.network", "tcp", "replica database network")
	rootCmd.Flags().StringVar(&replicaAddr, "replica.addr", "", "replica database address")
	rootCmd.Flags().StringVar(&replicaUser, "replica.user", "", "replica database user")
	rootCmd.Flags().StringVar(&replicaPasswordStr, "replica.password", "", "replica user password")
	rootCmd.Flags().StringVar(&replicaPasswordFile, "replica.password-file", "", "replica user password file")
	rootCmd.Flags().StringVar(&replicaDatabase, "replica.database", "", "replica database name")
	rootCmd.Flags().StringVar(&replicaSSLMode, "replica.ssl-mode", "require", "replica database ssl mode (verify-full|require|disable)")
	rootCmd.Flags().DurationVar(&replicaDialTimeout, "replica.timeout.dial", 5*time.Second, "replica timeout for establishing new connections")
	rootCmd.Flags().DurationVar(&replicaReadTimeout, "replica.timeout.read", 10*time.Second, "replica timeout for socket reads")
	rootCmd.Flags().DurationVar(&replicaWriteTimeout, "replica.timeout.write", 5*time.Second, "replica timeout for socket writes")
}

func initConfig() {
	if cfgFile != "" {
		viper.SetConfigFile(cfgFile)
	} else {
		viper.AddConfigPath(".")
		viper.SetConfigType("yaml")
		viper.SetConfigName(".odh-vkg-sync")
	}

	viper.AutomaticEnv()
	viper.SetEnvPrefix("ODH_VKG_SYNC")
	viper.SetEnvKeyReplacer(strings.NewReplacer("-", "_", ".", "_"))

	if err := viper.ReadInConfig(); err != nil {
		if _, ok := err.(viper.ConfigFileNotFoundError); !ok {
			log.Fatal(err)
		}
	}
}

func parseSSLMode(sslMode string) (pgdriver.Option, error) {
	switch sslMode {
	case "verify-full":
		return pgdriver.WithTLSConfig(new(tls.Config)), nil
	case "require":
		return pgdriver.WithTLSConfig(&tls.Config{InsecureSkipVerify: true}), nil
	case "disable":
		return pgdriver.WithInsecure(true), nil
	default:
		return nil, fmt.Errorf("unknown ssl mode %q", sslMode)
	}
}

func parseSecret(plaintext, file string) (string, error) {
	if file == "" {
		return plaintext, nil
	}

	contents, err := os.ReadFile(file)

	if err != nil {
		return plaintext, err
	}

	return strings.TrimSpace(string(contents)), nil
}

func openDatabase(dsn, network, addr, user, password, database, sslMode string, dialTimeout, readTimeout, writeTimeout time.Duration) (*bun.DB, error) {
	if dsn != "" {
		sqldb := sql.OpenDB(pgdriver.NewConnector(pgdriver.WithDSN(dsn)))
		return bun.NewDB(sqldb, pgdialect.New()), nil
	} else {
		tlsConfig, err := parseSSLMode(sslMode)

		if err != nil {
			return nil, err
		}

		switch {
		case addr == "":
			return nil, errors.New("address is empty")
		case user == "":
			return nil, errors.New("user is empty")
		case database == "":
			return nil, errors.New("database is empty")
		}

		sqldb := sql.OpenDB(pgdriver.NewConnector(
			pgdriver.WithNetwork(network),
			pgdriver.WithAddr(addr),
			pgdriver.WithUser(user),
			pgdriver.WithPassword(password),
			pgdriver.WithDatabase(database),
			tlsConfig,
			pgdriver.WithDialTimeout(dialTimeout),
			pgdriver.WithReadTimeout(readTimeout),
			pgdriver.WithWriteTimeout(writeTimeout),
		))

		return bun.NewDB(sqldb, pgdialect.New()), nil
	}
}
