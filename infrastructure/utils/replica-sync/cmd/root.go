package cmd

import (
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
	"github.com/spf13/viper"
)

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "replica-sync",
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
	// Uncomment the following line if your bare application
	// has an action associated with it:
	// Run: func(cmd *cobra.Command, args []string) { },
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

func init() {
	cobra.OnInitialize(initConfig)
}

func initConfig() {
	if cfgFile != "" {
		viper.SetConfigFile(cfgFile)
	} else {
		viper.AddConfigPath(".")
		viper.SetConfigType("yaml")
		viper.SetConfigName("replica-sync")
	}

	viper.AutomaticEnv()
	viper.SetEnvPrefix("ODH_REPLICA_SYNC")
	viper.SetEnvKeyReplacer(strings.NewReplacer("-", "_", ".", "_"))

	if err := viper.ReadInConfig(); err != nil {
		if _, ok := err.(viper.ConfigFileNotFoundError); !ok {
			log.Fatal(err)
		}
	}
}
