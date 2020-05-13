CREATE SUBSCRIPTION ${subscription_name}
    CONNECTION 'host=${original_host_ip} dbname=${original_db} user=${original_user} password=${original_password}'
    PUBLICATION vkgpublication
    WITH (create_slot = true);
