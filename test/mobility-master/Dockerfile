FROM postgis/postgis:13-3.1-alpine as base

COPY original_schema.sql /docker-entrypoint-initdb.d/01-original_schema.sql
COPY dump-mobility-20200714.sql.gz /docker-entrypoint-initdb.d/03-dump.sql.gz

FROM base as master
CMD ["postgres", "-c", "wal_level=logical"]
COPY 04-publication.sql /docker-entrypoint-initdb.d/

FROM base as standalone
