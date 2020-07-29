FROM postgres:12 as base
COPY original_schema.sql /docker-entrypoint-initdb.d/01-original_schema.sql
COPY dump-tourism-201911121025.sql.gz /docker-entrypoint-initdb.d/03-dump.sql.gz

FROM base as master
CMD ["postgres", "-c", "wal_level=logical"]
COPY 04-publication.sql /docker-entrypoint-initdb.d/

FROM base as standalone
COPY triggers_and_derived_tables.sql /docker-entrypoint-initdb.d/02-triggers_and_tables.sql
