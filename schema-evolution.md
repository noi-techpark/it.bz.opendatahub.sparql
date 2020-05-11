# Schema evolution

Logical replication is in use on the NOI's production and test servers.

This documentation provides recommendations on how to proceed when the schema of the source changes. 

## Possible changes
### JSON level

#### New key
A new JSON key is first safely ignored. One [can regenerate the corresponding derived  table and trigger](#regenerating-a-derived-table-and-a-trigger) for creating the corresponding column.

#### Key removed
**TODO: check that it does not prevent anything from working immediately.**

However, one should plan to remove soon the mapping entries using that key. 
Indeed, they may break once the derived tables and triggers are regenerated, as the corresponding column won't appear anymore.

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
Given that the subscription has been created for all the tables, it should stop the replication until the corresponding table is added on the slave. **TODO: test it**.

#### Table removed
**TODO: test it**.

## Actions

### Pausing and resuming the replication
From https://pgdash.io/blog/postgres-replication-gotchas.html
```sql
-- pause replication (destination side)
ALTER SUBSCRIPTION mysub DISABLE;

-- resume replication
ALTER SUBSCRIPTION mysub ENABLE;
```

### Regenerating a derived table and a trigger

**TODO: modify the script for performing all these actions**.

This SQL script performs the following actions:
1. It pauses the replication
2. It regenerates the derived table and trigger.
3. It populates the derived table from the mirror table.
4. It resumes the replication (see above).

Steps:
 1. Generates the script. **TODO: add the command **
 2. [Publish it](#publish-a-migration-script)


 ### Adding and removing columns in the mirror tables

1. Write a SQL script adding and removing some columns in the mirror tables
2. [Publish it](#publish-a-migration-script)

### Publish a migration script
Steps:
 1. Copy the script to the `sql` and rename it with the latest `Vxx__` prefix (following the Flyway conventions)
 2. Commit the new file and push it on Github.

 The CI runner should recreate the Ontop Docker image. When starting this new image, the container should run the new script (through Flyway) on the slave DB instance.
