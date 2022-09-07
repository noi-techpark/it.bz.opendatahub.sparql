SELECT pg_catalog.set_config('search_path', '${flyway:defaultSchema}', false);

ALTER TABLE ONLY edge ALTER CONSTRAINT fk_edge_destination_id_station_pk DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY edge ALTER CONSTRAINT fk_edge_edge_data_id_station_pk DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY edge ALTER CONSTRAINT fk_edge_origin_id_station_pk DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY measurement ALTER CONSTRAINT fk_measurement_station_id_station_pk DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY measurement ALTER CONSTRAINT fk_measurement_type_id_type_pk DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY measurementhistory ALTER CONSTRAINT fk_measurementhistory_station_id_station_pk DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY measurementhistory ALTER CONSTRAINT fk_measurementhistory_type_id_type_pk DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY measurementstring ALTER CONSTRAINT fk_measurementstring_station_id_station_pk DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY measurementstring ALTER CONSTRAINT fk_measurementstring_type_id_type_pk DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY measurementstringhistory ALTER CONSTRAINT fk_measurementstringhistory_station_id_station_pk DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY measurementstringhistory ALTER CONSTRAINT fk_measurementstringhistory_type_id_type_pk DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY metadata ALTER CONSTRAINT fk_metadata_station_id_station_pk DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY station ALTER CONSTRAINT fk_station_meta_data_id_metadata_pk DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY station ALTER CONSTRAINT fk_station_parent_id_station_pk DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY type ALTER CONSTRAINT fk_type_meta_data_id_type_metadata_pk DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY type_metadata ALTER CONSTRAINT type_metadata_type_id_fkey DEFERRABLE INITIALLY DEFERRED;
