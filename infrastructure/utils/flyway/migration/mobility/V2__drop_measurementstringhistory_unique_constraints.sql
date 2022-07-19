SELECT pg_catalog.set_config('search_path', '${flyway:defaultSchema}', false);

ALTER TABLE measurementstringhistory DROP CONSTRAINT IF EXISTS uc_measurementstringhistory_sta__timestamp_period_string_value_;
