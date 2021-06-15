# Flight Rule for Migration to a new DB instance

Get passwords from https://passwords.testingmachine.eu under
`it.bz.opendatahub.sparql.*`. All instances must have `wal_level = logical`, and
must be able to see eachother, hence set the right firewall rules. That is, add
the IP of the new instance to `generic-vkg-logical-replication` secgroup.

**Hint**: You can watch the databases' logfiles with the following command:
```sh
watch 'aws rds download-db-log-file-portion \
       --db-instance-identifier prod-postgres-vkg \
	   --output text \
	   --log-file-name error/postgresql.log.2021-06-15-13 | tail -n20'
```
For that to work you need a functioning aws CLI installation. The log time is UTC...

## Tourism DB (Publisher)
Login to `prod-postgres-tourism-2.co90ybcr8iim.eu-west-1.rds.amazonaws.com` with
DB `tourism` and schema `public`.

```sql
-- ROLE
CREATE ROLE vkgreplicate WITH LOGIN PASSWORD '<your-secret-password>';
COMMENT ON ROLE vkgreplicate IS 'Role with the privileges to replicate data for the VKG project';
GRANT rds_replication TO vkgreplicate;
GRANT CONNECT ON DATABASE tourism TO vkgreplicate;
GRANT USAGE ON SCHEMA public to vkgreplicate;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO vkgreplicate;

-- PUBLICATION
CREATE PUBLICATION vkgpublication FOR TABLE
articles, pois, poisopen, articlesopen, tvs, packages,
gastronomies, users, alpinebits, eventsopen, smgpois, smgpoisopen,
accommodationsopen, accommodationrooms, accommodationroomsopen,
gastronomiesopen, eventeuracnoi, tripplaners, accommodations,
metaregionsopen, regionsopen, tvsopen, municipalities,
municipalitiesopen, districts, districtsopen, areas, skiareas,
skiareasopen, skiregions, skiregionsopen, wines, activitiesopen,
experienceareas, events, metaregions, regions, userdevices,
measuringpoints, ltstaggingtypes, experienceareasopen, activities,
suedtiroltypes, smgtags, marketinggroups, natureparks, smgpoismobilefilters,
smgpoismobiletypes, accothemesmobiles, mobilehtmls, appsuggestions,
appmessages, tutorials, accommodationtypes, accommodationfeatures,
articletypes, poitypes, activitytypes, smgpoitypes, gastronomytypes,
eventtypes, webcams, webcamsopen, odhactivitypoimetainfos, venues,
venuesopen, venuetypes;

-- Make it a read-only publication by default
ALTER PUBLICATION vkgpublication SET (publish = '');
```

## Mobility DB - Testing (Publisher)
Login to `test-pg-bdp.co90ybcr8iim.eu-west-1.rds.amazonaws.com` with DB `bdp`
and schema `intimev2`.

```sql
-- ROLE
CREATE ROLE vkgreplicate WITH LOGIN PASSWORD '<your-secret-password>';
COMMENT ON ROLE vkgreplicate IS 'Role with the privileges to replicate data for the VKG project';
GRANT CONNECT ON DATABASE bdp TO vkgreplicate;
GRANT rds_replication TO vkgreplicate;
GRANT SELECT ON ALL TABLES IN SCHEMA intimev2 TO vkgreplicate;
GRANT USAGE ON SCHEMA intimev2 to vkgreplicate;

-- PUBLICATION
CREATE PUBLICATION vkgpublication FOR TABLE edge, measurement,
measurementhistory, measurementstring, measurementstringhistory,
metadata, station, type, type_metadata;

-- Make it a read-only publication by default
ALTER PUBLICATION vkgpublication SET (publish = '');
```

## Mobility DB - Production (Publisher)
Login to `prod-pg-bdp.co90ybcr8iim.eu-west-1.rds.amazonaws.com` with DB `bdp`
and schema `intimev2`.

```sql
-- ROLE
CREATE ROLE vkgreplicate WITH LOGIN PASSWORD '<your-secret-password>';
COMMENT ON ROLE vkgreplicate IS 'Role with the privileges to replicate data for the VKG project';
GRANT CONNECT ON DATABASE bdp TO vkgreplicate;
GRANT rds_replication TO vkgreplicate;
GRANT SELECT ON ALL TABLES IN SCHEMA intimev2 TO vkgreplicate;
GRANT USAGE ON SCHEMA intimev2 to vkgreplicate;

-- PUBLICATION
CREATE PUBLICATION vkgpublication FOR TABLE edge, measurement,
measurementhistory, measurementstring, measurementstringhistory,
metadata, station, type, type_metadata;

-- Make it a read-only publication by default
ALTER PUBLICATION vkgpublication SET (publish = '');
```

## VKG DB (Subscriber)
Login to `prod-postgres-vkg.co90ybcr8iim.eu-west-1.rds.amazonaws.com`.

```sql
-- ROLE read only
CREATE ROLE vkguser_readonly WITH LOGIN PASSWORD '<your-secret-password>';
COMMENT ON ROLE vkguser_readonly IS 'Read-only account to access the virtual knowledge graph';
ALTER ROLE vkguser_readonly SET statement_timeout TO '360s';

-- ROLE read+write
CREATE ROLE vkguser WITH LOGIN PASSWORD '<your-secret-password>';
COMMENT ON ROLE vkguser IS 'Admin account to access the virtual knowledge graph';
ALTER ROLE vkguser SET statement_timeout TO '0';
GRANT rds_superuser to vkguser; -- needed to create subscriptions
GRANT rds_replication to vkguser;

--
-- TEST SETUP (mobility and tourism)
--
create database test;
--> change now to that database

create extension postgis;

create schema intimev2;
create schema public;

GRANT CONNECT ON DATABASE test TO vkguser_readonly;
GRANT USAGE ON SCHEMA intimev2 TO vkguser_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA intimev2 TO vkguser_readonly;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA intimev2 TO vkguser_readonly;
GRANT USAGE ON SCHEMA public TO vkguser_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO vkguser_readonly;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO vkguser_readonly;

GRANT CONNECT ON DATABASE test TO vkguser;
GRANT CREATE ON SCHEMA intimev2 TO vkguser;
GRANT SELECT ON ALL TABLES IN SCHEMA intimev2 TO vkguser;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA intimev2 TO vkguser;
GRANT CREATE ON SCHEMA public TO vkguser;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO vkguser;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO vkguser;

--
-- PROD SETUP (mobility and tourism)
--
create database prod;
--> change now to that database

create extension postgis;

create schema intimev2;
create schema public;

GRANT CONNECT ON DATABASE test TO vkguser_readonly;
GRANT USAGE ON SCHEMA intimev2 TO vkguser_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA intimev2 TO vkguser_readonly;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA intimev2 TO vkguser_readonly;
GRANT USAGE ON SCHEMA public TO vkguser_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO vkguser_readonly;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO vkguser_readonly;

GRANT CONNECT ON DATABASE test TO vkguser;
GRANT CREATE ON SCHEMA intimev2 TO vkguser;
GRANT SELECT ON ALL TABLES IN SCHEMA intimev2 TO vkguser;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA intimev2 TO vkguser;
GRANT CREATE ON SCHEMA public TO vkguser;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO vkguser;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO vkguser;
```

Install flyway on your local machine: https://flywaydb.org

Go to [flywayconf](flywayconf) and fill missing values in or set them via
environmental variables.

If the old replication slot was prefixed with `vkg1` use `vkg2`, or vice-versa,
for the new instance.

Run `flyway`:
```sh
# Tourism TEST installation (takes about 10 minutes)
flyway -configFiles=flywayconf/flyway-tourism-test.conf migrate
# --> check if everything works with SQL on the VKG DB

# Mobility TEST installation (takes about 5 hours)
flyway -configFiles=flywayconf/flyway-mobility-test.conf migrate
# --> check if everything works with SQL on the VKG DB

# Repeat the above calls for production if everything worked well before
flyway -configFiles=flywayconf/flyway-tourism-prod.conf migrate
flyway -configFiles=flywayconf/flyway-mobility-prod.conf migrate
```

Finally, if everything works, delete the old replication slots from each
`publisher`. Find the old ones with:

```sql
SELECT * FROM pg_replication_slots;
```
...and delete with:
```sql
-- Warning, if you delete the wrong one, you must drop the DB and redo all steps!!!
select pg_drop_replication_slot('vkg1_mobility_test_subscription')
```

**Hint**: If you can't drop the slot, go to its subscriber node and drop the
corresponding subscription:

For example:
```sql
ALTER SUBSCRIPTION vkg1_tourism_prod_subscription DISABLE;
ALTER SUBSCRIPTION vkg1_tourism_prod_subscription SET (slot_name = NONE);
DROP SUBSCRIPTION vkg1_tourism_prod_subscription;
```

Delete the old database instance, probably taking a last snapshot which should
then be removed after some days if nothing bad happens.

Ready.
