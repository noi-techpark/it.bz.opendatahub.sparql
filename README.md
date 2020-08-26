# odh-vkg

Virtual Knowledge Graph (VKG) over the Open Data Hub (ODH).

## Table of contents

- [Getting started](#getting-started)
- [Deployment at NOI](#deployment-at-noi)
- [Maintenance](#maintenance)
- [Information](#information)

## Getting started

These instructions will get you a copy of the project up and running
on your local machine for development and testing purposes.

### Prerequisites

For a ready to use Docker environment with all prerequisites already installed
and prepared, you can check out the [Docker environment](#docker-environment)
section.

### Source code

Get a copy of the repository:

```bash
git clone https://github.com/noi-techpark/odh-vkg.git
```

Change directory:

```bash
cd odh-vkg/
```

### Local deployment

1. Create the `.env` file in which, amongst all, the SPARQL endpoint port and the PG external port (for debugging purposes) are specified

* `cp .env.example .env`

2. Start the Docker container (see [the dedicated section](#Start-and-stop-the-containers))

3. Visit the SPARQL endpoint

* Now we can open the link <http://localhost:8080> in the browser and test some SPARQL queries
* Note that synchronisation between the master and the slave takes some time. Until it is finished, some queries may return empty results.

#### Docker environment

For the project a Docker environment is already prepared and ready to use with all necessary prerequisites.

The default Docker Compose file *(docker-compose.yml)* uses 3 containers:
 - A PostgreSQL  DB containing a fragment of the ODH Tourism dataset
 - Ontop as SPARQL endpoint
 - Nginx as reverse proxy and cache


#### Installation

Install [Docker](https://docs.docker.com/install/) (with Docker Compose) locally on your machine.

#### Start and stop the containers

##### Option 1: On the foreground

To start the container on the foreground:
```
docker-compose pull && docker-compose up --build
```
The container is run on the foreground and can be stopped by pressing CTRL-C.

##### Option 2: On the background

To start the container on the background:
```
docker-compose pull && docker-compose up --build -d
```

To stop it:
```
docker-compose down
```

## Deployment at NOI

The databases used in the test and production environments of NOI are not managed by Docker, but are instead AWS RDS services.

Deployment in these environments is achieved through Jenkins scripts (*Jenkinsfile-CI.groovy*, *Jenkinsfile-Production.groovy* and *Jenkinsfile-Test.groovy*). They use two dedicated Docker compose scripts: (*docker-compose.build.yml* and *docker-compose.run.yml*).

Current deployments:
 * Test: https://sparql.opendatahub.testingmachine.eu/
 * Production: https://sparql.opendatahub.bz.it/

#### Database synchronization
The SPARQL endpoints do not query directly the production database but slave read-only instances, which are synchronized with the master database through logical replication. For more details, see [the dedicated page](docs/replication.md).


## Maintenance

### Schema evolution

[See the dedicated page](docs/schema-evolution.md)

### Test database image

For building a newer version of the Docker image of the test database out of a fresh dump, please refer to [the dedicated page](docs/test-master.md).

This Docker image is published [on Docker Hub](https://hub.docker.com/r/ontopicvkg/odh-tourism-db).


## Information

### Support

For support, please contact [info@opendatahub.bz.it](mailto:info@opendatahub.bz.it).

### Contributing

If you'd like to contribute, please follow the following instructions:

- Fork the repository.

- Checkout a topic branch from the `development` branch.

- Make sure the tests are passing.

- Create a pull request against the `development` branch.

### Documentation

More documentation can be found at [https://opendatahub.readthedocs.io/en/latest/index.html](https://opendatahub.readthedocs.io/en/latest/index.html).

### License

The code in this project is licensed under the GNU AFFERO GENERAL PUBLIC LICENSE Version 3 license. See the [LICENSE.md](LICENSE.md) file for more information.

### Examples of SPARQL queries

Some examples of possible SPARQL queries can be found in the SPARQL Queries folder. You can take a look at some [data quality queries here](sparql_queries/dataquality.md) and at some [regular queries here](sparql_queries/regular.md).

### Schema

The schema of the VKG can be visualized [in the dedicated page](sparql_queries/schema.md).
