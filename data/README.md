# PostgreSQL Docker image for Open Data Hub

Contains the Open Data fragment of the tourism dataset of the Open Data Hub.

## How to start

```sh
docker run --name odh_db_running -p 7777:5432 -e POSTGRES_USER=tourismuser -e POSTGRES_PASSWORD=postgres2 -d ontopicvkg/odh-tourism-db
```

## Cleaning the dump file

### Search path (for finding the extension)
Change 
```sql
SELECT pg_catalog.set_config('search_path', '', false);
```
into
```sql
SELECT pg_catalog.set_config('search_path', 'public', false);
```

### Earth distance extension
Add before creating the indexes
```sql
CREATE EXTENSION earthdistance CASCADE;
```

### Rights to NOI employees
Remove the GRANT commands at the end of the file.