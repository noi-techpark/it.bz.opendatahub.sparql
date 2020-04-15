#!/bin/sh

set -e
set -o pipefail

echo "Entrypoint - Run Flyway Migrations"
/usr/local/bin/flyway -locations=filesystem:/opt/ontop/sql migrate

echo "Entrypoint - Starting Ontop Endpoint"
/opt/ontop/entrypoint.sh
