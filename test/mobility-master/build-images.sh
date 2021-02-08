#!/usr/bin/env bash
docker build --target master -t registry.gitlab.com/ontopic/odh-vkg-images/odh-mobility-db:master .
docker build --target standalone -t registry.gitlab.com/ontopic/odh-vkg-images/odh-mobility-db:standalone .
