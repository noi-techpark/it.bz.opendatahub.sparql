## How to generate a dump

- dump of the schema

```shell
$ /usr/local/bin/pg_dump --dbname=mobility --schema-only --schema=intimev2 -O -x --file=original_schema.sql --username=xiao --host=localhost --port=5432 --table=intimev2.edge --table=intimev2.measurement --table=intimev2.measurementstring --table=intimev2.metadata --table=intimev2.station --table=intimev2.type_metadata --table=intimev2.type --table=intimev2.measurementstringhistory --table=intimev2.measurementhistory
```

- dump of the data

```shell
$ /usr/local/bin/pg_dump --dbname=mobility --data-only --schema=intimev2 -O -x --disable-triggers  --file=dump-mobility-20200714.sql --username=xiao --host=localhost --port=5432  --table=intimev2.edge --table=intimev2.measurement --table=intimev2.measurementstring --table=intimev2.metadata --table=intimev2.station --table=intimev2.type_metadata --table=intimev2.type --table=intimev2.measurementstringhistory --table=intimev2.measurementhistory
$ gzip -k dump-mobility-20200714.sql 
```
