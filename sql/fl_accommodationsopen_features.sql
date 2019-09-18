CREATE MATERIALIZED VIEW fl_accommodationsopen_features AS (SELECT accommodation_id,
data->>'Id' AS id,
data->>'Name' AS name,
data->>'HgvId' AS hgvid -- data quality issues (sometimes an empty string, sometimes a number)
-- data->>'OtaCodes' AS otacodes,
-- data->>'RoomAmenityCodes' AS roomamenitycodes
FROM (SELECT id AS accommodation_id, jsonb_array_elements(data->'Features') AS data
FROM accommodationsopen
WHERE data->'Features' <> 'null') t);

CREATE UNIQUE INDEX fl_accommodationsopen_features_pk ON fl_accommodationsopen_features(id, accommodation_id);