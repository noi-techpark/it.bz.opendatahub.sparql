#!/bin/bash

set -eo pipefail

echo "Entrypoint - Run Flyway Migrations"
/usr/local/bin/flyway -locations=filesystem:/opt/ontop/sql "${EXTRA_FLYWAY_OPTIONS}" migrate

echo "Entrypoint - Starting Ontop Endpoint"
/opt/ontop/entrypoint.sh
