# PostgreSQL Docker test image for ODH Tourism

Contains the Open Data fragment of the tourism dataset of the Open Data Hub. The various versions of the Docker image are published [on Docker Hub](https://hub.docker.com/r/ontopicvkg/odh-tourism-db).

Note this image is intended to be used for development and tests purposes, on your local machine. It does not contain up-to-date data.

It has 2 main versions:
  - Standalone: contains the original dump, the triggers and the derived views
  - Master: contains the original dump


## How to start manually

Standalone version:
```sh
docker run --name odh_db_running -p 7777:5432 -e POSTGRES_USER=tourismuser -e POSTGRES_PASSWORD=postgres2 -d ontopicvkg/odh-tourism-db:standalone
```

Note that normally it is started by docker-compose in dev mode.

## Release a new version

### Cleaning the dump file

#### Disable the indexes using the earthdistance extension
Remove the lines `CREATE INDEX` involving `ll_to_earth`. They produce some warnings while creating the materialized views.

#### Rights to NOI employees
Remove the `GRANT` commands at the end of the file.

#### Split the schema from the data

The schema is expected to be called `original_schema.sql` and the data `dump-tourism-201911121025.sql` .

Make sure that the following statement is disabled (`public` needs to be in the `search_path` for the triggers to work).
```sql
-- SELECT pg_catalog.set_config('search_path', '', false);
```

### Updating the script generating triggers and trigger tables (for the standalone version)

In case the schema have changed.

  1. Create a temporary Docker image of PG out the original schema and the dump (preferably without triggers). See below for the instructions.
  2. Start this image.
  3. Generate the script by connecting this container.
  ```sh
  cd scripts
  python3 create_derived_tables_and_triggers_from_db.py all -u tourismuser -p postgres2 -h localhost -d tourismuser --port=7777
  ```
  4. Stop and delete the container
  5. Remove the temporary image.


### Build the Docker image

#### Files to put in the `test/tourism-master` directory

* `original_schema.sql`
* `dump-tourism-201911121025.sql.gz` (you can use the `gzip` to create it from the SQL file)
* `triggers_and_derived_tables.sql` from the `scripts` directory (for the standalone version)

#### Commands

Standalone version:
```sh
docker build --target standalone -t ontopicvkg/odh-tourism-db:standalone .
docker push ontopicvkg/odh-tourism-db:standalone
```

Master version:
```sh
docker build --target master -t ontopicvkg/odh-tourism-db:master .
docker push ontopicvkg/odh-tourism-db:master
```
