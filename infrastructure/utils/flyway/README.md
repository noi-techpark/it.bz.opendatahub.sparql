# Database Migrations

This document describes how to perform schema updates on our databases in a
versioned and automated way. Do not insert or change any schema objects
directly. Check that all objects have `ontopic` as owner, that is, execute these
migration scripts always as `ontopic`.

See [docs/schema-evolution.md](../../../docs/schema-evolution.md) for some
guidelines about how to handle schema changes.

We use the command line version of [Flyway](https://flywaydb.org/) to execute
database migration scripts.

## Run Flyway manually

These manual steps should not be necessary in our setup, since we will run
Flyway during Continuous Deployment Pipelines automatically. However, if we get
a timeout, because some changes are too demanding on the database side, we might
need to redo some parts manually, or to cleanup wrong migration scripts
afterwards.

### Prepare the database

#### Create users

We need a privileged user `ontopic`, that will run all our Flyway scripts.

```sql
CREATE ROLE ontopic WITH LOGIN PASSWORD 's3cret';
COMMENT ON ROLE ontopic IS 'Admin account to access the virtual knowledge graph';
GRANT CONNECT ON DATABASE vkg TO ontopic;
GRANT CREATE ON SCHEMA public TO ontopic;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO ontopic;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO ontopic;
ALTER ROLE ontopic SET statement_timeout TO '360s';
```

In addition we need a read only user `ontopicreadonly`, to access the data.

```sql
CREATE ROLE ontopicreadonly WITH LOGIN PASSWORD 's3cret';
COMMENT ON ROLE ontopicreadonly IS 'Read-only account to access the virtual knowledge graph';
GRANT CONNECT ON DATABASE vkg TO ontopicreadonly;
GRANT USAGE ON SCHEMA public TO ontopicreadonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO ontopicreadonly;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO ontopicreadonly;
ALTER ROLE ontopicreadonly SET statement_timeout TO '360s';
```

#### Create schemas

The schemas must already exist and their owner should be `ontopic`. On your VKG
database execute the following as privileged user:

```sql
-- Mobility
create schema if not exists intimev2;
alter schema intimev2 owner to ontopic;
grant all on schema intimev2 to ontopic;

-- Tourism
create schema if not exists public;
alter schema public owner to ontopic;
grant all on schema public to ontopic;
```

#### Install Postgis extension

In addition, we need a Postgres extension called `postgis`. If you get errors
like `type "public.geometry" does not exist`, you miss that extension. So, lets
install it with:
```sql
create extension postgis;
```

Install it into the `public` schema.

### Execute database migrations

Create a `.env` file:
```sh
cp .env.example .env
```

Open it, and add the `ontopic` user's password. Uncomment either the **Tourism**
or **Mobility** section (not both, the second would overwrite the first).

Then call `flyway`. These are some example calls to gather information about
actual migration installations, migrate all present migration scripts inside
`migration/mobility` or `migration/tourism`, or to set a
[baseline](https://flywaydb.org/documentation/command/baseline):
```sh
docker-compose run --rm flyway info
docker-compose run --rm flyway migrate
docker-compose run --rm flyway baseline -baselineVersion=2
```

See https://flywaydb.org/documentation for more information about these commands.
