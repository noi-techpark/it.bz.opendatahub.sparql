# Infrastructure

The Virtual Knowledge Graph is composed of a single VKG Postgres DB, from where
we subscribe to various source databases via logical replication. Then, we
create a `SparQL endpoint` and `SparQL querying web application` with two docker
containers, namely `Ontop` and `Nginx`.

If you want to know how to setup logical replication, have a look at our [Flight
Rules](https://github.com/noi-techpark/documentation/blob/master/FLIGHTRULES.md#i-want-to-enable-logical-replication-on-an-awsrds-or-regular-postgres-instance).

## Endpoints

- Production:
  - SparQL endpoint: https://sparql.opendatahub.bz.it/sparql 
  - SparQL querying web application: https://sparql.opendatahub.bz.it
  - Json-LD endpoint: https://sparql.opendatahub.bz.it/api/JsonLD
- Testing:
  - SparQL endpoint: https://sparql.opendatahub.testingmachine.eu/sparql 
  - SparQL querying web application: https://sparql.opendatahub.testingmachine.eu
  - Json-LD endpoint: https://sparql.opendatahub.testingmachine.eu/api/JsonLD

## Jenkins

- CI: https://ci.opendatahub.bz.it/job/it.bz.opendatahub.sparql
- CD: https://jenkins.testingmachine.eu/job/it.bz.opendatahub.sparql

## Credentials

Prefix is `it.bz.opendatahub.sparql`.

- `it.bz.opendatahub.sparql.db.vkg.password`
- `it.bz.opendatahub.sparql.db.vkg.password.readonly`
- `it.bz.opendatahub.sparql.db.tourism.password`

## Databases

### Tourism Postgres DB (source)
This is the original source of tourism data. We access it through logical
replication as described in our [Flight
Rules](https://github.com/noi-techpark/documentation/blob/master/FLIGHTRULES.md#i-want-to-enable-logical-replication-on-an-awsrds-or-regular-postgres-instance).

## Security

Open ports (Postgres' default is `5432`)
- The VKG database must have access to the tourism db for the subscription
- The Docker server must have access to the VKG database

Create DB roles
- See both database sections for further details

### Virtual Knowledge Graph Postgres DB (destination)

## Docker containers
First, we start an `Ontop` container, which initially executes
[Flyway](https://flywaydb.org) to update the schema of the replication database.

Second, we start an `Nginx` container to serve the web frontend of the SparQL endpoint.

## Flight Rules

### I want to update the tourism DB dump

The current dump is inside `sql/V1__initial_setup.sql`.

```sh
cd infrastructure/utils
./tourism-dump-schema.sh
```

### I have a Flyway schema error, which I want to repair

Assume that the docker of Ontop runs on `dockertest2` and all commands are
executed as `root`.

```sh
ssh dockertest2
cd /var/docker/odh-vkg/current
docker-compose run --entrypoint="flyway -X repair" ontop
```

### I want to login into the Ontop container

Assume that the docker of Ontop runs on `dockertest2` and all commands are
executed as `root`.

```sh
ssh dockertest2
cd /var/docker/odh-vkg/current
docker-compose run --entrypoint=/bin/bash ontop
```
