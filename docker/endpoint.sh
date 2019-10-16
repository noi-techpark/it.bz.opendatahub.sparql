#!/bin/sh

export PGPASSWORD="$ORIGINAL_POSTGRES_PASSWORD"
pg_dump --host=$ORIGINAL_POSTGRES_HOST --username=$ORIGINAL_POSTGRES_USERNAME $ORIGINAL_POSTGRES_DB > dump.sql

export PGPASSWORD="$COPY_POSTGRES_PASSWORD"
psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME $COPY_POSTGRES_DB --command="DROP SCHEMA IF EXISTS public;"
psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME $COPY_POSTGRES_DB --command="CREATE SCHEMA public;"
psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME $COPY_POSTGRES_DB < dump.sql

rm -rf dump.sql

psql --host=$COPY_POSTGRES_HOST --username=$COPY_POSTGRES_USERNAME $COPY_POSTGRES_DB < /opt/ontop/src/create_views.sql

java -cp ./lib/*:./jdbc/* -Dlogback.configurationFile=./log/logback.xml \
    it.unibz.inf.ontop.cli.Ontop endpoint \
    --ontology=$ONTOLOGY_FILE \
    --mapping=$MAPPING_FILE \
    --properties=$PROPERTIES_FILE
