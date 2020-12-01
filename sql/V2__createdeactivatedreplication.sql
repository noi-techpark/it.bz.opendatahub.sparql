-- Sometimes the underlying slot of a subscription is still present after a drop
-- subscription, hence we need to deactivate it first, such that a next drop
-- command succeeds. This must be in a separate Flyway script, because it is
-- transactional, whereas drop and create subscription commands are
-- non-transactional, and those cannot be mixed. Finally, this workaround is due
-- to the fact that ALTER SUBSCRIPTION IF EXISTS is not yet implemented in PG12
DO $$
BEGIN
  IF EXISTS(select * from pg_catalog.pg_subscription where subname = '${subscription_name}')
  THEN
    ALTER SUBSCRIPTION ${subscription_name} DISABLE;
    ALTER SUBSCRIPTION ${subscription_name} SET (slot_name = NONE);
    DROP SUBSCRIPTION ${subscription_name};
    CREATE SUBSCRIPTION ${subscription_name}
      CONNECTION 'host=${original_host_ip} dbname=${original_db} user=${original_user} password=${original_password}'
      PUBLICATION ${publication_name}
      WITH (create_slot = false);
  ELSE
    CREATE SUBSCRIPTION ${subscription_name}
      CONNECTION 'host=${original_host_ip} dbname=${original_db} user=${original_user} password=${original_password}'
      PUBLICATION ${publication_name}
      WITH (create_slot = true);
  END IF;
  ALTER SUBSCRIPTION ${subscription_name} DISABLE;
END $$;
