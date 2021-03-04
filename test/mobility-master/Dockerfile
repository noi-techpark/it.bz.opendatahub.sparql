FROM postgis/postgis:13-3.1-alpine as base

# postgis image has a script: 10_postgis.sh

COPY original_schema.sql /docker-entrypoint-initdb.d/20-original_schema.sql
COPY dump-mobility-20200714.sql.gz /docker-entrypoint-initdb.d/30-dump.sql.gz

FROM base as master
CMD ["postgres", "-c", "wal_level=logical"]
COPY 04-publication.sql /docker-entrypoint-initdb.d/40-publication.sql

FROM base as standalone
