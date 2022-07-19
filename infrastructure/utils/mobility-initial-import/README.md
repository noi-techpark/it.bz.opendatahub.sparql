# Initial Database import for Mobility Data

**WARNING**: This procedure is only applicable for an import into a database,
where we can delete all data first! Do not run it if you need the data inside
those tables. You will loose all your records!!!

- Create a [database, users and schemas](../flyway/README.md)
- Then fill that schema. Two possibilites exist:
  - Run it [manually](../flyway/README.md#execute-database-migrations)
  - Deploy this application with our Docker setup, which automatically runs all
    migration scripts
- We fill the mobility database tables in two steps:
  - Create a `.pgpass` file in your home directory (See Postgres docs for
    details)
  - First the smaller tables with
    ```sh
	./vkg-download.sh
	./vkg-init.sh   # Careful, this command truncates your tables
	```
  - Then the big history tables with
    ```sh
	./vkg-sync-single.sh measurmentstringhistory
	./vkg-sync-single.sh measurmenthistory
	```

Please note, this will take up to 24 hours. Better to run it inside a server:
```
nohup ./vkg-sync-single.sh measurmentstringhistory &
tail -f nohup.log
```

With `nohup` it's possible to close the ssh session, and the process continues.
