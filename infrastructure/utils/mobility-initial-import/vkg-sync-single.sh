#!/bin/bash
set -euo pipefail

export LC_ALL=en_US.UTF-8

HOST="prod-pg-bdp.co90ybcr8iim.eu-west-1.rds.amazonaws.com"
DB="bdp"
USER="pmoser"
PSQL="psql -h $HOST -p 5432 -U $USER $DB -v ON_ERROR_STOP=on -t -1 "

HOSTVKG="virtual-knowledge-graph.co90ybcr8iim.eu-west-1.rds.amazonaws.com"
DBVKG="test"
USERVKG="ontopic"
PSQLVKG="psql -h $HOSTVKG -p 5432 -U $USERVKG $DBVKG -v ON_ERROR_STOP=on -t -1 "

TABLE=${1?Missing table name}
STEP=${2:-1000000}

START=$($PSQLVKG -c "select coalesce(max(id), 0) from intimev2.$TABLE" | xargs)
END=$($PSQL -c "select max(id) from $TABLE" | xargs)
ITERATIONS=$(((END - START) / STEP))
echo "START = $START; END = $END; STEP = $STEP; ITERATIONS = $ITERATIONS"

i=$START
while ((i < END)); do
    FROM=$i
    if ((i+STEP-1 > END)); then
        TO=$END
    else
        TO=$((i+STEP))
    fi

    ROUND=$(( ITERATIONS - ((END - FROM) / STEP) ))

    echo "$ROUND/$ITERATIONS: select $TABLE FROM $FROM TO $TO --> VKG DB DIRECTLY"
    $PSQL -c "copy (select * from $TABLE where id > $FROM and id <= $TO) to stdout;" | $PSQLVKG -c "copy intimev2.$TABLE from stdin;"
    ((i += STEP))
done

echo "READY."
echo

exit 0
