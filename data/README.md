# PostgreSQL Docker image for Open Data Hub

Contains the Open Data fragment of the tourism dataset of the Open Data Hub.

## How to start

```sh
docker run --name odh_db_running -p 7777:5432 -e POSTGRES_USER=tourismuser -e POSTGRES_PASSWORD=postgres2 -d ontopicvkg/odh-tourism-db
```

## Cleaning the dump file


### Disable the indexes using the earthdistance extension
Remove the lines `CREATE INDEX` involving `ll_to_earth`. They produce some warnings while creating the materialized views.

### Rights to NOI employees
Remove the `GRANT` commands at the end of the file.

## Files to put in the data directory

* `dump-tourism-201911121025.sql.gz` (you can use the `gzip` to create it from the SQL file)
* `create_views.sql` from the `src` directory