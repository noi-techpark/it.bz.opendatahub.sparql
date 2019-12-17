#!/bin/sh

set -e
set -o pipefail

echo "Entrypoint - Dumping old DB"
export PGPASSWORD="$ORIGINAL_POSTGRES_PASSWORD"
pg_dump --host=$ORIGINAL_POSTGRES_HOST --username=$ORIGINAL_POSTGRES_USERNAME \
    --no-acl \
    --no-owner \
    --exclude-table='public."AspNetRoles"' \
    --exclude-table='public."AspNetUserClaims"' \
    --exclude-table='public."AspNetUserLogins"' \
    --exclude-table='public."AspNetUserRoles"' \
    --exclude-table='public."AspNetUsers"' \
    --exclude-table='public."users"' \
    --exclude-table='public."tripplaners"' \
    --exclude-table='public."AspNetUserClaims_Id_seq"' \
    $ORIGINAL_POSTGRES_DB | grep -v -E '^(CREATE\ EXTENSION|COMMENT\ ON\ EXTENSION)' > dump.sql

echo "Entrypoint - Restoring new DB"
export PGPASSWORD="$COPY_POSTGRES_PASSWORD"
psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME \
    --command="DROP SCHEMA IF EXISTS public CASCADE;" $COPY_POSTGRES_DB
psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME \
    --command="CREATE SCHEMA public;" $COPY_POSTGRES_DB
psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME \
    --command="DROP EXTENSION IF EXISTS cube; CREATE EXTENSION cube SCHEMA public;" $COPY_POSTGRES_DB
psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME \
    --command="DROP EXTENSION IF EXISTS earthdistance; CREATE EXTENSION earthdistance SCHEMA public;" $COPY_POSTGRES_DB
psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME \
    --command="ALTER role $COPY_POSTGRES_USERNAME SET statement_timeout TO 0;" $COPY_POSTGRES_DB
psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME \
    $COPY_POSTGRES_DB < dump.sql

rm -rf dump.sql

echo "Entrypoint - Create views"
psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME \
    $COPY_POSTGRES_DB < /opt/ontop/src/create_views.sql

psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME \
    --command="ALTER role $COPY_POSTGRES_USERNAME SET statement_timeout TO $COPY_POSTGRES_STATEMENT_TIMEOUT;" $COPY_POSTGRES_DB

echo "Entrypoint - Starting Ontop Endpoint"

/opt/ontop/entrypoint.sh
