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

type taskType int

const (
	replace taskType = iota + 1
	update
)

func (t taskType) String() string {
	switch t {
	case replace:
		return "R"
	case update:
		return "U"
	default:
		return "?"
	}
}

type task struct {
	Src  string
	Dest string
	Type taskType
}

func (t task) String() string {
	return fmt.Sprintf("%s -> %s (%s)", t.Src, t.Dest, t.Type)
}

type tasks []task

func (t tasks) StringSlice() []string {
	ss := make([]string, 0, len(t))
	for _, task := range t {
		ss = append(ss, task.String())
	}
	return ss
}

type jobType int

const (
	singleTx jobType = iota + 1
	multiTx
)

func (t jobType) String() string {
	switch t {
	case singleTx:
		return "single"
	case multiTx:
		return "multi"
	default:
		return "unknown"
	}
}

type job struct {
	Type  jobType
	Tasks tasks
}

var testJobs = []job{
	{
		Type: singleTx,
		Tasks: tasks{
			{Src: "type", Dest: "type", Type: replace},
			{Src: "type_metadata", Dest: "type_metadata", Type: update},
		},
	},
	{
		Type: singleTx,
		Tasks: tasks{
			{Src: "metadata", Dest: "metadata", Type: update},
			{Src: "station", Dest: "station", Type: replace},
		},
	},
	{
		Type: singleTx,
		Tasks: tasks{
			{Src: "edge", Dest: "edge", Type: replace},
		},
	},
	{
		Type: singleTx,
		Tasks: tasks{
			{Src: "measurement", Dest: "measurement", Type: replace},
		},
	},
	{
		Type: singleTx,
		Tasks: tasks{
			{Src: "measurementstring", Dest: "measurementstring", Type: replace},
		},
	},
	{
		Type: singleTx,
		Tasks: tasks{
			{Src: "measurement", Dest: "measurementhistory", Type: replace},
		},
	},
	{
		Type: singleTx,
		Tasks: tasks{
			{Src: "measurementstring", Dest: "measurementstringhistory", Type: replace},
		},
	},
}

var prodJobs = []job{
	{
		Type: singleTx,
		Tasks: tasks{
			{Src: "type", Dest: "type", Type: replace},
			{Src: "type_metadata", Dest: "type_metadata", Type: update},
		},
	},
	{
		Type: singleTx,
		Tasks: tasks{
			{Src: "metadata", Dest: "metadata", Type: update},
			{Src: "station", Dest: "station", Type: replace},
		},
	},
	{
		Type: singleTx,
		Tasks: tasks{
			{Src: "edge", Dest: "edge", Type: replace},
		},
	},
	{
		Type: singleTx,
		Tasks: tasks{
			{Src: "measurement", Dest: "measurement", Type: replace},
		},
	},
	{
		Type: singleTx,
		Tasks: tasks{
			{Src: "measurementstring", Dest: "measurementstring", Type: replace},
		},
	},
	{
		Type: multiTx,
		Tasks: tasks{
			{Src: "measurementhistory", Dest: "measurementhistory", Type: update},
		},
	},
	{
		Type: multiTx,
		Tasks: tasks{
			{Src: "measurementstringhistory", Dest: "measurementstringhistory", Type: update},
		},
	},
}

func (app *Application) Synchronize(parentCtx context.Context) {
	jobs := prodJobs

	if app.testing {
		jobs = testJobs
	}

	for _, job := range jobs {
		if err := app.execJob(parentCtx, job); err != nil {
			break
		}
	}
}

func (app *Application) execJob(parentCtx context.Context, job job) error {
	jobCtx, cancelJobCtx := context.WithCancel(parentCtx)
	defer cancelJobCtx()

	app.log.Info(
		"JOB | started",
		zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
	)

	app.log.Info(
		"CONNECT: mobility database | started",
		zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
	)

	mobilityConn, err := app.mobilityDB.Conn(jobCtx)
	if err != nil {
		app.log.Info(
			"CONNECT: mobility database | error",
			zap.Error(err),
			zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
		)
		return err
	}

	app.log.Info(
		"CONNECT: mobility database | completed",
		zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
	)

	defer func() {
		cancelJobCtx()
		if err := mobilityConn.Close(); !errors.Is(err, sql.ErrConnDone) && err != nil {
			app.log.Error(
				"CLOSE: mobility database | error",
				zap.Error(err),
				zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
			)
		}
	}()

	app.log.Info(
		"CONNECT: replica database | started",
		zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
	)

	replicaConn, err := app.replicaDB.Conn(jobCtx)
	if err != nil {
		app.log.Info(
			"CONNECT: replica database | error",
			zap.Error(err),
			zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
		)
		return err
	}

	app.log.Info(
		"CONNECT: replica database | completed",
		zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
	)

	defer func() {
		cancelJobCtx()
		if err := replicaConn.Close(); !errors.Is(err, sql.ErrConnDone) && err != nil {
			app.log.Error(
				"CLOSE: replica database | error",
				zap.Error(err),
				zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
			)
		}
	}()

	switch job.Type {
	case singleTx:
		app.log.Info(
			"BEGIN TRANSACTION (replica) | started",
			zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
		)

		tx, err := replicaConn.BeginTx(jobCtx, nil)
		if err != nil {
			app.log.Error(
				"BEGIN TRANSACTION (replica) | error",
				zap.Error(err),
				zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
			)
		}

		app.log.Info(
			"BEGIN TRANSACTION (replica) | completed",
			zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
		)

		defer func() {
			if err := tx.Rollback(); !errors.Is(err, sql.ErrTxDone) && err != nil {
				app.log.Error(
					"ROLLBACK TRANSACTION (replica) | error",
					zap.Error(err),
					zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
				)
			}
		}()

		for _, task := range job.Tasks {
			app.log.Info(
				"TASK | started",
				zap.Stringer("type", task.Type), zap.String("src", task.Src), zap.String("dest", task.Dest),
			)

			switch task.Type {
			case replace:
				if err = app.replaceTable(jobCtx, mobilityConn, replicaConn, tx, task.Src, task.Dest); err != nil {
					return err
				}
			case update:
				app.log.Info(
					"QUERY LAST RECORD ID (mobility) | started",
					zap.String("table", task.Src),
				)

				srcLastId, err := app.lastRecordID(app.mobilityDB, task.Src)
				if err != nil {
					app.log.Info(
						"QUERY LAST RECORD ID (mobility) | error",
						zap.Error(err),
						zap.String("table", task.Src),
					)
					return err
				}

				app.log.Info(
					"QUERY LAST RECORD ID (mobility) | completed",
					zap.String("table", task.Src), zap.Int64("id", srcLastId),
				)

				app.log.Info(
					"QUERY LAST RECORD ID (replica) | started",
					zap.String("table", task.Dest),
				)

				destLastId, err := app.lastRecordID(app.replicaDB, task.Dest)
				if err != nil {
					app.log.Info(
						"QUERY LAST RECORD ID (replica) | error",
						zap.Error(err),
						zap.String("table", task.Dest),
					)
					return err
				}

				app.log.Info(
					"QUERY LAST RECORD ID (replica) | completed",
					zap.String("table", task.Dest), zap.Int64("id", destLastId),
				)

				for from := destLastId; from < srcLastId; from += 1_000_000 {
					if err = app.updateTable(jobCtx, mobilityConn, replicaConn, tx, task.Src, task.Dest, srcLastId, from, 1_000_000); err != nil {
						return err
					}
				}
			}

			app.log.Info(
				"TASK | completed",
				zap.Stringer("type", task.Type), zap.String("src", task.Src), zap.String("dest", task.Dest),
			)
		}

		app.log.Info(
			"COMMIT TRANSACTION (replica) | started",
			zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
		)

		if err = tx.Commit(); err != nil {
			app.log.Error(
				"COMMIT TRANSACTION (replica) | error",
				zap.Error(err),
				zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
			)
			return err
		}

		app.log.Info(
			"COMMIT TRANSACTION (replica) | completed",
			zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
		)

	case multiTx:
		if len(job.Tasks) != 1 && job.Tasks[0].Type != update {
			err = errors.New("multi tx only supports a single update task")
			app.log.Error(
				"JOB | error",
				zap.Error(err),
				zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
			)
			return err
		}

		app.log.Info(
			"QUERY LAST RECORD ID (mobility) | started",
			zap.String("table", job.Tasks[0].Src),
		)

		srcLastId, err := app.lastRecordID(app.mobilityDB, job.Tasks[0].Src)
		if err != nil {
			app.log.Info(
				"QUERY LAST RECORD ID (mobility) | error",
				zap.Error(err),
				zap.String("table", job.Tasks[0].Src),
			)
			return err
		}

		app.log.Info(
			"QUERY LAST RECORD ID (mobility) | completed",
			zap.String("table", job.Tasks[0].Src), zap.Int64("id", srcLastId),
		)

		app.log.Info(
			"QUERY LAST RECORD ID (replica) | started",
			zap.String("table", job.Tasks[0].Dest),
		)

		destLastId, err := app.lastRecordID(app.replicaDB, job.Tasks[0].Dest)
		if err != nil {
			app.log.Info(
				"QUERY LAST RECORD ID (replica) | error",
				zap.Error(err),
				zap.String("table", job.Tasks[0].Dest),
			)
			return err
		}

		app.log.Info(
			"QUERY LAST RECORD ID (replica) | completed",
			zap.String("table", job.Tasks[0].Dest), zap.Int64("id", destLastId),
		)

		for from := destLastId; from < srcLastId; from += 1_000_000 {
			// isolate inside anonymous function to have single defer per for loop
			err = func() error {
				app.log.Info(
					"BEGIN TRANSACTION (replica) | started",
					zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
				)

				tx, err := replicaConn.BeginTx(jobCtx, nil)
				if err != nil {
					app.log.Error(
						"BEGIN TRANSACTION (replica) | error",
						zap.Error(err),
						zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
					)
				}

				app.log.Info(
					"BEGIN TRANSACTION (replica) | completed",
					zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
				)

				defer func() {
					if err := tx.Rollback(); !errors.Is(err, sql.ErrTxDone) && err != nil {
						app.log.Error(
							"ROLLBACK TRANSACTION (replica) | error",
							zap.Error(err),
							zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
						)
					}
				}()

				if err = app.updateTable(jobCtx, mobilityConn, replicaConn, tx, job.Tasks[0].Src, job.Tasks[0].Dest, srcLastId, from, 1_000_000); err != nil {
					return err
				}

				app.log.Info(
					"COMMIT TRANSACTION (replica) | started",
					zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
				)

				if err = tx.Commit(); err != nil {
					app.log.Error(
						"COMMIT TRANSACTION (replica) | error",
						zap.Error(err),
						zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
					)
					return err
				}

				app.log.Info(
					"COMMIT TRANSACTION (replica) | completed",
					zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
				)

				return nil
			}()

			if err != nil {
				return err
			}
		}
	}

	app.log.Info(
		"JOB | completed",
		zap.Stringer("type", job.Type), zap.Strings("tasks", job.Tasks.StringSlice()),
	)

	return nil
}

func (app *Application) lastRecordID(db *bun.DB, table string) (int64, error) {
	var id sql.NullInt64
	err := db.QueryRow(fmt.Sprintf("SELECT max(id) FROM intimev2.%s", table)).Scan(&id)

	if err != nil {
		return -1, err
	}

	return id.Int64, nil
}

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
	from, to := destLastId, destLastId+maxDelta
	if to > srcLastId {
		to = srcLastId
	}

	if from == to || srcLastId < 0 || destLastId < 0 {
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
