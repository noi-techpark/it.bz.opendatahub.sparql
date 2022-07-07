# Database Migrations

This document describes how to perform schema updates on our databases in a
versioned and automated way. Do not insert or change any schema objects
directly. Check that all objects have `ontopic` as owner, that is, execute these
migration scripts always as `ontopic`.

See [docs/schema-evolution.md](../../../docs/schema-evolution.md) for some
guidelines about how to handle schema changes.

We use the command line version of [Flyway](https://flywaydb.org/) to execute
database migration scripts.

## Executing Flyway manually

These manual steps should not be necessary in our setup, since we will run
Flyway during Continuous Deployment Pipelines automatically. However, if we get
a timeout, because some changes are too demanding on the database side, we might
need to redo some parts manually, or to cleanup wrong migration scripts
afterwards.

Create a `.env` file:
```sh
cp .env.example .env
```

Open it, and add the `ontopic` user's password. Uncomment either the **Tourism**
or **Mobility** section (not both, the second would overwrite the first).

Then call flyway. These are some example calls to gather information about
actual migration installations, migrate all present migration scripts inside
`migration/mobility` or `migration/tourism`, or to set a
[baseline](https://flywaydb.org/documentation/command/baseline):
```sh
docker-compose run --rm flyway info
docker-compose run --rm flyway migrate
docker-compose run --rm flyway baseline -baselineVersion=2
```

See https://flywaydb.org/documentation for more information about these commands.
