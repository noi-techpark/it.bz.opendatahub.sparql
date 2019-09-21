
DROP MATERIALIZED VIEW IF EXISTS  "v_accommodationroomsopen";

CREATE MATERIALIZED VIEW "v_accommodationroomsopen" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'A0RID' As varchar) AS "A0RID",
CAST("data"->>'HGVId' As varchar) AS "HGVId",
CAST("data"->>'LTSId' As varchar) AS "LTSId",
CAST("data"->>'Source' As varchar) AS "Source",
CAST("data"->>'Roommax' As integer) AS "Roommax",
CAST("data"->>'Roommin' As integer) AS "Roommin",
CAST("data"->>'Roomstd' As integer) AS "Roomstd",
CAST("data"->>'RoomCode' As varchar) AS "RoomCode",
CAST("data"->>'Roomtype' As varchar) AS "Roomtype",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'RoomQuantity' As integer) AS "RoomQuantity",
CAST("data"->'AccoRoomDetail'->'de'->>'Name' As varchar) AS "AccoRoomDetail-de-Name",
CAST("data"->'AccoRoomDetail'->'de'->>'Language' As varchar) AS "AccoRoomDetail-de-Language",
CAST("data"->'AccoRoomDetail'->'en'->>'Name' As varchar) AS "AccoRoomDetail-en-Name",
CAST("data"->'AccoRoomDetail'->'en'->>'Language' As varchar) AS "AccoRoomDetail-en-Language",
CAST("data"->'AccoRoomDetail'->'it'->>'Name' As varchar) AS "AccoRoomDetail-it-Name",
CAST("data"->'AccoRoomDetail'->'it'->>'Language' As varchar) AS "AccoRoomDetail-it-Language"
FROM accommodationroomsopen;

CREATE UNIQUE INDEX "v_accommodationroomsopen_pk" ON "v_accommodationroomsopen"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_accommodationroomsopen_Features";

CREATE MATERIALIZED VIEW "v_accommodationroomsopen_Features" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'Features') AS "Feature"
        FROM accommodationroomsopen
        WHERE data -> 'Features' != 'null')
    SELECT "Id" AS "accommodationroomsopen_Id", CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Name' As varchar) AS "Name"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS  "v_accommodationsopen";

CREATE MATERIALIZED VIEW "v_accommodationsopen" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Beds' As integer) AS "Beds",
CAST("data"->>'Units' As integer) AS "Units",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'Gpstype' As varchar) AS "Gpstype",
CAST("data"->>'HasRoom' As bool) AS "HasRoom",
CAST("data"->>'Altitude' As float) AS "Altitude",
CAST("data"->>'Latitude' As float) AS "Latitude",
CAST("data"->>'TVMember' As bool) AS "TVMember",
CAST("data"->>'IsCamping' As bool) AS "IsCamping",
CAST("data"->>'Longitude' As float) AS "Longitude",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'AccoTypeId' As varchar) AS "AccoTypeId",
CAST("data"->>'DistrictId' As varchar) AS "DistrictId",
CAST("data"->>'IsBookable' As bool) AS "IsBookable",
CAST("data"->>'LastChange' As varchar) AS "LastChange",
CAST("data"->>'FirstImport' As varchar) AS "FirstImport",
CAST("data"->>'GastronomyId' As varchar) AS "GastronomyId",
CAST("data"->>'HasApartment' As bool) AS "HasApartment",
CAST("data"->>'IsGastronomy' As bool) AS "IsGastronomy",
CAST("data"->>'MainLanguage' As varchar) AS "MainLanguage",
CAST("data"->>'TrustYouScore' As float) AS "TrustYouScore",
CAST("data"->>'TrustYouState' As integer) AS "TrustYouState",
CAST("data"->>'AccoCategoryId' As varchar) AS "AccoCategoryId",
CAST("data"->>'Representation' As integer) AS "Representation",
CAST("data"->>'TrustYouActive' As bool) AS "TrustYouActive",
CAST("data"->>'IsAccommodation' As bool) AS "IsAccommodation",
CAST("data"->>'TourismVereinId' As varchar) AS "TourismVereinId",
CAST("data"->>'TrustYouResults' As integer) AS "TrustYouResults",
CAST("data"->>'AltitudeUnitofMeasure' As varchar) AS "AltitudeUnitofMeasure",
CAST("data"->'AccoDetail'->'de'->>'Fax' As varchar) AS "AccoDetail-de-Fax",
CAST("data"->'AccoDetail'->'de'->>'Zip' As varchar) AS "AccoDetail-de-Zip",
CAST("data"->'AccoDetail'->'de'->>'City' As varchar) AS "AccoDetail-de-City",
CAST("data"->'AccoDetail'->'de'->>'Name' As varchar) AS "AccoDetail-de-Name",
CAST("data"->'AccoDetail'->'de'->>'Email' As varchar) AS "AccoDetail-de-Email",
CAST("data"->'AccoDetail'->'de'->>'Phone' As varchar) AS "AccoDetail-de-Phone",
CAST("data"->'AccoDetail'->'de'->>'Mobile' As varchar) AS "AccoDetail-de-Mobile",
CAST("data"->'AccoDetail'->'de'->>'Street' As varchar) AS "AccoDetail-de-Street",
CAST("data"->'AccoDetail'->'de'->>'Language' As varchar) AS "AccoDetail-de-Language",
CAST("data"->'AccoDetail'->'de'->>'Lastname' As varchar) AS "AccoDetail-de-Lastname",
CAST("data"->'AccoDetail'->'de'->>'Firstname' As varchar) AS "AccoDetail-de-Firstname",
CAST("data"->'AccoDetail'->'de'->>'NameAddition' As varchar) AS "AccoDetail-de-NameAddition",
CAST("data"->'AccoDetail'->'en'->>'Fax' As varchar) AS "AccoDetail-en-Fax",
CAST("data"->'AccoDetail'->'en'->>'Zip' As varchar) AS "AccoDetail-en-Zip",
CAST("data"->'AccoDetail'->'en'->>'City' As varchar) AS "AccoDetail-en-City",
CAST("data"->'AccoDetail'->'en'->>'Name' As varchar) AS "AccoDetail-en-Name",
CAST("data"->'AccoDetail'->'en'->>'Email' As varchar) AS "AccoDetail-en-Email",
CAST("data"->'AccoDetail'->'en'->>'Phone' As varchar) AS "AccoDetail-en-Phone",
CAST("data"->'AccoDetail'->'en'->>'Mobile' As varchar) AS "AccoDetail-en-Mobile",
CAST("data"->'AccoDetail'->'en'->>'Street' As varchar) AS "AccoDetail-en-Street",
CAST("data"->'AccoDetail'->'en'->>'Language' As varchar) AS "AccoDetail-en-Language",
CAST("data"->'AccoDetail'->'en'->>'Lastname' As varchar) AS "AccoDetail-en-Lastname",
CAST("data"->'AccoDetail'->'en'->>'Firstname' As varchar) AS "AccoDetail-en-Firstname",
CAST("data"->'AccoDetail'->'en'->>'NameAddition' As varchar) AS "AccoDetail-en-NameAddition",
CAST("data"->'AccoDetail'->'it'->>'Fax' As varchar) AS "AccoDetail-it-Fax",
CAST("data"->'AccoDetail'->'it'->>'Zip' As varchar) AS "AccoDetail-it-Zip",
CAST("data"->'AccoDetail'->'it'->>'City' As varchar) AS "AccoDetail-it-City",
CAST("data"->'AccoDetail'->'it'->>'Name' As varchar) AS "AccoDetail-it-Name",
CAST("data"->'AccoDetail'->'it'->>'Email' As varchar) AS "AccoDetail-it-Email",
CAST("data"->'AccoDetail'->'it'->>'Phone' As varchar) AS "AccoDetail-it-Phone",
CAST("data"->'AccoDetail'->'it'->>'Mobile' As varchar) AS "AccoDetail-it-Mobile",
CAST("data"->'AccoDetail'->'it'->>'Street' As varchar) AS "AccoDetail-it-Street",
CAST("data"->'AccoDetail'->'it'->>'Language' As varchar) AS "AccoDetail-it-Language",
CAST("data"->'AccoDetail'->'it'->>'Lastname' As varchar) AS "AccoDetail-it-Lastname",
CAST("data"->'AccoDetail'->'it'->>'Longdesc' As varchar) AS "AccoDetail-it-Longdesc",
CAST("data"->'AccoDetail'->'it'->>'Firstname' As varchar) AS "AccoDetail-it-Firstname",
CAST("data"->'AccoDetail'->'it'->>'Shortdesc' As varchar) AS "AccoDetail-it-Shortdesc",
CAST("data"->'AccoDetail'->'it'->>'NameAddition' As varchar) AS "AccoDetail-it-NameAddition",
CAST("data"->'LocationInfo'->'TvInfo'->>'Id' As varchar) AS "LocationInfo-TvInfo-Id",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-TvInfo-Name-cs",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'de' As varchar) AS "LocationInfo-TvInfo-Name-de",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'en' As varchar) AS "LocationInfo-TvInfo-Name-en",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-TvInfo-Name-fr",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'it' As varchar) AS "LocationInfo-TvInfo-Name-it",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-TvInfo-Name-nl",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-TvInfo-Name-pl",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-TvInfo-Name-ru",
CAST("data"->'LocationInfo'->'RegionInfo'->>'Id' As varchar) AS "LocationInfo-RegionInfo-Id",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-RegionInfo-Name-cs",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'de' As varchar) AS "LocationInfo-RegionInfo-Name-de",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'en' As varchar) AS "LocationInfo-RegionInfo-Name-en",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-RegionInfo-Name-fr",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'it' As varchar) AS "LocationInfo-RegionInfo-Name-it",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-RegionInfo-Name-nl",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-RegionInfo-Name-pl",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-RegionInfo-Name-ru",
CAST("data"->'LocationInfo'->'DistrictInfo'->>'Id' As varchar) AS "LocationInfo-DistrictInfo-Id",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-DistrictInfo-Name-cs",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'de' As varchar) AS "LocationInfo-DistrictInfo-Name-de",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'en' As varchar) AS "LocationInfo-DistrictInfo-Name-en",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-DistrictInfo-Name-fr",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'it' As varchar) AS "LocationInfo-DistrictInfo-Name-it",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-DistrictInfo-Name-nl",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-DistrictInfo-Name-pl",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-DistrictInfo-Name-ru",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->>'Id' As varchar) AS "LocationInfo-MunicipalityInfo-Id",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-MunicipalityInfo-Name-cs",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'de' As varchar) AS "LocationInfo-MunicipalityInfo-Name-de",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'en' As varchar) AS "LocationInfo-MunicipalityInfo-Name-en",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-MunicipalityInfo-Name-fr",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'it' As varchar) AS "LocationInfo-MunicipalityInfo-Name-it",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-MunicipalityInfo-Name-nl",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-MunicipalityInfo-Name-pl",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-MunicipalityInfo-Name-ru"
FROM accommodationsopen;

CREATE UNIQUE INDEX "v_accommodationsopen_pk" ON "v_accommodationsopen"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_accommodationsopen_SmgTags";

CREATE MATERIALIZED VIEW "v_accommodationsopen_SmgTags" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'SmgTags') AS "data"
        FROM accommodationsopen
        WHERE data -> 'SmgTags' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_accommodationsopen_ThemeIds";

CREATE MATERIALIZED VIEW "v_accommodationsopen_ThemeIds" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'ThemeIds') AS "data"
        FROM accommodationsopen
        WHERE data -> 'ThemeIds' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_accommodationsopen_HasLanguage";

CREATE MATERIALIZED VIEW "v_accommodationsopen_HasLanguage" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'HasLanguage') AS "data"
        FROM accommodationsopen
        WHERE data -> 'HasLanguage' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_accommodationsopen_SpecialFeaturesIds";

CREATE MATERIALIZED VIEW "v_accommodationsopen_SpecialFeaturesIds" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'SpecialFeaturesIds') AS "data"
        FROM accommodationsopen
        WHERE data -> 'SpecialFeaturesIds' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_accommodationsopen_Features";

CREATE MATERIALIZED VIEW "v_accommodationsopen_Features" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'Features') AS "Feature"
        FROM accommodationsopen
        WHERE data -> 'Features' != 'null')
    SELECT "Id" AS "accommodationsopen_Id", CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Name' As varchar) AS "Name"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS  "v_activitiesopen";

CREATE MATERIALIZED VIEW "v_activitiesopen" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Type' As varchar) AS "Type",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'IsOpen' As bool) AS "IsOpen",
CAST("data"->>'PoiType' As varchar) AS "PoiType",
CAST("data"->>'SubType' As varchar) AS "SubType",
CAST("data"->>'FeetClimb' As bool) AS "FeetClimb",
CAST("data"->>'Highlight' As bool) AS "Highlight",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'Difficulty' As varchar) AS "Difficulty",
CAST("data"->>'HasRentals' As bool) AS "HasRentals",
CAST("data"->>'IsPrepared' As bool) AS "IsPrepared",
CAST("data"->>'LastChange' As varchar) AS "LastChange",
CAST("data"->>'FirstImport' As varchar) AS "FirstImport",
CAST("data"->>'IsWithLigth' As bool) AS "IsWithLigth",
CAST("data"->>'RunToValley' As bool) AS "RunToValley",
CAST("data"->>'AltitudeSumUp' As float) AS "AltitudeSumUp",
CAST("data"->>'BikeTransport' As bool) AS "BikeTransport",
CAST("data"->>'LiftAvailable' As bool) AS "LiftAvailable",
CAST("data"->>'DistanceLength' As float) AS "DistanceLength",
CAST("data"->>'AltitudeSumDown' As float) AS "AltitudeSumDown",
CAST("data"->>'HasFreeEntrance' As bool) AS "HasFreeEntrance",
CAST("data"->>'OutdooractiveID' As varchar) AS "OutdooractiveID",
CAST("data"->>'DistanceDuration' As float) AS "DistanceDuration",
CAST("data"->>'AltitudeDifference' As float) AS "AltitudeDifference",
CAST("data"->>'AltitudeLowestPoint' As float) AS "AltitudeLowestPoint",
CAST("data"->>'AltitudeHighestPoint' As float) AS "AltitudeHighestPoint",
CAST("data"->>'TourismorganizationId' As varchar) AS "TourismorganizationId",
CAST("data"->'Detail'->'de'->>'Title' As varchar) AS "Detail-de-Title",
CAST("data"->'Detail'->'de'->>'BaseText' As varchar) AS "Detail-de-BaseText",
CAST("data"->'Detail'->'de'->>'Language' As varchar) AS "Detail-de-Language",
CAST("data"->'Detail'->'de'->>'GetThereText' As varchar) AS "Detail-de-GetThereText",
CAST("data"->'Detail'->'de'->>'AdditionalText' As varchar) AS "Detail-de-AdditionalText",
CAST("data"->'Detail'->'en'->>'Title' As varchar) AS "Detail-en-Title",
CAST("data"->'Detail'->'en'->>'BaseText' As varchar) AS "Detail-en-BaseText",
CAST("data"->'Detail'->'en'->>'Language' As varchar) AS "Detail-en-Language",
CAST("data"->'Detail'->'en'->>'GetThereText' As varchar) AS "Detail-en-GetThereText",
CAST("data"->'Detail'->'en'->>'AdditionalText' As varchar) AS "Detail-en-AdditionalText",
CAST("data"->'Detail'->'it'->>'Title' As varchar) AS "Detail-it-Title",
CAST("data"->'Detail'->'it'->>'BaseText' As varchar) AS "Detail-it-BaseText",
CAST("data"->'Detail'->'it'->>'Language' As varchar) AS "Detail-it-Language",
CAST("data"->'Detail'->'it'->>'GetThereText' As varchar) AS "Detail-it-GetThereText",
CAST("data"->'Detail'->'it'->>'AdditionalText' As varchar) AS "Detail-it-AdditionalText",
CAST("data"->'Ratings'->>'Stamina' As varchar) AS "Ratings-Stamina",
CAST("data"->'Ratings'->>'Landscape' As varchar) AS "Ratings-Landscape",
CAST("data"->'Ratings'->>'Technique' As varchar) AS "Ratings-Technique",
CAST("data"->'Ratings'->>'Difficulty' As varchar) AS "Ratings-Difficulty",
CAST("data"->'Ratings'->>'Experience' As varchar) AS "Ratings-Experience",
CAST("data"->'GpsPoints'->'position'->>'Gpstype' As varchar) AS "GpsPoints-position-Gpstype",
CAST("data"->'GpsPoints'->'position'->>'Altitude' As float) AS "GpsPoints-position-Altitude",
CAST("data"->'GpsPoints'->'position'->>'Latitude' As float) AS "GpsPoints-position-Latitude",
CAST("data"->'GpsPoints'->'position'->>'Longitude' As float) AS "GpsPoints-position-Longitude",
CAST("data"->'GpsPoints'->'position'->>'AltitudeUnitofMeasure' As varchar) AS "GpsPoints-position-AltitudeUnitofMeasure",
CAST("data"->'ContactInfos'->'de'->>'Url' As varchar) AS "ContactInfos-de-Url",
CAST("data"->'ContactInfos'->'de'->>'City' As varchar) AS "ContactInfos-de-City",
CAST("data"->'ContactInfos'->'de'->>'Email' As varchar) AS "ContactInfos-de-Email",
CAST("data"->'ContactInfos'->'de'->>'Address' As varchar) AS "ContactInfos-de-Address",
CAST("data"->'ContactInfos'->'de'->>'Surname' As varchar) AS "ContactInfos-de-Surname",
CAST("data"->'ContactInfos'->'de'->>'ZipCode' As varchar) AS "ContactInfos-de-ZipCode",
CAST("data"->'ContactInfos'->'de'->>'Language' As varchar) AS "ContactInfos-de-Language",
CAST("data"->'ContactInfos'->'de'->>'Faxnumber' As varchar) AS "ContactInfos-de-Faxnumber",
CAST("data"->'ContactInfos'->'de'->>'Givenname' As varchar) AS "ContactInfos-de-Givenname",
CAST("data"->'ContactInfos'->'de'->>'NamePrefix' As varchar) AS "ContactInfos-de-NamePrefix",
CAST("data"->'ContactInfos'->'de'->>'CompanyName' As varchar) AS "ContactInfos-de-CompanyName",
CAST("data"->'ContactInfos'->'de'->>'CountryCode' As varchar) AS "ContactInfos-de-CountryCode",
CAST("data"->'ContactInfos'->'de'->>'CountryName' As varchar) AS "ContactInfos-de-CountryName",
CAST("data"->'ContactInfos'->'de'->>'Phonenumber' As varchar) AS "ContactInfos-de-Phonenumber",
CAST("data"->'ContactInfos'->'en'->>'Url' As varchar) AS "ContactInfos-en-Url",
CAST("data"->'ContactInfos'->'en'->>'City' As varchar) AS "ContactInfos-en-City",
CAST("data"->'ContactInfos'->'en'->>'Email' As varchar) AS "ContactInfos-en-Email",
CAST("data"->'ContactInfos'->'en'->>'Address' As varchar) AS "ContactInfos-en-Address",
CAST("data"->'ContactInfos'->'en'->>'Surname' As varchar) AS "ContactInfos-en-Surname",
CAST("data"->'ContactInfos'->'en'->>'ZipCode' As varchar) AS "ContactInfos-en-ZipCode",
CAST("data"->'ContactInfos'->'en'->>'Language' As varchar) AS "ContactInfos-en-Language",
CAST("data"->'ContactInfos'->'en'->>'Faxnumber' As varchar) AS "ContactInfos-en-Faxnumber",
CAST("data"->'ContactInfos'->'en'->>'Givenname' As varchar) AS "ContactInfos-en-Givenname",
CAST("data"->'ContactInfos'->'en'->>'NamePrefix' As varchar) AS "ContactInfos-en-NamePrefix",
CAST("data"->'ContactInfos'->'en'->>'CompanyName' As varchar) AS "ContactInfos-en-CompanyName",
CAST("data"->'ContactInfos'->'en'->>'CountryCode' As varchar) AS "ContactInfos-en-CountryCode",
CAST("data"->'ContactInfos'->'en'->>'CountryName' As varchar) AS "ContactInfos-en-CountryName",
CAST("data"->'ContactInfos'->'en'->>'Phonenumber' As varchar) AS "ContactInfos-en-Phonenumber",
CAST("data"->'ContactInfos'->'it'->>'Url' As varchar) AS "ContactInfos-it-Url",
CAST("data"->'ContactInfos'->'it'->>'City' As varchar) AS "ContactInfos-it-City",
CAST("data"->'ContactInfos'->'it'->>'Email' As varchar) AS "ContactInfos-it-Email",
CAST("data"->'ContactInfos'->'it'->>'Address' As varchar) AS "ContactInfos-it-Address",
CAST("data"->'ContactInfos'->'it'->>'Surname' As varchar) AS "ContactInfos-it-Surname",
CAST("data"->'ContactInfos'->'it'->>'ZipCode' As varchar) AS "ContactInfos-it-ZipCode",
CAST("data"->'ContactInfos'->'it'->>'Language' As varchar) AS "ContactInfos-it-Language",
CAST("data"->'ContactInfos'->'it'->>'Faxnumber' As varchar) AS "ContactInfos-it-Faxnumber",
CAST("data"->'ContactInfos'->'it'->>'Givenname' As varchar) AS "ContactInfos-it-Givenname",
CAST("data"->'ContactInfos'->'it'->>'NamePrefix' As varchar) AS "ContactInfos-it-NamePrefix",
CAST("data"->'ContactInfos'->'it'->>'CompanyName' As varchar) AS "ContactInfos-it-CompanyName",
CAST("data"->'ContactInfos'->'it'->>'CountryCode' As varchar) AS "ContactInfos-it-CountryCode",
CAST("data"->'ContactInfos'->'it'->>'CountryName' As varchar) AS "ContactInfos-it-CountryName",
CAST("data"->'ContactInfos'->'it'->>'Phonenumber' As varchar) AS "ContactInfos-it-Phonenumber",
CAST("data"->'LocationInfo'->'TvInfo'->>'Id' As varchar) AS "LocationInfo-TvInfo-Id",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-TvInfo-Name-cs",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'de' As varchar) AS "LocationInfo-TvInfo-Name-de",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'en' As varchar) AS "LocationInfo-TvInfo-Name-en",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-TvInfo-Name-fr",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'it' As varchar) AS "LocationInfo-TvInfo-Name-it",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-TvInfo-Name-nl",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-TvInfo-Name-pl",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-TvInfo-Name-ru",
CAST("data"->'LocationInfo'->'AreaInfo'->>'Id' As varchar) AS "LocationInfo-AreaInfo-Id",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-AreaInfo-Name-cs",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'de' As varchar) AS "LocationInfo-AreaInfo-Name-de",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'en' As varchar) AS "LocationInfo-AreaInfo-Name-en",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-AreaInfo-Name-fr",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'it' As varchar) AS "LocationInfo-AreaInfo-Name-it",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-AreaInfo-Name-nl",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-AreaInfo-Name-pl",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-AreaInfo-Name-ru",
CAST("data"->'LocationInfo'->'RegionInfo'->>'Id' As varchar) AS "LocationInfo-RegionInfo-Id",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-RegionInfo-Name-cs",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'de' As varchar) AS "LocationInfo-RegionInfo-Name-de",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'en' As varchar) AS "LocationInfo-RegionInfo-Name-en",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-RegionInfo-Name-fr",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'it' As varchar) AS "LocationInfo-RegionInfo-Name-it",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-RegionInfo-Name-nl",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-RegionInfo-Name-pl",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-RegionInfo-Name-ru",
CAST("data"->'AdditionalPoiInfos'->'de'->>'PoiType' As varchar) AS "AdditionalPoiInfos-de-PoiType",
CAST("data"->'AdditionalPoiInfos'->'de'->>'SubType' As varchar) AS "AdditionalPoiInfos-de-SubType",
CAST("data"->'AdditionalPoiInfos'->'de'->>'Language' As varchar) AS "AdditionalPoiInfos-de-Language",
CAST("data"->'AdditionalPoiInfos'->'de'->>'MainType' As varchar) AS "AdditionalPoiInfos-de-MainType",
CAST("data"->'AdditionalPoiInfos'->'en'->>'PoiType' As varchar) AS "AdditionalPoiInfos-en-PoiType",
CAST("data"->'AdditionalPoiInfos'->'en'->>'SubType' As varchar) AS "AdditionalPoiInfos-en-SubType",
CAST("data"->'AdditionalPoiInfos'->'en'->>'Language' As varchar) AS "AdditionalPoiInfos-en-Language",
CAST("data"->'AdditionalPoiInfos'->'en'->>'MainType' As varchar) AS "AdditionalPoiInfos-en-MainType",
CAST("data"->'AdditionalPoiInfos'->'it'->>'PoiType' As varchar) AS "AdditionalPoiInfos-it-PoiType",
CAST("data"->'AdditionalPoiInfos'->'it'->>'SubType' As varchar) AS "AdditionalPoiInfos-it-SubType",
CAST("data"->'AdditionalPoiInfos'->'it'->>'Language' As varchar) AS "AdditionalPoiInfos-it-Language",
CAST("data"->'AdditionalPoiInfos'->'it'->>'MainType' As varchar) AS "AdditionalPoiInfos-it-MainType"
FROM activitiesopen;

CREATE UNIQUE INDEX "v_activitiesopen_pk" ON "v_activitiesopen"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_activitiesopen_AreaId";

CREATE MATERIALIZED VIEW "v_activitiesopen_AreaId" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'AreaId') AS "data"
        FROM activitiesopen
        WHERE data -> 'AreaId' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_activitiesopen_SmgTags";

CREATE MATERIALIZED VIEW "v_activitiesopen_SmgTags" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'SmgTags') AS "data"
        FROM activitiesopen
        WHERE data -> 'SmgTags' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_activitiesopen_HasLanguage";

CREATE MATERIALIZED VIEW "v_activitiesopen_HasLanguage" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'HasLanguage') AS "data"
        FROM activitiesopen
        WHERE data -> 'HasLanguage' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_activitiesopen_GpsInfo";

CREATE MATERIALIZED VIEW "v_activitiesopen_GpsInfo" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'GpsInfo') AS "Feature"
        FROM activitiesopen
        WHERE data -> 'GpsInfo' != 'null')
    SELECT "Id" AS "activitiesopen_Id", CAST("data"->>'Gpstype' As varchar) AS "Gpstype",
CAST("data"->>'Altitude' As float) AS "Altitude",
CAST("data"->>'Latitude' As float) AS "Latitude",
CAST("data"->>'Longitude' As float) AS "Longitude",
CAST("data"->>'AltitudeUnitofMeasure' As varchar) AS "AltitudeUnitofMeasure"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS "v_activitiesopen_GpsTrack";

CREATE MATERIALIZED VIEW "v_activitiesopen_GpsTrack" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'GpsTrack') AS "Feature"
        FROM activitiesopen
        WHERE data -> 'GpsTrack' != 'null')
    SELECT "Id" AS "activitiesopen_Id", CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Type' As varchar) AS "Type",
CAST("data"->>'GpxTrackUrl' As varchar) AS "GpxTrackUrl",
CAST("data"->'GpxTrackDesc'->>'de' As varchar) AS "GpxTrackDesc-de",
CAST("data"->'GpxTrackDesc'->>'en' As varchar) AS "GpxTrackDesc-en",
CAST("data"->'GpxTrackDesc'->>'it' As varchar) AS "GpxTrackDesc-it"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS "v_activitiesopen_OperationSchedule";

CREATE MATERIALIZED VIEW "v_activitiesopen_OperationSchedule" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'OperationSchedule') AS "Feature"
        FROM activitiesopen
        WHERE data -> 'OperationSchedule' != 'null')
    SELECT "Id" AS "activitiesopen_Id", CAST("data"->>'Stop' As varchar) AS "Stop",
CAST("data"->>'Type' As varchar) AS "Type",
CAST("data"->>'Start' As varchar) AS "Start",
CAST("data"->'OperationscheduleName'->>'de' As varchar) AS "OperationscheduleName-de"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS  "v_areas";

CREATE MATERIALIZED VIEW "v_areas" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'GID' As varchar) AS "GID",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'AreaType' As varchar) AS "AreaType",
CAST("data"->>'RegionId' As varchar) AS "RegionId",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'TourismvereinId' As varchar) AS "TourismvereinId"
FROM areas;

CREATE UNIQUE INDEX "v_areas_pk" ON "v_areas"("Id");

DROP MATERIALIZED VIEW IF EXISTS  "v_articlesopen";

CREATE MATERIALIZED VIEW "v_articlesopen" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Type' As varchar) AS "Type",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'SubType' As varchar) AS "SubType",
CAST("data"->>'Highlight' As bool) AS "Highlight",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'LastChange' As varchar) AS "LastChange",
CAST("data"->>'FirstImport' As varchar) AS "FirstImport",
CAST("data"->'Detail'->'de'->>'Title' As varchar) AS "Detail-de-Title",
CAST("data"->'Detail'->'de'->>'BaseText' As varchar) AS "Detail-de-BaseText"
FROM articlesopen;

CREATE UNIQUE INDEX "v_articlesopen_pk" ON "v_articlesopen"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_articlesopen_HasLanguage";

CREATE MATERIALIZED VIEW "v_articlesopen_HasLanguage" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'HasLanguage') AS "data"
        FROM articlesopen
        WHERE data -> 'HasLanguage' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS  "v_districtsopen";

CREATE MATERIALIZED VIEW "v_districtsopen" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'SiagId' As varchar) AS "SiagId",
CAST("data"->>'Gpstype' As varchar) AS "Gpstype",
CAST("data"->>'Altitude' As float) AS "Altitude",
CAST("data"->>'CustomId' As varchar) AS "CustomId",
CAST("data"->>'Latitude' As float) AS "Latitude",
CAST("data"->>'RegionId' As varchar) AS "RegionId",
CAST("data"->>'Longitude' As float) AS "Longitude",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'LastChange' As varchar) AS "LastChange",
CAST("data"->>'MunicipalityId' As varchar) AS "MunicipalityId",
CAST("data"->>'TourismvereinId' As varchar) AS "TourismvereinId",
CAST("data"->>'VisibleInSearch' As bool) AS "VisibleInSearch",
CAST("data"->>'AltitudeUnitofMeasure' As varchar) AS "AltitudeUnitofMeasure",
CAST("data"->'Detail'->'cs'->>'Title' As varchar) AS "Detail-cs-Title",
CAST("data"->'Detail'->'cs'->>'Language' As varchar) AS "Detail-cs-Language",
CAST("data"->'Detail'->'de'->>'Title' As varchar) AS "Detail-de-Title",
CAST("data"->'Detail'->'de'->>'Language' As varchar) AS "Detail-de-Language",
CAST("data"->'Detail'->'en'->>'Title' As varchar) AS "Detail-en-Title",
CAST("data"->'Detail'->'en'->>'Language' As varchar) AS "Detail-en-Language",
CAST("data"->'Detail'->'fr'->>'Title' As varchar) AS "Detail-fr-Title",
CAST("data"->'Detail'->'fr'->>'Language' As varchar) AS "Detail-fr-Language",
CAST("data"->'Detail'->'it'->>'Title' As varchar) AS "Detail-it-Title",
CAST("data"->'Detail'->'it'->>'Language' As varchar) AS "Detail-it-Language",
CAST("data"->'Detail'->'nl'->>'Title' As varchar) AS "Detail-nl-Title",
CAST("data"->'Detail'->'nl'->>'Language' As varchar) AS "Detail-nl-Language",
CAST("data"->'Detail'->'pl'->>'Title' As varchar) AS "Detail-pl-Title",
CAST("data"->'Detail'->'pl'->>'Language' As varchar) AS "Detail-pl-Language",
CAST("data"->'Detail'->'ru'->>'Title' As varchar) AS "Detail-ru-Title",
CAST("data"->'Detail'->'ru'->>'Language' As varchar) AS "Detail-ru-Language"
FROM districtsopen;

CREATE UNIQUE INDEX "v_districtsopen_pk" ON "v_districtsopen"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_districtsopen_HasLanguage";

CREATE MATERIALIZED VIEW "v_districtsopen_HasLanguage" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'HasLanguage') AS "data"
        FROM districtsopen
        WHERE data -> 'HasLanguage' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS  "v_eventeuracnoi";

CREATE MATERIALIZED VIEW "v_eventeuracnoi" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Source' As varchar) AS "Source",
CAST("data"->>'EndDate' As varchar) AS "EndDate",
CAST("data"->>'EventId' As integer) AS "EventId",
CAST("data"->>'Display1' As varchar) AS "Display1",
CAST("data"->>'Display2' As varchar) AS "Display2",
CAST("data"->>'Display3' As varchar) AS "Display3",
CAST("data"->>'Display4' As varchar) AS "Display4",
CAST("data"->>'Display5' As varchar) AS "Display5",
CAST("data"->>'Display6' As varchar) AS "Display6",
CAST("data"->>'Display7' As varchar) AS "Display7",
CAST("data"->>'Display8' As varchar) AS "Display8",
CAST("data"->>'Display9' As varchar) AS "Display9",
CAST("data"->>'ChangedOn' As varchar) AS "ChangedOn",
CAST("data"->>'CompanyId' As varchar) AS "CompanyId",
CAST("data"->>'StartDate' As varchar) AS "StartDate",
CAST("data"->>'CompanyFax' As varchar) AS "CompanyFax",
CAST("data"->>'CompanyUrl' As varchar) AS "CompanyUrl",
CAST("data"->>'ContactFax' As varchar) AS "ContactFax",
CAST("data"->>'EndDateUTC' As float) AS "EndDateUTC",
CAST("data"->>'WebAddress' As varchar) AS "WebAddress",
CAST("data"->>'AnchorVenue' As varchar) AS "AnchorVenue",
CAST("data"->>'CompanyCity' As varchar) AS "CompanyCity",
CAST("data"->>'CompanyMail' As varchar) AS "CompanyMail",
CAST("data"->>'CompanyName' As varchar) AS "CompanyName",
CAST("data"->>'ContactCell' As varchar) AS "ContactCell",
CAST("data"->>'ContactCity' As varchar) AS "ContactCity",
CAST("data"->>'ContactCode' As varchar) AS "ContactCode",
CAST("data"->>'CompanyPhone' As varchar) AS "CompanyPhone",
CAST("data"->>'ContactEmail' As varchar) AS "ContactEmail",
CAST("data"->>'ContactPhone' As varchar) AS "ContactPhone",
CAST("data"->>'StartDateUTC' As float) AS "StartDateUTC",
CAST("data"->>'EventLocation' As varchar) AS "EventLocation",
CAST("data"->>'CompanyCountry' As varchar) AS "CompanyCountry",
CAST("data"->>'ContactCountry' As varchar) AS "ContactCountry",
CAST("data"->>'ContactLastName' As varchar) AS "ContactLastName",
CAST("data"->>'AnchorVenueShort' As varchar) AS "AnchorVenueShort",
CAST("data"->>'ContactFirstName' As varchar) AS "ContactFirstName",
CAST("data"->>'EventDescription' As varchar) AS "EventDescription",
CAST("data"->>'CompanyPostalCode' As varchar) AS "CompanyPostalCode",
CAST("data"->>'ContactPostalCode' As varchar) AS "ContactPostalCode",
CAST("data"->>'EventDescriptionDE' As varchar) AS "EventDescriptionDE",
CAST("data"->>'EventDescriptionEN' As varchar) AS "EventDescriptionEN",
CAST("data"->>'EventDescriptionIT' As varchar) AS "EventDescriptionIT",
CAST("data"->>'CompanyAddressLine1' As varchar) AS "CompanyAddressLine1",
CAST("data"->>'CompanyAddressLine2' As varchar) AS "CompanyAddressLine2",
CAST("data"->>'CompanyAddressLine3' As varchar) AS "CompanyAddressLine3",
CAST("data"->>'ContactAddressLine1' As varchar) AS "ContactAddressLine1",
CAST("data"->>'ContactAddressLine2' As varchar) AS "ContactAddressLine2",
CAST("data"->>'ContactAddressLine3' As varchar) AS "ContactAddressLine3"
FROM eventeuracnoi;

CREATE UNIQUE INDEX "v_eventeuracnoi_pk" ON "v_eventeuracnoi"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_eventeuracnoi_RoomBooked";

CREATE MATERIALIZED VIEW "v_eventeuracnoi_RoomBooked" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'RoomBooked') AS "Feature"
        FROM eventeuracnoi
        WHERE data -> 'RoomBooked' != 'null')
    SELECT "Id" AS "eventeuracnoi_Id", CAST("data"->>'Space' As varchar) AS "Space",
CAST("data"->>'Comment' As varchar) AS "Comment",
CAST("data"->>'EndDate' As varchar) AS "EndDate",
CAST("data"->>'Subtitle' As varchar) AS "Subtitle",
CAST("data"->>'SpaceDesc' As varchar) AS "SpaceDesc",
CAST("data"->>'SpaceType' As varchar) AS "SpaceType",
CAST("data"->>'StartDate' As varchar) AS "StartDate",
CAST("data"->>'EndDateUTC' As float) AS "EndDateUTC",
CAST("data"->>'SpaceAbbrev' As varchar) AS "SpaceAbbrev",
CAST("data"->>'StartDateUTC' As float) AS "StartDateUTC"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS  "v_experienceareasopen";

CREATE MATERIALIZED VIEW "v_experienceareasopen" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'Gpstype' As varchar) AS "Gpstype",
CAST("data"->>'Latitude' As float) AS "Latitude",
CAST("data"->>'Longitude' As float) AS "Longitude",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'LastChange' As varchar) AS "LastChange",
CAST("data"->>'VisibleInSearch' As bool) AS "VisibleInSearch",
CAST("data"->>'AltitudeUnitofMeasure' As varchar) AS "AltitudeUnitofMeasure",
CAST("data"->'Detail'->'cs'->>'Title' As varchar) AS "Detail-cs-Title",
CAST("data"->'Detail'->'de'->>'Title' As varchar) AS "Detail-de-Title",
CAST("data"->'Detail'->'de'->>'BaseText' As varchar) AS "Detail-de-BaseText",
CAST("data"->'Detail'->'de'->>'IntroText' As varchar) AS "Detail-de-IntroText",
CAST("data"->'Detail'->'en'->>'Title' As varchar) AS "Detail-en-Title",
CAST("data"->'Detail'->'fr'->>'Title' As varchar) AS "Detail-fr-Title",
CAST("data"->'Detail'->'it'->>'Title' As varchar) AS "Detail-it-Title",
CAST("data"->'Detail'->'nl'->>'Title' As varchar) AS "Detail-nl-Title",
CAST("data"->'Detail'->'pl'->>'Title' As varchar) AS "Detail-pl-Title",
CAST("data"->'Detail'->'ru'->>'Title' As varchar) AS "Detail-ru-Title"
FROM experienceareasopen;

CREATE UNIQUE INDEX "v_experienceareasopen_pk" ON "v_experienceareasopen"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_experienceareasopen_TourismvereinIds";

CREATE MATERIALIZED VIEW "v_experienceareasopen_TourismvereinIds" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'TourismvereinIds') AS "data"
        FROM experienceareasopen
        WHERE data -> 'TourismvereinIds' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS  "v_ltstaggingtypes";

CREATE MATERIALIZED VIEW "v_ltstaggingtypes" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Key' As varchar) AS "Key",
CAST("data"->>'Level' As integer) AS "Level",
CAST("data"->>'Entity' As varchar) AS "Entity",
CAST("data"->>'TypeParent' As varchar) AS "TypeParent",
CAST("data"->'TypeNames'->>'de' As varchar) AS "TypeNames-de",
CAST("data"->'TypeNames'->>'en' As varchar) AS "TypeNames-en",
CAST("data"->'TypeNames'->>'it' As varchar) AS "TypeNames-it",
CAST("data"->'TypeDescriptions'->>'de' As varchar) AS "TypeDescriptions-de",
CAST("data"->'TypeDescriptions'->>'en' As varchar) AS "TypeDescriptions-en",
CAST("data"->'TypeDescriptions'->>'it' As varchar) AS "TypeDescriptions-it"
FROM ltstaggingtypes;

CREATE UNIQUE INDEX "v_ltstaggingtypes_pk" ON "v_ltstaggingtypes"("Id");

DROP MATERIALIZED VIEW IF EXISTS  "v_marketinggroups";

CREATE MATERIALIZED VIEW "v_marketinggroups" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'Beschreibung' As varchar) AS "Beschreibung"
FROM marketinggroups;

CREATE UNIQUE INDEX "v_marketinggroups_pk" ON "v_marketinggroups"("Id");

DROP MATERIALIZED VIEW IF EXISTS  "v_measuringpoints";

CREATE MATERIALIZED VIEW "v_measuringpoints" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'Gpstype' As varchar) AS "Gpstype",
CAST("data"->>'OwnerId' As varchar) AS "OwnerId",
CAST("data"->>'Altitude' As float) AS "Altitude",
CAST("data"->>'Latitude' As float) AS "Latitude",
CAST("data"->>'Longitude' As float) AS "Longitude",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'LastUpdate' As varchar) AS "LastUpdate",
CAST("data"->>'SnowHeight' As varchar) AS "SnowHeight",
CAST("data"->>'FirstImport' As varchar) AS "FirstImport",
CAST("data"->>'Temperature' As varchar) AS "Temperature",
CAST("data"->>'LastSnowDate' As varchar) AS "LastSnowDate",
CAST("data"->>'newSnowHeight' As varchar) AS "newSnowHeight",
CAST("data"->>'AltitudeUnitofMeasure' As varchar) AS "AltitudeUnitofMeasure",
CAST("data"->'LocationInfo'->'TvInfo'->>'Id' As varchar) AS "LocationInfo-TvInfo-Id",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-TvInfo-Name-cs",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'de' As varchar) AS "LocationInfo-TvInfo-Name-de",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'en' As varchar) AS "LocationInfo-TvInfo-Name-en",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-TvInfo-Name-fr",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'it' As varchar) AS "LocationInfo-TvInfo-Name-it",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-TvInfo-Name-nl",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-TvInfo-Name-pl",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-TvInfo-Name-ru",
CAST("data"->'LocationInfo'->'AreaInfo'->>'Id' As varchar) AS "LocationInfo-AreaInfo-Id",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-AreaInfo-Name-cs",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'de' As varchar) AS "LocationInfo-AreaInfo-Name-de",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'en' As varchar) AS "LocationInfo-AreaInfo-Name-en",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-AreaInfo-Name-fr",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'it' As varchar) AS "LocationInfo-AreaInfo-Name-it",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-AreaInfo-Name-nl",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-AreaInfo-Name-pl",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-AreaInfo-Name-ru",
CAST("data"->'LocationInfo'->'RegionInfo'->>'Id' As varchar) AS "LocationInfo-RegionInfo-Id",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-RegionInfo-Name-cs",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'de' As varchar) AS "LocationInfo-RegionInfo-Name-de",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'en' As varchar) AS "LocationInfo-RegionInfo-Name-en",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-RegionInfo-Name-fr",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'it' As varchar) AS "LocationInfo-RegionInfo-Name-it",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-RegionInfo-Name-nl",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-RegionInfo-Name-pl",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-RegionInfo-Name-ru"
FROM measuringpoints;

CREATE UNIQUE INDEX "v_measuringpoints_pk" ON "v_measuringpoints"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_measuringpoints_AreaIds";

CREATE MATERIALIZED VIEW "v_measuringpoints_AreaIds" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'AreaIds') AS "data"
        FROM measuringpoints
        WHERE data -> 'AreaIds' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS  "v_metaregionsopen";

CREATE MATERIALIZED VIEW "v_metaregionsopen" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'Gpstype' As varchar) AS "Gpstype",
CAST("data"->>'Latitude' As float) AS "Latitude",
CAST("data"->>'Longitude' As float) AS "Longitude",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'LastChange' As varchar) AS "LastChange",
CAST("data"->>'VisibleInSearch' As bool) AS "VisibleInSearch",
CAST("data"->'Detail'->'cs'->>'Title' As varchar) AS "Detail-cs-Title",
CAST("data"->'Detail'->'cs'->>'Header' As varchar) AS "Detail-cs-Header",
CAST("data"->'Detail'->'cs'->>'BaseText' As varchar) AS "Detail-cs-BaseText",
CAST("data"->'Detail'->'cs'->>'MetaDesc' As varchar) AS "Detail-cs-MetaDesc",
CAST("data"->'Detail'->'cs'->>'IntroText' As varchar) AS "Detail-cs-IntroText",
CAST("data"->'Detail'->'cs'->>'MetaTitle' As varchar) AS "Detail-cs-MetaTitle",
CAST("data"->'Detail'->'cs'->>'SubHeader' As varchar) AS "Detail-cs-SubHeader",
CAST("data"->'Detail'->'cs'->>'GetThereText' As varchar) AS "Detail-cs-GetThereText",
CAST("data"->'Detail'->'cs'->>'AdditionalText' As varchar) AS "Detail-cs-AdditionalText",
CAST("data"->'Detail'->'de'->>'Title' As varchar) AS "Detail-de-Title",
CAST("data"->'Detail'->'de'->>'Header' As varchar) AS "Detail-de-Header",
CAST("data"->'Detail'->'de'->>'BaseText' As varchar) AS "Detail-de-BaseText",
CAST("data"->'Detail'->'de'->>'MetaDesc' As varchar) AS "Detail-de-MetaDesc",
CAST("data"->'Detail'->'de'->>'IntroText' As varchar) AS "Detail-de-IntroText",
CAST("data"->'Detail'->'de'->>'MetaTitle' As varchar) AS "Detail-de-MetaTitle",
CAST("data"->'Detail'->'de'->>'SubHeader' As varchar) AS "Detail-de-SubHeader",
CAST("data"->'Detail'->'en'->>'Title' As varchar) AS "Detail-en-Title",
CAST("data"->'Detail'->'en'->>'Header' As varchar) AS "Detail-en-Header",
CAST("data"->'Detail'->'en'->>'BaseText' As varchar) AS "Detail-en-BaseText",
CAST("data"->'Detail'->'en'->>'MetaDesc' As varchar) AS "Detail-en-MetaDesc",
CAST("data"->'Detail'->'en'->>'IntroText' As varchar) AS "Detail-en-IntroText",
CAST("data"->'Detail'->'en'->>'MetaTitle' As varchar) AS "Detail-en-MetaTitle",
CAST("data"->'Detail'->'en'->>'SubHeader' As varchar) AS "Detail-en-SubHeader",
CAST("data"->'Detail'->'en'->>'GetThereText' As varchar) AS "Detail-en-GetThereText",
CAST("data"->'Detail'->'en'->>'AdditionalText' As varchar) AS "Detail-en-AdditionalText",
CAST("data"->'Detail'->'fr'->>'Title' As varchar) AS "Detail-fr-Title",
CAST("data"->'Detail'->'fr'->>'Header' As varchar) AS "Detail-fr-Header",
CAST("data"->'Detail'->'fr'->>'BaseText' As varchar) AS "Detail-fr-BaseText",
CAST("data"->'Detail'->'fr'->>'MetaDesc' As varchar) AS "Detail-fr-MetaDesc",
CAST("data"->'Detail'->'fr'->>'IntroText' As varchar) AS "Detail-fr-IntroText",
CAST("data"->'Detail'->'fr'->>'MetaTitle' As varchar) AS "Detail-fr-MetaTitle",
CAST("data"->'Detail'->'fr'->>'SubHeader' As varchar) AS "Detail-fr-SubHeader",
CAST("data"->'Detail'->'fr'->>'GetThereText' As varchar) AS "Detail-fr-GetThereText",
CAST("data"->'Detail'->'fr'->>'AdditionalText' As varchar) AS "Detail-fr-AdditionalText",
CAST("data"->'Detail'->'it'->>'Title' As varchar) AS "Detail-it-Title",
CAST("data"->'Detail'->'it'->>'Header' As varchar) AS "Detail-it-Header",
CAST("data"->'Detail'->'it'->>'BaseText' As varchar) AS "Detail-it-BaseText",
CAST("data"->'Detail'->'it'->>'MetaDesc' As varchar) AS "Detail-it-MetaDesc",
CAST("data"->'Detail'->'it'->>'IntroText' As varchar) AS "Detail-it-IntroText",
CAST("data"->'Detail'->'it'->>'MetaTitle' As varchar) AS "Detail-it-MetaTitle",
CAST("data"->'Detail'->'it'->>'SubHeader' As varchar) AS "Detail-it-SubHeader",
CAST("data"->'Detail'->'it'->>'GetThereText' As varchar) AS "Detail-it-GetThereText",
CAST("data"->'Detail'->'it'->>'AdditionalText' As varchar) AS "Detail-it-AdditionalText",
CAST("data"->'Detail'->'nl'->>'Title' As varchar) AS "Detail-nl-Title",
CAST("data"->'Detail'->'nl'->>'Header' As varchar) AS "Detail-nl-Header",
CAST("data"->'Detail'->'nl'->>'BaseText' As varchar) AS "Detail-nl-BaseText",
CAST("data"->'Detail'->'nl'->>'MetaDesc' As varchar) AS "Detail-nl-MetaDesc",
CAST("data"->'Detail'->'nl'->>'IntroText' As varchar) AS "Detail-nl-IntroText",
CAST("data"->'Detail'->'nl'->>'MetaTitle' As varchar) AS "Detail-nl-MetaTitle",
CAST("data"->'Detail'->'nl'->>'SubHeader' As varchar) AS "Detail-nl-SubHeader",
CAST("data"->'Detail'->'nl'->>'GetThereText' As varchar) AS "Detail-nl-GetThereText",
CAST("data"->'Detail'->'nl'->>'AdditionalText' As varchar) AS "Detail-nl-AdditionalText",
CAST("data"->'Detail'->'pl'->>'Title' As varchar) AS "Detail-pl-Title",
CAST("data"->'Detail'->'pl'->>'Header' As varchar) AS "Detail-pl-Header",
CAST("data"->'Detail'->'pl'->>'BaseText' As varchar) AS "Detail-pl-BaseText",
CAST("data"->'Detail'->'pl'->>'MetaDesc' As varchar) AS "Detail-pl-MetaDesc",
CAST("data"->'Detail'->'pl'->>'IntroText' As varchar) AS "Detail-pl-IntroText",
CAST("data"->'Detail'->'pl'->>'MetaTitle' As varchar) AS "Detail-pl-MetaTitle",
CAST("data"->'Detail'->'pl'->>'SubHeader' As varchar) AS "Detail-pl-SubHeader",
CAST("data"->'Detail'->'pl'->>'GetThereText' As varchar) AS "Detail-pl-GetThereText",
CAST("data"->'Detail'->'pl'->>'AdditionalText' As varchar) AS "Detail-pl-AdditionalText",
CAST("data"->'Detail'->'ru'->>'Title' As varchar) AS "Detail-ru-Title",
CAST("data"->'Detail'->'ru'->>'Header' As varchar) AS "Detail-ru-Header",
CAST("data"->'Detail'->'ru'->>'BaseText' As varchar) AS "Detail-ru-BaseText",
CAST("data"->'Detail'->'ru'->>'MetaDesc' As varchar) AS "Detail-ru-MetaDesc",
CAST("data"->'Detail'->'ru'->>'IntroText' As varchar) AS "Detail-ru-IntroText",
CAST("data"->'Detail'->'ru'->>'MetaTitle' As varchar) AS "Detail-ru-MetaTitle",
CAST("data"->'Detail'->'ru'->>'SubHeader' As varchar) AS "Detail-ru-SubHeader",
CAST("data"->'Detail'->'ru'->>'GetThereText' As varchar) AS "Detail-ru-GetThereText",
CAST("data"->'Detail'->'ru'->>'AdditionalText' As varchar) AS "Detail-ru-AdditionalText",
CAST("data"->'DetailThemed'->'cs'->>'Language' As varchar) AS "DetailThemed-cs-Language",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-cs-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-cs-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-cs-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-cs-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-cs-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-cs-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-cs-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-cs-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-cs-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-cs-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-cs-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-cs-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Essen und Trinken'->>'Intro' As varchar) AS "DetailThemed-cs-DetailsThemed-Essen und Trinken-Intro",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Essen und Trinken'->>'Title' As varchar) AS "DetailThemed-cs-DetailsThemed-Essen und Trinken-Title",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Essen und Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-cs-DetailsThemed-Essen und Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Essen und Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-cs-DetailsThemed-Essen und Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-cs-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-cs-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-cs-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-cs-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-c-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-c-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-c-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-c-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle",
CAST("data"->'DetailThemed'->'de'->>'Language' As varchar) AS "DetailThemed-de-Language",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-de-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-de-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-de-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-de-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-de-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-de-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-de-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-de-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-de-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-de-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-de-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-de-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Essen und Trinken'->>'Intro' As varchar) AS "DetailThemed-de-DetailsThemed-Essen und Trinken-Intro",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Essen und Trinken'->>'Title' As varchar) AS "DetailThemed-de-DetailsThemed-Essen und Trinken-Title",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Essen und Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-de-DetailsThemed-Essen und Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Essen und Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-de-DetailsThemed-Essen und Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-de-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-de-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-de-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-de-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-d-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-d-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-d-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-d-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle",
CAST("data"->'DetailThemed'->'en'->>'Language' As varchar) AS "DetailThemed-en-Language",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-en-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-en-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-en-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-en-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-en-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-en-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-en-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-en-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-en-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-en-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-en-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-en-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Essen und Trinken'->>'Intro' As varchar) AS "DetailThemed-en-DetailsThemed-Essen und Trinken-Intro",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Essen und Trinken'->>'Title' As varchar) AS "DetailThemed-en-DetailsThemed-Essen und Trinken-Title",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Essen und Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-en-DetailsThemed-Essen und Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Essen und Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-en-DetailsThemed-Essen und Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-en-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-en-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-en-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-en-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-e-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-e-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-e-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-e-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle",
CAST("data"->'DetailThemed'->'fr'->>'Language' As varchar) AS "DetailThemed-fr-Language",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-fr-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-fr-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-fr-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-fr-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-fr-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-fr-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-fr-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-fr-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-fr-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-fr-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-fr-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-fr-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Essen und Trinken'->>'Intro' As varchar) AS "DetailThemed-fr-DetailsThemed-Essen und Trinken-Intro",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Essen und Trinken'->>'Title' As varchar) AS "DetailThemed-fr-DetailsThemed-Essen und Trinken-Title",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Essen und Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-fr-DetailsThemed-Essen und Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Essen und Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-fr-DetailsThemed-Essen und Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-fr-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-fr-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-fr-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-fr-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-f-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-f-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-f-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-f-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle",
CAST("data"->'DetailThemed'->'it'->>'Language' As varchar) AS "DetailThemed-it-Language",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-it-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-it-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-it-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-it-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-it-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-it-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-it-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-it-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-it-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-it-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-it-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-it-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Essen und Trinken'->>'Intro' As varchar) AS "DetailThemed-it-DetailsThemed-Essen und Trinken-Intro",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Essen und Trinken'->>'Title' As varchar) AS "DetailThemed-it-DetailsThemed-Essen und Trinken-Title",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Essen und Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-it-DetailsThemed-Essen und Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Essen und Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-it-DetailsThemed-Essen und Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-it-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-it-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-it-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-it-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-i-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-i-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-i-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-i-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle",
CAST("data"->'DetailThemed'->'nl'->>'Language' As varchar) AS "DetailThemed-nl-Language",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-nl-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-nl-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-nl-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-nl-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-nl-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-nl-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-nl-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-nl-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-nl-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-nl-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-nl-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-nl-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Essen und Trinken'->>'Intro' As varchar) AS "DetailThemed-nl-DetailsThemed-Essen und Trinken-Intro",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Essen und Trinken'->>'Title' As varchar) AS "DetailThemed-nl-DetailsThemed-Essen und Trinken-Title",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Essen und Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-nl-DetailsThemed-Essen und Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Essen und Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-nl-DetailsThemed-Essen und Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-nl-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-nl-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-nl-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-nl-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-n-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-n-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-n-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-n-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle",
CAST("data"->'DetailThemed'->'pl'->>'Language' As varchar) AS "DetailThemed-pl-Language",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-pl-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-pl-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-pl-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-pl-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-pl-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-pl-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-pl-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-pl-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-pl-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-pl-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-pl-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-pl-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Essen und Trinken'->>'Intro' As varchar) AS "DetailThemed-pl-DetailsThemed-Essen und Trinken-Intro",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Essen und Trinken'->>'Title' As varchar) AS "DetailThemed-pl-DetailsThemed-Essen und Trinken-Title",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Essen und Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-pl-DetailsThemed-Essen und Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Essen und Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-pl-DetailsThemed-Essen und Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-pl-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-pl-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-pl-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-pl-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-p-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-p-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-p-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-p-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle",
CAST("data"->'DetailThemed'->'ru'->>'Language' As varchar) AS "DetailThemed-ru-Language",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-ru-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-ru-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-ru-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-ru-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-ru-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-ru-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-ru-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-ru-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-ru-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-ru-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-ru-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-ru-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Essen und Trinken'->>'Intro' As varchar) AS "DetailThemed-ru-DetailsThemed-Essen und Trinken-Intro",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Essen und Trinken'->>'Title' As varchar) AS "DetailThemed-ru-DetailsThemed-Essen und Trinken-Title",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Essen und Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-ru-DetailsThemed-Essen und Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Essen und Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-ru-DetailsThemed-Essen und Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-ru-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-ru-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-ru-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-ru-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-r-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-r-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-r-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-r-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle"
FROM metaregionsopen;

CREATE UNIQUE INDEX "v_metaregionsopen_pk" ON "v_metaregionsopen"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_metaregionsopen_RegionIds";

CREATE MATERIALIZED VIEW "v_metaregionsopen_RegionIds" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'RegionIds') AS "data"
        FROM metaregionsopen
        WHERE data -> 'RegionIds' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_metaregionsopen_DistrictIds";

CREATE MATERIALIZED VIEW "v_metaregionsopen_DistrictIds" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'DistrictIds') AS "data"
        FROM metaregionsopen
        WHERE data -> 'DistrictIds' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_metaregionsopen_HasLanguage";

CREATE MATERIALIZED VIEW "v_metaregionsopen_HasLanguage" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'HasLanguage') AS "data"
        FROM metaregionsopen
        WHERE data -> 'HasLanguage' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_metaregionsopen_TourismvereinIds";

CREATE MATERIALIZED VIEW "v_metaregionsopen_TourismvereinIds" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'TourismvereinIds') AS "data"
        FROM metaregionsopen
        WHERE data -> 'TourismvereinIds' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS  "v_municipalitiesopen";

CREATE MATERIALIZED VIEW "v_municipalitiesopen" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Plz' As varchar) AS "Plz",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'SiagId' As varchar) AS "SiagId",
CAST("data"->>'Gpstype' As varchar) AS "Gpstype",
CAST("data"->>'Altitude' As float) AS "Altitude",
CAST("data"->>'CustomId' As varchar) AS "CustomId",
CAST("data"->>'Latitude' As float) AS "Latitude",
CAST("data"->>'RegionId' As varchar) AS "RegionId",
CAST("data"->>'Longitude' As float) AS "Longitude",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'LastChange' As varchar) AS "LastChange",
CAST("data"->>'Inhabitants' As integer) AS "Inhabitants",
CAST("data"->>'IstatNumber' As varchar) AS "IstatNumber",
CAST("data"->>'TourismvereinId' As varchar) AS "TourismvereinId",
CAST("data"->>'VisibleInSearch' As bool) AS "VisibleInSearch",
CAST("data"->>'AltitudeUnitofMeasure' As varchar) AS "AltitudeUnitofMeasure",
CAST("data"->'Detail'->'cs'->>'Title' As varchar) AS "Detail-cs-Title",
CAST("data"->'Detail'->'cs'->>'Language' As varchar) AS "Detail-cs-Language",
CAST("data"->'Detail'->'de'->>'Title' As varchar) AS "Detail-de-Title",
CAST("data"->'Detail'->'de'->>'Language' As varchar) AS "Detail-de-Language",
CAST("data"->'Detail'->'en'->>'Title' As varchar) AS "Detail-en-Title",
CAST("data"->'Detail'->'en'->>'Language' As varchar) AS "Detail-en-Language",
CAST("data"->'Detail'->'fr'->>'Title' As varchar) AS "Detail-fr-Title",
CAST("data"->'Detail'->'fr'->>'Language' As varchar) AS "Detail-fr-Language",
CAST("data"->'Detail'->'it'->>'Title' As varchar) AS "Detail-it-Title",
CAST("data"->'Detail'->'it'->>'Language' As varchar) AS "Detail-it-Language",
CAST("data"->'Detail'->'nl'->>'Title' As varchar) AS "Detail-nl-Title",
CAST("data"->'Detail'->'nl'->>'Language' As varchar) AS "Detail-nl-Language",
CAST("data"->'Detail'->'pl'->>'Title' As varchar) AS "Detail-pl-Title",
CAST("data"->'Detail'->'pl'->>'Language' As varchar) AS "Detail-pl-Language",
CAST("data"->'Detail'->'ru'->>'Title' As varchar) AS "Detail-ru-Title",
CAST("data"->'Detail'->'ru'->>'Language' As varchar) AS "Detail-ru-Language"
FROM municipalitiesopen;

CREATE UNIQUE INDEX "v_municipalitiesopen_pk" ON "v_municipalitiesopen"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_municipalitiesopen_HasLanguage";

CREATE MATERIALIZED VIEW "v_municipalitiesopen_HasLanguage" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'HasLanguage') AS "data"
        FROM municipalitiesopen
        WHERE data -> 'HasLanguage' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS  "v_poisopen";

CREATE MATERIALIZED VIEW "v_poisopen" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Type' As varchar) AS "Type",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'IsOpen' As bool) AS "IsOpen",
CAST("data"->>'PoiType' As varchar) AS "PoiType",
CAST("data"->>'SubType' As varchar) AS "SubType",
CAST("data"->>'OwnerRid' As varchar) AS "OwnerRid",
CAST("data"->>'FeetClimb' As bool) AS "FeetClimb",
CAST("data"->>'Highlight' As bool) AS "Highlight",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'HasRentals' As bool) AS "HasRentals",
CAST("data"->>'IsPrepared' As bool) AS "IsPrepared",
CAST("data"->>'LastChange' As varchar) AS "LastChange",
CAST("data"->>'FirstImport' As varchar) AS "FirstImport",
CAST("data"->>'IsWithLigth' As bool) AS "IsWithLigth",
CAST("data"->>'RunToValley' As bool) AS "RunToValley",
CAST("data"->>'AltitudeSumUp' As float) AS "AltitudeSumUp",
CAST("data"->>'LiftAvailable' As bool) AS "LiftAvailable",
CAST("data"->>'DistanceLength' As float) AS "DistanceLength",
CAST("data"->>'AltitudeSumDown' As float) AS "AltitudeSumDown",
CAST("data"->>'HasFreeEntrance' As bool) AS "HasFreeEntrance",
CAST("data"->>'CopyrightChecked' As bool) AS "CopyrightChecked",
CAST("data"->>'DistanceDuration' As float) AS "DistanceDuration",
CAST("data"->>'AltitudeDifference' As float) AS "AltitudeDifference",
CAST("data"->>'AltitudeLowestPoint' As float) AS "AltitudeLowestPoint",
CAST("data"->>'AltitudeHighestPoint' As float) AS "AltitudeHighestPoint",
CAST("data"->>'TourismorganizationId' As varchar) AS "TourismorganizationId",
CAST("data"->'Detail'->'de'->>'Title' As varchar) AS "Detail-de-Title",
CAST("data"->'Detail'->'de'->>'Header' As varchar) AS "Detail-de-Header",
CAST("data"->'Detail'->'de'->>'BaseText' As varchar) AS "Detail-de-BaseText",
CAST("data"->'Detail'->'de'->>'Language' As varchar) AS "Detail-de-Language",
CAST("data"->'Detail'->'de'->>'IntroText' As varchar) AS "Detail-de-IntroText",
CAST("data"->'Detail'->'de'->>'AdditionalText' As varchar) AS "Detail-de-AdditionalText",
CAST("data"->'Detail'->'en'->>'Title' As varchar) AS "Detail-en-Title",
CAST("data"->'Detail'->'en'->>'Header' As varchar) AS "Detail-en-Header",
CAST("data"->'Detail'->'en'->>'BaseText' As varchar) AS "Detail-en-BaseText",
CAST("data"->'Detail'->'en'->>'Language' As varchar) AS "Detail-en-Language",
CAST("data"->'Detail'->'en'->>'IntroText' As varchar) AS "Detail-en-IntroText",
CAST("data"->'Detail'->'en'->>'AdditionalText' As varchar) AS "Detail-en-AdditionalText",
CAST("data"->'Detail'->'it'->>'Title' As varchar) AS "Detail-it-Title",
CAST("data"->'Detail'->'it'->>'Header' As varchar) AS "Detail-it-Header",
CAST("data"->'Detail'->'it'->>'BaseText' As varchar) AS "Detail-it-BaseText",
CAST("data"->'Detail'->'it'->>'Language' As varchar) AS "Detail-it-Language",
CAST("data"->'Detail'->'it'->>'IntroText' As varchar) AS "Detail-it-IntroText",
CAST("data"->'Detail'->'it'->>'AdditionalText' As varchar) AS "Detail-it-AdditionalText",
CAST("data"->'GpsPoints'->'position'->>'Gpstype' As varchar) AS "GpsPoints-position-Gpstype",
CAST("data"->'GpsPoints'->'position'->>'Altitude' As float) AS "GpsPoints-position-Altitude",
CAST("data"->'GpsPoints'->'position'->>'Latitude' As float) AS "GpsPoints-position-Latitude",
CAST("data"->'GpsPoints'->'position'->>'Longitude' As float) AS "GpsPoints-position-Longitude",
CAST("data"->'GpsPoints'->'position'->>'AltitudeUnitofMeasure' As varchar) AS "GpsPoints-position-AltitudeUnitofMeasure",
CAST("data"->'ContactInfos'->'de'->>'Url' As varchar) AS "ContactInfos-de-Url",
CAST("data"->'ContactInfos'->'de'->>'City' As varchar) AS "ContactInfos-de-City",
CAST("data"->'ContactInfos'->'de'->>'Email' As varchar) AS "ContactInfos-de-Email",
CAST("data"->'ContactInfos'->'de'->>'Address' As varchar) AS "ContactInfos-de-Address",
CAST("data"->'ContactInfos'->'de'->>'Surname' As varchar) AS "ContactInfos-de-Surname",
CAST("data"->'ContactInfos'->'de'->>'ZipCode' As varchar) AS "ContactInfos-de-ZipCode",
CAST("data"->'ContactInfos'->'de'->>'Language' As varchar) AS "ContactInfos-de-Language",
CAST("data"->'ContactInfos'->'de'->>'Faxnumber' As varchar) AS "ContactInfos-de-Faxnumber",
CAST("data"->'ContactInfos'->'de'->>'Givenname' As varchar) AS "ContactInfos-de-Givenname",
CAST("data"->'ContactInfos'->'de'->>'NamePrefix' As varchar) AS "ContactInfos-de-NamePrefix",
CAST("data"->'ContactInfos'->'de'->>'CompanyName' As varchar) AS "ContactInfos-de-CompanyName",
CAST("data"->'ContactInfos'->'de'->>'CountryCode' As varchar) AS "ContactInfos-de-CountryCode",
CAST("data"->'ContactInfos'->'de'->>'CountryName' As varchar) AS "ContactInfos-de-CountryName",
CAST("data"->'ContactInfos'->'de'->>'Phonenumber' As varchar) AS "ContactInfos-de-Phonenumber",
CAST("data"->'ContactInfos'->'en'->>'Url' As varchar) AS "ContactInfos-en-Url",
CAST("data"->'ContactInfos'->'en'->>'City' As varchar) AS "ContactInfos-en-City",
CAST("data"->'ContactInfos'->'en'->>'Email' As varchar) AS "ContactInfos-en-Email",
CAST("data"->'ContactInfos'->'en'->>'Address' As varchar) AS "ContactInfos-en-Address",
CAST("data"->'ContactInfos'->'en'->>'Surname' As varchar) AS "ContactInfos-en-Surname",
CAST("data"->'ContactInfos'->'en'->>'ZipCode' As varchar) AS "ContactInfos-en-ZipCode",
CAST("data"->'ContactInfos'->'en'->>'Language' As varchar) AS "ContactInfos-en-Language",
CAST("data"->'ContactInfos'->'en'->>'Faxnumber' As varchar) AS "ContactInfos-en-Faxnumber",
CAST("data"->'ContactInfos'->'en'->>'Givenname' As varchar) AS "ContactInfos-en-Givenname",
CAST("data"->'ContactInfos'->'en'->>'NamePrefix' As varchar) AS "ContactInfos-en-NamePrefix",
CAST("data"->'ContactInfos'->'en'->>'CompanyName' As varchar) AS "ContactInfos-en-CompanyName",
CAST("data"->'ContactInfos'->'en'->>'CountryCode' As varchar) AS "ContactInfos-en-CountryCode",
CAST("data"->'ContactInfos'->'en'->>'CountryName' As varchar) AS "ContactInfos-en-CountryName",
CAST("data"->'ContactInfos'->'en'->>'Phonenumber' As varchar) AS "ContactInfos-en-Phonenumber",
CAST("data"->'ContactInfos'->'it'->>'Url' As varchar) AS "ContactInfos-it-Url",
CAST("data"->'ContactInfos'->'it'->>'City' As varchar) AS "ContactInfos-it-City",
CAST("data"->'ContactInfos'->'it'->>'Email' As varchar) AS "ContactInfos-it-Email",
CAST("data"->'ContactInfos'->'it'->>'Address' As varchar) AS "ContactInfos-it-Address",
CAST("data"->'ContactInfos'->'it'->>'Surname' As varchar) AS "ContactInfos-it-Surname",
CAST("data"->'ContactInfos'->'it'->>'ZipCode' As varchar) AS "ContactInfos-it-ZipCode",
CAST("data"->'ContactInfos'->'it'->>'Language' As varchar) AS "ContactInfos-it-Language",
CAST("data"->'ContactInfos'->'it'->>'Faxnumber' As varchar) AS "ContactInfos-it-Faxnumber",
CAST("data"->'ContactInfos'->'it'->>'Givenname' As varchar) AS "ContactInfos-it-Givenname",
CAST("data"->'ContactInfos'->'it'->>'NamePrefix' As varchar) AS "ContactInfos-it-NamePrefix",
CAST("data"->'ContactInfos'->'it'->>'CompanyName' As varchar) AS "ContactInfos-it-CompanyName",
CAST("data"->'ContactInfos'->'it'->>'CountryCode' As varchar) AS "ContactInfos-it-CountryCode",
CAST("data"->'ContactInfos'->'it'->>'CountryName' As varchar) AS "ContactInfos-it-CountryName",
CAST("data"->'ContactInfos'->'it'->>'Phonenumber' As varchar) AS "ContactInfos-it-Phonenumber",
CAST("data"->'LocationInfo'->'TvInfo'->>'Id' As varchar) AS "LocationInfo-TvInfo-Id",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-TvInfo-Name-cs",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'de' As varchar) AS "LocationInfo-TvInfo-Name-de",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'en' As varchar) AS "LocationInfo-TvInfo-Name-en",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-TvInfo-Name-fr",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'it' As varchar) AS "LocationInfo-TvInfo-Name-it",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-TvInfo-Name-nl",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-TvInfo-Name-pl",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-TvInfo-Name-ru",
CAST("data"->'LocationInfo'->'AreaInfo'->>'Id' As varchar) AS "LocationInfo-AreaInfo-Id",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-AreaInfo-Name-cs",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'de' As varchar) AS "LocationInfo-AreaInfo-Name-de",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'en' As varchar) AS "LocationInfo-AreaInfo-Name-en",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-AreaInfo-Name-fr",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'it' As varchar) AS "LocationInfo-AreaInfo-Name-it",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-AreaInfo-Name-nl",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-AreaInfo-Name-pl",
CAST("data"->'LocationInfo'->'AreaInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-AreaInfo-Name-ru",
CAST("data"->'LocationInfo'->'RegionInfo'->>'Id' As varchar) AS "LocationInfo-RegionInfo-Id",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-RegionInfo-Name-cs",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'de' As varchar) AS "LocationInfo-RegionInfo-Name-de",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'en' As varchar) AS "LocationInfo-RegionInfo-Name-en",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-RegionInfo-Name-fr",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'it' As varchar) AS "LocationInfo-RegionInfo-Name-it",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-RegionInfo-Name-nl",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-RegionInfo-Name-pl",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-RegionInfo-Name-ru",
CAST("data"->'AdditionalPoiInfos'->'de'->>'PoiType' As varchar) AS "AdditionalPoiInfos-de-PoiType",
CAST("data"->'AdditionalPoiInfos'->'de'->>'SubType' As varchar) AS "AdditionalPoiInfos-de-SubType",
CAST("data"->'AdditionalPoiInfos'->'de'->>'Language' As varchar) AS "AdditionalPoiInfos-de-Language",
CAST("data"->'AdditionalPoiInfos'->'de'->>'MainType' As varchar) AS "AdditionalPoiInfos-de-MainType",
CAST("data"->'AdditionalPoiInfos'->'en'->>'PoiType' As varchar) AS "AdditionalPoiInfos-en-PoiType",
CAST("data"->'AdditionalPoiInfos'->'en'->>'SubType' As varchar) AS "AdditionalPoiInfos-en-SubType",
CAST("data"->'AdditionalPoiInfos'->'en'->>'Language' As varchar) AS "AdditionalPoiInfos-en-Language",
CAST("data"->'AdditionalPoiInfos'->'en'->>'MainType' As varchar) AS "AdditionalPoiInfos-en-MainType",
CAST("data"->'AdditionalPoiInfos'->'it'->>'PoiType' As varchar) AS "AdditionalPoiInfos-it-PoiType",
CAST("data"->'AdditionalPoiInfos'->'it'->>'SubType' As varchar) AS "AdditionalPoiInfos-it-SubType",
CAST("data"->'AdditionalPoiInfos'->'it'->>'Language' As varchar) AS "AdditionalPoiInfos-it-Language",
CAST("data"->'AdditionalPoiInfos'->'it'->>'MainType' As varchar) AS "AdditionalPoiInfos-it-MainType"
FROM poisopen;

CREATE UNIQUE INDEX "v_poisopen_pk" ON "v_poisopen"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_poisopen_AreaId";

CREATE MATERIALIZED VIEW "v_poisopen_AreaId" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'AreaId') AS "data"
        FROM poisopen
        WHERE data -> 'AreaId' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_poisopen_SmgTags";

CREATE MATERIALIZED VIEW "v_poisopen_SmgTags" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'SmgTags') AS "data"
        FROM poisopen
        WHERE data -> 'SmgTags' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_poisopen_HasLanguage";

CREATE MATERIALIZED VIEW "v_poisopen_HasLanguage" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'HasLanguage') AS "data"
        FROM poisopen
        WHERE data -> 'HasLanguage' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_poisopen_GpsInfo";

CREATE MATERIALIZED VIEW "v_poisopen_GpsInfo" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'GpsInfo') AS "Feature"
        FROM poisopen
        WHERE data -> 'GpsInfo' != 'null')
    SELECT "Id" AS "poisopen_Id", CAST("data"->>'Gpstype' As varchar) AS "Gpstype",
CAST("data"->>'Altitude' As float) AS "Altitude",
CAST("data"->>'Latitude' As float) AS "Latitude",
CAST("data"->>'Longitude' As float) AS "Longitude",
CAST("data"->>'AltitudeUnitofMeasure' As varchar) AS "AltitudeUnitofMeasure"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS "v_poisopen_LTSTags";

CREATE MATERIALIZED VIEW "v_poisopen_LTSTags" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'LTSTags') AS "Feature"
        FROM poisopen
        WHERE data -> 'LTSTags' != 'null')
    SELECT "Id" AS "poisopen_Id", CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Level' As integer) AS "Level",
CAST("data"->'TagName'->>'de' As varchar) AS "TagName-de",
CAST("data"->'TagName'->>'en' As varchar) AS "TagName-en",
CAST("data"->'TagName'->>'it' As varchar) AS "TagName-it"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS "v_poisopen_OperationSchedule";

CREATE MATERIALIZED VIEW "v_poisopen_OperationSchedule" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'OperationSchedule') AS "Feature"
        FROM poisopen
        WHERE data -> 'OperationSchedule' != 'null')
    SELECT "Id" AS "poisopen_Id", CAST("data"->>'Stop' As varchar) AS "Stop",
CAST("data"->>'Type' As varchar) AS "Type",
CAST("data"->>'Start' As varchar) AS "Start",
CAST("data"->'OperationscheduleName'->>'de' As varchar) AS "OperationscheduleName-de"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS "v_poisopen_OperationSchedule_OperationScheduleTime";

CREATE MATERIALIZED VIEW "v_poisopen_OperationSchedule_OperationScheduleTime" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'OperationSchedule_OperationScheduleTime') AS "Feature"
        FROM poisopen
        WHERE data -> 'OperationSchedule_OperationScheduleTime' != 'null')
    SELECT "Id" AS "poisopen_Id", CAST("data"->>'End' As varchar) AS "End",
CAST("data"->>'Start' As varchar) AS "Start",
CAST("data"->>'State' As integer) AS "State",
CAST("data"->>'Friday' As bool) AS "Friday",
CAST("data"->>'Monday' As bool) AS "Monday",
CAST("data"->>'Sunday' As bool) AS "Sunday",
CAST("data"->>'Tuesday' As bool) AS "Tuesday",
CAST("data"->>'Saturday' As bool) AS "Saturday",
CAST("data"->>'Timecode' As integer) AS "Timecode",
CAST("data"->>'Thuresday' As bool) AS "Thuresday",
CAST("data"->>'Wednesday' As bool) AS "Wednesday"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS  "v_regionsopen";

CREATE MATERIALIZED VIEW "v_regionsopen" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'Gpstype' As varchar) AS "Gpstype",
CAST("data"->>'Altitude' As float) AS "Altitude",
CAST("data"->>'CustomId' As varchar) AS "CustomId",
CAST("data"->>'Latitude' As float) AS "Latitude",
CAST("data"->>'Longitude' As float) AS "Longitude",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'LastChange' As varchar) AS "LastChange",
CAST("data"->>'VisibleInSearch' As bool) AS "VisibleInSearch",
CAST("data"->>'AltitudeUnitofMeasure' As varchar) AS "AltitudeUnitofMeasure",
CAST("data"->'Detail'->'cs'->>'Title' As varchar) AS "Detail-cs-Title",
CAST("data"->'Detail'->'cs'->>'Header' As varchar) AS "Detail-cs-Header",
CAST("data"->'Detail'->'cs'->>'BaseText' As varchar) AS "Detail-cs-BaseText",
CAST("data"->'Detail'->'cs'->>'Language' As varchar) AS "Detail-cs-Language",
CAST("data"->'Detail'->'cs'->>'MetaDesc' As varchar) AS "Detail-cs-MetaDesc",
CAST("data"->'Detail'->'cs'->>'IntroText' As varchar) AS "Detail-cs-IntroText",
CAST("data"->'Detail'->'cs'->>'MetaTitle' As varchar) AS "Detail-cs-MetaTitle",
CAST("data"->'Detail'->'cs'->>'SubHeader' As varchar) AS "Detail-cs-SubHeader",
CAST("data"->'Detail'->'cs'->>'GetThereText' As varchar) AS "Detail-cs-GetThereText",
CAST("data"->'Detail'->'cs'->>'AdditionalText' As varchar) AS "Detail-cs-AdditionalText",
CAST("data"->'Detail'->'de'->>'Title' As varchar) AS "Detail-de-Title",
CAST("data"->'Detail'->'de'->>'Header' As varchar) AS "Detail-de-Header",
CAST("data"->'Detail'->'de'->>'BaseText' As varchar) AS "Detail-de-BaseText",
CAST("data"->'Detail'->'de'->>'Language' As varchar) AS "Detail-de-Language",
CAST("data"->'Detail'->'de'->>'MetaDesc' As varchar) AS "Detail-de-MetaDesc",
CAST("data"->'Detail'->'de'->>'IntroText' As varchar) AS "Detail-de-IntroText",
CAST("data"->'Detail'->'de'->>'MetaTitle' As varchar) AS "Detail-de-MetaTitle",
CAST("data"->'Detail'->'de'->>'SubHeader' As varchar) AS "Detail-de-SubHeader",
CAST("data"->'Detail'->'en'->>'Title' As varchar) AS "Detail-en-Title",
CAST("data"->'Detail'->'en'->>'Header' As varchar) AS "Detail-en-Header",
CAST("data"->'Detail'->'en'->>'BaseText' As varchar) AS "Detail-en-BaseText",
CAST("data"->'Detail'->'en'->>'Language' As varchar) AS "Detail-en-Language",
CAST("data"->'Detail'->'en'->>'MetaDesc' As varchar) AS "Detail-en-MetaDesc",
CAST("data"->'Detail'->'en'->>'IntroText' As varchar) AS "Detail-en-IntroText",
CAST("data"->'Detail'->'en'->>'MetaTitle' As varchar) AS "Detail-en-MetaTitle",
CAST("data"->'Detail'->'en'->>'SubHeader' As varchar) AS "Detail-en-SubHeader",
CAST("data"->'Detail'->'en'->>'GetThereText' As varchar) AS "Detail-en-GetThereText",
CAST("data"->'Detail'->'en'->>'AdditionalText' As varchar) AS "Detail-en-AdditionalText",
CAST("data"->'Detail'->'fr'->>'Title' As varchar) AS "Detail-fr-Title",
CAST("data"->'Detail'->'fr'->>'Header' As varchar) AS "Detail-fr-Header",
CAST("data"->'Detail'->'fr'->>'BaseText' As varchar) AS "Detail-fr-BaseText",
CAST("data"->'Detail'->'fr'->>'Language' As varchar) AS "Detail-fr-Language",
CAST("data"->'Detail'->'fr'->>'MetaDesc' As varchar) AS "Detail-fr-MetaDesc",
CAST("data"->'Detail'->'fr'->>'IntroText' As varchar) AS "Detail-fr-IntroText",
CAST("data"->'Detail'->'fr'->>'MetaTitle' As varchar) AS "Detail-fr-MetaTitle",
CAST("data"->'Detail'->'fr'->>'SubHeader' As varchar) AS "Detail-fr-SubHeader",
CAST("data"->'Detail'->'fr'->>'GetThereText' As varchar) AS "Detail-fr-GetThereText",
CAST("data"->'Detail'->'fr'->>'AdditionalText' As varchar) AS "Detail-fr-AdditionalText",
CAST("data"->'Detail'->'it'->>'Title' As varchar) AS "Detail-it-Title",
CAST("data"->'Detail'->'it'->>'Header' As varchar) AS "Detail-it-Header",
CAST("data"->'Detail'->'it'->>'BaseText' As varchar) AS "Detail-it-BaseText",
CAST("data"->'Detail'->'it'->>'Language' As varchar) AS "Detail-it-Language",
CAST("data"->'Detail'->'it'->>'MetaDesc' As varchar) AS "Detail-it-MetaDesc",
CAST("data"->'Detail'->'it'->>'IntroText' As varchar) AS "Detail-it-IntroText",
CAST("data"->'Detail'->'it'->>'MetaTitle' As varchar) AS "Detail-it-MetaTitle",
CAST("data"->'Detail'->'it'->>'SubHeader' As varchar) AS "Detail-it-SubHeader",
CAST("data"->'Detail'->'it'->>'GetThereText' As varchar) AS "Detail-it-GetThereText",
CAST("data"->'Detail'->'it'->>'AdditionalText' As varchar) AS "Detail-it-AdditionalText",
CAST("data"->'Detail'->'nl'->>'Title' As varchar) AS "Detail-nl-Title",
CAST("data"->'Detail'->'nl'->>'Header' As varchar) AS "Detail-nl-Header",
CAST("data"->'Detail'->'nl'->>'BaseText' As varchar) AS "Detail-nl-BaseText",
CAST("data"->'Detail'->'nl'->>'Language' As varchar) AS "Detail-nl-Language",
CAST("data"->'Detail'->'nl'->>'MetaDesc' As varchar) AS "Detail-nl-MetaDesc",
CAST("data"->'Detail'->'nl'->>'IntroText' As varchar) AS "Detail-nl-IntroText",
CAST("data"->'Detail'->'nl'->>'MetaTitle' As varchar) AS "Detail-nl-MetaTitle",
CAST("data"->'Detail'->'nl'->>'SubHeader' As varchar) AS "Detail-nl-SubHeader",
CAST("data"->'Detail'->'nl'->>'GetThereText' As varchar) AS "Detail-nl-GetThereText",
CAST("data"->'Detail'->'nl'->>'AdditionalText' As varchar) AS "Detail-nl-AdditionalText",
CAST("data"->'Detail'->'pl'->>'Title' As varchar) AS "Detail-pl-Title",
CAST("data"->'Detail'->'pl'->>'Header' As varchar) AS "Detail-pl-Header",
CAST("data"->'Detail'->'pl'->>'BaseText' As varchar) AS "Detail-pl-BaseText",
CAST("data"->'Detail'->'pl'->>'Language' As varchar) AS "Detail-pl-Language",
CAST("data"->'Detail'->'pl'->>'MetaDesc' As varchar) AS "Detail-pl-MetaDesc",
CAST("data"->'Detail'->'pl'->>'IntroText' As varchar) AS "Detail-pl-IntroText",
CAST("data"->'Detail'->'pl'->>'MetaTitle' As varchar) AS "Detail-pl-MetaTitle",
CAST("data"->'Detail'->'pl'->>'SubHeader' As varchar) AS "Detail-pl-SubHeader",
CAST("data"->'Detail'->'pl'->>'GetThereText' As varchar) AS "Detail-pl-GetThereText",
CAST("data"->'Detail'->'pl'->>'AdditionalText' As varchar) AS "Detail-pl-AdditionalText",
CAST("data"->'Detail'->'ru'->>'Title' As varchar) AS "Detail-ru-Title",
CAST("data"->'Detail'->'ru'->>'Header' As varchar) AS "Detail-ru-Header",
CAST("data"->'Detail'->'ru'->>'BaseText' As varchar) AS "Detail-ru-BaseText",
CAST("data"->'Detail'->'ru'->>'Language' As varchar) AS "Detail-ru-Language",
CAST("data"->'Detail'->'ru'->>'MetaDesc' As varchar) AS "Detail-ru-MetaDesc",
CAST("data"->'Detail'->'ru'->>'IntroText' As varchar) AS "Detail-ru-IntroText",
CAST("data"->'Detail'->'ru'->>'MetaTitle' As varchar) AS "Detail-ru-MetaTitle",
CAST("data"->'Detail'->'ru'->>'SubHeader' As varchar) AS "Detail-ru-SubHeader",
CAST("data"->'Detail'->'ru'->>'GetThereText' As varchar) AS "Detail-ru-GetThereText",
CAST("data"->'Detail'->'ru'->>'AdditionalText' As varchar) AS "Detail-ru-AdditionalText",
CAST("data"->'ContactInfos'->'cs'->>'Url' As varchar) AS "ContactInfos-cs-Url",
CAST("data"->'ContactInfos'->'cs'->>'Vat' As varchar) AS "ContactInfos-cs-Vat",
CAST("data"->'ContactInfos'->'cs'->>'City' As varchar) AS "ContactInfos-cs-City",
CAST("data"->'ContactInfos'->'cs'->>'Email' As varchar) AS "ContactInfos-cs-Email",
CAST("data"->'ContactInfos'->'cs'->>'Address' As varchar) AS "ContactInfos-cs-Address",
CAST("data"->'ContactInfos'->'cs'->>'LogoUrl' As varchar) AS "ContactInfos-cs-LogoUrl",
CAST("data"->'ContactInfos'->'cs'->>'Surname' As varchar) AS "ContactInfos-cs-Surname",
CAST("data"->'ContactInfos'->'cs'->>'ZipCode' As varchar) AS "ContactInfos-cs-ZipCode",
CAST("data"->'ContactInfos'->'cs'->>'Language' As varchar) AS "ContactInfos-cs-Language",
CAST("data"->'ContactInfos'->'cs'->>'Faxnumber' As varchar) AS "ContactInfos-cs-Faxnumber",
CAST("data"->'ContactInfos'->'cs'->>'Givenname' As varchar) AS "ContactInfos-cs-Givenname",
CAST("data"->'ContactInfos'->'cs'->>'NamePrefix' As varchar) AS "ContactInfos-cs-NamePrefix",
CAST("data"->'ContactInfos'->'cs'->>'CompanyName' As varchar) AS "ContactInfos-cs-CompanyName",
CAST("data"->'ContactInfos'->'cs'->>'CountryCode' As varchar) AS "ContactInfos-cs-CountryCode",
CAST("data"->'ContactInfos'->'cs'->>'CountryName' As varchar) AS "ContactInfos-cs-CountryName",
CAST("data"->'ContactInfos'->'cs'->>'Phonenumber' As varchar) AS "ContactInfos-cs-Phonenumber",
CAST("data"->'ContactInfos'->'de'->>'Url' As varchar) AS "ContactInfos-de-Url",
CAST("data"->'ContactInfos'->'de'->>'City' As varchar) AS "ContactInfos-de-City",
CAST("data"->'ContactInfos'->'de'->>'Email' As varchar) AS "ContactInfos-de-Email",
CAST("data"->'ContactInfos'->'de'->>'Address' As varchar) AS "ContactInfos-de-Address",
CAST("data"->'ContactInfos'->'de'->>'LogoUrl' As varchar) AS "ContactInfos-de-LogoUrl",
CAST("data"->'ContactInfos'->'de'->>'ZipCode' As varchar) AS "ContactInfos-de-ZipCode",
CAST("data"->'ContactInfos'->'de'->>'Language' As varchar) AS "ContactInfos-de-Language",
CAST("data"->'ContactInfos'->'de'->>'CompanyName' As varchar) AS "ContactInfos-de-CompanyName",
CAST("data"->'ContactInfos'->'de'->>'CountryCode' As varchar) AS "ContactInfos-de-CountryCode",
CAST("data"->'ContactInfos'->'de'->>'CountryName' As varchar) AS "ContactInfos-de-CountryName",
CAST("data"->'ContactInfos'->'de'->>'Phonenumber' As varchar) AS "ContactInfos-de-Phonenumber",
CAST("data"->'ContactInfos'->'en'->>'Url' As varchar) AS "ContactInfos-en-Url",
CAST("data"->'ContactInfos'->'en'->>'Vat' As varchar) AS "ContactInfos-en-Vat",
CAST("data"->'ContactInfos'->'en'->>'City' As varchar) AS "ContactInfos-en-City",
CAST("data"->'ContactInfos'->'en'->>'Email' As varchar) AS "ContactInfos-en-Email",
CAST("data"->'ContactInfos'->'en'->>'Address' As varchar) AS "ContactInfos-en-Address",
CAST("data"->'ContactInfos'->'en'->>'LogoUrl' As varchar) AS "ContactInfos-en-LogoUrl",
CAST("data"->'ContactInfos'->'en'->>'Surname' As varchar) AS "ContactInfos-en-Surname",
CAST("data"->'ContactInfos'->'en'->>'ZipCode' As varchar) AS "ContactInfos-en-ZipCode",
CAST("data"->'ContactInfos'->'en'->>'Language' As varchar) AS "ContactInfos-en-Language",
CAST("data"->'ContactInfos'->'en'->>'Faxnumber' As varchar) AS "ContactInfos-en-Faxnumber",
CAST("data"->'ContactInfos'->'en'->>'Givenname' As varchar) AS "ContactInfos-en-Givenname",
CAST("data"->'ContactInfos'->'en'->>'NamePrefix' As varchar) AS "ContactInfos-en-NamePrefix",
CAST("data"->'ContactInfos'->'en'->>'CompanyName' As varchar) AS "ContactInfos-en-CompanyName",
CAST("data"->'ContactInfos'->'en'->>'CountryCode' As varchar) AS "ContactInfos-en-CountryCode",
CAST("data"->'ContactInfos'->'en'->>'CountryName' As varchar) AS "ContactInfos-en-CountryName",
CAST("data"->'ContactInfos'->'en'->>'Phonenumber' As varchar) AS "ContactInfos-en-Phonenumber",
CAST("data"->'ContactInfos'->'fr'->>'Url' As varchar) AS "ContactInfos-fr-Url",
CAST("data"->'ContactInfos'->'fr'->>'Vat' As varchar) AS "ContactInfos-fr-Vat",
CAST("data"->'ContactInfos'->'fr'->>'City' As varchar) AS "ContactInfos-fr-City",
CAST("data"->'ContactInfos'->'fr'->>'Email' As varchar) AS "ContactInfos-fr-Email",
CAST("data"->'ContactInfos'->'fr'->>'Address' As varchar) AS "ContactInfos-fr-Address",
CAST("data"->'ContactInfos'->'fr'->>'LogoUrl' As varchar) AS "ContactInfos-fr-LogoUrl",
CAST("data"->'ContactInfos'->'fr'->>'Surname' As varchar) AS "ContactInfos-fr-Surname",
CAST("data"->'ContactInfos'->'fr'->>'ZipCode' As varchar) AS "ContactInfos-fr-ZipCode",
CAST("data"->'ContactInfos'->'fr'->>'Language' As varchar) AS "ContactInfos-fr-Language",
CAST("data"->'ContactInfos'->'fr'->>'Faxnumber' As varchar) AS "ContactInfos-fr-Faxnumber",
CAST("data"->'ContactInfos'->'fr'->>'Givenname' As varchar) AS "ContactInfos-fr-Givenname",
CAST("data"->'ContactInfos'->'fr'->>'NamePrefix' As varchar) AS "ContactInfos-fr-NamePrefix",
CAST("data"->'ContactInfos'->'fr'->>'CompanyName' As varchar) AS "ContactInfos-fr-CompanyName",
CAST("data"->'ContactInfos'->'fr'->>'CountryCode' As varchar) AS "ContactInfos-fr-CountryCode",
CAST("data"->'ContactInfos'->'fr'->>'CountryName' As varchar) AS "ContactInfos-fr-CountryName",
CAST("data"->'ContactInfos'->'fr'->>'Phonenumber' As varchar) AS "ContactInfos-fr-Phonenumber",
CAST("data"->'ContactInfos'->'it'->>'Url' As varchar) AS "ContactInfos-it-Url",
CAST("data"->'ContactInfos'->'it'->>'Vat' As varchar) AS "ContactInfos-it-Vat",
CAST("data"->'ContactInfos'->'it'->>'City' As varchar) AS "ContactInfos-it-City",
CAST("data"->'ContactInfos'->'it'->>'Email' As varchar) AS "ContactInfos-it-Email",
CAST("data"->'ContactInfos'->'it'->>'Address' As varchar) AS "ContactInfos-it-Address",
CAST("data"->'ContactInfos'->'it'->>'LogoUrl' As varchar) AS "ContactInfos-it-LogoUrl",
CAST("data"->'ContactInfos'->'it'->>'Surname' As varchar) AS "ContactInfos-it-Surname",
CAST("data"->'ContactInfos'->'it'->>'ZipCode' As varchar) AS "ContactInfos-it-ZipCode",
CAST("data"->'ContactInfos'->'it'->>'Language' As varchar) AS "ContactInfos-it-Language",
CAST("data"->'ContactInfos'->'it'->>'Faxnumber' As varchar) AS "ContactInfos-it-Faxnumber",
CAST("data"->'ContactInfos'->'it'->>'Givenname' As varchar) AS "ContactInfos-it-Givenname",
CAST("data"->'ContactInfos'->'it'->>'NamePrefix' As varchar) AS "ContactInfos-it-NamePrefix",
CAST("data"->'ContactInfos'->'it'->>'CompanyName' As varchar) AS "ContactInfos-it-CompanyName",
CAST("data"->'ContactInfos'->'it'->>'CountryCode' As varchar) AS "ContactInfos-it-CountryCode",
CAST("data"->'ContactInfos'->'it'->>'CountryName' As varchar) AS "ContactInfos-it-CountryName",
CAST("data"->'ContactInfos'->'it'->>'Phonenumber' As varchar) AS "ContactInfos-it-Phonenumber",
CAST("data"->'ContactInfos'->'nl'->>'Url' As varchar) AS "ContactInfos-nl-Url",
CAST("data"->'ContactInfos'->'nl'->>'Vat' As varchar) AS "ContactInfos-nl-Vat",
CAST("data"->'ContactInfos'->'nl'->>'City' As varchar) AS "ContactInfos-nl-City",
CAST("data"->'ContactInfos'->'nl'->>'Email' As varchar) AS "ContactInfos-nl-Email",
CAST("data"->'ContactInfos'->'nl'->>'Address' As varchar) AS "ContactInfos-nl-Address",
CAST("data"->'ContactInfos'->'nl'->>'LogoUrl' As varchar) AS "ContactInfos-nl-LogoUrl",
CAST("data"->'ContactInfos'->'nl'->>'Surname' As varchar) AS "ContactInfos-nl-Surname",
CAST("data"->'ContactInfos'->'nl'->>'ZipCode' As varchar) AS "ContactInfos-nl-ZipCode",
CAST("data"->'ContactInfos'->'nl'->>'Language' As varchar) AS "ContactInfos-nl-Language",
CAST("data"->'ContactInfos'->'nl'->>'Faxnumber' As varchar) AS "ContactInfos-nl-Faxnumber",
CAST("data"->'ContactInfos'->'nl'->>'Givenname' As varchar) AS "ContactInfos-nl-Givenname",
CAST("data"->'ContactInfos'->'nl'->>'NamePrefix' As varchar) AS "ContactInfos-nl-NamePrefix",
CAST("data"->'ContactInfos'->'nl'->>'CompanyName' As varchar) AS "ContactInfos-nl-CompanyName",
CAST("data"->'ContactInfos'->'nl'->>'CountryCode' As varchar) AS "ContactInfos-nl-CountryCode",
CAST("data"->'ContactInfos'->'nl'->>'CountryName' As varchar) AS "ContactInfos-nl-CountryName",
CAST("data"->'ContactInfos'->'nl'->>'Phonenumber' As varchar) AS "ContactInfos-nl-Phonenumber",
CAST("data"->'ContactInfos'->'pl'->>'Url' As varchar) AS "ContactInfos-pl-Url",
CAST("data"->'ContactInfos'->'pl'->>'Vat' As varchar) AS "ContactInfos-pl-Vat",
CAST("data"->'ContactInfos'->'pl'->>'City' As varchar) AS "ContactInfos-pl-City",
CAST("data"->'ContactInfos'->'pl'->>'Email' As varchar) AS "ContactInfos-pl-Email",
CAST("data"->'ContactInfos'->'pl'->>'Address' As varchar) AS "ContactInfos-pl-Address",
CAST("data"->'ContactInfos'->'pl'->>'LogoUrl' As varchar) AS "ContactInfos-pl-LogoUrl",
CAST("data"->'ContactInfos'->'pl'->>'Surname' As varchar) AS "ContactInfos-pl-Surname",
CAST("data"->'ContactInfos'->'pl'->>'ZipCode' As varchar) AS "ContactInfos-pl-ZipCode",
CAST("data"->'ContactInfos'->'pl'->>'Language' As varchar) AS "ContactInfos-pl-Language",
CAST("data"->'ContactInfos'->'pl'->>'Faxnumber' As varchar) AS "ContactInfos-pl-Faxnumber",
CAST("data"->'ContactInfos'->'pl'->>'Givenname' As varchar) AS "ContactInfos-pl-Givenname",
CAST("data"->'ContactInfos'->'pl'->>'NamePrefix' As varchar) AS "ContactInfos-pl-NamePrefix",
CAST("data"->'ContactInfos'->'pl'->>'CompanyName' As varchar) AS "ContactInfos-pl-CompanyName",
CAST("data"->'ContactInfos'->'pl'->>'CountryCode' As varchar) AS "ContactInfos-pl-CountryCode",
CAST("data"->'ContactInfos'->'pl'->>'CountryName' As varchar) AS "ContactInfos-pl-CountryName",
CAST("data"->'ContactInfos'->'pl'->>'Phonenumber' As varchar) AS "ContactInfos-pl-Phonenumber",
CAST("data"->'ContactInfos'->'ru'->>'Url' As varchar) AS "ContactInfos-ru-Url",
CAST("data"->'ContactInfos'->'ru'->>'Vat' As varchar) AS "ContactInfos-ru-Vat",
CAST("data"->'ContactInfos'->'ru'->>'City' As varchar) AS "ContactInfos-ru-City",
CAST("data"->'ContactInfos'->'ru'->>'Email' As varchar) AS "ContactInfos-ru-Email",
CAST("data"->'ContactInfos'->'ru'->>'Address' As varchar) AS "ContactInfos-ru-Address",
CAST("data"->'ContactInfos'->'ru'->>'LogoUrl' As varchar) AS "ContactInfos-ru-LogoUrl",
CAST("data"->'ContactInfos'->'ru'->>'Surname' As varchar) AS "ContactInfos-ru-Surname",
CAST("data"->'ContactInfos'->'ru'->>'ZipCode' As varchar) AS "ContactInfos-ru-ZipCode",
CAST("data"->'ContactInfos'->'ru'->>'Language' As varchar) AS "ContactInfos-ru-Language",
CAST("data"->'ContactInfos'->'ru'->>'Faxnumber' As varchar) AS "ContactInfos-ru-Faxnumber",
CAST("data"->'ContactInfos'->'ru'->>'Givenname' As varchar) AS "ContactInfos-ru-Givenname",
CAST("data"->'ContactInfos'->'ru'->>'NamePrefix' As varchar) AS "ContactInfos-ru-NamePrefix",
CAST("data"->'ContactInfos'->'ru'->>'CompanyName' As varchar) AS "ContactInfos-ru-CompanyName",
CAST("data"->'ContactInfos'->'ru'->>'CountryCode' As varchar) AS "ContactInfos-ru-CountryCode",
CAST("data"->'ContactInfos'->'ru'->>'CountryName' As varchar) AS "ContactInfos-ru-CountryName",
CAST("data"->'ContactInfos'->'ru'->>'Phonenumber' As varchar) AS "ContactInfos-ru-Phonenumber",
CAST("data"->'DetailThemed'->'cs'->>'Language' As varchar) AS "DetailThemed-cs-Language",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-cs-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-cs-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-cs-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-cs-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-cs-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-cs-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-cs-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-cs-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-cs-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-cs-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-cs-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-cs-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Essen und Trinken'->>'Intro' As varchar) AS "DetailThemed-cs-DetailsThemed-Essen und Trinken-Intro",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Essen und Trinken'->>'Title' As varchar) AS "DetailThemed-cs-DetailsThemed-Essen und Trinken-Title",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Essen und Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-cs-DetailsThemed-Essen und Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Essen und Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-cs-DetailsThemed-Essen und Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-cs-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-cs-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-cs-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-cs-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-c-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-c-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-c-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'cs'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-c-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle",
CAST("data"->'DetailThemed'->'de'->>'Language' As varchar) AS "DetailThemed-de-Language",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-de-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-de-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-de-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-de-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-de-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-de-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-de-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-de-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Essen Trinken'->>'Intro' As varchar) AS "DetailThemed-de-DetailsThemed-Essen Trinken-Intro",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Essen Trinken'->>'Title' As varchar) AS "DetailThemed-de-DetailsThemed-Essen Trinken-Title",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Essen Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-de-DetailsThemed-Essen Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Essen Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-de-DetailsThemed-Essen Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-de-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-de-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-de-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-de-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-de-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-de-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-de-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-de-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-d-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-d-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-d-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'de'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-d-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle",
CAST("data"->'DetailThemed'->'en'->>'Language' As varchar) AS "DetailThemed-en-Language",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-en-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-en-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-en-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-en-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-en-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-en-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-en-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-en-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-en-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-en-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-en-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-en-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Essen und Trinken'->>'Intro' As varchar) AS "DetailThemed-en-DetailsThemed-Essen und Trinken-Intro",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Essen und Trinken'->>'Title' As varchar) AS "DetailThemed-en-DetailsThemed-Essen und Trinken-Title",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Essen und Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-en-DetailsThemed-Essen und Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Essen und Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-en-DetailsThemed-Essen und Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-en-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-en-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-en-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-en-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-e-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-e-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-e-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'en'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-e-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle",
CAST("data"->'DetailThemed'->'fr'->>'Language' As varchar) AS "DetailThemed-fr-Language",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-fr-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-fr-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-fr-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-fr-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-fr-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-fr-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-fr-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-fr-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-fr-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-fr-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-fr-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-fr-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Essen und Trinken'->>'Intro' As varchar) AS "DetailThemed-fr-DetailsThemed-Essen und Trinken-Intro",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Essen und Trinken'->>'Title' As varchar) AS "DetailThemed-fr-DetailsThemed-Essen und Trinken-Title",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Essen und Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-fr-DetailsThemed-Essen und Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Essen und Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-fr-DetailsThemed-Essen und Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-fr-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-fr-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-fr-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-fr-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-f-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-f-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-f-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'fr'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-f-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle",
CAST("data"->'DetailThemed'->'it'->>'Language' As varchar) AS "DetailThemed-it-Language",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-it-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-it-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-it-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-it-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-it-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-it-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-it-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-it-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-it-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-it-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-it-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-it-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Essen und Trinken'->>'Intro' As varchar) AS "DetailThemed-it-DetailsThemed-Essen und Trinken-Intro",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Essen und Trinken'->>'Title' As varchar) AS "DetailThemed-it-DetailsThemed-Essen und Trinken-Title",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Essen und Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-it-DetailsThemed-Essen und Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Essen und Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-it-DetailsThemed-Essen und Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-it-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-it-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-it-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-it-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-i-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-i-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-i-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'it'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-i-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle",
CAST("data"->'DetailThemed'->'nl'->>'Language' As varchar) AS "DetailThemed-nl-Language",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-nl-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-nl-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-nl-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-nl-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-nl-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-nl-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-nl-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-nl-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-nl-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-nl-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-nl-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-nl-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Essen und Trinken'->>'Intro' As varchar) AS "DetailThemed-nl-DetailsThemed-Essen und Trinken-Intro",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Essen und Trinken'->>'Title' As varchar) AS "DetailThemed-nl-DetailsThemed-Essen und Trinken-Title",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Essen und Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-nl-DetailsThemed-Essen und Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Essen und Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-nl-DetailsThemed-Essen und Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-nl-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-nl-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-nl-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-nl-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-n-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-n-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-n-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'nl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-n-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle",
CAST("data"->'DetailThemed'->'pl'->>'Language' As varchar) AS "DetailThemed-pl-Language",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-pl-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-pl-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-pl-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-pl-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-pl-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-pl-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-pl-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-pl-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-pl-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-pl-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-pl-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-pl-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Essen und Trinken'->>'Intro' As varchar) AS "DetailThemed-pl-DetailsThemed-Essen und Trinken-Intro",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Essen und Trinken'->>'Title' As varchar) AS "DetailThemed-pl-DetailsThemed-Essen und Trinken-Title",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Essen und Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-pl-DetailsThemed-Essen und Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Essen und Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-pl-DetailsThemed-Essen und Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-pl-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-pl-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-pl-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-pl-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-p-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-p-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-p-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'pl'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-p-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle",
CAST("data"->'DetailThemed'->'ru'->>'Language' As varchar) AS "DetailThemed-ru-Language",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Sommer'->>'Intro' As varchar) AS "DetailThemed-ru-DetailsThemed-Sommer-Intro",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Sommer'->>'Title' As varchar) AS "DetailThemed-ru-DetailsThemed-Sommer-Title",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Sommer'->>'MetaDesc' As varchar) AS "DetailThemed-ru-DetailsThemed-Sommer-MetaDesc",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Sommer'->>'MetaTitle' As varchar) AS "DetailThemed-ru-DetailsThemed-Sommer-MetaTitle",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Winter'->>'Intro' As varchar) AS "DetailThemed-ru-DetailsThemed-Winter-Intro",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Winter'->>'Title' As varchar) AS "DetailThemed-ru-DetailsThemed-Winter-Title",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Winter'->>'MetaDesc' As varchar) AS "DetailThemed-ru-DetailsThemed-Winter-MetaDesc",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Winter'->>'MetaTitle' As varchar) AS "DetailThemed-ru-DetailsThemed-Winter-MetaTitle",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Familienurlaub'->>'Intro' As varchar) AS "DetailThemed-ru-DetailsThemed-Familienurlaub-Intro",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Familienurlaub'->>'Title' As varchar) AS "DetailThemed-ru-DetailsThemed-Familienurlaub-Title",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Familienurlaub'->>'MetaDesc' As varchar) AS "DetailThemed-ru-DetailsThemed-Familienurlaub-MetaDesc",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Familienurlaub'->>'MetaTitle' As varchar) AS "DetailThemed-ru-DetailsThemed-Familienurlaub-MetaTitle",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Essen und Trinken'->>'Intro' As varchar) AS "DetailThemed-ru-DetailsThemed-Essen und Trinken-Intro",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Essen und Trinken'->>'Title' As varchar) AS "DetailThemed-ru-DetailsThemed-Essen und Trinken-Title",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Essen und Trinken'->>'MetaDesc' As varchar) AS "DetailThemed-ru-DetailsThemed-Essen und Trinken-MetaDesc",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Essen und Trinken'->>'MetaTitle' As varchar) AS "DetailThemed-ru-DetailsThemed-Essen und Trinken-MetaTitle",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Wellness und Entspannung'->>'Intro' As varchar) AS "DetailThemed-ru-DetailsThemed-Wellness und Entspannung-Intro",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Wellness und Entspannung'->>'Title' As varchar) AS "DetailThemed-ru-DetailsThemed-Wellness und Entspannung-Title",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaDesc' As varchar) AS "DetailThemed-ru-DetailsThemed-Wellness und Entspannung-MetaDesc",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Wellness und Entspannung'->>'MetaTitle' As varchar) AS "D-ru-DetailsThemed-Wellness und Entspannung-MetaTitle",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Intro' As varchar) AS "D-r-DetailsThemed-Kultur und Sehenswürdigkeiten-Intro",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'Title' As varchar) AS "D-r-DetailsThemed-Kultur und Sehenswürdigkeiten-Title",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaDesc' As varchar) AS "D-r-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaDesc",
CAST("data"->'DetailThemed'->'ru'->'DetailsThemed'->'Kultur und Sehenswürdigkeiten'->>'MetaTitle' As varchar) AS "D-r-DetailsThemed-Kultur und Sehenswürdigkeiten-MetaTitle"
FROM regionsopen;

CREATE UNIQUE INDEX "v_regionsopen_pk" ON "v_regionsopen"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_regionsopen_SkiareaIds";

CREATE MATERIALIZED VIEW "v_regionsopen_SkiareaIds" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'SkiareaIds') AS "data"
        FROM regionsopen
        WHERE data -> 'SkiareaIds' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_regionsopen_HasLanguage";

CREATE MATERIALIZED VIEW "v_regionsopen_HasLanguage" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'HasLanguage') AS "data"
        FROM regionsopen
        WHERE data -> 'HasLanguage' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS  "v_skiareasopen";

CREATE MATERIALIZED VIEW "v_skiareasopen" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'Gpstype' As varchar) AS "Gpstype",
CAST("data"->>'Latitude' As float) AS "Latitude",
CAST("data"->>'LiftCount' As varchar) AS "LiftCount",
CAST("data"->>'Longitude' As float) AS "Longitude",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'AltitudeTo' As integer) AS "AltitudeTo",
CAST("data"->>'LastChange' As varchar) AS "LastChange",
CAST("data"->>'SlopeKmRed' As varchar) AS "SlopeKmRed",
CAST("data"->>'SkiRegionId' As varchar) AS "SkiRegionId",
CAST("data"->>'SlopeKmBlue' As varchar) AS "SlopeKmBlue",
CAST("data"->>'AltitudeFrom' As integer) AS "AltitudeFrom",
CAST("data"->>'SlopeKmBlack' As varchar) AS "SlopeKmBlack",
CAST("data"->>'TotalSlopeKm' As varchar) AS "TotalSlopeKm",
CAST("data"->>'SkiAreaMapURL' As varchar) AS "SkiAreaMapURL",
CAST("data"->>'AltitudeUnitofMeasure' As varchar) AS "AltitudeUnitofMeasure",
CAST("data"->'Detail'->'cs'->>'Title' As varchar) AS "Detail-cs-Title",
CAST("data"->'Detail'->'cs'->>'Header' As varchar) AS "Detail-cs-Header",
CAST("data"->'Detail'->'cs'->>'BaseText' As varchar) AS "Detail-cs-BaseText",
CAST("data"->'Detail'->'cs'->>'Language' As varchar) AS "Detail-cs-Language",
CAST("data"->'Detail'->'cs'->>'MetaDesc' As varchar) AS "Detail-cs-MetaDesc",
CAST("data"->'Detail'->'cs'->>'IntroText' As varchar) AS "Detail-cs-IntroText",
CAST("data"->'Detail'->'cs'->>'MetaTitle' As varchar) AS "Detail-cs-MetaTitle",
CAST("data"->'Detail'->'cs'->>'SubHeader' As varchar) AS "Detail-cs-SubHeader",
CAST("data"->'Detail'->'de'->>'Title' As varchar) AS "Detail-de-Title",
CAST("data"->'Detail'->'de'->>'Header' As varchar) AS "Detail-de-Header",
CAST("data"->'Detail'->'de'->>'BaseText' As varchar) AS "Detail-de-BaseText",
CAST("data"->'Detail'->'de'->>'Language' As varchar) AS "Detail-de-Language",
CAST("data"->'Detail'->'de'->>'MetaDesc' As varchar) AS "Detail-de-MetaDesc",
CAST("data"->'Detail'->'de'->>'IntroText' As varchar) AS "Detail-de-IntroText",
CAST("data"->'Detail'->'de'->>'MetaTitle' As varchar) AS "Detail-de-MetaTitle",
CAST("data"->'Detail'->'de'->>'SubHeader' As varchar) AS "Detail-de-SubHeader",
CAST("data"->'Detail'->'en'->>'Title' As varchar) AS "Detail-en-Title",
CAST("data"->'Detail'->'en'->>'Header' As varchar) AS "Detail-en-Header",
CAST("data"->'Detail'->'en'->>'BaseText' As varchar) AS "Detail-en-BaseText",
CAST("data"->'Detail'->'en'->>'Language' As varchar) AS "Detail-en-Language",
CAST("data"->'Detail'->'en'->>'MetaDesc' As varchar) AS "Detail-en-MetaDesc",
CAST("data"->'Detail'->'en'->>'IntroText' As varchar) AS "Detail-en-IntroText",
CAST("data"->'Detail'->'en'->>'MetaTitle' As varchar) AS "Detail-en-MetaTitle",
CAST("data"->'Detail'->'en'->>'SubHeader' As varchar) AS "Detail-en-SubHeader",
CAST("data"->'Detail'->'fr'->>'Title' As varchar) AS "Detail-fr-Title",
CAST("data"->'Detail'->'fr'->>'Header' As varchar) AS "Detail-fr-Header",
CAST("data"->'Detail'->'fr'->>'BaseText' As varchar) AS "Detail-fr-BaseText",
CAST("data"->'Detail'->'fr'->>'Language' As varchar) AS "Detail-fr-Language",
CAST("data"->'Detail'->'fr'->>'MetaDesc' As varchar) AS "Detail-fr-MetaDesc",
CAST("data"->'Detail'->'fr'->>'IntroText' As varchar) AS "Detail-fr-IntroText",
CAST("data"->'Detail'->'fr'->>'MetaTitle' As varchar) AS "Detail-fr-MetaTitle",
CAST("data"->'Detail'->'fr'->>'SubHeader' As varchar) AS "Detail-fr-SubHeader",
CAST("data"->'Detail'->'it'->>'Title' As varchar) AS "Detail-it-Title",
CAST("data"->'Detail'->'it'->>'Header' As varchar) AS "Detail-it-Header",
CAST("data"->'Detail'->'it'->>'BaseText' As varchar) AS "Detail-it-BaseText",
CAST("data"->'Detail'->'it'->>'Language' As varchar) AS "Detail-it-Language",
CAST("data"->'Detail'->'it'->>'MetaDesc' As varchar) AS "Detail-it-MetaDesc",
CAST("data"->'Detail'->'it'->>'IntroText' As varchar) AS "Detail-it-IntroText",
CAST("data"->'Detail'->'it'->>'MetaTitle' As varchar) AS "Detail-it-MetaTitle",
CAST("data"->'Detail'->'it'->>'SubHeader' As varchar) AS "Detail-it-SubHeader",
CAST("data"->'Detail'->'nl'->>'Title' As varchar) AS "Detail-nl-Title",
CAST("data"->'Detail'->'nl'->>'Header' As varchar) AS "Detail-nl-Header",
CAST("data"->'Detail'->'nl'->>'BaseText' As varchar) AS "Detail-nl-BaseText",
CAST("data"->'Detail'->'nl'->>'Language' As varchar) AS "Detail-nl-Language",
CAST("data"->'Detail'->'nl'->>'MetaDesc' As varchar) AS "Detail-nl-MetaDesc",
CAST("data"->'Detail'->'nl'->>'IntroText' As varchar) AS "Detail-nl-IntroText",
CAST("data"->'Detail'->'nl'->>'MetaTitle' As varchar) AS "Detail-nl-MetaTitle",
CAST("data"->'Detail'->'nl'->>'SubHeader' As varchar) AS "Detail-nl-SubHeader",
CAST("data"->'Detail'->'pl'->>'Title' As varchar) AS "Detail-pl-Title",
CAST("data"->'Detail'->'pl'->>'Header' As varchar) AS "Detail-pl-Header",
CAST("data"->'Detail'->'pl'->>'BaseText' As varchar) AS "Detail-pl-BaseText",
CAST("data"->'Detail'->'pl'->>'Language' As varchar) AS "Detail-pl-Language",
CAST("data"->'Detail'->'pl'->>'MetaDesc' As varchar) AS "Detail-pl-MetaDesc",
CAST("data"->'Detail'->'pl'->>'IntroText' As varchar) AS "Detail-pl-IntroText",
CAST("data"->'Detail'->'pl'->>'MetaTitle' As varchar) AS "Detail-pl-MetaTitle",
CAST("data"->'Detail'->'pl'->>'SubHeader' As varchar) AS "Detail-pl-SubHeader",
CAST("data"->'Detail'->'ru'->>'Title' As varchar) AS "Detail-ru-Title",
CAST("data"->'Detail'->'ru'->>'Header' As varchar) AS "Detail-ru-Header",
CAST("data"->'Detail'->'ru'->>'BaseText' As varchar) AS "Detail-ru-BaseText",
CAST("data"->'Detail'->'ru'->>'Language' As varchar) AS "Detail-ru-Language",
CAST("data"->'Detail'->'ru'->>'MetaDesc' As varchar) AS "Detail-ru-MetaDesc",
CAST("data"->'Detail'->'ru'->>'IntroText' As varchar) AS "Detail-ru-IntroText",
CAST("data"->'Detail'->'ru'->>'MetaTitle' As varchar) AS "Detail-ru-MetaTitle",
CAST("data"->'Detail'->'ru'->>'SubHeader' As varchar) AS "Detail-ru-SubHeader",
CAST("data"->'ContactInfos'->'cs'->>'Url' As varchar) AS "ContactInfos-cs-Url",
CAST("data"->'ContactInfos'->'cs'->>'City' As varchar) AS "ContactInfos-cs-City",
CAST("data"->'ContactInfos'->'cs'->>'Email' As varchar) AS "ContactInfos-cs-Email",
CAST("data"->'ContactInfos'->'cs'->>'Address' As varchar) AS "ContactInfos-cs-Address",
CAST("data"->'ContactInfos'->'cs'->>'LogoUrl' As varchar) AS "ContactInfos-cs-LogoUrl",
CAST("data"->'ContactInfos'->'cs'->>'ZipCode' As varchar) AS "ContactInfos-cs-ZipCode",
CAST("data"->'ContactInfos'->'cs'->>'Language' As varchar) AS "ContactInfos-cs-Language",
CAST("data"->'ContactInfos'->'cs'->>'CompanyName' As varchar) AS "ContactInfos-cs-CompanyName",
CAST("data"->'ContactInfos'->'cs'->>'CountryCode' As varchar) AS "ContactInfos-cs-CountryCode",
CAST("data"->'ContactInfos'->'cs'->>'CountryName' As varchar) AS "ContactInfos-cs-CountryName",
CAST("data"->'ContactInfos'->'cs'->>'Phonenumber' As varchar) AS "ContactInfos-cs-Phonenumber",
CAST("data"->'ContactInfos'->'de'->>'Url' As varchar) AS "ContactInfos-de-Url",
CAST("data"->'ContactInfos'->'de'->>'City' As varchar) AS "ContactInfos-de-City",
CAST("data"->'ContactInfos'->'de'->>'Email' As varchar) AS "ContactInfos-de-Email",
CAST("data"->'ContactInfos'->'de'->>'Address' As varchar) AS "ContactInfos-de-Address",
CAST("data"->'ContactInfos'->'de'->>'LogoUrl' As varchar) AS "ContactInfos-de-LogoUrl",
CAST("data"->'ContactInfos'->'de'->>'ZipCode' As varchar) AS "ContactInfos-de-ZipCode",
CAST("data"->'ContactInfos'->'de'->>'Language' As varchar) AS "ContactInfos-de-Language",
CAST("data"->'ContactInfos'->'de'->>'Faxnumber' As varchar) AS "ContactInfos-de-Faxnumber",
CAST("data"->'ContactInfos'->'de'->>'CompanyName' As varchar) AS "ContactInfos-de-CompanyName",
CAST("data"->'ContactInfos'->'de'->>'CountryCode' As varchar) AS "ContactInfos-de-CountryCode",
CAST("data"->'ContactInfos'->'de'->>'CountryName' As varchar) AS "ContactInfos-de-CountryName",
CAST("data"->'ContactInfos'->'de'->>'Phonenumber' As varchar) AS "ContactInfos-de-Phonenumber",
CAST("data"->'ContactInfos'->'en'->>'Url' As varchar) AS "ContactInfos-en-Url",
CAST("data"->'ContactInfos'->'en'->>'City' As varchar) AS "ContactInfos-en-City",
CAST("data"->'ContactInfos'->'en'->>'Email' As varchar) AS "ContactInfos-en-Email",
CAST("data"->'ContactInfos'->'en'->>'Address' As varchar) AS "ContactInfos-en-Address",
CAST("data"->'ContactInfos'->'en'->>'LogoUrl' As varchar) AS "ContactInfos-en-LogoUrl",
CAST("data"->'ContactInfos'->'en'->>'ZipCode' As varchar) AS "ContactInfos-en-ZipCode",
CAST("data"->'ContactInfos'->'en'->>'Language' As varchar) AS "ContactInfos-en-Language",
CAST("data"->'ContactInfos'->'en'->>'CompanyName' As varchar) AS "ContactInfos-en-CompanyName",
CAST("data"->'ContactInfos'->'en'->>'CountryCode' As varchar) AS "ContactInfos-en-CountryCode",
CAST("data"->'ContactInfos'->'en'->>'CountryName' As varchar) AS "ContactInfos-en-CountryName",
CAST("data"->'ContactInfos'->'en'->>'Phonenumber' As varchar) AS "ContactInfos-en-Phonenumber",
CAST("data"->'ContactInfos'->'fr'->>'Url' As varchar) AS "ContactInfos-fr-Url",
CAST("data"->'ContactInfos'->'fr'->>'City' As varchar) AS "ContactInfos-fr-City",
CAST("data"->'ContactInfos'->'fr'->>'Email' As varchar) AS "ContactInfos-fr-Email",
CAST("data"->'ContactInfos'->'fr'->>'Address' As varchar) AS "ContactInfos-fr-Address",
CAST("data"->'ContactInfos'->'fr'->>'LogoUrl' As varchar) AS "ContactInfos-fr-LogoUrl",
CAST("data"->'ContactInfos'->'fr'->>'ZipCode' As varchar) AS "ContactInfos-fr-ZipCode",
CAST("data"->'ContactInfos'->'fr'->>'Language' As varchar) AS "ContactInfos-fr-Language",
CAST("data"->'ContactInfos'->'fr'->>'CompanyName' As varchar) AS "ContactInfos-fr-CompanyName",
CAST("data"->'ContactInfos'->'fr'->>'CountryCode' As varchar) AS "ContactInfos-fr-CountryCode",
CAST("data"->'ContactInfos'->'fr'->>'CountryName' As varchar) AS "ContactInfos-fr-CountryName",
CAST("data"->'ContactInfos'->'fr'->>'Phonenumber' As varchar) AS "ContactInfos-fr-Phonenumber",
CAST("data"->'ContactInfos'->'it'->>'Url' As varchar) AS "ContactInfos-it-Url",
CAST("data"->'ContactInfos'->'it'->>'City' As varchar) AS "ContactInfos-it-City",
CAST("data"->'ContactInfos'->'it'->>'Email' As varchar) AS "ContactInfos-it-Email",
CAST("data"->'ContactInfos'->'it'->>'Address' As varchar) AS "ContactInfos-it-Address",
CAST("data"->'ContactInfos'->'it'->>'LogoUrl' As varchar) AS "ContactInfos-it-LogoUrl",
CAST("data"->'ContactInfos'->'it'->>'ZipCode' As varchar) AS "ContactInfos-it-ZipCode",
CAST("data"->'ContactInfos'->'it'->>'Language' As varchar) AS "ContactInfos-it-Language",
CAST("data"->'ContactInfos'->'it'->>'CompanyName' As varchar) AS "ContactInfos-it-CompanyName",
CAST("data"->'ContactInfos'->'it'->>'CountryCode' As varchar) AS "ContactInfos-it-CountryCode",
CAST("data"->'ContactInfos'->'it'->>'CountryName' As varchar) AS "ContactInfos-it-CountryName",
CAST("data"->'ContactInfos'->'it'->>'Phonenumber' As varchar) AS "ContactInfos-it-Phonenumber",
CAST("data"->'ContactInfos'->'nl'->>'Url' As varchar) AS "ContactInfos-nl-Url",
CAST("data"->'ContactInfos'->'nl'->>'City' As varchar) AS "ContactInfos-nl-City",
CAST("data"->'ContactInfos'->'nl'->>'Email' As varchar) AS "ContactInfos-nl-Email",
CAST("data"->'ContactInfos'->'nl'->>'Address' As varchar) AS "ContactInfos-nl-Address",
CAST("data"->'ContactInfos'->'nl'->>'LogoUrl' As varchar) AS "ContactInfos-nl-LogoUrl",
CAST("data"->'ContactInfos'->'nl'->>'ZipCode' As varchar) AS "ContactInfos-nl-ZipCode",
CAST("data"->'ContactInfos'->'nl'->>'Language' As varchar) AS "ContactInfos-nl-Language",
CAST("data"->'ContactInfos'->'nl'->>'CompanyName' As varchar) AS "ContactInfos-nl-CompanyName",
CAST("data"->'ContactInfos'->'nl'->>'CountryCode' As varchar) AS "ContactInfos-nl-CountryCode",
CAST("data"->'ContactInfos'->'nl'->>'CountryName' As varchar) AS "ContactInfos-nl-CountryName",
CAST("data"->'ContactInfos'->'nl'->>'Phonenumber' As varchar) AS "ContactInfos-nl-Phonenumber",
CAST("data"->'ContactInfos'->'pl'->>'Url' As varchar) AS "ContactInfos-pl-Url",
CAST("data"->'ContactInfos'->'pl'->>'City' As varchar) AS "ContactInfos-pl-City",
CAST("data"->'ContactInfos'->'pl'->>'Email' As varchar) AS "ContactInfos-pl-Email",
CAST("data"->'ContactInfos'->'pl'->>'Address' As varchar) AS "ContactInfos-pl-Address",
CAST("data"->'ContactInfos'->'pl'->>'LogoUrl' As varchar) AS "ContactInfos-pl-LogoUrl",
CAST("data"->'ContactInfos'->'pl'->>'ZipCode' As varchar) AS "ContactInfos-pl-ZipCode",
CAST("data"->'ContactInfos'->'pl'->>'Language' As varchar) AS "ContactInfos-pl-Language",
CAST("data"->'ContactInfos'->'pl'->>'CompanyName' As varchar) AS "ContactInfos-pl-CompanyName",
CAST("data"->'ContactInfos'->'pl'->>'CountryCode' As varchar) AS "ContactInfos-pl-CountryCode",
CAST("data"->'ContactInfos'->'pl'->>'CountryName' As varchar) AS "ContactInfos-pl-CountryName",
CAST("data"->'ContactInfos'->'pl'->>'Phonenumber' As varchar) AS "ContactInfos-pl-Phonenumber",
CAST("data"->'ContactInfos'->'ru'->>'Url' As varchar) AS "ContactInfos-ru-Url",
CAST("data"->'ContactInfos'->'ru'->>'City' As varchar) AS "ContactInfos-ru-City",
CAST("data"->'ContactInfos'->'ru'->>'Email' As varchar) AS "ContactInfos-ru-Email",
CAST("data"->'ContactInfos'->'ru'->>'Address' As varchar) AS "ContactInfos-ru-Address",
CAST("data"->'ContactInfos'->'ru'->>'LogoUrl' As varchar) AS "ContactInfos-ru-LogoUrl",
CAST("data"->'ContactInfos'->'ru'->>'ZipCode' As varchar) AS "ContactInfos-ru-ZipCode",
CAST("data"->'ContactInfos'->'ru'->>'Language' As varchar) AS "ContactInfos-ru-Language",
CAST("data"->'ContactInfos'->'ru'->>'CompanyName' As varchar) AS "ContactInfos-ru-CompanyName",
CAST("data"->'ContactInfos'->'ru'->>'CountryCode' As varchar) AS "ContactInfos-ru-CountryCode",
CAST("data"->'ContactInfos'->'ru'->>'CountryName' As varchar) AS "ContactInfos-ru-CountryName",
CAST("data"->'ContactInfos'->'ru'->>'Phonenumber' As varchar) AS "ContactInfos-ru-Phonenumber",
CAST("data"->'LocationInfo'->'TvInfo'->>'Id' As varchar) AS "LocationInfo-TvInfo-Id",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-TvInfo-Name-cs",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'de' As varchar) AS "LocationInfo-TvInfo-Name-de",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'en' As varchar) AS "LocationInfo-TvInfo-Name-en",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-TvInfo-Name-fr",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'it' As varchar) AS "LocationInfo-TvInfo-Name-it",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-TvInfo-Name-nl",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-TvInfo-Name-pl",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-TvInfo-Name-ru",
CAST("data"->'LocationInfo'->'RegionInfo'->>'Id' As varchar) AS "LocationInfo-RegionInfo-Id",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-RegionInfo-Name-cs",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'de' As varchar) AS "LocationInfo-RegionInfo-Name-de",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'en' As varchar) AS "LocationInfo-RegionInfo-Name-en",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-RegionInfo-Name-fr",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'it' As varchar) AS "LocationInfo-RegionInfo-Name-it",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-RegionInfo-Name-nl",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-RegionInfo-Name-pl",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-RegionInfo-Name-ru",
CAST("data"->'SkiRegionName'->>'cs' As varchar) AS "SkiRegionName-cs",
CAST("data"->'SkiRegionName'->>'de' As varchar) AS "SkiRegionName-de",
CAST("data"->'SkiRegionName'->>'en' As varchar) AS "SkiRegionName-en",
CAST("data"->'SkiRegionName'->>'fr' As varchar) AS "SkiRegionName-fr",
CAST("data"->'SkiRegionName'->>'it' As varchar) AS "SkiRegionName-it",
CAST("data"->'SkiRegionName'->>'nl' As varchar) AS "SkiRegionName-nl",
CAST("data"->'SkiRegionName'->>'pl' As varchar) AS "SkiRegionName-pl",
CAST("data"->'SkiRegionName'->>'ru' As varchar) AS "SkiRegionName-ru"
FROM skiareasopen;

CREATE UNIQUE INDEX "v_skiareasopen_pk" ON "v_skiareasopen"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_skiareasopen_AreaId";

CREATE MATERIALIZED VIEW "v_skiareasopen_AreaId" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'AreaId') AS "data"
        FROM skiareasopen
        WHERE data -> 'AreaId' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_skiareasopen_SmgTags";

CREATE MATERIALIZED VIEW "v_skiareasopen_SmgTags" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'SmgTags') AS "data"
        FROM skiareasopen
        WHERE data -> 'SmgTags' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_skiareasopen_RegionIds";

CREATE MATERIALIZED VIEW "v_skiareasopen_RegionIds" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'RegionIds') AS "data"
        FROM skiareasopen
        WHERE data -> 'RegionIds' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_skiareasopen_HasLanguage";

CREATE MATERIALIZED VIEW "v_skiareasopen_HasLanguage" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'HasLanguage') AS "data"
        FROM skiareasopen
        WHERE data -> 'HasLanguage' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_skiareasopen_TourismvereinIds";

CREATE MATERIALIZED VIEW "v_skiareasopen_TourismvereinIds" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'TourismvereinIds') AS "data"
        FROM skiareasopen
        WHERE data -> 'TourismvereinIds' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_skiareasopen_Webcam";

CREATE MATERIALIZED VIEW "v_skiareasopen_Webcam" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'Webcam') AS "Feature"
        FROM skiareasopen
        WHERE data -> 'Webcam' != 'null')
    SELECT "Id" AS "skiareasopen_Id", CAST("data"->>'WebcamId' As varchar) AS "WebcamId",
CAST("data"->>'Webcamurl' As varchar) AS "Webcamurl",
CAST("data"->'GpsInfo'->>'Gpstype' As varchar) AS "GpsInfo-Gpstype",
CAST("data"->'GpsInfo'->>'Latitude' As float) AS "GpsInfo-Latitude",
CAST("data"->'GpsInfo'->>'Longitude' As float) AS "GpsInfo-Longitude",
CAST("data"->'GpsInfo'->>'AltitudeUnitofMeasure' As varchar) AS "GpsInfo-AltitudeUnitofMeasure",
CAST("data"->'Webcamname'->>'cs' As varchar) AS "Webcamname-cs",
CAST("data"->'Webcamname'->>'de' As varchar) AS "Webcamname-de",
CAST("data"->'Webcamname'->>'en' As varchar) AS "Webcamname-en",
CAST("data"->'Webcamname'->>'fr' As varchar) AS "Webcamname-fr",
CAST("data"->'Webcamname'->>'it' As varchar) AS "Webcamname-it",
CAST("data"->'Webcamname'->>'nl' As varchar) AS "Webcamname-nl",
CAST("data"->'Webcamname'->>'pl' As varchar) AS "Webcamname-pl",
CAST("data"->'Webcamname'->>'ru' As varchar) AS "Webcamname-ru"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS "v_skiareasopen_OperationSchedule";

CREATE MATERIALIZED VIEW "v_skiareasopen_OperationSchedule" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'OperationSchedule') AS "Feature"
        FROM skiareasopen
        WHERE data -> 'OperationSchedule' != 'null')
    SELECT "Id" AS "skiareasopen_Id", CAST("data"->>'Stop' As varchar) AS "Stop",
CAST("data"->>'Type' As varchar) AS "Type",
CAST("data"->>'Start' As varchar) AS "Start",
CAST("data"->'OperationscheduleName'->>'cs' As varchar) AS "OperationscheduleName-cs",
CAST("data"->'OperationscheduleName'->>'de' As varchar) AS "OperationscheduleName-de",
CAST("data"->'OperationscheduleName'->>'en' As varchar) AS "OperationscheduleName-en",
CAST("data"->'OperationscheduleName'->>'it' As varchar) AS "OperationscheduleName-it",
CAST("data"->'OperationscheduleName'->>'nl' As varchar) AS "OperationscheduleName-nl",
CAST("data"->'OperationscheduleName'->>'pl' As varchar) AS "OperationscheduleName-pl"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS  "v_skiregionsopen";

CREATE MATERIALIZED VIEW "v_skiregionsopen" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'Gpstype' As varchar) AS "Gpstype",
CAST("data"->>'Altitude' As float) AS "Altitude",
CAST("data"->>'Latitude' As float) AS "Latitude",
CAST("data"->>'Longitude' As float) AS "Longitude",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'LastChange' As varchar) AS "LastChange",
CAST("data"->>'AltitudeUnitofMeasure' As varchar) AS "AltitudeUnitofMeasure",
CAST("data"->'Detail'->'cs'->>'Title' As varchar) AS "Detail-cs-Title",
CAST("data"->'Detail'->'cs'->>'BaseText' As varchar) AS "Detail-cs-BaseText",
CAST("data"->'Detail'->'cs'->>'Language' As varchar) AS "Detail-cs-Language",
CAST("data"->'Detail'->'cs'->>'IntroText' As varchar) AS "Detail-cs-IntroText",
CAST("data"->'Detail'->'cs'->>'SubHeader' As varchar) AS "Detail-cs-SubHeader",
CAST("data"->'Detail'->'cs'->>'GetThereText' As varchar) AS "Detail-cs-GetThereText",
CAST("data"->'Detail'->'de'->>'Title' As varchar) AS "Detail-de-Title",
CAST("data"->'Detail'->'de'->>'BaseText' As varchar) AS "Detail-de-BaseText",
CAST("data"->'Detail'->'de'->>'Language' As varchar) AS "Detail-de-Language",
CAST("data"->'Detail'->'de'->>'IntroText' As varchar) AS "Detail-de-IntroText",
CAST("data"->'Detail'->'de'->>'SubHeader' As varchar) AS "Detail-de-SubHeader",
CAST("data"->'Detail'->'de'->>'GetThereText' As varchar) AS "Detail-de-GetThereText",
CAST("data"->'Detail'->'en'->>'Title' As varchar) AS "Detail-en-Title",
CAST("data"->'Detail'->'en'->>'BaseText' As varchar) AS "Detail-en-BaseText",
CAST("data"->'Detail'->'en'->>'Language' As varchar) AS "Detail-en-Language",
CAST("data"->'Detail'->'en'->>'IntroText' As varchar) AS "Detail-en-IntroText",
CAST("data"->'Detail'->'en'->>'SubHeader' As varchar) AS "Detail-en-SubHeader",
CAST("data"->'Detail'->'en'->>'GetThereText' As varchar) AS "Detail-en-GetThereText",
CAST("data"->'Detail'->'fr'->>'Title' As varchar) AS "Detail-fr-Title",
CAST("data"->'Detail'->'fr'->>'Header' As varchar) AS "Detail-fr-Header",
CAST("data"->'Detail'->'fr'->>'BaseText' As varchar) AS "Detail-fr-BaseText",
CAST("data"->'Detail'->'fr'->>'Language' As varchar) AS "Detail-fr-Language",
CAST("data"->'Detail'->'fr'->>'IntroText' As varchar) AS "Detail-fr-IntroText",
CAST("data"->'Detail'->'fr'->>'SubHeader' As varchar) AS "Detail-fr-SubHeader",
CAST("data"->'Detail'->'fr'->>'GetThereText' As varchar) AS "Detail-fr-GetThereText",
CAST("data"->'Detail'->'it'->>'Title' As varchar) AS "Detail-it-Title",
CAST("data"->'Detail'->'it'->>'BaseText' As varchar) AS "Detail-it-BaseText",
CAST("data"->'Detail'->'it'->>'Language' As varchar) AS "Detail-it-Language",
CAST("data"->'Detail'->'it'->>'IntroText' As varchar) AS "Detail-it-IntroText",
CAST("data"->'Detail'->'it'->>'SubHeader' As varchar) AS "Detail-it-SubHeader",
CAST("data"->'Detail'->'it'->>'GetThereText' As varchar) AS "Detail-it-GetThereText",
CAST("data"->'Detail'->'nl'->>'Title' As varchar) AS "Detail-nl-Title",
CAST("data"->'Detail'->'nl'->>'BaseText' As varchar) AS "Detail-nl-BaseText",
CAST("data"->'Detail'->'nl'->>'Language' As varchar) AS "Detail-nl-Language",
CAST("data"->'Detail'->'nl'->>'IntroText' As varchar) AS "Detail-nl-IntroText",
CAST("data"->'Detail'->'nl'->>'SubHeader' As varchar) AS "Detail-nl-SubHeader",
CAST("data"->'Detail'->'nl'->>'GetThereText' As varchar) AS "Detail-nl-GetThereText",
CAST("data"->'Detail'->'pl'->>'Title' As varchar) AS "Detail-pl-Title",
CAST("data"->'Detail'->'pl'->>'BaseText' As varchar) AS "Detail-pl-BaseText",
CAST("data"->'Detail'->'pl'->>'Language' As varchar) AS "Detail-pl-Language",
CAST("data"->'Detail'->'pl'->>'IntroText' As varchar) AS "Detail-pl-IntroText",
CAST("data"->'Detail'->'pl'->>'SubHeader' As varchar) AS "Detail-pl-SubHeader",
CAST("data"->'Detail'->'pl'->>'GetThereText' As varchar) AS "Detail-pl-GetThereText",
CAST("data"->'Detail'->'ru'->>'Title' As varchar) AS "Detail-ru-Title",
CAST("data"->'Detail'->'ru'->>'Header' As varchar) AS "Detail-ru-Header",
CAST("data"->'Detail'->'ru'->>'BaseText' As varchar) AS "Detail-ru-BaseText",
CAST("data"->'Detail'->'ru'->>'Language' As varchar) AS "Detail-ru-Language",
CAST("data"->'Detail'->'ru'->>'IntroText' As varchar) AS "Detail-ru-IntroText",
CAST("data"->'Detail'->'ru'->>'SubHeader' As varchar) AS "Detail-ru-SubHeader",
CAST("data"->'Detail'->'ru'->>'GetThereText' As varchar) AS "Detail-ru-GetThereText",
CAST("data"->'ContactInfos'->'cs'->>'Url' As varchar) AS "ContactInfos-cs-Url",
CAST("data"->'ContactInfos'->'cs'->>'City' As varchar) AS "ContactInfos-cs-City",
CAST("data"->'ContactInfos'->'cs'->>'Email' As varchar) AS "ContactInfos-cs-Email",
CAST("data"->'ContactInfos'->'cs'->>'Address' As varchar) AS "ContactInfos-cs-Address",
CAST("data"->'ContactInfos'->'cs'->>'LogoUrl' As varchar) AS "ContactInfos-cs-LogoUrl",
CAST("data"->'ContactInfos'->'cs'->>'ZipCode' As varchar) AS "ContactInfos-cs-ZipCode",
CAST("data"->'ContactInfos'->'cs'->>'Language' As varchar) AS "ContactInfos-cs-Language",
CAST("data"->'ContactInfos'->'cs'->>'CompanyName' As varchar) AS "ContactInfos-cs-CompanyName",
CAST("data"->'ContactInfos'->'cs'->>'CountryCode' As varchar) AS "ContactInfos-cs-CountryCode",
CAST("data"->'ContactInfos'->'cs'->>'CountryName' As varchar) AS "ContactInfos-cs-CountryName",
CAST("data"->'ContactInfos'->'cs'->>'Phonenumber' As varchar) AS "ContactInfos-cs-Phonenumber",
CAST("data"->'ContactInfos'->'de'->>'Url' As varchar) AS "ContactInfos-de-Url",
CAST("data"->'ContactInfos'->'de'->>'City' As varchar) AS "ContactInfos-de-City",
CAST("data"->'ContactInfos'->'de'->>'Email' As varchar) AS "ContactInfos-de-Email",
CAST("data"->'ContactInfos'->'de'->>'Address' As varchar) AS "ContactInfos-de-Address",
CAST("data"->'ContactInfos'->'de'->>'LogoUrl' As varchar) AS "ContactInfos-de-LogoUrl",
CAST("data"->'ContactInfos'->'de'->>'ZipCode' As varchar) AS "ContactInfos-de-ZipCode",
CAST("data"->'ContactInfos'->'de'->>'Language' As varchar) AS "ContactInfos-de-Language",
CAST("data"->'ContactInfos'->'de'->>'CompanyName' As varchar) AS "ContactInfos-de-CompanyName",
CAST("data"->'ContactInfos'->'de'->>'CountryCode' As varchar) AS "ContactInfos-de-CountryCode",
CAST("data"->'ContactInfos'->'de'->>'CountryName' As varchar) AS "ContactInfos-de-CountryName",
CAST("data"->'ContactInfos'->'de'->>'Phonenumber' As varchar) AS "ContactInfos-de-Phonenumber",
CAST("data"->'ContactInfos'->'en'->>'Url' As varchar) AS "ContactInfos-en-Url",
CAST("data"->'ContactInfos'->'en'->>'City' As varchar) AS "ContactInfos-en-City",
CAST("data"->'ContactInfos'->'en'->>'Email' As varchar) AS "ContactInfos-en-Email",
CAST("data"->'ContactInfos'->'en'->>'Address' As varchar) AS "ContactInfos-en-Address",
CAST("data"->'ContactInfos'->'en'->>'LogoUrl' As varchar) AS "ContactInfos-en-LogoUrl",
CAST("data"->'ContactInfos'->'en'->>'ZipCode' As varchar) AS "ContactInfos-en-ZipCode",
CAST("data"->'ContactInfos'->'en'->>'Language' As varchar) AS "ContactInfos-en-Language",
CAST("data"->'ContactInfos'->'en'->>'CompanyName' As varchar) AS "ContactInfos-en-CompanyName",
CAST("data"->'ContactInfos'->'en'->>'CountryCode' As varchar) AS "ContactInfos-en-CountryCode",
CAST("data"->'ContactInfos'->'en'->>'CountryName' As varchar) AS "ContactInfos-en-CountryName",
CAST("data"->'ContactInfos'->'en'->>'Phonenumber' As varchar) AS "ContactInfos-en-Phonenumber",
CAST("data"->'ContactInfos'->'fr'->>'Url' As varchar) AS "ContactInfos-fr-Url",
CAST("data"->'ContactInfos'->'fr'->>'City' As varchar) AS "ContactInfos-fr-City",
CAST("data"->'ContactInfos'->'fr'->>'Email' As varchar) AS "ContactInfos-fr-Email",
CAST("data"->'ContactInfos'->'fr'->>'Address' As varchar) AS "ContactInfos-fr-Address",
CAST("data"->'ContactInfos'->'fr'->>'LogoUrl' As varchar) AS "ContactInfos-fr-LogoUrl",
CAST("data"->'ContactInfos'->'fr'->>'ZipCode' As varchar) AS "ContactInfos-fr-ZipCode",
CAST("data"->'ContactInfos'->'fr'->>'Language' As varchar) AS "ContactInfos-fr-Language",
CAST("data"->'ContactInfos'->'fr'->>'CompanyName' As varchar) AS "ContactInfos-fr-CompanyName",
CAST("data"->'ContactInfos'->'fr'->>'CountryCode' As varchar) AS "ContactInfos-fr-CountryCode",
CAST("data"->'ContactInfos'->'fr'->>'CountryName' As varchar) AS "ContactInfos-fr-CountryName",
CAST("data"->'ContactInfos'->'fr'->>'Phonenumber' As varchar) AS "ContactInfos-fr-Phonenumber",
CAST("data"->'ContactInfos'->'it'->>'Url' As varchar) AS "ContactInfos-it-Url",
CAST("data"->'ContactInfos'->'it'->>'City' As varchar) AS "ContactInfos-it-City",
CAST("data"->'ContactInfos'->'it'->>'Email' As varchar) AS "ContactInfos-it-Email",
CAST("data"->'ContactInfos'->'it'->>'Address' As varchar) AS "ContactInfos-it-Address",
CAST("data"->'ContactInfos'->'it'->>'LogoUrl' As varchar) AS "ContactInfos-it-LogoUrl",
CAST("data"->'ContactInfos'->'it'->>'ZipCode' As varchar) AS "ContactInfos-it-ZipCode",
CAST("data"->'ContactInfos'->'it'->>'Language' As varchar) AS "ContactInfos-it-Language",
CAST("data"->'ContactInfos'->'it'->>'CompanyName' As varchar) AS "ContactInfos-it-CompanyName",
CAST("data"->'ContactInfos'->'it'->>'CountryCode' As varchar) AS "ContactInfos-it-CountryCode",
CAST("data"->'ContactInfos'->'it'->>'CountryName' As varchar) AS "ContactInfos-it-CountryName",
CAST("data"->'ContactInfos'->'it'->>'Phonenumber' As varchar) AS "ContactInfos-it-Phonenumber",
CAST("data"->'ContactInfos'->'nl'->>'Url' As varchar) AS "ContactInfos-nl-Url",
CAST("data"->'ContactInfos'->'nl'->>'City' As varchar) AS "ContactInfos-nl-City",
CAST("data"->'ContactInfos'->'nl'->>'Email' As varchar) AS "ContactInfos-nl-Email",
CAST("data"->'ContactInfos'->'nl'->>'Address' As varchar) AS "ContactInfos-nl-Address",
CAST("data"->'ContactInfos'->'nl'->>'LogoUrl' As varchar) AS "ContactInfos-nl-LogoUrl",
CAST("data"->'ContactInfos'->'nl'->>'ZipCode' As varchar) AS "ContactInfos-nl-ZipCode",
CAST("data"->'ContactInfos'->'nl'->>'Language' As varchar) AS "ContactInfos-nl-Language",
CAST("data"->'ContactInfos'->'nl'->>'CompanyName' As varchar) AS "ContactInfos-nl-CompanyName",
CAST("data"->'ContactInfos'->'nl'->>'CountryCode' As varchar) AS "ContactInfos-nl-CountryCode",
CAST("data"->'ContactInfos'->'nl'->>'CountryName' As varchar) AS "ContactInfos-nl-CountryName",
CAST("data"->'ContactInfos'->'nl'->>'Phonenumber' As varchar) AS "ContactInfos-nl-Phonenumber",
CAST("data"->'ContactInfos'->'pl'->>'Url' As varchar) AS "ContactInfos-pl-Url",
CAST("data"->'ContactInfos'->'pl'->>'City' As varchar) AS "ContactInfos-pl-City",
CAST("data"->'ContactInfos'->'pl'->>'Email' As varchar) AS "ContactInfos-pl-Email",
CAST("data"->'ContactInfos'->'pl'->>'Address' As varchar) AS "ContactInfos-pl-Address",
CAST("data"->'ContactInfos'->'pl'->>'LogoUrl' As varchar) AS "ContactInfos-pl-LogoUrl",
CAST("data"->'ContactInfos'->'pl'->>'ZipCode' As varchar) AS "ContactInfos-pl-ZipCode",
CAST("data"->'ContactInfos'->'pl'->>'Language' As varchar) AS "ContactInfos-pl-Language",
CAST("data"->'ContactInfos'->'pl'->>'CompanyName' As varchar) AS "ContactInfos-pl-CompanyName",
CAST("data"->'ContactInfos'->'pl'->>'CountryCode' As varchar) AS "ContactInfos-pl-CountryCode",
CAST("data"->'ContactInfos'->'pl'->>'CountryName' As varchar) AS "ContactInfos-pl-CountryName",
CAST("data"->'ContactInfos'->'pl'->>'Phonenumber' As varchar) AS "ContactInfos-pl-Phonenumber",
CAST("data"->'ContactInfos'->'ru'->>'Url' As varchar) AS "ContactInfos-ru-Url",
CAST("data"->'ContactInfos'->'ru'->>'City' As varchar) AS "ContactInfos-ru-City",
CAST("data"->'ContactInfos'->'ru'->>'Email' As varchar) AS "ContactInfos-ru-Email",
CAST("data"->'ContactInfos'->'ru'->>'Address' As varchar) AS "ContactInfos-ru-Address",
CAST("data"->'ContactInfos'->'ru'->>'LogoUrl' As varchar) AS "ContactInfos-ru-LogoUrl",
CAST("data"->'ContactInfos'->'ru'->>'ZipCode' As varchar) AS "ContactInfos-ru-ZipCode",
CAST("data"->'ContactInfos'->'ru'->>'Language' As varchar) AS "ContactInfos-ru-Language",
CAST("data"->'ContactInfos'->'ru'->>'CompanyName' As varchar) AS "ContactInfos-ru-CompanyName",
CAST("data"->'ContactInfos'->'ru'->>'CountryCode' As varchar) AS "ContactInfos-ru-CountryCode",
CAST("data"->'ContactInfos'->'ru'->>'CountryName' As varchar) AS "ContactInfos-ru-CountryName",
CAST("data"->'ContactInfos'->'ru'->>'Phonenumber' As varchar) AS "ContactInfos-ru-Phonenumber"
FROM skiregionsopen;

CREATE UNIQUE INDEX "v_skiregionsopen_pk" ON "v_skiregionsopen"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_skiregionsopen_HasLanguage";

CREATE MATERIALIZED VIEW "v_skiregionsopen_HasLanguage" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'HasLanguage') AS "data"
        FROM skiregionsopen
        WHERE data -> 'HasLanguage' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_skiregionsopen_GpsPolygon";

CREATE MATERIALIZED VIEW "v_skiregionsopen_GpsPolygon" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'GpsPolygon') AS "Feature"
        FROM skiregionsopen
        WHERE data -> 'GpsPolygon' != 'null')
    SELECT "Id" AS "skiregionsopen_Id", CAST("data"->>'Latitude' As float) AS "Latitude",
CAST("data"->>'Longitude' As float) AS "Longitude"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS  "v_smgpoisopen";

CREATE MATERIALIZED VIEW "v_smgpoisopen" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Type' As varchar) AS "Type",
CAST("data"->>'AgeTo' As integer) AS "AgeTo",
CAST("data"->>'SmgId' As varchar) AS "SmgId",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'IsOpen' As bool) AS "IsOpen",
CAST("data"->>'Source' As varchar) AS "Source",
CAST("data"->>'AgeFrom' As integer) AS "AgeFrom",
CAST("data"->>'PoiType' As varchar) AS "PoiType",
CAST("data"->>'SubType' As varchar) AS "SubType",
CAST("data"->>'CustomId' As varchar) AS "CustomId",
CAST("data"->>'OwnerRid' As varchar) AS "OwnerRid",
CAST("data"->>'FeetClimb' As bool) AS "FeetClimb",
CAST("data"->>'Highlight' As bool) AS "Highlight",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'Difficulty' As varchar) AS "Difficulty",
CAST("data"->>'HasRentals' As bool) AS "HasRentals",
CAST("data"->>'IsPrepared' As bool) AS "IsPrepared",
CAST("data"->>'LastChange' As varchar) AS "LastChange",
CAST("data"->>'FirstImport' As varchar) AS "FirstImport",
CAST("data"->>'IsWithLigth' As bool) AS "IsWithLigth",
CAST("data"->>'RunToValley' As bool) AS "RunToValley",
CAST("data"->>'AltitudeSumUp' As float) AS "AltitudeSumUp",
CAST("data"->>'LiftAvailable' As bool) AS "LiftAvailable",
CAST("data"->>'DistanceLength' As float) AS "DistanceLength",
CAST("data"->>'SyncUpdateMode' As varchar) AS "SyncUpdateMode",
CAST("data"->>'AltitudeSumDown' As float) AS "AltitudeSumDown",
CAST("data"->>'HasFreeEntrance' As bool) AS "HasFreeEntrance",
CAST("data"->>'OutdooractiveID' As varchar) AS "OutdooractiveID",
CAST("data"->>'CopyrightChecked' As bool) AS "CopyrightChecked",
CAST("data"->>'DistanceDuration' As float) AS "DistanceDuration",
CAST("data"->>'AltitudeDifference' As float) AS "AltitudeDifference",
CAST("data"->>'MaxSeatingCapacity' As integer) AS "MaxSeatingCapacity",
CAST("data"->>'AltitudeLowestPoint' As float) AS "AltitudeLowestPoint",
CAST("data"->>'SyncSourceInterface' As varchar) AS "SyncSourceInterface",
CAST("data"->>'AltitudeHighestPoint' As float) AS "AltitudeHighestPoint",
CAST("data"->>'TourismorganizationId' As varchar) AS "TourismorganizationId",
CAST("data"->'Detail'->'cs'->>'Title' As varchar) AS "Detail-cs-Title",
CAST("data"->'Detail'->'cs'->>'BaseText' As varchar) AS "Detail-cs-BaseText",
CAST("data"->'Detail'->'cs'->>'MetaDesc' As varchar) AS "Detail-cs-MetaDesc",
CAST("data"->'Detail'->'cs'->>'MetaTitle' As varchar) AS "Detail-cs-MetaTitle",
CAST("data"->'Detail'->'de'->>'Title' As varchar) AS "Detail-de-Title",
CAST("data"->'Detail'->'de'->>'BaseText' As varchar) AS "Detail-de-BaseText",
CAST("data"->'Detail'->'de'->>'Language' As varchar) AS "Detail-de-Language",
CAST("data"->'Detail'->'de'->>'MetaDesc' As varchar) AS "Detail-de-MetaDesc",
CAST("data"->'Detail'->'de'->>'IntroText' As varchar) AS "Detail-de-IntroText",
CAST("data"->'Detail'->'de'->>'MetaTitle' As varchar) AS "Detail-de-MetaTitle",
CAST("data"->'Detail'->'de'->>'GetThereText' As varchar) AS "Detail-de-GetThereText",
CAST("data"->'Detail'->'en'->>'Title' As varchar) AS "Detail-en-Title",
CAST("data"->'Detail'->'en'->>'BaseText' As varchar) AS "Detail-en-BaseText",
CAST("data"->'Detail'->'en'->>'Language' As varchar) AS "Detail-en-Language",
CAST("data"->'Detail'->'en'->>'MetaDesc' As varchar) AS "Detail-en-MetaDesc",
CAST("data"->'Detail'->'en'->>'MetaTitle' As varchar) AS "Detail-en-MetaTitle",
CAST("data"->'Detail'->'en'->>'GetThereText' As varchar) AS "Detail-en-GetThereText",
CAST("data"->'Detail'->'fr'->>'Title' As varchar) AS "Detail-fr-Title",
CAST("data"->'Detail'->'fr'->>'BaseText' As varchar) AS "Detail-fr-BaseText",
CAST("data"->'Detail'->'fr'->>'MetaDesc' As varchar) AS "Detail-fr-MetaDesc",
CAST("data"->'Detail'->'fr'->>'MetaTitle' As varchar) AS "Detail-fr-MetaTitle",
CAST("data"->'Detail'->'it'->>'Title' As varchar) AS "Detail-it-Title",
CAST("data"->'Detail'->'it'->>'BaseText' As varchar) AS "Detail-it-BaseText",
CAST("data"->'Detail'->'it'->>'Language' As varchar) AS "Detail-it-Language",
CAST("data"->'Detail'->'it'->>'MetaDesc' As varchar) AS "Detail-it-MetaDesc",
CAST("data"->'Detail'->'it'->>'IntroText' As varchar) AS "Detail-it-IntroText",
CAST("data"->'Detail'->'it'->>'MetaTitle' As varchar) AS "Detail-it-MetaTitle",
CAST("data"->'Detail'->'it'->>'GetThereText' As varchar) AS "Detail-it-GetThereText",
CAST("data"->'Detail'->'nl'->>'Title' As varchar) AS "Detail-nl-Title",
CAST("data"->'Detail'->'nl'->>'BaseText' As varchar) AS "Detail-nl-BaseText",
CAST("data"->'Detail'->'nl'->>'MetaDesc' As varchar) AS "Detail-nl-MetaDesc",
CAST("data"->'Detail'->'nl'->>'MetaTitle' As varchar) AS "Detail-nl-MetaTitle",
CAST("data"->'Detail'->'pl'->>'Title' As varchar) AS "Detail-pl-Title",
CAST("data"->'Detail'->'pl'->>'BaseText' As varchar) AS "Detail-pl-BaseText",
CAST("data"->'Detail'->'pl'->>'MetaDesc' As varchar) AS "Detail-pl-MetaDesc",
CAST("data"->'Detail'->'pl'->>'MetaTitle' As varchar) AS "Detail-pl-MetaTitle",
CAST("data"->'Detail'->'ru'->>'Title' As varchar) AS "Detail-ru-Title",
CAST("data"->'Detail'->'ru'->>'BaseText' As varchar) AS "Detail-ru-BaseText",
CAST("data"->'Detail'->'ru'->>'MetaDesc' As varchar) AS "Detail-ru-MetaDesc",
CAST("data"->'Detail'->'ru'->>'MetaTitle' As varchar) AS "Detail-ru-MetaTitle",
CAST("data"->'Ratings'->>'Stamina' As varchar) AS "Ratings-Stamina",
CAST("data"->'Ratings'->>'Landscape' As varchar) AS "Ratings-Landscape",
CAST("data"->'Ratings'->>'Technique' As varchar) AS "Ratings-Technique",
CAST("data"->'Ratings'->>'Difficulty' As varchar) AS "Ratings-Difficulty",
CAST("data"->'Ratings'->>'Experience' As varchar) AS "Ratings-Experience",
CAST("data"->'GpsPoints'->'position'->>'Gpstype' As varchar) AS "GpsPoints-position-Gpstype",
CAST("data"->'GpsPoints'->'position'->>'Altitude' As float) AS "GpsPoints-position-Altitude",
CAST("data"->'GpsPoints'->'position'->>'Latitude' As float) AS "GpsPoints-position-Latitude",
CAST("data"->'GpsPoints'->'position'->>'Longitude' As float) AS "GpsPoints-position-Longitude",
CAST("data"->'GpsPoints'->'position'->>'AltitudeUnitofMeasure' As varchar) AS "GpsPoints-position-AltitudeUnitofMeasure",
CAST("data"->'GpsPoints'->'arrivalpoint'->>'Gpstype' As varchar) AS "GpsPoints-arrivalpoint-Gpstype",
CAST("data"->'GpsPoints'->'arrivalpoint'->>'Altitude' As float) AS "GpsPoints-arrivalpoint-Altitude",
CAST("data"->'GpsPoints'->'arrivalpoint'->>'Latitude' As float) AS "GpsPoints-arrivalpoint-Latitude",
CAST("data"->'GpsPoints'->'arrivalpoint'->>'Longitude' As float) AS "GpsPoints-arrivalpoint-Longitude",
CAST("data"->'GpsPoints'->'arrivalpoint'->>'AltitudeUnitofMeasure' As varchar) AS "GpsPoints-arrivalpoint-AltitudeUnitofMeasure",
CAST("data"->'GpsPoints'->'startingpoint'->>'Gpstype' As varchar) AS "GpsPoints-startingpoint-Gpstype",
CAST("data"->'GpsPoints'->'startingpoint'->>'Altitude' As float) AS "GpsPoints-startingpoint-Altitude",
CAST("data"->'GpsPoints'->'startingpoint'->>'Latitude' As float) AS "GpsPoints-startingpoint-Latitude",
CAST("data"->'GpsPoints'->'startingpoint'->>'Longitude' As float) AS "GpsPoints-startingpoint-Longitude",
CAST("data"->'GpsPoints'->'startingpoint'->>'AltitudeUnitofMeasure' As varchar) AS "GpsPoints-startingpoint-AltitudeUnitofMeasure",
CAST("data"->'ContactInfos'->'de'->>'Url' As varchar) AS "ContactInfos-de-Url",
CAST("data"->'ContactInfos'->'de'->>'City' As varchar) AS "ContactInfos-de-City",
CAST("data"->'ContactInfos'->'de'->>'Email' As varchar) AS "ContactInfos-de-Email",
CAST("data"->'ContactInfos'->'de'->>'Address' As varchar) AS "ContactInfos-de-Address",
CAST("data"->'ContactInfos'->'de'->>'Surname' As varchar) AS "ContactInfos-de-Surname",
CAST("data"->'ContactInfos'->'de'->>'ZipCode' As varchar) AS "ContactInfos-de-ZipCode",
CAST("data"->'ContactInfos'->'de'->>'Language' As varchar) AS "ContactInfos-de-Language",
CAST("data"->'ContactInfos'->'de'->>'Faxnumber' As varchar) AS "ContactInfos-de-Faxnumber",
CAST("data"->'ContactInfos'->'de'->>'Givenname' As varchar) AS "ContactInfos-de-Givenname",
CAST("data"->'ContactInfos'->'de'->>'NamePrefix' As varchar) AS "ContactInfos-de-NamePrefix",
CAST("data"->'ContactInfos'->'de'->>'CompanyName' As varchar) AS "ContactInfos-de-CompanyName",
CAST("data"->'ContactInfos'->'de'->>'CountryCode' As varchar) AS "ContactInfos-de-CountryCode",
CAST("data"->'ContactInfos'->'de'->>'CountryName' As varchar) AS "ContactInfos-de-CountryName",
CAST("data"->'ContactInfos'->'de'->>'Phonenumber' As varchar) AS "ContactInfos-de-Phonenumber",
CAST("data"->'ContactInfos'->'en'->>'Url' As varchar) AS "ContactInfos-en-Url",
CAST("data"->'ContactInfos'->'en'->>'City' As varchar) AS "ContactInfos-en-City",
CAST("data"->'ContactInfos'->'en'->>'Email' As varchar) AS "ContactInfos-en-Email",
CAST("data"->'ContactInfos'->'en'->>'Address' As varchar) AS "ContactInfos-en-Address",
CAST("data"->'ContactInfos'->'en'->>'Surname' As varchar) AS "ContactInfos-en-Surname",
CAST("data"->'ContactInfos'->'en'->>'ZipCode' As varchar) AS "ContactInfos-en-ZipCode",
CAST("data"->'ContactInfos'->'en'->>'Language' As varchar) AS "ContactInfos-en-Language",
CAST("data"->'ContactInfos'->'en'->>'Faxnumber' As varchar) AS "ContactInfos-en-Faxnumber",
CAST("data"->'ContactInfos'->'en'->>'Givenname' As varchar) AS "ContactInfos-en-Givenname",
CAST("data"->'ContactInfos'->'en'->>'NamePrefix' As varchar) AS "ContactInfos-en-NamePrefix",
CAST("data"->'ContactInfos'->'en'->>'CompanyName' As varchar) AS "ContactInfos-en-CompanyName",
CAST("data"->'ContactInfos'->'en'->>'CountryCode' As varchar) AS "ContactInfos-en-CountryCode",
CAST("data"->'ContactInfos'->'en'->>'CountryName' As varchar) AS "ContactInfos-en-CountryName",
CAST("data"->'ContactInfos'->'en'->>'Phonenumber' As varchar) AS "ContactInfos-en-Phonenumber",
CAST("data"->'ContactInfos'->'it'->>'Url' As varchar) AS "ContactInfos-it-Url",
CAST("data"->'ContactInfos'->'it'->>'City' As varchar) AS "ContactInfos-it-City",
CAST("data"->'ContactInfos'->'it'->>'Email' As varchar) AS "ContactInfos-it-Email",
CAST("data"->'ContactInfos'->'it'->>'Address' As varchar) AS "ContactInfos-it-Address",
CAST("data"->'ContactInfos'->'it'->>'Surname' As varchar) AS "ContactInfos-it-Surname",
CAST("data"->'ContactInfos'->'it'->>'ZipCode' As varchar) AS "ContactInfos-it-ZipCode",
CAST("data"->'ContactInfos'->'it'->>'Language' As varchar) AS "ContactInfos-it-Language",
CAST("data"->'ContactInfos'->'it'->>'Faxnumber' As varchar) AS "ContactInfos-it-Faxnumber",
CAST("data"->'ContactInfos'->'it'->>'Givenname' As varchar) AS "ContactInfos-it-Givenname",
CAST("data"->'ContactInfos'->'it'->>'NamePrefix' As varchar) AS "ContactInfos-it-NamePrefix",
CAST("data"->'ContactInfos'->'it'->>'CompanyName' As varchar) AS "ContactInfos-it-CompanyName",
CAST("data"->'ContactInfos'->'it'->>'CountryCode' As varchar) AS "ContactInfos-it-CountryCode",
CAST("data"->'ContactInfos'->'it'->>'CountryName' As varchar) AS "ContactInfos-it-CountryName",
CAST("data"->'ContactInfos'->'it'->>'Phonenumber' As varchar) AS "ContactInfos-it-Phonenumber",
CAST("data"->'LocationInfo'->'TvInfo'->>'Id' As varchar) AS "LocationInfo-TvInfo-Id",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-TvInfo-Name-cs",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'de' As varchar) AS "LocationInfo-TvInfo-Name-de",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'en' As varchar) AS "LocationInfo-TvInfo-Name-en",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-TvInfo-Name-fr",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'it' As varchar) AS "LocationInfo-TvInfo-Name-it",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-TvInfo-Name-nl",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-TvInfo-Name-pl",
CAST("data"->'LocationInfo'->'TvInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-TvInfo-Name-ru",
CAST("data"->'LocationInfo'->'RegionInfo'->>'Id' As varchar) AS "LocationInfo-RegionInfo-Id",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-RegionInfo-Name-cs",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'de' As varchar) AS "LocationInfo-RegionInfo-Name-de",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'en' As varchar) AS "LocationInfo-RegionInfo-Name-en",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-RegionInfo-Name-fr",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'it' As varchar) AS "LocationInfo-RegionInfo-Name-it",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-RegionInfo-Name-nl",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-RegionInfo-Name-pl",
CAST("data"->'LocationInfo'->'RegionInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-RegionInfo-Name-ru",
CAST("data"->'LocationInfo'->'DistrictInfo'->>'Id' As varchar) AS "LocationInfo-DistrictInfo-Id",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-DistrictInfo-Name-cs",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'de' As varchar) AS "LocationInfo-DistrictInfo-Name-de",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'en' As varchar) AS "LocationInfo-DistrictInfo-Name-en",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-DistrictInfo-Name-fr",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'it' As varchar) AS "LocationInfo-DistrictInfo-Name-it",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-DistrictInfo-Name-nl",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-DistrictInfo-Name-pl",
CAST("data"->'LocationInfo'->'DistrictInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-DistrictInfo-Name-ru",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->>'Id' As varchar) AS "LocationInfo-MunicipalityInfo-Id",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'cs' As varchar) AS "LocationInfo-MunicipalityInfo-Name-cs",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'de' As varchar) AS "LocationInfo-MunicipalityInfo-Name-de",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'en' As varchar) AS "LocationInfo-MunicipalityInfo-Name-en",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'fr' As varchar) AS "LocationInfo-MunicipalityInfo-Name-fr",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'it' As varchar) AS "LocationInfo-MunicipalityInfo-Name-it",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'nl' As varchar) AS "LocationInfo-MunicipalityInfo-Name-nl",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'pl' As varchar) AS "LocationInfo-MunicipalityInfo-Name-pl",
CAST("data"->'LocationInfo'->'MunicipalityInfo'->'Name'->>'ru' As varchar) AS "LocationInfo-MunicipalityInfo-Name-ru",
CAST("data"->'AdditionalPoiInfos'->'cs'->>'Novelty' As varchar) AS "AdditionalPoiInfos-cs-Novelty",
CAST("data"->'AdditionalPoiInfos'->'cs'->>'PoiType' As varchar) AS "AdditionalPoiInfos-cs-PoiType",
CAST("data"->'AdditionalPoiInfos'->'cs'->>'SubType' As varchar) AS "AdditionalPoiInfos-cs-SubType",
CAST("data"->'AdditionalPoiInfos'->'cs'->>'Language' As varchar) AS "AdditionalPoiInfos-cs-Language",
CAST("data"->'AdditionalPoiInfos'->'cs'->>'MainType' As varchar) AS "AdditionalPoiInfos-cs-MainType",
CAST("data"->'AdditionalPoiInfos'->'de'->>'PoiType' As varchar) AS "AdditionalPoiInfos-de-PoiType",
CAST("data"->'AdditionalPoiInfos'->'de'->>'SubType' As varchar) AS "AdditionalPoiInfos-de-SubType",
CAST("data"->'AdditionalPoiInfos'->'de'->>'Language' As varchar) AS "AdditionalPoiInfos-de-Language",
CAST("data"->'AdditionalPoiInfos'->'de'->>'MainType' As varchar) AS "AdditionalPoiInfos-de-MainType",
CAST("data"->'AdditionalPoiInfos'->'en'->>'PoiType' As varchar) AS "AdditionalPoiInfos-en-PoiType",
CAST("data"->'AdditionalPoiInfos'->'en'->>'SubType' As varchar) AS "AdditionalPoiInfos-en-SubType",
CAST("data"->'AdditionalPoiInfos'->'en'->>'Language' As varchar) AS "AdditionalPoiInfos-en-Language",
CAST("data"->'AdditionalPoiInfos'->'en'->>'MainType' As varchar) AS "AdditionalPoiInfos-en-MainType",
CAST("data"->'AdditionalPoiInfos'->'fr'->>'Novelty' As varchar) AS "AdditionalPoiInfos-fr-Novelty",
CAST("data"->'AdditionalPoiInfos'->'fr'->>'PoiType' As varchar) AS "AdditionalPoiInfos-fr-PoiType",
CAST("data"->'AdditionalPoiInfos'->'fr'->>'SubType' As varchar) AS "AdditionalPoiInfos-fr-SubType",
CAST("data"->'AdditionalPoiInfos'->'fr'->>'Language' As varchar) AS "AdditionalPoiInfos-fr-Language",
CAST("data"->'AdditionalPoiInfos'->'fr'->>'MainType' As varchar) AS "AdditionalPoiInfos-fr-MainType",
CAST("data"->'AdditionalPoiInfos'->'it'->>'PoiType' As varchar) AS "AdditionalPoiInfos-it-PoiType",
CAST("data"->'AdditionalPoiInfos'->'it'->>'SubType' As varchar) AS "AdditionalPoiInfos-it-SubType",
CAST("data"->'AdditionalPoiInfos'->'it'->>'Language' As varchar) AS "AdditionalPoiInfos-it-Language",
CAST("data"->'AdditionalPoiInfos'->'it'->>'MainType' As varchar) AS "AdditionalPoiInfos-it-MainType",
CAST("data"->'AdditionalPoiInfos'->'nl'->>'Novelty' As varchar) AS "AdditionalPoiInfos-nl-Novelty",
CAST("data"->'AdditionalPoiInfos'->'nl'->>'PoiType' As varchar) AS "AdditionalPoiInfos-nl-PoiType",
CAST("data"->'AdditionalPoiInfos'->'nl'->>'SubType' As varchar) AS "AdditionalPoiInfos-nl-SubType",
CAST("data"->'AdditionalPoiInfos'->'nl'->>'Language' As varchar) AS "AdditionalPoiInfos-nl-Language",
CAST("data"->'AdditionalPoiInfos'->'nl'->>'MainType' As varchar) AS "AdditionalPoiInfos-nl-MainType",
CAST("data"->'AdditionalPoiInfos'->'pl'->>'Novelty' As varchar) AS "AdditionalPoiInfos-pl-Novelty",
CAST("data"->'AdditionalPoiInfos'->'pl'->>'PoiType' As varchar) AS "AdditionalPoiInfos-pl-PoiType",
CAST("data"->'AdditionalPoiInfos'->'pl'->>'SubType' As varchar) AS "AdditionalPoiInfos-pl-SubType",
CAST("data"->'AdditionalPoiInfos'->'pl'->>'Language' As varchar) AS "AdditionalPoiInfos-pl-Language",
CAST("data"->'AdditionalPoiInfos'->'pl'->>'MainType' As varchar) AS "AdditionalPoiInfos-pl-MainType",
CAST("data"->'AdditionalPoiInfos'->'ru'->>'Novelty' As varchar) AS "AdditionalPoiInfos-ru-Novelty",
CAST("data"->'AdditionalPoiInfos'->'ru'->>'PoiType' As varchar) AS "AdditionalPoiInfos-ru-PoiType",
CAST("data"->'AdditionalPoiInfos'->'ru'->>'SubType' As varchar) AS "AdditionalPoiInfos-ru-SubType",
CAST("data"->'AdditionalPoiInfos'->'ru'->>'Language' As varchar) AS "AdditionalPoiInfos-ru-Language",
CAST("data"->'AdditionalPoiInfos'->'ru'->>'MainType' As varchar) AS "AdditionalPoiInfos-ru-MainType"
FROM smgpoisopen;

CREATE UNIQUE INDEX "v_smgpoisopen_pk" ON "v_smgpoisopen"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_smgpoisopen_AreaId";

CREATE MATERIALIZED VIEW "v_smgpoisopen_AreaId" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'AreaId') AS "data"
        FROM smgpoisopen
        WHERE data -> 'AreaId' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_smgpoisopen_SmgTags";

CREATE MATERIALIZED VIEW "v_smgpoisopen_SmgTags" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'SmgTags') AS "data"
        FROM smgpoisopen
        WHERE data -> 'SmgTags' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_smgpoisopen_Exposition";

CREATE MATERIALIZED VIEW "v_smgpoisopen_Exposition" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'Exposition') AS "data"
        FROM smgpoisopen
        WHERE data -> 'Exposition' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_smgpoisopen_HasLanguage";

CREATE MATERIALIZED VIEW "v_smgpoisopen_HasLanguage" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'HasLanguage') AS "data"
        FROM smgpoisopen
        WHERE data -> 'HasLanguage' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_smgpoisopen_GpsInfo";

CREATE MATERIALIZED VIEW "v_smgpoisopen_GpsInfo" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'GpsInfo') AS "Feature"
        FROM smgpoisopen
        WHERE data -> 'GpsInfo' != 'null')
    SELECT "Id" AS "smgpoisopen_Id", CAST("data"->>'Gpstype' As varchar) AS "Gpstype",
CAST("data"->>'Altitude' As float) AS "Altitude",
CAST("data"->>'Latitude' As float) AS "Latitude",
CAST("data"->>'Longitude' As float) AS "Longitude",
CAST("data"->>'AltitudeUnitofMeasure' As varchar) AS "AltitudeUnitofMeasure"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS "v_smgpoisopen_GpsTrack";

CREATE MATERIALIZED VIEW "v_smgpoisopen_GpsTrack" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'GpsTrack') AS "Feature"
        FROM smgpoisopen
        WHERE data -> 'GpsTrack' != 'null')
    SELECT "Id" AS "smgpoisopen_Id", CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Type' As varchar) AS "Type",
CAST("data"->>'GpxTrackUrl' As varchar) AS "GpxTrackUrl",
CAST("data"->'GpxTrackDesc'->>'de' As varchar) AS "GpxTrackDesc-de",
CAST("data"->'GpxTrackDesc'->>'en' As varchar) AS "GpxTrackDesc-en",
CAST("data"->'GpxTrackDesc'->>'it' As varchar) AS "GpxTrackDesc-it"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS "v_smgpoisopen_OperationSchedule";

CREATE MATERIALIZED VIEW "v_smgpoisopen_OperationSchedule" AS
    WITH t ("Id", "data") AS (
        SELECT id AS "Id", jsonb_array_elements("data" -> 'OperationSchedule') AS "Feature"
        FROM smgpoisopen
        WHERE data -> 'OperationSchedule' != 'null')
    SELECT "Id" AS "smgpoisopen_Id", CAST("data"->>'Stop' As varchar) AS "Stop",
CAST("data"->>'Type' As varchar) AS "Type",
CAST("data"->>'Start' As varchar) AS "Start",
CAST("data"->'OperationscheduleName'->>'de' As varchar) AS "OperationscheduleName-de"
    FROM t;

DROP MATERIALIZED VIEW IF EXISTS  "v_smgtags";

CREATE MATERIALIZED VIEW "v_smgtags" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'MainEntity' As varchar) AS "MainEntity",
CAST("data"->'TagName'->>'de' As varchar) AS "TagName-de"
FROM smgtags;

CREATE UNIQUE INDEX "v_smgtags_pk" ON "v_smgtags"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_smgtags_ValidForEntity";

CREATE MATERIALIZED VIEW "v_smgtags_ValidForEntity" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'ValidForEntity') AS "data"
        FROM smgtags
        WHERE data -> 'ValidForEntity' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS  "v_suedtiroltypes";

CREATE MATERIALIZED VIEW "v_suedtiroltypes" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Key' As varchar) AS "Key",
CAST("data"->>'Level' As integer) AS "Level",
CAST("data"->>'Entity' As varchar) AS "Entity",
CAST("data"->>'TypeParent' As varchar) AS "TypeParent",
CAST("data"->'TypeNames'->>'cs' As varchar) AS "TypeNames-cs",
CAST("data"->'TypeNames'->>'de' As varchar) AS "TypeNames-de",
CAST("data"->'TypeNames'->>'en' As varchar) AS "TypeNames-en",
CAST("data"->'TypeNames'->>'fr' As varchar) AS "TypeNames-fr",
CAST("data"->'TypeNames'->>'it' As varchar) AS "TypeNames-it",
CAST("data"->'TypeNames'->>'nl' As varchar) AS "TypeNames-nl",
CAST("data"->'TypeNames'->>'pl' As varchar) AS "TypeNames-pl",
CAST("data"->'TypeNames'->>'ru' As varchar) AS "TypeNames-ru"
FROM suedtiroltypes;

CREATE UNIQUE INDEX "v_suedtiroltypes_pk" ON "v_suedtiroltypes"("Id");

DROP MATERIALIZED VIEW IF EXISTS  "v_tvsopen";

CREATE MATERIALIZED VIEW "v_tvsopen" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'Gpstype' As varchar) AS "Gpstype",
CAST("data"->>'Altitude' As float) AS "Altitude",
CAST("data"->>'CustomId' As varchar) AS "CustomId",
CAST("data"->>'Latitude' As float) AS "Latitude",
CAST("data"->>'RegionId' As varchar) AS "RegionId",
CAST("data"->>'Longitude' As float) AS "Longitude",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'LastChange' As varchar) AS "LastChange",
CAST("data"->>'VisibleInSearch' As bool) AS "VisibleInSearch",
CAST("data"->>'AltitudeUnitofMeasure' As varchar) AS "AltitudeUnitofMeasure",
CAST("data"->'Detail'->'cs'->>'Title' As varchar) AS "Detail-cs-Title",
CAST("data"->'Detail'->'cs'->>'Header' As varchar) AS "Detail-cs-Header",
CAST("data"->'Detail'->'cs'->>'BaseText' As varchar) AS "Detail-cs-BaseText",
CAST("data"->'Detail'->'cs'->>'Language' As varchar) AS "Detail-cs-Language",
CAST("data"->'Detail'->'cs'->>'MetaDesc' As varchar) AS "Detail-cs-MetaDesc",
CAST("data"->'Detail'->'cs'->>'IntroText' As varchar) AS "Detail-cs-IntroText",
CAST("data"->'Detail'->'cs'->>'MetaTitle' As varchar) AS "Detail-cs-MetaTitle",
CAST("data"->'Detail'->'cs'->>'SubHeader' As varchar) AS "Detail-cs-SubHeader",
CAST("data"->'Detail'->'cs'->>'GetThereText' As varchar) AS "Detail-cs-GetThereText",
CAST("data"->'Detail'->'cs'->>'AdditionalText' As varchar) AS "Detail-cs-AdditionalText",
CAST("data"->'Detail'->'de'->>'Title' As varchar) AS "Detail-de-Title",
CAST("data"->'Detail'->'de'->>'Header' As varchar) AS "Detail-de-Header",
CAST("data"->'Detail'->'de'->>'BaseText' As varchar) AS "Detail-de-BaseText",
CAST("data"->'Detail'->'de'->>'Language' As varchar) AS "Detail-de-Language",
CAST("data"->'Detail'->'de'->>'MetaDesc' As varchar) AS "Detail-de-MetaDesc",
CAST("data"->'Detail'->'de'->>'IntroText' As varchar) AS "Detail-de-IntroText",
CAST("data"->'Detail'->'de'->>'MetaTitle' As varchar) AS "Detail-de-MetaTitle",
CAST("data"->'Detail'->'de'->>'SubHeader' As varchar) AS "Detail-de-SubHeader",
CAST("data"->'Detail'->'en'->>'Title' As varchar) AS "Detail-en-Title",
CAST("data"->'Detail'->'en'->>'Header' As varchar) AS "Detail-en-Header",
CAST("data"->'Detail'->'en'->>'BaseText' As varchar) AS "Detail-en-BaseText",
CAST("data"->'Detail'->'en'->>'Language' As varchar) AS "Detail-en-Language",
CAST("data"->'Detail'->'en'->>'MetaDesc' As varchar) AS "Detail-en-MetaDesc",
CAST("data"->'Detail'->'en'->>'IntroText' As varchar) AS "Detail-en-IntroText",
CAST("data"->'Detail'->'en'->>'MetaTitle' As varchar) AS "Detail-en-MetaTitle",
CAST("data"->'Detail'->'en'->>'SubHeader' As varchar) AS "Detail-en-SubHeader",
CAST("data"->'Detail'->'en'->>'GetThereText' As varchar) AS "Detail-en-GetThereText",
CAST("data"->'Detail'->'en'->>'AdditionalText' As varchar) AS "Detail-en-AdditionalText",
CAST("data"->'Detail'->'fr'->>'Title' As varchar) AS "Detail-fr-Title",
CAST("data"->'Detail'->'fr'->>'Header' As varchar) AS "Detail-fr-Header",
CAST("data"->'Detail'->'fr'->>'BaseText' As varchar) AS "Detail-fr-BaseText",
CAST("data"->'Detail'->'fr'->>'Language' As varchar) AS "Detail-fr-Language",
CAST("data"->'Detail'->'fr'->>'MetaDesc' As varchar) AS "Detail-fr-MetaDesc",
CAST("data"->'Detail'->'fr'->>'IntroText' As varchar) AS "Detail-fr-IntroText",
CAST("data"->'Detail'->'fr'->>'MetaTitle' As varchar) AS "Detail-fr-MetaTitle",
CAST("data"->'Detail'->'fr'->>'SubHeader' As varchar) AS "Detail-fr-SubHeader",
CAST("data"->'Detail'->'fr'->>'GetThereText' As varchar) AS "Detail-fr-GetThereText",
CAST("data"->'Detail'->'fr'->>'AdditionalText' As varchar) AS "Detail-fr-AdditionalText",
CAST("data"->'Detail'->'it'->>'Title' As varchar) AS "Detail-it-Title",
CAST("data"->'Detail'->'it'->>'Header' As varchar) AS "Detail-it-Header",
CAST("data"->'Detail'->'it'->>'BaseText' As varchar) AS "Detail-it-BaseText",
CAST("data"->'Detail'->'it'->>'Language' As varchar) AS "Detail-it-Language",
CAST("data"->'Detail'->'it'->>'MetaDesc' As varchar) AS "Detail-it-MetaDesc",
CAST("data"->'Detail'->'it'->>'IntroText' As varchar) AS "Detail-it-IntroText",
CAST("data"->'Detail'->'it'->>'MetaTitle' As varchar) AS "Detail-it-MetaTitle",
CAST("data"->'Detail'->'it'->>'SubHeader' As varchar) AS "Detail-it-SubHeader",
CAST("data"->'Detail'->'it'->>'GetThereText' As varchar) AS "Detail-it-GetThereText",
CAST("data"->'Detail'->'it'->>'AdditionalText' As varchar) AS "Detail-it-AdditionalText",
CAST("data"->'Detail'->'nl'->>'Title' As varchar) AS "Detail-nl-Title",
CAST("data"->'Detail'->'nl'->>'Header' As varchar) AS "Detail-nl-Header",
CAST("data"->'Detail'->'nl'->>'BaseText' As varchar) AS "Detail-nl-BaseText",
CAST("data"->'Detail'->'nl'->>'Language' As varchar) AS "Detail-nl-Language",
CAST("data"->'Detail'->'nl'->>'MetaDesc' As varchar) AS "Detail-nl-MetaDesc",
CAST("data"->'Detail'->'nl'->>'IntroText' As varchar) AS "Detail-nl-IntroText",
CAST("data"->'Detail'->'nl'->>'MetaTitle' As varchar) AS "Detail-nl-MetaTitle",
CAST("data"->'Detail'->'nl'->>'SubHeader' As varchar) AS "Detail-nl-SubHeader",
CAST("data"->'Detail'->'nl'->>'GetThereText' As varchar) AS "Detail-nl-GetThereText",
CAST("data"->'Detail'->'nl'->>'AdditionalText' As varchar) AS "Detail-nl-AdditionalText",
CAST("data"->'Detail'->'pl'->>'Title' As varchar) AS "Detail-pl-Title",
CAST("data"->'Detail'->'pl'->>'Header' As varchar) AS "Detail-pl-Header",
CAST("data"->'Detail'->'pl'->>'BaseText' As varchar) AS "Detail-pl-BaseText",
CAST("data"->'Detail'->'pl'->>'Language' As varchar) AS "Detail-pl-Language",
CAST("data"->'Detail'->'pl'->>'MetaDesc' As varchar) AS "Detail-pl-MetaDesc",
CAST("data"->'Detail'->'pl'->>'IntroText' As varchar) AS "Detail-pl-IntroText",
CAST("data"->'Detail'->'pl'->>'MetaTitle' As varchar) AS "Detail-pl-MetaTitle",
CAST("data"->'Detail'->'pl'->>'SubHeader' As varchar) AS "Detail-pl-SubHeader",
CAST("data"->'Detail'->'pl'->>'GetThereText' As varchar) AS "Detail-pl-GetThereText",
CAST("data"->'Detail'->'pl'->>'AdditionalText' As varchar) AS "Detail-pl-AdditionalText",
CAST("data"->'Detail'->'ru'->>'Title' As varchar) AS "Detail-ru-Title",
CAST("data"->'Detail'->'ru'->>'Header' As varchar) AS "Detail-ru-Header",
CAST("data"->'Detail'->'ru'->>'BaseText' As varchar) AS "Detail-ru-BaseText",
CAST("data"->'Detail'->'ru'->>'Language' As varchar) AS "Detail-ru-Language",
CAST("data"->'Detail'->'ru'->>'MetaDesc' As varchar) AS "Detail-ru-MetaDesc",
CAST("data"->'Detail'->'ru'->>'IntroText' As varchar) AS "Detail-ru-IntroText",
CAST("data"->'Detail'->'ru'->>'MetaTitle' As varchar) AS "Detail-ru-MetaTitle",
CAST("data"->'Detail'->'ru'->>'SubHeader' As varchar) AS "Detail-ru-SubHeader",
CAST("data"->'Detail'->'ru'->>'GetThereText' As varchar) AS "Detail-ru-GetThereText",
CAST("data"->'Detail'->'ru'->>'AdditionalText' As varchar) AS "Detail-ru-AdditionalText",
CAST("data"->'ContactInfos'->'cs'->>'Url' As varchar) AS "ContactInfos-cs-Url",
CAST("data"->'ContactInfos'->'cs'->>'Vat' As varchar) AS "ContactInfos-cs-Vat",
CAST("data"->'ContactInfos'->'cs'->>'City' As varchar) AS "ContactInfos-cs-City",
CAST("data"->'ContactInfos'->'cs'->>'Email' As varchar) AS "ContactInfos-cs-Email",
CAST("data"->'ContactInfos'->'cs'->>'Address' As varchar) AS "ContactInfos-cs-Address",
CAST("data"->'ContactInfos'->'cs'->>'LogoUrl' As varchar) AS "ContactInfos-cs-LogoUrl",
CAST("data"->'ContactInfos'->'cs'->>'Surname' As varchar) AS "ContactInfos-cs-Surname",
CAST("data"->'ContactInfos'->'cs'->>'ZipCode' As varchar) AS "ContactInfos-cs-ZipCode",
CAST("data"->'ContactInfos'->'cs'->>'Language' As varchar) AS "ContactInfos-cs-Language",
CAST("data"->'ContactInfos'->'cs'->>'Faxnumber' As varchar) AS "ContactInfos-cs-Faxnumber",
CAST("data"->'ContactInfos'->'cs'->>'Givenname' As varchar) AS "ContactInfos-cs-Givenname",
CAST("data"->'ContactInfos'->'cs'->>'NamePrefix' As varchar) AS "ContactInfos-cs-NamePrefix",
CAST("data"->'ContactInfos'->'cs'->>'CompanyName' As varchar) AS "ContactInfos-cs-CompanyName",
CAST("data"->'ContactInfos'->'cs'->>'CountryCode' As varchar) AS "ContactInfos-cs-CountryCode",
CAST("data"->'ContactInfos'->'cs'->>'CountryName' As varchar) AS "ContactInfos-cs-CountryName",
CAST("data"->'ContactInfos'->'cs'->>'Phonenumber' As varchar) AS "ContactInfos-cs-Phonenumber",
CAST("data"->'ContactInfos'->'de'->>'Url' As varchar) AS "ContactInfos-de-Url",
CAST("data"->'ContactInfos'->'de'->>'City' As varchar) AS "ContactInfos-de-City",
CAST("data"->'ContactInfos'->'de'->>'Email' As varchar) AS "ContactInfos-de-Email",
CAST("data"->'ContactInfos'->'de'->>'Address' As varchar) AS "ContactInfos-de-Address",
CAST("data"->'ContactInfos'->'de'->>'LogoUrl' As varchar) AS "ContactInfos-de-LogoUrl",
CAST("data"->'ContactInfos'->'de'->>'ZipCode' As varchar) AS "ContactInfos-de-ZipCode",
CAST("data"->'ContactInfos'->'de'->>'Language' As varchar) AS "ContactInfos-de-Language",
CAST("data"->'ContactInfos'->'de'->>'CompanyName' As varchar) AS "ContactInfos-de-CompanyName",
CAST("data"->'ContactInfos'->'de'->>'CountryCode' As varchar) AS "ContactInfos-de-CountryCode",
CAST("data"->'ContactInfos'->'de'->>'CountryName' As varchar) AS "ContactInfos-de-CountryName",
CAST("data"->'ContactInfos'->'de'->>'Phonenumber' As varchar) AS "ContactInfos-de-Phonenumber",
CAST("data"->'ContactInfos'->'en'->>'Url' As varchar) AS "ContactInfos-en-Url",
CAST("data"->'ContactInfos'->'en'->>'Vat' As varchar) AS "ContactInfos-en-Vat",
CAST("data"->'ContactInfos'->'en'->>'City' As varchar) AS "ContactInfos-en-City",
CAST("data"->'ContactInfos'->'en'->>'Email' As varchar) AS "ContactInfos-en-Email",
CAST("data"->'ContactInfos'->'en'->>'Address' As varchar) AS "ContactInfos-en-Address",
CAST("data"->'ContactInfos'->'en'->>'LogoUrl' As varchar) AS "ContactInfos-en-LogoUrl",
CAST("data"->'ContactInfos'->'en'->>'Surname' As varchar) AS "ContactInfos-en-Surname",
CAST("data"->'ContactInfos'->'en'->>'ZipCode' As varchar) AS "ContactInfos-en-ZipCode",
CAST("data"->'ContactInfos'->'en'->>'Language' As varchar) AS "ContactInfos-en-Language",
CAST("data"->'ContactInfos'->'en'->>'Faxnumber' As varchar) AS "ContactInfos-en-Faxnumber",
CAST("data"->'ContactInfos'->'en'->>'Givenname' As varchar) AS "ContactInfos-en-Givenname",
CAST("data"->'ContactInfos'->'en'->>'NamePrefix' As varchar) AS "ContactInfos-en-NamePrefix",
CAST("data"->'ContactInfos'->'en'->>'CompanyName' As varchar) AS "ContactInfos-en-CompanyName",
CAST("data"->'ContactInfos'->'en'->>'CountryCode' As varchar) AS "ContactInfos-en-CountryCode",
CAST("data"->'ContactInfos'->'en'->>'CountryName' As varchar) AS "ContactInfos-en-CountryName",
CAST("data"->'ContactInfos'->'en'->>'Phonenumber' As varchar) AS "ContactInfos-en-Phonenumber",
CAST("data"->'ContactInfos'->'fr'->>'Url' As varchar) AS "ContactInfos-fr-Url",
CAST("data"->'ContactInfos'->'fr'->>'Vat' As varchar) AS "ContactInfos-fr-Vat",
CAST("data"->'ContactInfos'->'fr'->>'City' As varchar) AS "ContactInfos-fr-City",
CAST("data"->'ContactInfos'->'fr'->>'Email' As varchar) AS "ContactInfos-fr-Email",
CAST("data"->'ContactInfos'->'fr'->>'Address' As varchar) AS "ContactInfos-fr-Address",
CAST("data"->'ContactInfos'->'fr'->>'LogoUrl' As varchar) AS "ContactInfos-fr-LogoUrl",
CAST("data"->'ContactInfos'->'fr'->>'Surname' As varchar) AS "ContactInfos-fr-Surname",
CAST("data"->'ContactInfos'->'fr'->>'ZipCode' As varchar) AS "ContactInfos-fr-ZipCode",
CAST("data"->'ContactInfos'->'fr'->>'Language' As varchar) AS "ContactInfos-fr-Language",
CAST("data"->'ContactInfos'->'fr'->>'Faxnumber' As varchar) AS "ContactInfos-fr-Faxnumber",
CAST("data"->'ContactInfos'->'fr'->>'Givenname' As varchar) AS "ContactInfos-fr-Givenname",
CAST("data"->'ContactInfos'->'fr'->>'NamePrefix' As varchar) AS "ContactInfos-fr-NamePrefix",
CAST("data"->'ContactInfos'->'fr'->>'CompanyName' As varchar) AS "ContactInfos-fr-CompanyName",
CAST("data"->'ContactInfos'->'fr'->>'CountryCode' As varchar) AS "ContactInfos-fr-CountryCode",
CAST("data"->'ContactInfos'->'fr'->>'CountryName' As varchar) AS "ContactInfos-fr-CountryName",
CAST("data"->'ContactInfos'->'fr'->>'Phonenumber' As varchar) AS "ContactInfos-fr-Phonenumber",
CAST("data"->'ContactInfos'->'it'->>'Url' As varchar) AS "ContactInfos-it-Url",
CAST("data"->'ContactInfos'->'it'->>'Vat' As varchar) AS "ContactInfos-it-Vat",
CAST("data"->'ContactInfos'->'it'->>'City' As varchar) AS "ContactInfos-it-City",
CAST("data"->'ContactInfos'->'it'->>'Email' As varchar) AS "ContactInfos-it-Email",
CAST("data"->'ContactInfos'->'it'->>'Address' As varchar) AS "ContactInfos-it-Address",
CAST("data"->'ContactInfos'->'it'->>'LogoUrl' As varchar) AS "ContactInfos-it-LogoUrl",
CAST("data"->'ContactInfos'->'it'->>'Surname' As varchar) AS "ContactInfos-it-Surname",
CAST("data"->'ContactInfos'->'it'->>'ZipCode' As varchar) AS "ContactInfos-it-ZipCode",
CAST("data"->'ContactInfos'->'it'->>'Language' As varchar) AS "ContactInfos-it-Language",
CAST("data"->'ContactInfos'->'it'->>'Faxnumber' As varchar) AS "ContactInfos-it-Faxnumber",
CAST("data"->'ContactInfos'->'it'->>'Givenname' As varchar) AS "ContactInfos-it-Givenname",
CAST("data"->'ContactInfos'->'it'->>'NamePrefix' As varchar) AS "ContactInfos-it-NamePrefix",
CAST("data"->'ContactInfos'->'it'->>'CompanyName' As varchar) AS "ContactInfos-it-CompanyName",
CAST("data"->'ContactInfos'->'it'->>'CountryCode' As varchar) AS "ContactInfos-it-CountryCode",
CAST("data"->'ContactInfos'->'it'->>'CountryName' As varchar) AS "ContactInfos-it-CountryName",
CAST("data"->'ContactInfos'->'it'->>'Phonenumber' As varchar) AS "ContactInfos-it-Phonenumber",
CAST("data"->'ContactInfos'->'nl'->>'Url' As varchar) AS "ContactInfos-nl-Url",
CAST("data"->'ContactInfos'->'nl'->>'Vat' As varchar) AS "ContactInfos-nl-Vat",
CAST("data"->'ContactInfos'->'nl'->>'City' As varchar) AS "ContactInfos-nl-City",
CAST("data"->'ContactInfos'->'nl'->>'Email' As varchar) AS "ContactInfos-nl-Email",
CAST("data"->'ContactInfos'->'nl'->>'Address' As varchar) AS "ContactInfos-nl-Address",
CAST("data"->'ContactInfos'->'nl'->>'LogoUrl' As varchar) AS "ContactInfos-nl-LogoUrl",
CAST("data"->'ContactInfos'->'nl'->>'Surname' As varchar) AS "ContactInfos-nl-Surname",
CAST("data"->'ContactInfos'->'nl'->>'ZipCode' As varchar) AS "ContactInfos-nl-ZipCode",
CAST("data"->'ContactInfos'->'nl'->>'Language' As varchar) AS "ContactInfos-nl-Language",
CAST("data"->'ContactInfos'->'nl'->>'Faxnumber' As varchar) AS "ContactInfos-nl-Faxnumber",
CAST("data"->'ContactInfos'->'nl'->>'Givenname' As varchar) AS "ContactInfos-nl-Givenname",
CAST("data"->'ContactInfos'->'nl'->>'NamePrefix' As varchar) AS "ContactInfos-nl-NamePrefix",
CAST("data"->'ContactInfos'->'nl'->>'CompanyName' As varchar) AS "ContactInfos-nl-CompanyName",
CAST("data"->'ContactInfos'->'nl'->>'CountryCode' As varchar) AS "ContactInfos-nl-CountryCode",
CAST("data"->'ContactInfos'->'nl'->>'CountryName' As varchar) AS "ContactInfos-nl-CountryName",
CAST("data"->'ContactInfos'->'nl'->>'Phonenumber' As varchar) AS "ContactInfos-nl-Phonenumber",
CAST("data"->'ContactInfos'->'pl'->>'Url' As varchar) AS "ContactInfos-pl-Url",
CAST("data"->'ContactInfos'->'pl'->>'Vat' As varchar) AS "ContactInfos-pl-Vat",
CAST("data"->'ContactInfos'->'pl'->>'City' As varchar) AS "ContactInfos-pl-City",
CAST("data"->'ContactInfos'->'pl'->>'Email' As varchar) AS "ContactInfos-pl-Email",
CAST("data"->'ContactInfos'->'pl'->>'Address' As varchar) AS "ContactInfos-pl-Address",
CAST("data"->'ContactInfos'->'pl'->>'LogoUrl' As varchar) AS "ContactInfos-pl-LogoUrl",
CAST("data"->'ContactInfos'->'pl'->>'Surname' As varchar) AS "ContactInfos-pl-Surname",
CAST("data"->'ContactInfos'->'pl'->>'ZipCode' As varchar) AS "ContactInfos-pl-ZipCode",
CAST("data"->'ContactInfos'->'pl'->>'Language' As varchar) AS "ContactInfos-pl-Language",
CAST("data"->'ContactInfos'->'pl'->>'Faxnumber' As varchar) AS "ContactInfos-pl-Faxnumber",
CAST("data"->'ContactInfos'->'pl'->>'Givenname' As varchar) AS "ContactInfos-pl-Givenname",
CAST("data"->'ContactInfos'->'pl'->>'NamePrefix' As varchar) AS "ContactInfos-pl-NamePrefix",
CAST("data"->'ContactInfos'->'pl'->>'CompanyName' As varchar) AS "ContactInfos-pl-CompanyName",
CAST("data"->'ContactInfos'->'pl'->>'CountryCode' As varchar) AS "ContactInfos-pl-CountryCode",
CAST("data"->'ContactInfos'->'pl'->>'CountryName' As varchar) AS "ContactInfos-pl-CountryName",
CAST("data"->'ContactInfos'->'pl'->>'Phonenumber' As varchar) AS "ContactInfos-pl-Phonenumber",
CAST("data"->'ContactInfos'->'ru'->>'Url' As varchar) AS "ContactInfos-ru-Url",
CAST("data"->'ContactInfos'->'ru'->>'Vat' As varchar) AS "ContactInfos-ru-Vat",
CAST("data"->'ContactInfos'->'ru'->>'City' As varchar) AS "ContactInfos-ru-City",
CAST("data"->'ContactInfos'->'ru'->>'Email' As varchar) AS "ContactInfos-ru-Email",
CAST("data"->'ContactInfos'->'ru'->>'Address' As varchar) AS "ContactInfos-ru-Address",
CAST("data"->'ContactInfos'->'ru'->>'LogoUrl' As varchar) AS "ContactInfos-ru-LogoUrl",
CAST("data"->'ContactInfos'->'ru'->>'Surname' As varchar) AS "ContactInfos-ru-Surname",
CAST("data"->'ContactInfos'->'ru'->>'ZipCode' As varchar) AS "ContactInfos-ru-ZipCode",
CAST("data"->'ContactInfos'->'ru'->>'Language' As varchar) AS "ContactInfos-ru-Language",
CAST("data"->'ContactInfos'->'ru'->>'Faxnumber' As varchar) AS "ContactInfos-ru-Faxnumber",
CAST("data"->'ContactInfos'->'ru'->>'Givenname' As varchar) AS "ContactInfos-ru-Givenname",
CAST("data"->'ContactInfos'->'ru'->>'NamePrefix' As varchar) AS "ContactInfos-ru-NamePrefix",
CAST("data"->'ContactInfos'->'ru'->>'CompanyName' As varchar) AS "ContactInfos-ru-CompanyName",
CAST("data"->'ContactInfos'->'ru'->>'CountryCode' As varchar) AS "ContactInfos-ru-CountryCode",
CAST("data"->'ContactInfos'->'ru'->>'CountryName' As varchar) AS "ContactInfos-ru-CountryName",
CAST("data"->'ContactInfos'->'ru'->>'Phonenumber' As varchar) AS "ContactInfos-ru-Phonenumber"
FROM tvsopen;

CREATE UNIQUE INDEX "v_tvsopen_pk" ON "v_tvsopen"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_tvsopen_SkiareaIds";

CREATE MATERIALIZED VIEW "v_tvsopen_SkiareaIds" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'SkiareaIds') AS "data"
        FROM tvsopen
        WHERE data -> 'SkiareaIds' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS "v_tvsopen_HasLanguage";

CREATE MATERIALIZED VIEW "v_tvsopen_HasLanguage" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'HasLanguage') AS "data"
        FROM tvsopen
        WHERE data -> 'HasLanguage' != 'null';
 
DROP MATERIALIZED VIEW IF EXISTS  "v_wines";

CREATE MATERIALIZED VIEW "v_wines" AS
SELECT CAST("data"->>'Id' As varchar) AS "Id",
CAST("data"->>'Active' As bool) AS "Active",
CAST("data"->>'Vintage' As integer) AS "Vintage",
CAST("data"->>'CustomId' As varchar) AS "CustomId",
CAST("data"->>'Awardyear' As integer) AS "Awardyear",
CAST("data"->>'CompanyId' As varchar) AS "CompanyId",
CAST("data"->>'Shortname' As varchar) AS "Shortname",
CAST("data"->>'SmgActive' As bool) AS "SmgActive",
CAST("data"->>'LastChange' As varchar) AS "LastChange",
CAST("data"->>'FirstImport' As varchar) AS "FirstImport",
CAST("data"->'Detail'->'de'->>'Title' As varchar) AS "Detail-de-Title",
CAST("data"->'Detail'->'de'->>'Header' As varchar) AS "Detail-de-Header",
CAST("data"->'Detail'->'de'->>'Language' As varchar) AS "Detail-de-Language",
CAST("data"->'Detail'->'en'->>'Title' As varchar) AS "Detail-en-Title",
CAST("data"->'Detail'->'en'->>'Header' As varchar) AS "Detail-en-Header",
CAST("data"->'Detail'->'en'->>'Language' As varchar) AS "Detail-en-Language",
CAST("data"->'Detail'->'it'->>'Title' As varchar) AS "Detail-it-Title",
CAST("data"->'Detail'->'it'->>'Header' As varchar) AS "Detail-it-Header",
CAST("data"->'Detail'->'it'->>'Language' As varchar) AS "Detail-it-Language"
FROM wines;

CREATE UNIQUE INDEX "v_wines_pk" ON "v_wines"("Id");

DROP MATERIALIZED VIEW IF EXISTS "v_wines_Awards";

CREATE MATERIALIZED VIEW "v_wines_Awards" AS
        SELECT id AS "Id", jsonb_array_elements_text("data" -> 'Awards') AS "data"
        FROM wines
        WHERE data -> 'Awards' != 'null';
 