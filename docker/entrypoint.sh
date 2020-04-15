#!/bin/sh

set -e
set -o pipefail

echo "Entrypoint - Run Flyway Migrations"
/usr/local/bin/flyway migrate

echo "Entrypoint - Starting Ontop Endpoint"
/opt/ontop/entrypoint.sh
