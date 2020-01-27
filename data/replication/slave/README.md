


```bash
docker run --name odh_db_slave -p 7778:5432 -e POSTGRES_USER=tourismuser -e POSTGRES_PASSWORD=postgres2 -d ontopicvkg/odh-db-slave
```