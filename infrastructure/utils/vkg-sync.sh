#!/bin/bash
set -euo pipefail

while true; do
    OUT="DUMP-$(date '+%Y%m%d-%H%M%S')"
    mkdir -p $OUT
    ./vkg-download.sh $OUT &> $OUT/download.log
    ./vkg-update.sh &> $OUT/update.log
    sleep 15m
done 

exit 0