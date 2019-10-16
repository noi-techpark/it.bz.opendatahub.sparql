#!/bin/sh

set -e
set -o pipefail

echo "Entrypoint - Dumping old DB"
export PGPASSWORD="$ORIGINAL_POSTGRES_PASSWORD"
pg_dump --host=$ORIGINAL_POSTGRES_HOST --username=$ORIGINAL_POSTGRES_USERNAME \
    --exclude-table='public."AspNetRoles"' \
    --exclude-table='public."AspNetUserClaims"' \
    --exclude-table='public."AspNetUserLogins"' \
    --exclude-table='public."AspNetUserRoles"' \
    --exclude-table='public."AspNetUsers"' \
    --exclude-table='public."users"' \
    --exclude-table='public."tripplaners"' \
    --exclude-table='public."AspNetUserClaims_Id_seq"' \
    $ORIGINAL_POSTGRES_DB > dump.sql

echo "Entrypoint - Restoring new DB"
export PGPASSWORD="$COPY_POSTGRES_PASSWORD"
psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME \
    --command="DROP SCHEMA IF EXISTS public;" $COPY_POSTGRES_DB
psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME \
    --command="CREATE SCHEMA public;" $COPY_POSTGRES_DB
psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME \
    $COPY_POSTGRES_DB < dump.sql

rm -rf dump.sql

echo "Entrypoint - Create views"
psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME \
    $COPY_POSTGRES_DB < /opt/ontop/src/create_views.sql

echo "Entrypoint - Starting Ontop Endpoint"
java -cp ./lib/*:./jdbc/* -Dlogback.configurationFile=./log/logback.xml \
    it.unibz.inf.ontop.cli.Ontop endpoint \
    --ontology=$ONTOLOGY_FILE \
    --mapping=$MAPPING_FILE \
    --properties=$PROPERTIES_FILE
