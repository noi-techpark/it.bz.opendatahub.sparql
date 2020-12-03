--
-- XXX Should this be part of Flyway migrations, or should we create roles etc. manually beforehand?
--
CREATE ROLE ${copy_user_readonly} WITH LOGIN PASSWORD ${copy_password_readonly};
GRANT CONNECT ON DATABASE ${copy_db} TO ${copy_user_readonly};
GRANT USAGE ON SCHEMA public TO ${copy_user_readonly};
GRANT SELECT ON ALL TABLES IN SCHEMA public TO ${copy_user_readonly};
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO ${copy_user_readonly};
ALTER ROLE ${copy_user_readonly} SET statement_timeout TO '360s';
COMMENT ON ROLE ${copy_user_readonly} IS 'Read-only account to access the virtual knowledge graph';
