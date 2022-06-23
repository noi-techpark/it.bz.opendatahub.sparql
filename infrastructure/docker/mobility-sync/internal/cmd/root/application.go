package root

import (
	"bytes"
	"context"
	"database/sql"
	"errors"
	"fmt"

	"github.com/uptrace/bun"
	"github.com/uptrace/bun/driver/pgdriver"
	"go.uber.org/zap"
)

type Options struct {
	Testing    bool
	MobilityDB *bun.DB
	ReplicaDB  *bun.DB
}

type Application struct {
	log        *zap.Logger
	testing    bool
	mobilityDB *bun.DB
	replicaDB  *bun.DB
}

func NewApplication(log *zap.Logger, opts Options) *Application {
	return &Application{
		log:        log,
		testing:    opts.Testing,
		mobilityDB: opts.MobilityDB,
		replicaDB:  opts.ReplicaDB,
	}
}

type table struct {
	Name       string
	AppendOnly bool
}

type transaction struct {
	Name   string
	Tables []table
}

func (app *Application) Synchronize(parent context.Context) {
	transactions := []transaction{
		{
			Name: "type & type_metadata",
			Tables: []table{
				{Name: "type", AppendOnly: false},
				{Name: "type_metadata", AppendOnly: true},
			},
		},
		{
			Name: "metadata & station",
			Tables: []table{
				{Name: "metadata", AppendOnly: true},
				{Name: "station", AppendOnly: false},
			},
		},
		{
			Name: "edge",
			Tables: []table{
				{Name: "edge", AppendOnly: false},
			},
		},
		{
			Name: "measurement",
			Tables: []table{
				{Name: "measurement", AppendOnly: false},
			},
		},
		{
			Name: "measurementstring",
			Tables: []table{
				{Name: "measurementstring", AppendOnly: false},
			},
		},
	}

	for _, transaction := range transactions {
		ctx, cancel := context.WithCancel(parent)
		defer cancel()

		mobilityConn, err := app.mobilityDB.Conn(ctx)

		if err != nil {
			app.log.Error("error establishing a connection to the mobility database", zap.Error(err))
			return
		}

		defer func() {
			cancel()
			if err := mobilityConn.Close(); !errors.Is(err, sql.ErrConnDone) && err != nil {
				app.log.Error("error closing connection with mobility database", zap.Error(err))
			}
		}()

		replicaConn, err := app.replicaDB.Conn(ctx)

		if err != nil {
			app.log.Error("error establishing a connection to the replica database", zap.Error(err))
			return
		}

		defer func() {
			cancel()
			if err := replicaConn.Close(); !errors.Is(err, sql.ErrConnDone) && err != nil {
				app.log.Error("error closing connection with replica database", zap.Error(err))
			}
		}()

		tx, err := replicaConn.BeginTx(ctx, nil)

		if err != nil {
			app.log.Error("error beginning transaction in the replica database", zap.Error(err), zap.String("transaction", transaction.Name))
		}

		for _, table := range transaction.Tables {
			if table.AppendOnly {
				app.log.Info("querying last record id from replica database", zap.String("table", table.Name))

				from, err := app.lastRecordID(app.replicaDB, table.Name)

				if err != nil {
					app.log.Error("error querying last record id from replica database", zap.Error(err), zap.String("table", table.Name))
					return
				}

				app.log.Debug("finished querying last record id from replica database", zap.String("table", table.Name), zap.Int64("id", from))

				app.log.Info("querying last record id from mobility database", zap.String("table", table.Name))

				to, err := app.lastRecordID(app.mobilityDB, table.Name)

				if err != nil {
					app.log.Error("error querying last record id from mobility database", zap.Error(err), zap.String("table", table.Name))
					return
				}

				app.log.Debug("finished querying last record id from mobility database", zap.String("table", table.Name), zap.Int64("id", to))

				app.log.Info("transfering delta for table", zap.String("table", table.Name), zap.Int64("from", from), zap.Int64("to", to))

				if err := app.transferDelta(ctx, mobilityConn, replicaConn, tx, table.Name, from, to); err != nil {
					if err = tx.Rollback(); !errors.Is(err, sql.ErrTxDone) && err != nil {
						app.log.Error("error rolling back transaction", zap.Error(err), zap.String("transaction", transaction.Name))
					}

					return
				}
			} else {
				app.log.Info("transfering table", zap.String("table", table.Name))

				if err := app.transferTable(ctx, mobilityConn, replicaConn, tx, table.Name); err != nil {
					if err = tx.Rollback(); !errors.Is(err, sql.ErrTxDone) && err != nil {
						app.log.Error("error rolling back transaction", zap.Error(err), zap.String("transaction", transaction.Name))
					}

					return
				}
			}
		}

		app.log.Info("committing transaction", zap.String("transaction", transaction.Name))

		err = tx.Commit()

		if err != nil {
			app.log.Error("error committing transaction", zap.Error(err), zap.String("transaction", transaction.Name))
			return
		}
	}

	bigTables := []string{"measurementhistory", "measurementstringhistory"}

	for _, table := range bigTables {
		ctx, cancel := context.WithCancel(parent)
		defer cancel()

		mobilityConn, err := app.mobilityDB.Conn(ctx)

		if err != nil {
			app.log.Error("error establishing a connection to the mobility database", zap.Error(err))
			return
		}

		defer func() {
			cancel()
			if err := mobilityConn.Close(); !errors.Is(err, sql.ErrConnDone) && err != nil {
				app.log.Error("error closing connection with mobility database", zap.Error(err))
			}
		}()

		replicaConn, err := app.replicaDB.Conn(ctx)

		if err != nil {
			app.log.Error("error establishing a connection to the replica database", zap.Error(err))
			return
		}

		defer func() {
			cancel()
			if err := replicaConn.Close(); !errors.Is(err, sql.ErrConnDone) && err != nil {
				app.log.Error("error closing connection with replica database", zap.Error(err))
			}
		}()

		app.log.Info("querying last record id from replica database", zap.String("table", table))

		from, err := app.lastRecordID(app.replicaDB, table)

		if err != nil {
			app.log.Error("error querying last record id from replica database", zap.Error(err), zap.String("table", table))
			return
		}

		app.log.Debug("finished querying last record id from replica database", zap.String("table", table), zap.Int64("id", from))

		app.log.Info("querying last record id from mobility database", zap.String("table", table))

		to, err := app.lastRecordID(app.mobilityDB, table)

		if err != nil {
			app.log.Error("error querying last record id from mobility database", zap.Error(err), zap.String("table", table))
			return
		}

		app.log.Debug("finished querying last record id from mobility database", zap.String("table", table), zap.Int64("id", to))

		app.log.Info("transfering delta for big table", zap.String("table", table), zap.Int64("from", from), zap.Int64("to", to))

		step := int64(1_000_000)
		for start := from; start < to; start += step {
			end := start + step

			if end-1 > to {
				end = to
			}

			tx, err := replicaConn.BeginTx(ctx, nil)

			if err != nil {
				app.log.Error("error beginning transaction in the replica database for big table", zap.Error(err), zap.String("table", table), zap.Int64("start", start), zap.Int64("end", end))
			}

			if err := app.transferDelta(ctx, mobilityConn, replicaConn, tx, table, start, end); err != nil {
				if err = tx.Rollback(); !errors.Is(err, sql.ErrTxDone) && err != nil {
					app.log.Error("error rolling back transaction for big table", zap.Error(err), zap.String("table", table), zap.Int64("start", start), zap.Int64("end", end))
				}

				return
			}

			app.log.Info("committing transaction for big table", zap.String("table", table), zap.Int64("start", start), zap.Int64("end", end))

			err = tx.Commit()

			if err != nil {
				app.log.Error("error committing transaction for big table", zap.Error(err), zap.String("table", table), zap.Int64("start", start), zap.Int64("end", end))
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

func (app *Application) transferTable(ctx context.Context, mobilityConn bun.Conn, replicaConn bun.Conn, tx *sql.Tx, table string) error {
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

	app.log.Info("copying table from memory to replica database", zap.String("table", table))

	tempTable, targetTable := fmt.Sprintf("%s_tmp", table), fmt.Sprintf("intimev2.%s", table)
	_, err = tx.ExecContext(ctx, fmt.Sprintf("CREATE TEMPORARY TABLE %s (LIKE %s) ON COMMIT DROP", tempTable, targetTable))

	if err != nil {
		app.log.Error("error creating temporary table to copy data into", zap.Error(err), zap.String("table", table))
		return err
	}

	_, err = pgdriver.CopyFrom(ctx, replicaConn, &data, fmt.Sprintf("COPY %s FROM STDIN WITH CSV", tempTable))

	if err != nil {
		app.log.Error("error copying table from memory to replica database", zap.Error(err), zap.String("table", table))
		return err
	}

	app.log.Info("truncating destination table in replica database", zap.String("table", targetTable))

	_, err = tx.ExecContext(ctx, fmt.Sprintf("DELETE FROM %s", targetTable))

	if err != nil {
		app.log.Error("error truncating destination table in replica database", zap.Error(err), zap.String("table", table))
		return err
	}

	app.log.Info("inserting value into destination table in replica database", zap.String("table", targetTable))

	_, err = tx.ExecContext(ctx, fmt.Sprintf("INSERT INTO %s (SELECT * FROM %s)", targetTable, tempTable))

	if err != nil {
		app.log.Error("error inserting values into destination table in replica database", zap.Error(err), zap.String("table", table))
		return err
	}

	return nil
}

func (app *Application) transferDelta(ctx context.Context, mobilityConn bun.Conn, replicaConn bun.Conn, tx *sql.Tx, table string, from, to int64) error {
	tempTable, targetTable := fmt.Sprintf("%s_tmp", table), fmt.Sprintf("intimev2.%s", table)
	_, err := tx.ExecContext(ctx, fmt.Sprintf("CREATE TEMPORARY TABLE %s (LIKE %s) ON COMMIT DROP", tempTable, targetTable))

	if err != nil {
		app.log.Error("error creating temporary table to copy data into", zap.Error(err), zap.String("table", table))
		return err
	}

	step := int64(1_000_000)
	for start := from; start < to; start += step {
		end := start + step

		if end-1 > to {
			end = to
		}

		app.log.Info(
			"copying delta segment from mobility database to memory",
			zap.String("table", table),
			zap.Int64("from", from), zap.Int64("to", to), zap.Int64("step", step),
			zap.Int64("start", start), zap.Int64("end", end),
		)

		var data bytes.Buffer
		result, err := pgdriver.CopyTo(ctx, mobilityConn, &data, fmt.Sprintf("COPY (SELECT * FROM %s WHERE id > %d AND id <= %d) TO STDOUT WITH CSV", table, start, end))

		if err != nil {
			app.log.Error(
				"error copying delta segment from mobility database to memory",
				zap.Error(err), zap.String("table", table),
				zap.Int64("from", from), zap.Int64("to", to), zap.Int64("step", step),
				zap.Int64("start", start), zap.Int64("end", end),
			)
			return err
		}

		numRows, err := result.RowsAffected()

		if err != nil {
			app.log.Error(
				"error reading number of affected row from mobility database",
				zap.Error(err), zap.String("table", table),
				zap.Int64("from", from), zap.Int64("to", to), zap.Int64("step", step),
				zap.Int64("start", start), zap.Int64("end", end),
			)
			return err
		}

		app.log.Debug(
			"finished copying delta segment from mobility database to memory",
			zap.String("table", table), zap.Int64("rows", numRows), zap.Int("bytes", data.Len()),
			zap.Int64("from", from), zap.Int64("to", to), zap.Int64("step", step),
			zap.Int64("start", start), zap.Int64("end", end),
		)

		app.log.Info(
			"copying delta segment from memory to replica database",
			zap.String("table", table),
			zap.Int64("from", from), zap.Int64("to", to), zap.Int64("step", step),
			zap.Int64("start", start), zap.Int64("end", end),
		)
		_, err = pgdriver.CopyFrom(ctx, replicaConn, &data, fmt.Sprintf("COPY %s FROM STDIN WITH CSV", tempTable))

		if err != nil {
			app.log.Error(
				"error delta segment from memory to replica database",
				zap.Error(err), zap.String("table", table),
				zap.Int64("from", from), zap.Int64("to", to), zap.Int64("step", step),
				zap.Int64("start", start), zap.Int64("end", end),
			)
			return err
		}
	}

	app.log.Info("inserting values into destination table in replica database", zap.String("table", table))

	_, err = tx.ExecContext(ctx, fmt.Sprintf("INSERT INTO %s (SELECT * FROM %s)", targetTable, tempTable))

	if err != nil {
		app.log.Error("error inserting values into destination table in replica database", zap.Error(err), zap.String("table", table))
		return err
	}

	return nil
}

// ---

func (app *Application) replaceTable(ctx context.Context, mobilityConn bun.Conn, replicaConn bun.Conn, tx *sql.Tx, srcTable string, destTable string) error {
	app.log.Info(
		"REPLACE: source table (mobility) -> destination table (replica) | started",
		zap.String("src", srcTable), zap.String("dest", destTable),
	)

	app.log.Info("COPY TO: source table (mobility) -> in-memory buffer | started", zap.String("table", srcTable))

	var buf bytes.Buffer
	res, err := pgdriver.CopyTo(ctx, mobilityConn, &buf, fmt.Sprintf("COPY %s TO STDOUT WITH CSV", srcTable))

	if err != nil {
		app.log.Error("COPY TO: source table (mobility) -x> in-memory buffer | error", zap.Error(err), zap.String("table", srcTable))
		return err
	}

	nRows, err := res.RowsAffected()

	if err != nil {
		app.log.Error(
			"COPY TO: source table (mobility) -x> in-memory buffer | cannot determine number of affected rows",
			zap.Error(err), zap.String("table", srcTable),
		)
		return err
	}

	app.log.Info(
		"COPY TO: source table (mobility) -> in-memory buffer | completed",
		zap.String("table", srcTable), zap.Int64("rows", nRows), zap.Int("bytes", buf.Len()),
	)

	tmpTable := fmt.Sprintf("%s_tmp", destTable)

	app.log.Info("CREATE TEMPORARY TABLE (replica) | started", zap.String("temp", tmpTable), zap.String("template", destTable))

	_, err = tx.ExecContext(ctx, fmt.Sprintf("CREATE TEMPORARY TABLE IF NOT EXISTS %s (LIKE intimev2.%s) ON COMMIT DROP", tmpTable, destTable))
	if err != nil {
		app.log.Error("CREATE TEMPORARY TABLE (replica) | error", zap.Error(err), zap.String("temp", tmpTable), zap.String("template", destTable))
		return err
	}

	app.log.Info("CREATE TEMPORARY TABLE (replica) | completed", zap.String("temp", tmpTable), zap.String("template", destTable))

	app.log.Info("TRUNCATE TEMPORARY TABLE (replica) | started", zap.String("table", tmpTable))

	_, err = tx.ExecContext(ctx, fmt.Sprintf("TRUNCATE %s", tmpTable))
	if err != nil {
		app.log.Error("TRUNCATE TEMPORARY TABLE (replica) | error", zap.Error(err), zap.String("table", tmpTable))
		return err
	}

	app.log.Info("TRUNCATE TEMPORARY TABLE (replica) | completed", zap.String("table", tmpTable))

	app.log.Info("COPY FROM: temporary table (replica) <- in-memory buffer | started", zap.String("table", tmpTable))

	_, err = pgdriver.CopyFrom(ctx, replicaConn, &buf, fmt.Sprintf("COPY %s FROM STDIN WITH CSV", tmpTable))
	if err != nil {
		app.log.Error("COPY FROM: temporary table (replica) <x- in-memory buffer | error",
			zap.Error(err), zap.String("table", tmpTable),
		)
		return err
	}

	app.log.Info("COPY FROM: temporary table (replica) <- in-memory buffer | completed", zap.String("table", tmpTable))

	app.log.Info("DELETE FROM: destination table (replica) | started", zap.String("table", destTable))

	_, err = tx.ExecContext(ctx, fmt.Sprintf("DELETE FROM intimev2.%s", destTable))
	if err != nil {
		app.log.Error("DELETE FROM: destination table (replica) | error", zap.Error(err), zap.String("table", destTable))
		return err
	}

	app.log.Info("DELETE FROM: destination table (replica) | completed", zap.String("table", destTable))

	app.log.Info(
		"INSERT INTO: temporary table (replica) -> destination table (replica) | started",
		zap.String("temp", tmpTable), zap.String("destination", destTable),
	)

	_, err = tx.ExecContext(ctx, fmt.Sprintf("INSERT INTO intimev2.%s (SELECT * FROM %s)", destTable, tmpTable))
	if err != nil {
		app.log.Info(
			"INSERT INTO: temporary table (replica) -x> destination table (replica) | error",
			zap.Error(err), zap.String("temp", tmpTable), zap.String("destination", destTable),
		)
		return err
	}

	app.log.Info(
		"INSERT INTO: temporary table (replica) -> destination table (replica) | completed",
		zap.String("temp", tmpTable), zap.String("destination", destTable),
	)

	app.log.Info(
		"REPLACE: source table (mobility) -> destination table (replica) | completed",
		zap.String("src", srcTable), zap.String("dest", destTable),
	)

	return nil
}

func (app *Application) updateTable(
	ctx context.Context,
	mobilityConn bun.Conn, replicaConn bun.Conn, tx *sql.Tx,
	srcTable string, destTable string,
	srcLastId int64, destLastId int64, maxDelta int64,
) error {
	if srcLastId == destLastId {
		app.log.Info(
			"UPDATE: source table (mobility) -> destination table (replica) | skipped",
			zap.String("source", srcTable), zap.String("dest", destTable),
			zap.Int64("sourceLastId", srcLastId), zap.Int64("destLastId", destLastId), zap.Int64("maxDelta", maxDelta),
		)
		return nil
	}

	app.log.Info(
		"UPDATE: source table (mobility) -> destination table (replica) | started",
		zap.String("source", srcTable), zap.String("dest", destTable),
		zap.Int64("sourceLastId", srcLastId), zap.Int64("destLastId", destLastId), zap.Int64("maxDelta", maxDelta),
	)

	from, to := destLastId, destLastId+maxDelta
	if to > srcLastId {
		to = srcLastId
	}

	app.log.Info(
		"COPY TO: source table (mobility) -> in-memory buffer | started",
		zap.String("table", srcTable), zap.Int64("from", from), zap.Int64("to", to),
	)

	var buf bytes.Buffer
	res, err := pgdriver.CopyTo(
		ctx, mobilityConn, &buf,
		fmt.Sprintf(
			"COPY (SELECT * FROM %s WHERE id > %d AND id <= %d) TO STDOUT WITH CSV",
			srcTable, from, to,
		),
	)

	if err != nil {
		app.log.Error(
			"COPY TO: source table (mobility) -x> in-memory buffer | error",
			zap.Error(err),
			zap.String("table", srcTable), zap.Int64("from", from), zap.Int64("to", to),
		)
		return err
	}

	nRows, err := res.RowsAffected()

	if err != nil {
		app.log.Error(
			"COPY TO: source table (mobility) -x> in-memory buffer | cannot determine number of affected rows",
			zap.Error(err),
			zap.String("table", srcTable), zap.Int64("from", from), zap.Int64("to", to),
		)
		return err
	}

	app.log.Info(
		"COPY TO: source table (mobility) -> in-memory buffer | completed",
		zap.String("table", srcTable), zap.Int64("from", from), zap.Int64("to", to),
		zap.Int64("rows", nRows), zap.Int("bytes", buf.Len()),
	)

	tmpTable := fmt.Sprintf("%s_tmp", destTable)

	app.log.Info("CREATE TEMPORARY TABLE (replica) | started", zap.String("temp", tmpTable), zap.String("template", destTable))

	_, err = tx.ExecContext(ctx, fmt.Sprintf("CREATE TEMPORARY TABLE IF NOT EXISTS %s (LIKE intimev2.%s) ON COMMIT DROP", tmpTable, destTable))
	if err != nil {
		app.log.Info("CREATE TEMPORARY TABLE (replica) | error", zap.Error(err), zap.String("temp", tmpTable), zap.String("template", destTable))
		return err
	}

	app.log.Info("CREATE TEMPORARY TABLE (replica) | completed", zap.String("temp", tmpTable), zap.String("template", destTable))

	app.log.Info("TRUNCATE TEMPORARY TABLE (replica) | started", zap.String("table", tmpTable))

	_, err = tx.ExecContext(ctx, fmt.Sprintf("TRUNCATE %s", tmpTable))
	if err != nil {
		app.log.Error("TRUNCATE TEMPORARY TABLE (replica) | error", zap.Error(err), zap.String("table", tmpTable))
		return err
	}

	app.log.Info("TRUNCATE TEMPORARY TABLE (replica) | completed", zap.String("table", tmpTable))

	app.log.Info(
		"COPY FROM: temporary table (replica) <- in-memory buffer | started",
		zap.String("table", tmpTable), zap.Int64("from", from), zap.Int64("to", to),
	)

	_, err = pgdriver.CopyFrom(ctx, replicaConn, &buf, fmt.Sprintf("COPY %s FROM STDIN WITH CSV", tmpTable))
	if err != nil {
		app.log.Error(
			"COPY FROM: temporary table (replica) <x- in-memory buffer | error",
			zap.Error(err),
			zap.String("table", tmpTable), zap.Int64("from", from), zap.Int64("to", to),
		)
		return err
	}

	app.log.Info(
		"COPY FROM: temporary table (replica) <- in-memory buffer | completed",
		zap.String("table", tmpTable), zap.Int64("from", from), zap.Int64("to", to),
	)

	app.log.Info(
		"INSERT INTO: temporary table (replica) -> destination table (replica) | started",
		zap.String("temp", tmpTable), zap.String("destination", destTable), zap.Int64("from", from), zap.Int64("to", to),
	)

	_, err = tx.ExecContext(ctx, fmt.Sprintf("INSERT INTO intimev2.%s (SELECT * FROM %s)", destTable, tmpTable))
	if err != nil {
		app.log.Info(
			"INSERT INTO: temporary table (replica) -x> destination table (replica) | error",
			zap.Error(err),
			zap.String("temp", tmpTable), zap.String("destination", destTable), zap.Int64("from", from), zap.Int64("to", to),
		)
		return err
	}

	app.log.Info(
		"INSERT INTO: temporary table (replica) -> destination table (replica) | completed",
		zap.String("temp", tmpTable), zap.String("destination", destTable), zap.Int64("from", from), zap.Int64("to", to),
	)

	app.log.Info(
		"UPDATE: source table (mobility) -> destination table (replica) | completed",
		zap.String("source", srcTable), zap.String("dest", destTable),
		zap.Int64("sourceLastId", srcLastId), zap.Int64("destLastId", destLastId), zap.Int64("maxDelta", maxDelta),
	)

	return nil
}
