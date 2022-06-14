FROM ontop/ontop-endpoint:4.2.0 as base
RUN apt-get update && apt-get install -y curl postgresql-client

# Dev
FROM base as dev
RUN curl https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /wait-for-it.sh
RUN chmod u+x /wait-for-it.sh

# Build
FROM base as build
COPY vkg /opt/ontop/input
COPY jdbc /opt/ontop/jdbc
