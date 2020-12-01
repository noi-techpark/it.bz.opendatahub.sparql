-- Simplifies the V2 script (was not working for our regular PG12 set up)
CREATE SUBSCRIPTION ${subscription_name}
CONNECTION 'host=${original_host_ip} dbname=${original_db} user=${original_user} password=${original_password}'
PUBLICATION vkgpublication
WITH (create_slot = true, enabled = false);
