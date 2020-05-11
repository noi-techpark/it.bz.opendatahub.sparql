FROM postgres:12

COPY original_schema.sql /docker-entrypoint-initdb.d/01-original_schema.sql
COPY create_triggers_gen.sql /docker-entrypoint-initdb.d/02-triggers_and_tables.sql
COPY dump-tourism-201911121025.sql.gz /docker-entrypoint-initdb.d/03-dump.sql.gz
