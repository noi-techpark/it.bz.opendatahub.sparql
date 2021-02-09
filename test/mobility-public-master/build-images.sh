#!/usr/bin/env bash
docker build --target master -t ontopicvkg/odh-mobility-db-public:master .
docker build --target standalone -t ontopicvkg/odh-mobility-db-public:standalone .
