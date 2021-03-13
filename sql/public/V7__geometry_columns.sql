ALTER TABLE v_accommodationsopen
    add "Geometry" geometry GENERATED ALWAYS AS (
        ST_SetSRID(ST_MakePoint("Longitude", "Latitude", "Altitude"),4326))
        STORED ;

CREATE INDEX v_accommodationsopen_geom_idx
    ON v_accommodationsopen
        USING GIST ("Geometry");

ALTER TABLE v_poisopen
    add "Geometry" geometry GENERATED ALWAYS AS (
        ST_SetSRID(ST_MakePoint("GpsPoints-position-Longitude", "GpsPoints-position-Latitude"),4326))
        STORED ;

CREATE INDEX v_poisopen_geom_idx
    ON v_poisopen
        USING GIST ("Geometry");

ALTER TABLE v_skiareasopen
    add "Geometry" geometry GENERATED ALWAYS AS (
        ST_SetSRID(ST_MakePoint("Longitude", "Latitude"),4326))
        STORED ;

CREATE INDEX v_skiareasopen_geom_idx
    ON v_skiareasopen
        USING GIST ("Geometry");


ALTER TABLE v_skiregionsopen
    add "Geometry" geometry GENERATED ALWAYS AS (
        ST_SetSRID(ST_MakePoint("Longitude", "Latitude", "Altitude"),4326))
        STORED ;

CREATE INDEX v_skiregionsopen_geom_idx
    ON v_skiregionsopen
        USING GIST ("Geometry");


ALTER TABLE v_gastronomiesopen
    add "Geometry" geometry GENERATED ALWAYS AS (
        ST_SetSRID(ST_MakePoint("Longitude", "Latitude", "Altitude"),4326))
        STORED ;

CREATE INDEX v_gastronomiesopen_geom_idx
    ON v_gastronomiesopen
        USING GIST ("Geometry");

