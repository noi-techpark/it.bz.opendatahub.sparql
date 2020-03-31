# Slave Docker image for the ODH tourism dataset

Inspired by https://blog.raveland.org/post/postgresql_lr_en/

## Master configuration

The WAL level of the master needs to be set to the logical level.
```sql
ALTER SYSTEM SET wal_level = 'logical';
```

On the master, one needs to create a dedicated role for replication (here `replicate`), create a publication (here `odhpub`) and grant access to the tables to the dedicated role.
```sql
CREATE ROLE replicate WITH LOGIN PASSWORD 'Azerty' REPLICATION;
CREATE PUBLICATION odhpub FOR ALL TABLES;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO replicate;
```

## Slave configuration

If the master is a Docker container on the same machine, one must make sure they are on the same Docker network (here `tourism`) than the master container.

```bash
docker run --name odh_db_slave -p 7778:5432 -e POSTGRES_USER=tourismuser -e POSTGRES_PASSWORD=postgres2 --network tourism -d ontopicvkg/odh-db-slave
```

Connect to the shell and open `psql`
```bash
docker exec -it odh_db_slave /bin/sh
psql -U tourismuser
```

Let the slave subscribe to the publication:
```sql
CREATE SUBSCRIPTION subodh CONNECTION 'host=odh-hackathon-2019_db_1 dbname=tourismuser user=replicate password=Azerty' PUBLICATION odhpub;
```
Note that the subscription `subodh` must not already exist (otherwise give it another name).

### Unsubscribing

Before removing the slave container, it is recommended to disable the subscription:
```sql
ALTER SUBSCRIPTION subodh DISABLE;
```
