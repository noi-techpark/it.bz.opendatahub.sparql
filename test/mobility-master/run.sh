# SPDX-FileCopyrightText: NOI Techpark <digital@noi.bz.it>
#
# SPDX-License-Identifier: CC0-1.0

docker run --rm --name odh-mobility-db-running -e POSTGRES_USER=tourismuser -e POSTGRES_PASSWORD=postgres2 -e POSTGRES_DB=mobility registry.gitlab.com/ontopic/odh-vkg-images/odh-mobility-db
