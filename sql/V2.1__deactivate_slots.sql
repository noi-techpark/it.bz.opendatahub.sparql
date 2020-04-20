-- Sometimes the underlying slot of a subscription is still present after a drop
-- subscription, hence we need to deactivate it first, such that a next drop
-- command succeeds. This must be in a separate Flyway script, because it is
-- transactional, whereas drop and create subscription commands are
-- non-transactional, and those cannot be mixed. Finally, this workaround is due
-- to the fact that ALTER SUBSCRIPTION IF EXISTS is not yet implemented in PG12
DO $$
BEGIN
  IF EXISTS(select * from pg_catalog.pg_subscription where subname = '${subscription_name}')
  THEN)
  THEN
    ALTER SUBSCRIPTION ${subscription_name} DISABLE;
    ALTER SUBSCRIPTION ${subscription_name} SET (slot_name = NONE);
  END IF;
END $$;
