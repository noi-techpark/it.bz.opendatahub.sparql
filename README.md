# odh-vkg

## Installation Instruction

1. Git clone or pull this repository.

2. Setup databse

* Run the script [src/create_views.sql](src/create_views.sql) to create views. 

3. Setup Ontop

*  Download Ontop-cli from the shared Google Drive directory, <https://drive.google.com/open?id=18Aco1k0PlpX1IAsou1OevdvMqzxn3fvo>, the current version is `ontop-cli-4.0.0-SNAPSHOT-20190923-974857e0.zip`. 
* Unzip it to a directory, called `$ONTOP_DIR`.
* Download the Postgres JDBC driver (https://jdbc.postgresql.org/download/postgresql-42.2.8.jar) to `$ONTOP_DIR/jdbc`

4. Change the credential of database

* Modify the file [vkg/odh.properties](vkg/odh.properties) accordingly

5. Start the Ontop endpoint

```console
$ cd vkg
$ $ONTOP_DIR/ontop endpoint --ontology=odh.ttl --mapping=odh.obda --properties=odh.properties --cors-allowed-origins='*'
```

6. Visit the Ontop endpoint
* Now we can open the <http://localhost:8080> in the browser and test SPARQL queries




