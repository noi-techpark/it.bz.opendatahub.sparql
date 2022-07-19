# Infrastructure

The Virtual Knowledge Graph is composed of a single VKG Postgres DB, which
aggregates the tourism and mobility datasets into a single database. Then, we
create a `SparQL endpoint` and `SparQL querying web application` with two docker
containers, namely `Ontop` and `Nginx`.

- [Infrastructure](#infrastructure)
	- [Endpoints](#endpoints)
	- [Credentials](#credentials)
	- [Security](#security)
	- [Databases](#databases)
		- [Tourism Postgres DB](#tourism-postgres-db)
		- [Virtual Knowledge Graph Postgres DB](#virtual-knowledge-graph-postgres-db)
	- [Docker containers](#docker-containers)
		- [I want to update the tourism DB dump](#i-want-to-update-the-tourism-db-dump)
		- [I want to login into the Ontop container](#i-want-to-login-into-the-ontop-container)

## Endpoints

Current deployments:

- Production: <https://sparql.opendatahub.bz.it>
- Testing: <https://sparql.opendatahub.testingmachine.eu>

On these servers, one can find:

- Front-end portal:  `/`
- SPARQL endpoint: `/sparql`
- Predefined queries: `/predefined/{queryId}?{param1=value1}*`
  - Example: <https://sparql.opendatahub.testingmachine.eu/predefined/accommodation?Id=86673280ABD13ADC4D521DF459C75474>
- Clone of the existing ODH API `/api/JsonLD/DetailInLD?type={value1}&{param2=value2}*`
  - Example: <https://sparql.opendatahub.testingmachine.eu/api/JsonLD/DetailInLD?type=accommodation&Id=32E7BE648E7B11D181AB006097B896BA&showid=false>
- `/restricted` to enter a restricted area which needs a login. From here you
  can access also closed data. See [docs/authentication.md](docs/authentication.md)
  for details.

## Credentials

Passbolt:

- Resource = `it.bz.opendatahub.sparql.db.vkg`; Username = `ontopic`
- Resource = `it.bz.opendatahub.sparql.db.vkg`; Username = `ontopicreadonly`
- Resource = `it.bz.opendatahub.sparql.db.vkg`; Username = `postgres`

## Security

Open ports (Postgres' default is `5432`)

- The Docker server must have access to the VKG database

Create DB roles

- See both database sections for further details

## Databases

The databases used in the test and production environments of NOI are not
managed by Docker, but are instead AWS RDS services.

### Tourism Postgres DB

This is the original source of tourism data.

### Virtual Knowledge Graph Postgres DB

We use Flyway for Database Migrations. Refer to the [dedicated document](utils/flyway/README.md) for details.

## Docker containers

First, we start an `Ontop` container.

Second, we start an `Nginx` container to serve the web frontend of the SparQL endpoint.

### I want to update the tourism DB dump

The current dump is inside `infrastructure/utils/flyway/migration/V1__initial_setup.sql`.

```sh
cd infrastructure/utils
./dump-tourism.sh
```

### I want to login into the Ontop container

Assume that the docker of Ontop runs on `dockertest` and all commands are
executed as `root`.

```sh
ssh dockertest
cd /var/docker/odh-vkg/current
docker-compose run --entrypoint=/bin/bash ontop
```
