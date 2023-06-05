#!/usr/bin/env bash

# SPDX-FileCopyrightText: NOI Techpark <digital@noi.bz.it>
#
# SPDX-License-Identifier: CC0-1.0

docker build --target master -t ontopicvkg/odh-mobility-db-public:master .
docker build --target standalone -t ontopicvkg/odh-mobility-db-public:standalone .
