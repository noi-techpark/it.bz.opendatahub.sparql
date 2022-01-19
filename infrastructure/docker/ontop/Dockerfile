FROM ontop/ontop-endpoint:4.2.0 as base
COPY --from=flyway/flyway:7.3-alpine /flyway /flyway
COPY infrastructure/docker/ontop/entrypoint.sh /entrypoint.sh
COPY sql /opt/ontop/sql
RUN apt-get update && apt-get install -y curl postgresql-client && \
    ln -s /flyway/flyway /usr/local/bin/flyway

# Dev
FROM base as dev
RUN curl https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /wait-for-it.sh
RUN chmod u+x /wait-for-it.sh

# Build
FROM base as build
COPY vkg /opt/ontop/input
COPY jdbc /opt/ontop/jdbc
ENTRYPOINT /entrypoint.sh
