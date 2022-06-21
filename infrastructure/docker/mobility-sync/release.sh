#!/usr/bin/env bash
MODULE=github.com/noi-techpark/it.bz.opendatahub.sparql/infrastructure/utils/mobility-sync
IMAGE=mobility-sync
GIT_DESCRIPTION=$(git describe --always --dirty --tags --long)

docker build -t $IMAGE:"$GIT_DESCRIPTION" -t $IMAGE:latest --build-arg module="$MODULE" --build-arg version="$GIT_DESCRIPTION" .

# for tag in $GIT_DESCRIPTION latest; do
#   docker push $IMAGE:"$tag"
# done
