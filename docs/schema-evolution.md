# Schema evolution

This documentation provides recommendations on how to proceed when the schema of the source changes.

## Possible changes
### JSON level

#### New key
A new JSON key is first safely ignored. One [can regenerate the corresponding derived table and trigger](#regenerating-a-derived-table-and-a-trigger) for creating the corresponding column.

#### Key removed
However, one should plan to remove soon the mapping entries using that key.
Indeed, they may break once the derived tables and triggers are regenerated, as the corresponding column won't appear anymore.

In case of an array, the derived table for the old array is now useless. Please write by hand a SQL script for cleaning the derived table and its trigger.

#### Literal replaced by an Object or an Array
Not considered at the moment. To be investigated when the situation appears.


### Column level

#### New column
Adding a column in a source table will stop the replication (see https://pgdash.io/blog/postgres-replication-gotchas.html)
until the same column is added to the corresponding replicated table.

See [the dedicated action for migrating the schema](#adding-and-removing-columns-in-the-mirror-tables).

#### Column removed
At the moment only two columns in the mirror tables are used for building derived tables: `id` and `data`.
However, removing an additional column may break the replication. See [the dedicated action for migrating the schema](#adding-and-removing-columns-in-the-mirror-tables).

### Table level

#### New table
We no longer use logical replication, so we do not have issues here.

#### Table removed
It does not seems to complain.

## Actions

### Regenerating the derived tables of a mirror table

This SQL script performs the following actions:
1. It regenerates all the derived tables and triggers of a mirror table.
2. It populates the derived tables from the mirror table.
3. It resumes the replication.

Steps:
 1. Generate the script (change the parameter values)
 ```sh
 cd scripts
 python3 create_derived_tables_and_triggers_from_db.py regenerate -t accommodationsopen -u tourismuser -p postgres2 -h localhost -d tourismuser --port 7776
 ```
 2. [Publish](#publish-a-migration-script) the SQL script with the prefix `regen-`.


 ### Adding and removing columns in the mirror tables

1. Write a SQL script adding and removing some columns in the mirror tables
2. [Publish it](#publish-a-migration-script)

### Publish a migration script
Steps:
 1. Copy the script to the `sql` and rename it with the latest `Vxx__` prefix (following the Flyway conventions)
 2. Commit the new file and push it on Github.

 The CI runner should recreate the Ontop Docker image. When starting this new image, the container should run the new script (through Flyway) on the slave DB instance.

 See
 [infrastructure/utils/flyway/README.md](../infrastructure/utils/flyway/README.md)
 for further information about Flyway, and its manual execution.
