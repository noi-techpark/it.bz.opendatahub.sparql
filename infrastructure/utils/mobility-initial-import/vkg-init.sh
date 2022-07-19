#!/bin/bash
set -euo pipefail

export LC_ALL=en_US.UTF-8

HOSTVKG="virtual-knowledge-graph.co90ybcr8iim.eu-west-1.rds.amazonaws.com"
DBVKG="test"
USERVKG="ontopic"

PSQLVKG="psql -h $HOSTVKG -p 5432 -U $USERVKG $DBVKG --csv -v ON_ERROR_STOP=on -t -1 "

OUT="DUMP"
mkdir -p $OUT/DONE

main() {

    echo "!! WARNING !!"
    echo "This script truncates all your tables inside $HOSTVKG/$DBVKG!"
    read -rp "Continue? (Y/N): " confirm

    if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        echo "OK... truncating!"
    else
        echo "EXITING"
        exit 1
    fi

    #$PSQLVKG -c "truncate intimev2.metadata cascade; truncate intimev2.station cascade; truncate intimev2.type cascade; truncate intimev2.type_metadata cascade; "

    echo "TYPE: Remove FK to type_metadata"
    $PSQLVKG -c "ALTER TABLE intimev2.type DROP CONSTRAINT IF EXISTS fk_type_meta_data_id_type_metadata_pk;"

    #
    # type
    #
    upsert "type" "$PWD/$OUT/type.csv" << EOF
        insert into intimev2.type select * from intimev2.type_tmp;
EOF


    #
    # type_metadata
    #
    upsert "type_metadata" $OUT/type_metadata-*.csv << EOF
        insert into intimev2.type_metadata
        table intimev2.type_metadata_tmp
EOF

    echo "TYPE: ADD FK to type_metadata"
    $PSQLVKG -c "ALTER TABLE intimev2.type ADD CONSTRAINT fk_type_meta_data_id_type_metadata_pk FOREIGN KEY (meta_data_id) REFERENCES intimev2.type_metadata(id) DEFERRABLE INITIALLY DEFERRED;"


    echo "STATION: Remove FK to metadata"
    $PSQLVKG -c "ALTER TABLE intimev2.station DROP CONSTRAINT IF EXISTS fk_station_meta_data_id_metadata_pk;"

    #
    # station
    #
    upsert "station" "$PWD/$OUT/station.csv" << EOF
        insert into intimev2.station table intimev2.station_tmp
EOF


    #
    # metadata
    #
    upsert "metadata" $OUT/metadata-*.csv << EOF
        insert into intimev2.metadata table intimev2.metadata_tmp
EOF

    echo "STATION: Add FK to metadata"
    $PSQLVKG -c "ALTER TABLE intimev2.station ADD CONSTRAINT fk_station_meta_data_id_metadata_pk FOREIGN KEY (meta_data_id) REFERENCES intimev2.metadata(id) DEFERRABLE INITIALLY DEFERRED;"

    copy_delete_insert edge $OUT/edge.csv
    copy_delete_insert measurement $OUT/measurement.csv
    copy_delete_insert measurementstring $OUT/measurementstring.csv

}

upsert() {
    TBL=$1
    shift
    GLOB=$@
    ls $GLOB &>/dev/null || {
        echo "..... UPSERT: Skipping... No file found for table $TBL with glob $GLOB"
        return
    }
    QRY=$(while read data; do echo "$data"; done)
    $PSQLVKG -c "create table if not exists intimev2.${TBL}_tmp as table intimev2.${TBL} with no data"
    for FILE in $(ls $GLOB); do
        echo "..... UPSERT: Processing $FILE..."
        $PSQLVKG -c "truncate intimev2.${TBL}_tmp;"
        $PSQLVKG -c "copy intimev2.${TBL}_tmp from stdin with delimiter ',' csv;" < "$FILE"
        $PSQLVKG -c "$QRY"
        mv "$FILE" $OUT/DONE
        echo "..... UPSERT: READY."
    done
    $PSQLVKG -c "drop table intimev2.${TBL}_tmp"
}

#
# Upsert all tables that have updates
#
copy_delete_insert() {
    TBL=$1
    shift
    upsert "$TBL" $@ << EOF
        delete from intimev2.$TBL;
        insert into intimev2.$TBL table intimev2.${TBL}_tmp
EOF
}

main "$@"
