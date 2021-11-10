#!/bin/bash
set -euo pipefail

export LC_ALL=en_US.UTF-8

HOSTVKG="prod-postgres-vkg.co90ybcr8iim.eu-west-1.rds.amazonaws.com"
DBVKG="test"
USERVKG="vkguser"

PSQLVKG="psql -h $HOSTVKG -p 5432 -U $USERVKG $DBVKG --csv -v ON_ERROR_STOP=on -t -1 "

OUT="DUMP"
mkdir -p $OUT/DONE

function upsert() {
    TBL=$1
    shift
    GLOB=$@
    ls $GLOB &>/dev/null || {
        echo "..... UPSERT: Skipping... No file found for table $TBL with glob $GLOB"
        return
    }
    $PSQLVKG -c "create table if not exists intimev2.${TBL}_tmp as table intimev2.${TBL} with no data"    
    for FILE in $(ls $GLOB); do
        echo "..... UPSERT: Processing $FILE..."
        $PSQLVKG -c "truncate intimev2.${TBL}_tmp;"
        cat $FILE | $PSQLVKG -c "copy intimev2.${TBL}_tmp from stdin with delimiter ',' csv;"
        QRY=$(while read data; do echo "$data"; done)
        $PSQLVKG -c "$QRY"
        mv $FILE $OUT/DONE
        echo "..... UPSERT: READY."
    done
    $PSQLVKG -c "drop table intimev2.${TBL}_tmp"
}

#
# type_metadata
#
upsert "type_metadata" $OUT/type_metadata-*.csv << EOF
    insert into intimev2.type_metadata 
    table intimev2.type_metadata_tmp 
    on conflict do nothing
EOF

#
# type
#
upsert "type" $PWD/$OUT/type.csv << EOF
    update intimev2.type 
    set
        cname = type_tmp.cname, 
        created_on = type_tmp.created_on, 
        cunit = type_tmp.cunit, 
        description = type_tmp.description, 
        rtype = type_tmp.rtype, 
        meta_data_id = type_tmp.meta_data_id
    from intimev2.type_tmp
    where type.id = type_tmp.id
    and type.cname = type_tmp.cname;

    insert into intimev2.type select * from intimev2.type_tmp on conflict do nothing;
EOF

#
# metadata
#
upsert "metadata" $OUT/metadata-*.csv << EOF
    insert into intimev2.metadata table intimev2.metadata_tmp on conflict do nothing;
EOF

#
# station
#
upsert "station" $PWD/$OUT/station.csv << EOF
    update intimev2.station 
    set
        active = tmp.active,
        available = tmp.available,
        name = tmp.name, 
        origin = tmp.origin, 
        pointprojection = tmp.pointprojection, 
        stationcode = tmp.stationcode, 
        stationtype = tmp.stationtype, 
        meta_data_id = tmp.meta_data_id,
        parent_id = tmp.parent_id
    from intimev2.station_tmp tmp
    where station.stationcode = tmp.stationcode
    and station.stationtype = tmp.stationtype
    and station.id = tmp.id;

    insert into intimev2.station select * from intimev2.station_tmp on conflict do nothing;
EOF

#
# Upsert all tables that have updates
#
function copy_delete_insert() {
	TBL=$1
    shift
    upsert "$TBL" $@ << EOF
	    delete from intimev2.$TBL; 
        insert into intimev2.$TBL table intimev2.${TBL}_tmp
EOF
}

function copy_insert() {
	TBL=$1
    shift
	upsert "$TBL" $@ << EOF
        insert into intimev2.$TBL table intimev2.${TBL}_tmp on conflict do nothing
EOF
}

copy_delete_insert edge $OUT/edge.csv
copy_delete_insert measurement $OUT/measurement.csv
copy_delete_insert measurementstring $OUT/measurementstring.csv

# Take the biggest id from all tables that have only inserts
# - measurementhistory
# - measurementstringhistory
copy_insert measurementhistory $OUT/measurementhistory-*.csv
copy_insert measurementstringhistory $OUT/measurementstringhistory-*.csv

exit 0

