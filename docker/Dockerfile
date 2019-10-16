FROM ontop/ontop-endpoint:4.0-snapshot as base

FROM base as dev

FROM base as build

RUN apk add --no-cache postgresql-client

COPY docker/endpoint.sh /endpoint.sh

ENTRYPOINT /endpoint.sh
