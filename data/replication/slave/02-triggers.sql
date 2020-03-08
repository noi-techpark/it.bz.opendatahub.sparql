CREATE TABLE public.v_accommodationroomsopen (
"Id" VARCHAR,
"A0RID" VARCHAR,
"HGVId" VARCHAR,
"LTSId" VARCHAR,
"Source" VARCHAR,
"Roommax" INTEGER,
"Roommin" INTEGER,
"Roomstd" INTEGER,
"RoomCode" VARCHAR,
"Roomtype" VARCHAR,
"Shortname" VARCHAR,
"RoomQuantity" INTEGER,
"AccoRoomDetail-de-Name" VARCHAR,
"AccoRoomDetail-de-Language" VARCHAR,
"AccoRoomDetail-de-Longdesc" VARCHAR,
"AccoRoomDetail-de-Shortdesc" VARCHAR,
"AccoRoomDetail-en-Name" VARCHAR,
"AccoRoomDetail-en-Language" VARCHAR,
"AccoRoomDetail-it-Name" VARCHAR,
"AccoRoomDetail-it-Language" VARCHAR,
"AccoRoomDetail-it-Longdesc" VARCHAR,
"AccoRoomDetail-it-Shortdesc" VARCHAR
);

CREATE FUNCTION roomsopen_fct()
RETURNS TRIGGER
AS $$
BEGIN
INSERT INTO v_accommodationroomsopen
SELECT CAST(NEW."data"->>'Id' As varchar) AS "Id",
CAST(NEW."data"->>'A0RID' As varchar) AS "A0RID",
CAST(NEW."data"->>'HGVId' As varchar) AS "HGVId",
CAST(NEW."data"->>'LTSId' As varchar) AS "LTSId",
CAST(NEW."data"->>'Source' As varchar) AS "Source",
CAST(NEW."data"->>'Roommax' As integer) AS "Roommax",
CAST(NEW."data"->>'Roommin' As integer) AS "Roommin",
CAST(NEW."data"->>'Roomstd' As integer) AS "Roomstd",
CAST(NEW."data"->>'RoomCode' As varchar) AS "RoomCode",
CAST(NEW."data"->>'Roomtype' As varchar) AS "Roomtype",
CAST(NEW."data"->>'Shortname' As varchar) AS "Shortname",
CAST(NEW."data"->>'RoomQuantity' As integer) AS "RoomQuantity",
CAST(NEW."data"->'AccoRoomDetail'->'de'->>'Name' As varchar) AS "AccoRoomDetail-de-Name",
CAST(NEW."data"->'AccoRoomDetail'->'de'->>'Language' As varchar) AS "AccoRoomDetail-de-Language",
CAST(NEW."data"->'AccoRoomDetail'->'de'->>'Longdesc' As varchar) AS "AccoRoomDetail-de-Longdesc",
CAST(NEW."data"->'AccoRoomDetail'->'de'->>'Shortdesc' As varchar) AS "AccoRoomDetail-de-Shortdesc",
CAST(NEW."data"->'AccoRoomDetail'->'en'->>'Name' As varchar) AS "AccoRoomDetail-en-Name",
CAST(NEW."data"->'AccoRoomDetail'->'en'->>'Language' As varchar) AS "AccoRoomDetail-en-Language",
CAST(NEW."data"->'AccoRoomDetail'->'it'->>'Name' As varchar) AS "AccoRoomDetail-it-Name",
CAST(NEW."data"->'AccoRoomDetail'->'it'->>'Language' As varchar) AS "AccoRoomDetail-it-Language",
CAST(NEW."data"->'AccoRoomDetail'->'it'->>'Longdesc' As varchar) AS "AccoRoomDetail-it-Longdesc",
CAST(NEW."data"->'AccoRoomDetail'->'it'->>'Shortdesc' As varchar) AS "AccoRoomDetail-it-Shortdesc";
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER t_accommodationroomsopen
    BEFORE INSERT
    ON accommodationroomsopen
    FOR EACH ROW
    EXECUTE PROCEDURE roomsopen_fct();

ALTER TABLE accommodationroomsopen
    ENABLE ALWAYS TRIGGER t_accommodationroomsopen;
