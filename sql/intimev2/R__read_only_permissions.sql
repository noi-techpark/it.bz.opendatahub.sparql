DO
$$
    BEGIN
        CREATE ROLE ${vkg_user_readonly};
    EXCEPTION WHEN DUPLICATE_OBJECT THEN
        RAISE NOTICE 'role ${vkg_user_readonly} exists, skipping...';
    END
$$;

-- CREATE ROLE ${vkg_user_readonly};
GRANT USAGE ON SCHEMA ${mobility_schema_vkg} TO ${vkg_user_readonly};
GRANT SELECT ON ALL TABLES IN SCHEMA ${mobility_schema_vkg} TO ${vkg_user_readonly};
GRANT SELECT ON ALL SEQUENCES IN SCHEMA ${mobility_schema_vkg} TO ${vkg_user_readonly};

