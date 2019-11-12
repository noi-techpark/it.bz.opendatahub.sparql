FROM postgres:12

COPY dump-tourism-201911121025.sql.gz /docker-entrypoint-initdb.d/01-dump.sql.gz
COPY create_views.sql /docker-entrypoint-initdb.d/02-views.sql
