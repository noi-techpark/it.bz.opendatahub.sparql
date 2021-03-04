--
-- Roles should exist already. The role that runs this command has no privileges
-- to create roles (on production environments), so we will get a permission
-- denied even if the role exists already. To prevent that we need to create a
-- corresponding user beforehand (manually).
--
-- DO
-- $$
--     BEGIN
--         CREATE ROLE ${vkg_user_readonly};
--     EXCEPTION WHEN DUPLICATE_OBJECT THEN
--         RAISE NOTICE 'role ${vkg_user_readonly} exists, skipping...';
--     END
-- $$;
--
-- Simple alternative:
-- CREATE ROLE ${vkg_user_readonly};
--

GRANT USAGE ON SCHEMA ${tourism_schema_vkg} TO ${vkg_user_readonly};
GRANT SELECT ON ALL TABLES IN SCHEMA ${tourism_schema_vkg} TO ${vkg_user_readonly};
GRANT SELECT ON ALL SEQUENCES IN SCHEMA ${tourism_schema_vkg} TO ${vkg_user_readonly};
