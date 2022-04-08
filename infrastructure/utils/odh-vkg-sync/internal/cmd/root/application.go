package root

import (
	"context"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"

	"github.com/uptrace/bun"
	"github.com/uptrace/bun/driver/pgdriver"
	"go.uber.org/zap"
)

type Options struct {
	MobilityDB *bun.DB
	ReplicaDB  *bun.DB
}

type Application struct {
	log            *zap.Logger
	mobilityDB     *bun.DB
	replicaDB      *bun.DB
	appendTables   []string
	truncateTables []string
}

func NewApplication(log *zap.Logger, opts Options) *Application {
	return &Application{
		log:            log,
		mobilityDB:     opts.MobilityDB,
		replicaDB:      opts.ReplicaDB,
		appendTables:   []string{"measurementhistory", "measurementstringhistory", "type_metadata", "metadata"},
		truncateTables: []string{"measurement", "measurementstring", "edge", "type", "station"},
	}
}

func (a *Application) queryIDs(db *bun.DB, tables []string) ([]int64, error) {
	var stmt []string

	for _, table := range tables {
		stmt = append(stmt, fmt.Sprintf("SELECT max(id) FROM %s", table))
	}

	rows, err := db.Query(strings.Join(stmt, " UNION ALL "))

	if err != nil {
		return nil, err
	}

	defer rows.Close()
	ids := make([]int64, 0, len(tables))

	for rows.Next() {
		var id int64

		err = rows.Scan(&id)

		if err != nil {
			return nil, err
		}

		ids = append(ids, id)
	}

	return ids, nil
}

func (app *Application) Main(ctx context.Context) {
	app.log.Info("cleaning up dump directory")

	err := os.RemoveAll("dump")

	if err != nil {
		app.log.Warn("error cleaning up dump directory", zap.Error(err))
	}

	err = os.MkdirAll("dump", 0700)

	if err != nil {
		app.log.Error("error creating dump directory", zap.Error(err))
		return
	}

	app.log.Info("querying append-only tables max ids", zap.Strings("tables", app.appendTables))

	mobilityIDs, err := app.queryIDs(app.mobilityDB, app.appendTables)

	if err != nil {
		app.log.Error("error querying append-only tables max ids from the mobility database", zap.Error(err))
		return
	}

	app.log.Debug("mobility append-only tables max ids", zap.Int64s("ids", mobilityIDs))

	replicaIDs, err := app.queryIDs(app.replicaDB, app.appendTables)

	if err != nil {
		app.log.Error("error querying append-only tables max ids from the replica database", zap.Error(err))
		return
	}

	app.log.Debug("replica append-only tables max ids", zap.Int64s("ids", replicaIDs))

	app.log.Info("downloading tables from the mobility database", zap.Strings("tables", app.truncateTables))

	conn, err := app.mobilityDB.Conn(ctx)

	if err != nil {
		app.log.Error("error establishing a connection to the mobility database", zap.Error(err))
		return
	}

	for _, table := range app.truncateTables {
		app.log.Info("dumping table", zap.String("table", table))

		filename := fmt.Sprintf("dump/%s.csv", table)
		file, err := os.OpenFile(filename, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0600)

		if err != nil {
			app.log.Error("error opening dump file", zap.Error(err), zap.String("file", filename))
			return
		}

		defer file.Close()
		numRows, err := app.dumpTable(ctx, conn, file, table)

		if err != nil {
			app.log.Error("error dumping table", zap.Error(err), zap.String("table", table))
			return
		}

		app.log.Debug("table dumped", zap.String("table", table), zap.Int64("rows", numRows))
	}

	app.log.Info("downloading append-only tables delta from the mobility database", zap.Strings("tables", app.appendTables))

	for i, table := range app.appendTables {
		from, to := replicaIDs[i], mobilityIDs[i]
		app.log.Info("dumping delta", zap.String("table", table), zap.Int64("from", from), zap.Int64("to", to))

		for start := from; start < to; start += 1_000_00 {
			end := start + 1_000_00

			if end-1 > to {
				end = to
			}

			app.log.Info("dumping segment", zap.String("table", table), zap.Int64("from", start), zap.Int64("to", end))

			filename := fmt.Sprintf("dump/%s-%d-%d.csv", table, start, end)
			file, err := os.OpenFile(filename, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0600)

			if err != nil {
				app.log.Error("error opening segment file", zap.Error(err), zap.String("file", filename))
				return
			}

			defer file.Close()
			numRows, err := app.dumpTableSlice(ctx, conn, file, table, start, end)

			if err != nil {
				app.log.Error("error dumping segment", zap.Error(err), zap.String("table", table), zap.Int64("from", start), zap.Int64("to", end))
				return
			}

			app.log.Debug("segment dumped", zap.String("table", table), zap.Int64("from", start), zap.Int64("to", end), zap.Int64("rows", numRows))
		}
	}

	// ! DO NOT CHANGE THE ORDER OF TABLE INSERTIONS, OR INCUR THE WRATH OF FOREIGN KEY CONSTRAINTS !

	restoreWholeTable := func(table string) bool {
		app.log.Info("restoring table", zap.String("table", table))

		filename := fmt.Sprintf("dump/%s.csv", table)
		file, err := os.Open(filename)

		if err != nil {
			app.log.Error("error opening dump file", zap.Error(err), zap.String("file", filename))
			return false
		}

		defer file.Close()
		err = app.restoreTable(ctx, conn, file, table)

		if err != nil {
			app.log.Error("error restoring table", zap.Error(err))
			return false
		}

		return true
	}

	restoreTableSegments := func(table string) bool {
		app.log.Info("restoring table", zap.String("table", table))

		segments, err := filepath.Glob(fmt.Sprintf("dump/%s-*-*", table))

		app.log.Debug("table segments", zap.Strings("segments", segments))

		if err != nil {
			app.log.Error("error listing segment files", zap.Error(err), zap.String("table", table))
			return false
		}

		var rs []io.Reader

		for _, segment := range segments {
			file, err := os.Open(segment)

			if err != nil {
				app.log.Error("error opening segment file", zap.Error(err), zap.String("file", segment), zap.String("table", table))
				return false
			}

			defer file.Close()
			rs = append(rs, file)
		}

		err = app.restoreTableSlices(ctx, conn, rs, table)

		if err != nil {
			app.log.Error("error restoring table", zap.Error(err), zap.String("table", table))
			return false
		}

		app.log.Debug("restored table", zap.String("table", table))

		return true
	}

	if !restoreTableSegments("type_metadata") {
		return
	}

	if !restoreWholeTable("type") {
		return
	}

	if !restoreTableSegments("metadata") {
		return
	}

	for _, table := range []string{"station", "edge", "measurement", "measurementstring"} {
		if !restoreWholeTable(table) {
			return
		}
	}

	for _, table := range []string{"measurementhistory", "measurementstringhistory"} {
		if !restoreTableSegments(table) {
			return
		}
	}
}

func (a *Application) dumpTable(ctx context.Context, conn bun.Conn, w io.Writer, table string) (int64, error) {
	result, err := pgdriver.CopyTo(ctx, conn, w, fmt.Sprintf("COPY %s TO STDOUT WITH CSV", table))

	if err != nil {
		return 0, nil
	}

	return result.RowsAffected()
}

func (a *Application) dumpTableSlice(ctx context.Context, conn bun.Conn, w io.Writer, table string, from, to int64) (int64, error) {
	result, err := pgdriver.CopyTo(ctx, conn, w, fmt.Sprintf("COPY (SELECT * FROM %s WHERE id > %d AND id <= %d) TO STDOUT WITH CSV", table, from, to))

	if err != nil {
		return 0, nil
	}

	return result.RowsAffected()
}

func (a *Application) restoreTable(ctx context.Context, conn bun.Conn, r io.Reader, table string) error {
	tempTable, targetTable := fmt.Sprintf("intimev2.%s_tmp", table), fmt.Sprintf("intimev2.%s", table)
	_, err := conn.ExecContext(ctx, fmt.Sprintf("CREATE TABLE IF NOT EXISTS %s AS TABLE %s WITH NO DATA", tempTable, targetTable))

	if err != nil {
		return err
	}

	_, err = conn.ExecContext(ctx, fmt.Sprintf("TRUNCATE %s", tempTable))

	if err != nil {
		return err
	}

	_, err = pgdriver.CopyFrom(ctx, conn, r, fmt.Sprintf("COPY %s FROM STDIN", tempTable))

	if err != nil {
		return err
	}

	tx, err := conn.BeginTx(ctx, nil)

	_, err = tx.Exec(fmt.Sprintf("TRUNCATE %s", targetTable))

	if err != nil {
		return err
	}

	_, err = tx.Exec(fmt.Sprintf("INSERT INTO %s TABLE %s ON CONFLICT DO NOTHING", targetTable, tempTable))

	if err != nil {
		return err
	}

	_, err = tx.Exec(fmt.Sprintf("DROP %s", tempTable))

	if err != nil {
		return err
	}

	err = tx.Commit()

	if err != nil {
		return err
	}

	return nil
}

func (a *Application) restoreTableSlices(ctx context.Context, conn bun.Conn, rs []io.Reader, table string) error {
	tempTable, targetTable := fmt.Sprintf("intimev2.%s_tmp", table), fmt.Sprintf("intimev2.%s", table)
	_, err := conn.ExecContext(ctx, fmt.Sprintf("CREATE TABLE IF NOT EXISTS %s AS TABLE %s WITH NO DATA", tempTable, targetTable))

	if err != nil {
		return err
	}

	for _, r := range rs {
		_, err = conn.ExecContext(ctx, fmt.Sprintf("TRUNCATE %s", tempTable))

		if err != nil {
			return err
		}

		_, err = pgdriver.CopyFrom(ctx, conn, r, fmt.Sprintf("COPY %s FROM STDIN", tempTable))

		if err != nil {
			return err
		}

		_, err = conn.ExecContext(ctx, fmt.Sprintf("INSERT INTO %s TABLE %s ON CONFLICT DO NOTHING", targetTable, tempTable))

		if err != nil {
			return err
		}
	}

	_, err = conn.ExecContext(ctx, fmt.Sprintf("DROP %s", tempTable))

	if err != nil {
		return err
	}

	return nil
}
