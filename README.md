# odh-vkg

## Conventions

### Postgres

Dumping command:
```sh
pg_dump --schema-only --no-owner --no-privileges
```

Views (materialized or not) are starting with the prefix `v_`.
