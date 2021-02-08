#!/usr/bin/env bash
docker build --target master -t ontopicvkg/odh-tourism-db:master .
docker build --target standalone -t ontopicvkg/odh-tourism-db:standalone .
