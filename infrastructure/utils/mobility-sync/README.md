# Mobility dataset synchronization tool

This tools synchronizes the mobility dataset (the `intimev2` schema) between the mobility database and the VKG one.

It was developed to replace logical replication between the mobility database and the VKG one, which resulted suboptimal due to the huge amount of data ingested by the mobility database.

## How does the synchronization work

The tool differentiates between three kind of tables: big tables, small tables, and append-only tables.

Big tables:

- measurementhistory
- measurementstringhistory

Small tables:

- type
- station
- edge
- measurement
- measurementstring

Append-only tables:

- type_metadata
- metadata

Small tables are handled by reading the entire table from the mobility database via a `COPY TO` statement to local memory, `COPY FROM` into a temporary table in the VKG database, `DELETE FROM` the target table in the VKG database and finally `INSERT INTO` from the temporary table.

Append-only tables are handled by first reading the last record id from both the mobility database and the VKG one, via a `SELECT max(id)`, then a temporary table is created in the VKG database, and the record difference between the VKG and mobility database is first `COPY TO` to memory and then `COPY FROM` to the temporary table in increments of 1000000 records. Once all delta records have been copied, a final `INSERT INTO` is issued against the target table from the temporary table.

Big tables are handled the same as append-only tables, with the difference that every 1000000 records increment is executes as its own transaction. This is done to avoid exhausting memory both locally and on the VKG database side, by committing often and thus freeing the transaction space.

All of these operations are performed inside transactions, which enable us to defer the reference constraints, which would normally avoid the deletion of the table's rows.

This is the list of the transactions run by the tool, which reflects the underlying reference constraints of the schema:

1:

- type
- type_metadata

2:

- metadata
- station

3:

- edge

4:

- measurement

5:

- measurementstring

## CLI interface

```text
Synchronize the replica with the ODH mobility database,
by dumping and restoring data.

Usage:
  mobility-sync [flags]
  mobility-sync [command]

Available Commands:
  completion  Generate the autocompletion script for the specified shell
  help        Help about any command
  version     Display version and build time

Flags:
      --config string                     config file (default is ./mobility-sync.yaml)
      --debug                             enable debug mode with enhanced logs
  -h, --help                              help for mobility-sync
      --interval duration                 duration to wait between synchronization runs (default 5m0s)
      --mobility.addr string              mobility database address
      --mobility.database string          mobility database name
      --mobility.dsn string               mobility database DSN
      --mobility.network string           mobility database network (default "tcp")
      --mobility.password string          mobility user password
      --mobility.password-file string     mobility user password file
      --mobility.ssl-mode string          mobility database ssl mode (verify-full|require|disable) (default "require")
      --mobility.timeout.dial duration    mobility timeout for establishing new connections (default 5s)
      --mobility.timeout.read duration    mobility timeout for socket reads (default 10s)
      --mobility.timeout.write duration   mobility timeout for socket writes (default 5s)
      --mobility.user string              mobility database user
      --replica.addr string               replica database address
      --replica.database string           replica database name
      --replica.dsn string                replica database DSN
      --replica.network string            replica database network (default "tcp")
      --replica.password string           replica user password
      --replica.password-file string      replica user password file
      --replica.ssl-mode string           replica database ssl mode (verify-full|require|disable) (default "require")
      --replica.timeout.dial duration     replica timeout for establishing new connections (default 5s)
      --replica.timeout.read duration     replica timeout for socket reads (default 10s)
      --replica.timeout.write duration    replica timeout for socket writes (default 5s)
      --replica.user string               replica database user
```

Either provide a DNS for a database or build one via the provided flags.

## Environment interface

The same configuration flags can be set via the environment, by prefixing the flag with `MOBILITY_SYNC_`, making it all uppercase, and replacing any dots or dashed with underscores.

For example, `mobility.ssl-mode` becomes `MOBILITY_SYNC_MOBILITY_SSL_MODE`.

## Config file

A YAML configuration file can also be provided to the tool. The configuration keys are the same as the flag names.

In terms of configuration precedence, CLI flags override environmental flags, which in turn override the YAML configuration keys.
