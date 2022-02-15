#!/bin/bash

set -euo pipefail

# Delete everything that is older than 180 minutes
find DUMP-2021* -maxdepth 0 -type d -mmin +180 -exec rm -rf "{}" \;

exit 0
