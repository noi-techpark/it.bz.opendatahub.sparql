ALTER role ${copy_user_readonly} SET statement_timeout TO '360s';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO ${copy_user_readonly};
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO ${copy_user_readonly};
