--
-- Roles should exist already. The role that runs this command has no privileges
-- to create roles (on production environments), so we will get a permission
-- denied even if the role exists already. To prevent that we need to create a
-- corresponding user beforehand (manually).
--
-- DO
-- $$
--     BEGIN
--         CREATE ROLE ${READONLY_USER};
--     EXCEPTION WHEN DUPLICATE_OBJECT THEN
--         RAISE NOTICE 'role ${READONLY_USER} exists, skipping...';
--     END
-- $$;
--
-- Simple alternative:
-- CREATE ROLE ${READONLY_USER};
--

GRANT USAGE ON SCHEMA ${flyway:defaultSchema} TO ${READONLY_USER};
GRANT SELECT ON ALL TABLES IN SCHEMA ${flyway:defaultSchema} TO ${READONLY_USER};
GRANT SELECT ON ALL SEQUENCES IN SCHEMA ${flyway:defaultSchema} TO ${READONLY_USER};
