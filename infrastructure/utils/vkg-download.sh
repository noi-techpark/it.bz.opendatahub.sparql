#!/bin/bash
set -euo pipefail

export LC_ALL=en_US.UTF-8

HOST="prod-pg-bdp.co90ybcr8iim.eu-west-1.rds.amazonaws.com"
DB="bdp"
USER="vkgreplicate"
PSQL="psql -h $HOST -p 5432 -U $USER $DB --csv -v ON_ERROR_STOP=on -t -1 "

HOSTVKG="prod-postgres-vkg.co90ybcr8iim.eu-west-1.rds.amazonaws.com"
DBVKG="test"
USERVKG="vkguser"
PSQLVKG="psql -h $HOSTVKG -p 5432 -U $USERVKG $DBVKG --csv -v ON_ERROR_STOP=on -t -1 "

OUT=$1
mkdir -p "$OUT"
OUTLINK="DUMP"

# Take the biggest id from all tables that have only inserts
# - measurementhistory
# - measurementstringhistory
# - type_metadata
# - metadata
if [ -f "$OUT/orig_max_id.csv" ]; then
    echo Skipping "$OUT/orig_max_id.csv"
else
    $PSQL > "$OUT/orig_max_id.csv" << EOF
    select max(id) from measurementhistory
    union all
    select max(id) from measurementstringhistory
    union all
    select max(id) from type_metadata
    union all
    select max(id) from metadata;
EOF
    CHECK=$(wc -l $OUT/orig_max_id.csv | awk '{print $1}')
    test $((CHECK == 4))
fi


if [ -f "$OUT/vkg_max_id.csv" ]; then
    echo Skipping "$OUT/vkg_max_id.csv"
else
    $PSQLVKG > "$OUT/vkg_max_id.csv" << EOF
    select max(id) from intimev2.measurementhistory
    union all
    select max(id) from intimev2.measurementstringhistory
    union all
    select max(id) from intimev2.type_metadata
    union all
    select max(id) from intimev2.metadata;
EOF
    CHECK=$(wc -l $OUT/vkg_max_id.csv | awk '{print $1}')
    test $((CHECK == 4))
fi

# Dump all tables that have updates
# - measurement
# - measurementstring
# - edge
# - type
# - station
function download_all() {
    TABLE=$1
    if [ -f "$OUT/$TABLE.csv" ]; then
        echo Skipping "$OUT/$TABLE.csv"
    else
        $PSQL > "$OUT/$TABLE.csv" -c "table $TABLE"
    fi
}
download_all measurement
download_all measurementstring
download_all edge
download_all type
download_all station


# Export all tables with only inserts from the VKG id to the source ID
function download() {
    CNT_ROW=$1
    TABLE=$2
    START=$(sed -n ${CNT_ROW}p "$OUT/vkg_max_id.csv")
    END=$(sed -n ${CNT_ROW}p "$OUT/orig_max_id.csv")
    STEP=1000000
    i=$START
    echo "START = $START; END = $END"
    while ((i < END)); do
        FROM=$i
        if ((i+STEP-1 > END)); then 
            TO=$END
        else
            TO=$((i+STEP))
        fi
        OUTFILE="$OUT/$TABLE-$FROM-$TO.csv"
        if [ -f "$OUTFILE" ]; then
            echo Skipping "$OUTFILE"
        else
            echo "select $TABLE FROM $FROM TO $TO --> $OUTFILE"
            $PSQL > "$OUTFILE" -c "select * from $TABLE where id > $FROM and id <= $TO" 
            echo "$TO" > "$OUT/${TABLE}_latest.csv"
        fi
        ((i += STEP))
    done
}
download 1 measurementhistory
download 2 measurementstringhistory
download 3 type_metadata
download 4 metadata

# Point to the latest download folder
rm -f "$OUTLINK"
ln -s "$OUT" "$OUTLINK"

exit 0

