#!/usr/bin/env bash
MODULE=github.com/noi-techpark/it.bz.opendatahub.sparql/infrastructure/utils/mobility-sync

echo "Building binary..."

GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -a -ldflags \
"-s -w -X ${MODULE}/cmd.version=$(git describe --always --dirty --tags --long) -X ${MODULE}/cmd.buildTime=$(date -u +%Y-%m-%dT%H:%M:%SZ)" .
