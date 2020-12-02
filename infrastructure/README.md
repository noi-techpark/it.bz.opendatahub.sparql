# Infrastructure

The Virtual Knowledge Graph is composed of a single VKG Postgres DB, from where we subscribe to various source databases via logical replication. Then, we create a `SparQL endpoint` and `SparQL querying web application` with two docker containers, namely `Ontop` and `Nginx`.

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
This is the original source of tourism data. We access it through logical replication. To do so, we need to activate logical replication within the Tourism DB.

- TODO describe the env variables related to this DB (link to jenkins/test/prod.groovy)
- TODO Write flightrule for logical replication setup and link to it
- TODO Put the most important SQL scripts here (or better add it to a general vkg CLI script)
- TODO Add all passwords to passbolt 

We subscribe to this database, which exposes a logical replication publication with the following parameters:

```
```

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
