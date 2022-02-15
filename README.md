# odh-vkg

Virtual Knowledge Graph (VKG) over the Open Data Hub (ODH) powered by [Ontop](https://ontop-vkg.org) and curated by [Ontopic](https://ontopic.ai).


[![CI](https://github.com/noi-techpark/it.bz.opendatahub.sparql/actions/workflows/main.yml/badge.svg)](https://github.com/noi-techpark/it.bz.opendatahub.sparql/actions/workflows/main.yml)

**Table of contents**
- [odh-vkg](#odh-vkg)
	- [Getting started](#getting-started)
		- [Prerequisites](#prerequisites)
		- [Source code](#source-code)
		- [Local deployment](#local-deployment)
			- [Docker environment](#docker-environment)
			- [Installation](#installation)
			- [Start and stop the containers](#start-and-stop-the-containers)
				- [Option 1: On the foreground](#option-1-on-the-foreground)
				- [Option 2: On the background](#option-2-on-the-background)
			- [Authentication](#authentication)
	- [Deployment at NOI](#deployment-at-noi)
			- [Database synchronization](#database-synchronization)
	- [Endpoints](#endpoints)
	- [Maintenance](#maintenance)
		- [Schema evolution](#schema-evolution)
		- [Test database images](#test-database-images)
	- [Information](#information)
		- [Support](#support)
		- [Contributing](#contributing)
		- [Documentation](#documentation)
		- [License](#license)
		- [Examples of SPARQL queries](#examples-of-sparql-queries)
		- [Schema](#schema)

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

1. Create the `.env` file in which, amongst all, the SPARQL endpoint port and
   the PG external port (for debugging purposes) are specified
   * `cp .env.example .env`
2. Create the `.env` file for the website
    * `cp ./website/.env.example ./website/.env`
    * Run the script `cd ./website/utils && .dotenv-sed.sh` to introduce the environment variables in javascript
3. Start the Docker container (see [the dedicated section](#Start-and-stop-the-containers))
4. Visit the SPARQL endpoint
   * Now we can open the link <http://localhost:8080/portal/> in the browser and test
     some SPARQL queries
   * Note that synchronisation between the master and the slave takes some time.
     Until it is finished, some queries may return empty results.

#### Docker environment
For the project a Docker environment is already prepared and ready to use with
all necessary prerequisites.

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

#### Authentication
A second Docker-compose file (`docker-compose.auth.yml`) can be used for testing
access control policies. It requires a running and configurable instance of
Keycloak. See https://github.com/noi-techpark/authentication-server for
instructions on how to install it locally. Refer to [docs/authentication.md](docs/authentication.md) for instruction on how to configure Keycloak and the authentication proxy.

## Deployment at NOI

All NOI specific infrastructure documentation and scripts can be found inside
the `infrastructure` folder. See
[infrastructure/README.md](infrastructure/README.md) for details.

#### Database synchronization
The SPARQL endpoints do not query directly the production database but slave
read-only instances, which are synchronized with the master database through
logical replication. For more details, see [the dedicated
page](https://github.com/noi-techpark/documentation/blob/master/logical-replication.md).

## Endpoints

 - Landing page: `/`
 - Public SPARQL endpoint: `/sparql`
 - Public portal: `/portal/`
 - Public predefined queries: `/predefined/`
 - Portal with restricted access: `/restricted/`
 - SPARQL endpoint with restricted access: `/restricted/sparql`
 - Predefined queries with restricted access: `/restricted/predefined/`



## Maintenance

### Schema evolution

[See the dedicated page](docs/schema-evolution.md)

### Test database images
For building a newer version of the Docker image of the test database out of a
fresh dump, please refer to [Tourism master](docs/test-tourism-master.md). This
Docker image is published [on Docker
Hub](https://hub.docker.com/r/ontopicvkg/odh-tourism-db).


## Information

### Support
For support, please contact
[help@opendatahub.bz.it](mailto:help@opendatahub.bz.it).

### Contributing
If you'd like to contribute, please follow the following instructions:
- Fork the repository.
- Checkout a topic branch from the `development` branch.
- Make sure the tests are passing.
- Create a pull request against the `development` branch.

### Documentation
More documentation can be found at
[https://opendatahub.readthedocs.io/en/latest/index.html](https://opendatahub.readthedocs.io/en/latest/index.html).

### License
The code in this project is licensed under the GNU AFFERO GENERAL PUBLIC LICENSE
Version 3 license. See the [LICENSE.md](LICENSE.md) file for more information.

### Examples of SPARQL queries
Some examples of possible SPARQL queries can be found in the SPARQL Queries
folder. You can take a look at some [data quality queries
here](sparql_queries/dataquality.md) and at some [regular queries
here](sparql_queries/regular.md).

### Schema
The schema of the VKG can be visualized [in the dedicated
page](sparql_queries/schema.md).
