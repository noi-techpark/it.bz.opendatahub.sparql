package root

import (
	"bytes"
	"context"
	"database/sql"
	"fmt"

	"github.com/uptrace/bun"
	"github.com/uptrace/bun/driver/pgdriver"
	"go.uber.org/zap"
)

type Options struct {
	MobilityDB *bun.DB
	ReplicaDB  *bun.DB
}

type Application struct {
	log        *zap.Logger
	mobilityDB *bun.DB
	replicaDB  *bun.DB
}

func NewApplication(log *zap.Logger, opts Options) *Application {
	return &Application{
		log:        log,
		mobilityDB: opts.MobilityDB,
		replicaDB:  opts.ReplicaDB,
	}
}

func (app *Application) Main(ctx context.Context) {
	// ! DON'T CHANGE THE INSERTION ORDER, OR INCUR THE WRATH OF FOREIGN KEY CONSTRAINTS!
	tables := []struct {
		Name    string
		IsDelta bool
	}{
		{Name: "type_metadata", IsDelta: true},
		{Name: "type", IsDelta: false},
		{Name: "metadata", IsDelta: true},
		{Name: "station", IsDelta: false},
		{Name: "edge", IsDelta: false},
		{Name: "measurement", IsDelta: false},
		{Name: "measurementstring", IsDelta: false},
		{Name: "measurementhistory", IsDelta: true},
		{Name: "measurementhistorystring", IsDelta: true},
	}

	for _, table := range tables {
		if table.IsDelta {
			app.log.Info("querying last record id from replica database", zap.String("table", table.Name))

			from, err := app.lastRecordID(app.replicaDB, table.Name)

			if err != nil {
				app.log.Error("error querying last record id from replica database", zap.String("table", table.Name))
				return
			}

			app.log.Debug("finished querying last record id from replica database", zap.String("table", table.Name), zap.Int64("id", from))

			app.log.Info("querying last record id from mobility database", zap.String("table", table.Name))

			to, err := app.lastRecordID(app.mobilityDB, table.Name)

			if err != nil {
				app.log.Error("error querying last record id from mobility database", zap.String("table", table.Name))
				return
			}

			app.log.Debug("finished querying last record id from mobility database", zap.String("table", table.Name), zap.Int64("id", to))

			app.log.Info("transfering delta for table", zap.String("table", table.Name), zap.Int64("from", from), zap.Int64("to", to))

			if err := app.transferDelta(ctx, table.Name, from, to); err != nil {
				return
			}
		} else {
			app.log.Info("transfering table", zap.String("table", table.Name))

			if err := app.transferTable(ctx, table.Name); err != nil {
				return
			}
		}
	}
}

func (app *Application) lastRecordID(db *bun.DB, table string) (int64, error) {
	var id sql.NullInt64
	err := db.QueryRow(fmt.Sprintf("SELECT max(id) FROM intimev2.%s", table)).Scan(&id)

	if err != nil {
		return -1, err
	}

	return id.Int64, nil
}

func (app *Application) transferTable(parent context.Context, table string) error {
	ctx, cancel := context.WithCancel(parent)
	defer cancel()

	mobilityConn, err := app.mobilityDB.Conn(ctx)

	if err != nil {
		app.log.Error("error establishing a connection to the mobility database")
		return err
	}

	defer func() {
		cancel()
		if err := mobilityConn.Close(); err != nil {
			app.log.Error("error closing connection with mobility database", zap.Error(err))
		}
	}()

	app.log.Info("copying table from mobility database to memory", zap.String("table", table))

	var data bytes.Buffer
	result, err := pgdriver.CopyTo(ctx, mobilityConn, &data, fmt.Sprintf("COPY %s TO STDOUT WITH CSV", table))

	if err != nil {
		app.log.Error("error copying table from mobility database to memory", zap.Error(err), zap.String("table", table))
		return err
	}

	numRows, err := result.RowsAffected()

	if err != nil {
		app.log.Error("error reading number of affected row from mobility database", zap.Error(err), zap.String("table", table))
		return err
	}

	app.log.Debug("finished copying table from mobility database to memory", zap.String("table", table), zap.Int64("rows", numRows), zap.Int("bytes", data.Len()))

	replicaConn, err := app.replicaDB.Conn(ctx)

	if err != nil {
		app.log.Error("error establishing a connection to the replica database")
		return err
	}

	defer func() {
		cancel()
		if err := replicaConn.Close(); err != nil {
			app.log.Error("error closing connection with replica database", zap.Error(err))
		}
	}()

	app.log.Info("copying table from memory to replica database", zap.String("table", table))

	tx, err := replicaConn.BeginTx(ctx, nil)

	if err != nil {
		app.log.Error("error beginning transaction in the replica database", zap.String("table", table))
		return err
	}

	tempTable, targetTable := fmt.Sprintf("%s_tmp", table), fmt.Sprintf("intimev2.%s", table)
	_, err = tx.Exec(fmt.Sprintf("CREATE TEMPORARY TABLE %s (LIKE %s) ON COMMIT DROP", tempTable, targetTable))

	if err != nil {
		app.log.Error("error creating temporary table to copy data into", zap.Error(err), zap.String("table", table))
		return err
	}

	_, err = pgdriver.CopyFrom(ctx, replicaConn, &data, fmt.Sprintf("COPY %s FROM STDIN WITH CSV", tempTable))

	if err != nil {
		app.log.Error("error copying table from memory to replica database", zap.Error(err), zap.String("table", table))
		return err
	}

	_, err = tx.Exec(fmt.Sprintf("TRUNCATE %s", targetTable))

	if err != nil {
		app.log.Error("error truncating destination table in replica database", zap.Error(err), zap.String("table", table))
		return err
	}

	_, err = tx.Exec(fmt.Sprintf("INSERT INTO %s (SELECT * FROM %s)", targetTable, tempTable))

	if err != nil {
		app.log.Error("error inserting values into destination table in replica database", zap.Error(err), zap.String("table", table))
		return err
	}

	err = tx.Commit()

	if err != nil {
		app.log.Error("error committing transaction", zap.Error(err), zap.String("table", table))
		return err
	}

	return nil
}

func (app *Application) transferDelta(parent context.Context, table string, from, to int64) error {
	ctx, cancel := context.WithCancel(parent)
	defer cancel()

	replicaConn, err := app.replicaDB.Conn(ctx)

	if err != nil {
		app.log.Error("error establishing a connection to the replica database")
		return err
	}

	defer func() {
		cancel()
		if err := replicaConn.Close(); err != nil {
			app.log.Error("error closing connection with replica database", zap.Error(err))
		}
	}()

	tx, err := replicaConn.BeginTx(ctx, nil)

	if err != nil {
		app.log.Error("error beginning transaction in the replica database", zap.String("table", table))
		return err
	}

	tempTable, targetTable := fmt.Sprintf("%s_tmp", table), fmt.Sprintf("intimev2.%s", table)
	_, err = tx.Exec(fmt.Sprintf("CREATE TEMPORARY TABLE %s (LIKE %s) ON COMMIT DROP", tempTable, targetTable))

	if err != nil {
		app.log.Error("error creating temporary table to copy data into", zap.Error(err), zap.String("table", table))
		return err
	}

	mobilityConn, err := app.mobilityDB.Conn(ctx)

	if err != nil {
		app.log.Error("error establishing a connection to the mobility database")
		return err
	}

	defer func() {
		cancel()
		if err := mobilityConn.Close(); err != nil {
			app.log.Error("error closing connection with mobility database", zap.Error(err))
		}
	}()

	for start := from; start < to; start += 1_000_00 {
		end := start + 1_000_00

		if end-1 > to {
			end = to
		}

		app.log.Info(
			"copying delta segment from mobility database to memory",
			zap.String("table", table),
			zap.Int64("from", from), zap.Int64("to", to), zap.Int("step", 1_000_00),
			zap.Int64("start", start), zap.Int64("end", end),
		)

		var data bytes.Buffer
		result, err := pgdriver.CopyTo(ctx, mobilityConn, &data, fmt.Sprintf("COPY (SELECT * FROM %s WHERE id > %d AND id <= %d) TO STDOUT WITH CSV", table, start, end))

		if err != nil {
			app.log.Error(
				"error copying delta segment from mobility database to memory",
				zap.Error(err), zap.String("table", table),
				zap.Int64("from", from), zap.Int64("to", to), zap.Int("step", 1_000_00),
				zap.Int64("start", start), zap.Int64("end", end),
			)
			return err
		}

		numRows, err := result.RowsAffected()

		if err != nil {
			app.log.Error(
				"error reading number of affected row from mobility database",
				zap.Error(err), zap.String("table", table),
				zap.Int64("from", from), zap.Int64("to", to), zap.Int("step", 1_000_00),
				zap.Int64("start", start), zap.Int64("end", end),
			)
			return err
		}

		app.log.Debug(
			"finished copying delta segment from mobility database to memory",
			zap.String("table", table), zap.Int64("rows", numRows), zap.Int("bytes", data.Len()),
			zap.Int64("from", from), zap.Int64("to", to), zap.Int("step", 1_000_00),
			zap.Int64("start", start), zap.Int64("end", end),
		)

		app.log.Info(
			"copying delta segment from memory to replica database",
			zap.String("table", table),
			zap.Int64("from", from), zap.Int64("to", to), zap.Int("step", 1_000_00),
			zap.Int64("start", start), zap.Int64("end", end),
		)
		_, err = pgdriver.CopyFrom(ctx, replicaConn, &data, fmt.Sprintf("COPY %s FROM STDIN WITH CSV", tempTable))

		if err != nil {
			app.log.Error(
				"error delta segment from memory to replica database",
				zap.Error(err), zap.String("table", table),
				zap.Int64("from", from), zap.Int64("to", to), zap.Int("step", 1_000_00),
				zap.Int64("start", start), zap.Int64("end", end),
			)
			return err
		}
	}

	_, err = tx.Exec(fmt.Sprintf("INSERT INTO %s (SELECT * FROM %s)", targetTable, tempTable))

	if err != nil {
		app.log.Error("error inserting values into destination table in replica database", zap.Error(err), zap.String("table", table))
		return err
	}

	err = tx.Commit()

	if err != nil {
		app.log.Error("error committing transaction", zap.Error(err), zap.String("table", table))
		return err
	}

	return nil
}
