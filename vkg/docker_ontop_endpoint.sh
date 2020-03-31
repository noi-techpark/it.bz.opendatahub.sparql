#!/usr/bin/env sh

# please run this at the root of this repository

docker run --rm \
-v $PWD/vkg:/opt/ontop/input \
-v $PWD/jdbc:/opt/ontop/jdbc \
-e ONTOP_ONTOLOGY_FILE=/opt/ontop/input/odh.ttl \
-e ONTOP_MAPPING_FILE=/opt/ontop/input/odh.obda \
-e ONTOP_PROPERTIES_FILE=/opt/ontop/input/odh.properties \
-e ONTOP_PORT
-p 8080:8080 ontop/ontop-endpoint:4.0-snapshot
