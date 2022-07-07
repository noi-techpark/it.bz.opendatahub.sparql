#!/bin/bash

set -eo pipefail

echo "### Entrypoint - Run Flyway Migrations"

echo "# Migrating MOBILITY: intimev2"
/usr/local/bin/flyway -X -locations=filesystem:"/opt/ontop/sql/mobility" -schemas="intimev2" migrate

echo "# Migrating TOURISM: public"
/usr/local/bin/flyway -X -locations=filesystem:"/opt/ontop/sql/tourism" -schemas="public" migrate

echo "### Entrypoint - Run Flyway Migrations: READY."

echo "### Entrypoint - Starting Ontop Endpoint"
/opt/ontop/entrypoint.sh
