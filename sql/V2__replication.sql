CREATE SUBSCRIPTION vkgsubscription 
    CONNECTION 'host=${original_host} dbname=${original_db} user=${original_user} password=${original_password}' 
    PUBLICATION vkgpublication
    WITH (create_slot = false);
