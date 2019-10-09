# odh-vkg

Virtual Knowledge Graph (VKG) over the Open Data Hub (ODH).

## Table of contents

- [Getting started](#getting-started)
- [Deployment](#deployment)
- [Docker environment](#docker-environment)
- [Information](#information)

## Getting started

These instructions will get you a copy of the project up and running
on your local machine for development and testing purposes.

### Prerequisites

For a ready to use Docker environment with all prerequisites already installed and prepared, you can check out the [Docker environment](#docker-environment) section.

### Source code

Get a copy of the repository:

```bash
git clone https://github.com/noi-techpark/odh-vkg.git
```

Change directory:

```bash
cd odh-vkg/
```

## Deployment

1. Create database views

* Run the script [src/create_views.sql](src/create_views.sql) to create the materialized views. 

2. Change the credentials of the database

* Modify the file [vkg/odh.docker.properties](vkg/odh.docker.properties) accordingly

3. Start the Docker container (see [the dedicated section](#Start-and-stop-the-containers))

4. Visit the Ontop endpoint
* Now we can open the link <http://localhost:8080> in the browser and test some SPARQL queries

## Docker environment

For the project a Docker environment is already prepared and ready to use with all necessary prerequisites.

These Docker containers are the same as used by the continuous integration servers.

### Installation

Install [Docker](https://docs.docker.com/install/) (with Docker Compose) locally on your machine.

### Start and stop the containers

To start the container:
```
docker run --rm \
-v $PWD/vkg:/opt/ontop/input \
-v $PWD/jdbc:/opt/ontop/jdbc \
-e ONTOLOGY_FILE=/opt/ontop/input/odh.ttl \
-e MAPPING_FILE=/opt/ontop/input/odh.obda \
-e PROPERTIES_FILE=/opt/ontop/input/odh.docker.properties \
-p 8080:8080 ontop/ontop-endpoint:4.0-snapshot
```

The container is run on the foreground and can be stopped by pressing CTRL-C.


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