FROM ontop/ontop-endpoint:4.0-snapshot as base
COPY --from=flyway/flyway:6.3.3 /flyway /flyway
ENV PATH="/flyway:${PATH}"

# Dev
FROM base as dev

# Build
FROM base as build
RUN apk add --no-cache postgresql-client
COPY docker/entrypoint.sh /entrypoint.sh
COPY sql /opt/ontop/sql
COPY vkg /opt/ontop/input
COPY jdbc /opt/ontop/jdbc
ENTRYPOINT /entrypoint.sh
