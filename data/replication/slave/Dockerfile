FROM postgres:12

COPY original_schema.sql /docker-entrypoint-initdb.d/01-schema.sql
COPY 02-triggers.sql /docker-entrypoint-initdb.d/
