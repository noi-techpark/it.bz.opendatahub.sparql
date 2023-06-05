#!/usr/bin/env bash

# SPDX-FileCopyrightText: NOI Techpark <digital@noi.bz.it>
#
# SPDX-License-Identifier: CC0-1.0

docker build --target master -t registry.gitlab.com/ontopic/odh-vkg-images/odh-mobility-db:master .
docker build --target standalone -t registry.gitlab.com/ontopic/odh-vkg-images/odh-mobility-db:standalone .
