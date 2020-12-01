FROM ontop/ontop-endpoint:4.1-snapshot as base
RUN apk add --update curl && \
    rm -rf /var/cache/apk/*
COPY --from=flyway/flyway:7.3-alpine /flyway /flyway
RUN ln -s /flyway/flyway /usr/local/bin/flyway
RUN apk add --no-cache postgresql-client
COPY infrastructure/docker/ontop/entrypoint.sh /entrypoint.sh
COPY sql /opt/ontop/sql

# Dev
FROM base as dev

RUN curl https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /wait-for-it.sh
RUN chmod u+x /wait-for-it.sh
# Overrides some scripts
COPY test/sql/* /opt/ontop/sql/

# Build
FROM base as build
COPY vkg /opt/ontop/input
COPY jdbc /opt/ontop/jdbc
ENTRYPOINT /entrypoint.sh