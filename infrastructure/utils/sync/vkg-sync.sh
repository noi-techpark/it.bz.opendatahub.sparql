#!/bin/bash
set -euo pipefail

while true; do
    OUT="DUMP-$(date '+%Y%m%d-%H%M%S')"
    mkdir -p $OUT
    mkdir -p logs
    ./vkg-download.sh $OUT &> $OUT/download.log
    ./vkg-update.sh &> $OUT/update.log
    ./vkg-delete.sh &>> logs/delete.log
    cp $OUT/download.log logs/$OUT-download.log
    cp $OUT/update.log logs/$OUT-update.log
    sleep 15m
done

exit 0
