FROM ontop/ontop-endpoint:4.0-snapshot as base

# Dev
FROM base as dev

# Build
FROM base as build
COPY --from=flyway/flyway:6.4.0-alpine /flyway /flyway
RUN ln -s /flyway/flyway /usr/local/bin/flyway
RUN apk add --no-cache postgresql-client
COPY infrastructure/docker/ontop/entrypoint.sh /entrypoint.sh
COPY sql /opt/ontop/sql
COPY vkg /opt/ontop/input
COPY jdbc /opt/ontop/jdbc
ENTRYPOINT /entrypoint.sh
