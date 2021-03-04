CREATE ROLE vkgreplicate WITH LOGIN PASSWORD 'Azerty' REPLICATION;
-- CREATE PUBLICATION vkg_mobility_publication_dev FOR ALL TABLES;
CREATE PUBLICATION vkg_mobility_publication_dev FOR TABLE  intimev2.edge,intimev2.measurement,intimev2.measurementstring,intimev2.metadata,intimev2.station,intimev2.type_metadata,intimev2.type,intimev2.measurementstringhistory,intimev2.measurementhistory;
-- GRANT SELECT ON ALL TABLES IN SCHEMA intimev2 TO vkgreplicate;
GRANT ALL ON ALL TABLES IN SCHEMA intimev2 TO vkgreplicate;
-- GRANT ALL ON ALL TABLES IN SCHEMA intimev2 TO tourismuser;
