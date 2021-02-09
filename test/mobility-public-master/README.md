## How to generate a dump for public

- dump of the schema

```shell
$ /usr/local/bin/pg_dump --dbname=mobility --schema-only --schema=intimev2 -O -x --file=original_schema.sql --username=xiao --host=localhost --port=5432 --table=intimev2.edge --table=intimev2.measurement --table=intimev2.measurementstring --table=intimev2.metadata --table=intimev2.station --table=intimev2.type_metadata --table=intimev2.type --table=intimev2.measurementstringhistory --table=intimev2.measurementhistory
```

- dump of the data (no history)

```shell
$ /usr/local/bin/pg_dump --dbname=mobility --data-only --schema=intimev2 -O -x --disable-triggers  --file=dump-mobility-20200714-no-history.sql --username=xiao --host=localhost --port=5432  --table=intimev2.edge --table=intimev2.measurement --table=intimev2.measurementstring --table=intimev2.metadata --table=intimev2.station --table=intimev2.type_metadata --table=intimev2.type 
$ gzip -k dump-mobility-20200714-no-history.sql 
```

- dump measurement history for public

```sql
CREATE TABLE intimev2.measurementhistory_public (
id bigint NOT NULL,
created_on timestamp without time zone NOT NULL,
period integer NOT NULL,
"timestamp" timestamp without time zone NOT NULL,
double_value double precision NOT NULL,
provenance_id bigint,
station_id bigint NOT NULL,
type_id bigint NOT NULL
);

INSERT INTO intimev2.measurementhistory_public
SELECT me.*
FROM intimev2.station s, intimev2.measurementhistory me
WHERE s.id = me.station_id AND
(
-- station types that are always open, regardless of the origin
s.stationtype in (
'NOI-Place',
'CreativeIndustry',
'BluetoothStation',
'CarpoolingHub',
'CarpoolingService',
'CarpoolingUser',
'CarsharingCar',
'CarsharingStation',
'EChargingPlug',
'EChargingStation',
'Streetstation',
'Culture')
-- station types that are only partly open, constrained by the origin
or (s.stationtype = 'Bicycle' and s.origin in ('ALGORAB', 'BIKE_SHARING_MERANO'))
or (s.stationtype = 'BikesharingStation' and s.origin = 'ALGORAB')
or (s.stationtype = 'EnvironmentStation' and s.origin = 'APPATN-open')
or (s.stationtype = 'LinkStation' and (s.origin is null or s.origin = 'NOI'))
or (s.stationtype = 'MeteoStation' and s.origin in ('meteotrentino', 'SIAG'))
or (s.stationtype = 'ParkingStation' and s.origin in ('FAMAS', 'FBK', 'Municipality Merano'))
or (s.stationtype = 'RWISstation' and s.origin = 'InfoMobility')
-- special rules
or (s.origin = 'APPABZ' and me.period = 3600)
);
```

```shell
$ /usr/local/bin/pg_dump --dbname=mobility --data-only --schema=intimev2 -O -x --disable-triggers  --file=dump-mobility-20200714-measurementhistory_public.sql --username=xiao --host=localhost --port=5432  --table=intimev2.measurementhistory_public
```

Then manually replace the table `measurementhistory_public` by `measurementhistory` in the generated SQL file

```shell
gzip -k dump-mobility-20200714-measurementhistory_public.sql
```

- dump measurement string history for public

```sql

CREATE TABLE intimev2.measurementstringhistory_public (
                                                          id bigint,
                                                          created_on timestamp without time zone NOT NULL,
                                                          period integer NOT NULL,
                                                          "timestamp" timestamp without time zone NOT NULL,
                                                          string_value character varying(255) NOT NULL,
                                                          provenance_id bigint,
                                                          station_id bigint NOT NULL,
                                                          type_id bigint NOT NULL
);

INSERT INTO intimev2.measurementstringhistory_public
SELECT me.*
FROM intimev2.station s, intimev2.measurementstringhistory me
WHERE s.id = me.station_id AND
    (
        -- station types that are always open, regardless of the origin
                s.stationtype in (
                                  'NOI-Place',
                                  'CreativeIndustry',
                                  'BluetoothStation',
                                  'CarpoolingHub',
                                  'CarpoolingService',
                                  'CarpoolingUser',
                                  'CarsharingCar',
                                  'CarsharingStation',
                                  'EChargingPlug',
                                  'EChargingStation',
                                  'Streetstation',
                                  'Culture')
            -- station types that are only partly open, constrained by the origin
            or (s.stationtype = 'Bicycle' and s.origin in ('ALGORAB', 'BIKE_SHARING_MERANO'))
            or (s.stationtype = 'BikesharingStation' and s.origin = 'ALGORAB')
            or (s.stationtype = 'EnvironmentStation' and s.origin = 'APPATN-open')
            or (s.stationtype = 'LinkStation' and (s.origin is null or s.origin = 'NOI'))
            or (s.stationtype = 'MeteoStation' and s.origin in ('meteotrentino', 'SIAG'))
            or (s.stationtype = 'ParkingStation' and s.origin in ('FAMAS', 'FBK', 'Municipality Merano'))
            or (s.stationtype = 'RWISstation' and s.origin = 'InfoMobility')
            -- special rules
            or (s.origin = 'APPABZ' and me.period = 3600)
        );

```

```shell
$ /usr/local/bin/pg_dump --dbname=mobility --data-only --schema=intimev2 -O -x --disable-triggers  --file=dump-mobility-20200714-measurementstringhistory_public.sql --username=xiao --host=localhost --port=5432  --table=intimev2.measurementstringhistory_public
```

Then manually replace the table `measurementstringhistory_public` by `measurementstringhistory` in the generated SQL file

```shell
gzip -k dump-mobility-20200714-measurementstringhistory_public.sql
```

