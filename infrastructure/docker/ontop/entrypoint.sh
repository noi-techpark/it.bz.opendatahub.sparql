#!/bin/sh

set -e
set -o pipefail

echo "Entrypoint - Run Flyway Migrations"
/usr/local/bin/flyway -X -locations=filesystem:/opt/ontop/sql ${EXTRA_FLYWAY_OPTIONS} repair

echo "Entrypoint - Starting Ontop Endpoint"
/opt/ontop/entrypoint.sh
