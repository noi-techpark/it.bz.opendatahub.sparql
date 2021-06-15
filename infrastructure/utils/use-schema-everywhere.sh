#!/bin/bash
set -euo pipefail

SUBST_REGEXP="$1"
FILE="$2"

sed -i '' \
    -re "s/((CREATE|DROP|ALTER) (TABLE|FUNCTION|TRIGGER)( IF EXISTS)* )/\\1$SUBST_REGEXP./g" \
    -re "s/(FROM )/\\1$SUBST_REGEXP./g" \
    -re "s/(INSERT INTO )/\\1$SUBST_REGEXP./g" "$FILE"

