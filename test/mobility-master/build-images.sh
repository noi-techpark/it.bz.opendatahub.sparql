#!/usr/bin/env bash
docker build -t registry.gitlab.com/ontopic/odh-vkg-images/odh-mobility-db:master .
docker build -t registry.gitlab.com/ontopic/odh-vkg-images/odh-mobility-db:standalone .
