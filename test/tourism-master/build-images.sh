#!/usr/bin/env bash

# SPDX-FileCopyrightText: NOI Techpark <digital@noi.bz.it>
#
# SPDX-License-Identifier: CC0-1.0

docker build --target master -t ontopicvkg/odh-tourism-db:master .
docker build --target standalone -t ontopicvkg/odh-tourism-db:standalone .
