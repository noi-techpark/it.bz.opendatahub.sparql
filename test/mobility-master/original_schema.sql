--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: davide; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA davide;


--
-- Name: debug_to_be_dropped; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA debug_to_be_dropped;


--
-- Name: elaboration; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA elaboration;


--
-- Name: intimev2; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA intimev2;


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: measurementhistory_seq; Type: SEQUENCE; Schema: intimev2; Owner: -
--

CREATE SEQUENCE intimev2.measurementhistory_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: measurementhistory; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.measurementhistory (
    id bigint DEFAULT nextval('intimev2.measurementhistory_seq'::regclass) NOT NULL,
    created_on timestamp without time zone NOT NULL,
    period integer NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    double_value double precision NOT NULL,
    provenance_id bigint,
    station_id bigint NOT NULL,
    type_id bigint NOT NULL
);


--
-- Name: deltart(intimev2.measurementhistory[], timestamp without time zone, timestamp without time zone, bigint, bigint, bigint, boolean, double precision); Type: FUNCTION; Schema: intimev2; Owner: -
--

CREATE FUNCTION intimev2.deltart(p_arr intimev2.measurementhistory[], p_mints timestamp without time zone, p_maxts timestamp without time zone, p_station_id bigint, p_type_id bigint, p_period bigint, p_extkey boolean DEFAULT false, p_epsilon double precision DEFAULT 0.0) RETURNS integer[]
    LANGUAGE plpgsql
    AS $$
    declare

        ele intimev2.measurementhistory;
        rec intimev2.measurementhistory;
        val double precision;
        cnt bigint;
        ret int[4];

    begin

        ret[1] := 0;  -- DELete count
        ret[2] := 0;  -- upDAte count
        ret[3] := 0;  -- inseRT count
        ret[4] := coalesce(array_length(p_arr, 1),0); -- input element count, zero when null or zero length array

        if (p_extkey) then

            -- ----------------------------------------------------------------------------------------- -- 
            -- case 1/2: key = (station_id, type_id, period, double_value) -> insert or delete                  --
            -- ----------------------------------------------------------------------------------------- -- 

            create temporary table tt ( 
                timestamp  timestamp without time zone,
                double_value      double precision,
                station_id bigint,
                type_id    bigint,
                period     integer
            );

            if (array_length(p_arr, 1) > 0) then

                -- loop over array for insert and copy the array into a temporary table

                foreach ele in array p_arr loop

                    insert into tt
                        (timestamp, double_value, station_id, type_id, period) 
                        values (ele.timestamp, ele.double_value, ele.station_id, ele.type_id, ele.period); 

                    if (ele.station_id != p_station_id or ele.type_id != p_type_id or ele.period != p_period) then
                        drop table tt;
                        raise exception 'parameter inconsistency';
                    end if;

                    if (ele.timestamp not between p_mints - '1 minute'::interval and p_maxts + '1 minute'::interval) then
                        drop table tt;
                        raise exception 'timestamp inconsistency';
                    end if;

                    select count(*) into cnt from measurementhistory t1
                    where t1.timestamp  = ele.timestamp  and
                          t1.type_id    = ele.type_id    and
                          t1.period     = ele.period     and
                          t1.station_id = ele.station_id and
                          abs(t1.double_value - ele.double_value) <= p_epsilon;

                    if (cnt = 0) then 

                        insert into measurementhistory
                        (created_on, timestamp, double_value, station_id, type_id, period) 
                        values (ele.created_on, ele.timestamp, ele.double_value, ele.station_id, ele.type_id, ele.period); 
                        ret[3] := ret[3] + 1;

                    end if;

                end loop;

            end if;

            -- loop over measurementhistory for delete

            for rec in select * from measurementhistory t1
                where t1.type_id    = p_type_id    and
                      t1.period     = p_period     and
                      t1.station_id = p_station_id and
                      t1.timestamp between p_mints and p_maxts
            loop

                select count(*) into cnt from tt t1
                where t1.timestamp  = rec.timestamp  and
                      t1.type_id    = rec.type_id    and
                      t1.period     = rec.period     and
                      t1.station_id = rec.station_id and
                      abs(t1.double_value - rec.double_value) <= p_epsilon;

                if (cnt = 0) then

                    delete from measurementhistory t1
                    where t1.timestamp  = rec.timestamp  and
                          t1.type_id    = rec.type_id    and
                          t1.period     = rec.period     and
                          t1.station_id = rec.station_id;

                    ret[1] := ret[1] + 1;
 
                end if;
        
            end loop;

        else

            -- ----------------------------------------------------------------------------------------- -- 
            -- case 2/2: key = (station_id, type_id, period) -> insert, update or delete                 --
            -- ----------------------------------------------------------------------------------------- -- 

            create temporary table tt ( 
                timestamp  timestamp without time zone,
                double_value      double precision,
                station_id bigint,
                type_id    bigint,
                period     integer
            );

            if (array_length(p_arr, 1) > 0) then

                -- loop over array for insert/update and copy the array into a temporary table

                foreach ele in array p_arr loop

                    insert into tt
                        (timestamp, double_value, station_id, type_id, period) 
                        values (ele.timestamp, ele.double_value, ele.station_id, ele.type_id, ele.period); 

                    if (ele.station_id != p_station_id or ele.type_id != p_type_id or ele.period != p_period) then
                        drop table tt;
                        raise exception 'parameter inconsistency';
                    end if;

                    if (ele.timestamp not between p_mints - '1 minute'::interval and p_maxts + '1 minute'::interval) then
                        drop table tt;
                        raise exception 'timestamp inconsistency';
                    end if;

                    select double_value into val from measurementhistory t1
                    where t1.timestamp  = ele.timestamp  and
                          t1.type_id    = ele.type_id    and
                          t1.period     = ele.period     and
                          t1.station_id = ele.station_id;

                    if (not found) then 

                        insert into measurementhistory
                        (created_on, timestamp, double_value, station_id, type_id, period) 
                        values (ele.created_on, ele.timestamp, ele.double_value, ele.station_id, ele.type_id, ele.period); 
                        ret[3] := ret[3] + 1;

                    elsif (abs(val - ele.double_value) > p_epsilon) then

                        update measurementhistory t1 set double_value = ele.double_value
                        where t1.timestamp  = ele.timestamp  and
                              t1.type_id    = ele.type_id    and
                              t1.period     = ele.period     and
                              t1.station_id = ele.station_id;

                        ret[2] := ret[2] + 1;

                    end if;

                end loop;

            end if;

            -- loop over measurementhistory for delete

            for rec in select * from measurementhistory t1
                where t1.type_id    = p_type_id    and
                      t1.period     = p_period     and
                      t1.station_id = p_station_id and
                      t1.timestamp between p_mints and p_maxts
            loop

                select double_value into val from tt t1
                where t1.timestamp  = rec.timestamp  and
                      t1.type_id    = rec.type_id    and
                      t1.period     = rec.period     and
                      t1.station_id = rec.station_id;

                if (not found) then

                    delete from measurementhistory t1
                    where t1.timestamp  = rec.timestamp  and
                          t1.type_id    = rec.type_id    and
                          t1.period     = rec.period     and
                          t1.station_id = rec.station_id;

                    ret[1] := ret[1] + 1;
 
                end if;
        
            end loop;

        end if;

        drop table tt;

        return ret;

    end;
$$;


--
-- Name: elaborationhistory; Type: TABLE; Schema: davide; Owner: -
--

CREATE TABLE davide.elaborationhistory (
    id bigint NOT NULL,
    created_on timestamp without time zone,
    "timestamp" timestamp without time zone,
    value double precision,
    station_id bigint NOT NULL,
    type_id bigint NOT NULL,
    period integer
);


--
-- Name: elaborationhistory_id_seq; Type: SEQUENCE; Schema: davide; Owner: -
--

CREATE SEQUENCE davide.elaborationhistory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: elaborationhistory_id_seq; Type: SEQUENCE OWNED BY; Schema: davide; Owner: -
--

ALTER SEQUENCE davide.elaborationhistory_id_seq OWNED BY davide.elaborationhistory.id;


--
-- Name: elaborationhistory_java; Type: TABLE; Schema: davide; Owner: -
--

CREATE TABLE davide.elaborationhistory_java (
    id bigint NOT NULL,
    created_on timestamp without time zone,
    "timestamp" timestamp without time zone,
    value double precision,
    station_id bigint NOT NULL,
    type_id bigint NOT NULL,
    period integer
);


--
-- Name: elaborationhistory_python; Type: TABLE; Schema: davide; Owner: -
--

CREATE TABLE davide.elaborationhistory_python (
    id bigint NOT NULL,
    created_on timestamp without time zone,
    "timestamp" timestamp without time zone,
    value double precision,
    station_id bigint NOT NULL,
    type_id bigint NOT NULL,
    period integer
);


--
-- Name: measurementstringhistory; Type: TABLE; Schema: davide; Owner: -
--

CREATE TABLE davide.measurementstringhistory (
    created_on timestamp without time zone,
    "timestamp" timestamp without time zone,
    value character varying,
    station_id bigint NOT NULL,
    type_id bigint NOT NULL,
    period integer,
    id bigint NOT NULL
);


--
-- Name: measurementstringhistory_python; Type: TABLE; Schema: davide; Owner: -
--

CREATE TABLE davide.measurementstringhistory_python (
    created_on timestamp without time zone,
    "timestamp" timestamp without time zone,
    value character varying,
    station_id bigint NOT NULL,
    type_id bigint NOT NULL,
    period integer,
    id bigint NOT NULL
);


--
-- Name: scheduler_run; Type: TABLE; Schema: davide; Owner: -
--

CREATE TABLE davide.scheduler_run (
    id integer NOT NULL,
    task_id integer,
    status character varying(512),
    start_time timestamp without time zone,
    stop_time timestamp without time zone,
    run_output text,
    run_result text,
    traceback text,
    worker_name character varying(512)
);


--
-- Name: scheduler_run_id_seq; Type: SEQUENCE; Schema: davide; Owner: -
--

CREATE SEQUENCE davide.scheduler_run_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scheduler_run_id_seq; Type: SEQUENCE OWNED BY; Schema: davide; Owner: -
--

ALTER SEQUENCE davide.scheduler_run_id_seq OWNED BY davide.scheduler_run.id;


--
-- Name: scheduler_task; Type: TABLE; Schema: davide; Owner: -
--

CREATE TABLE davide.scheduler_task (
    id integer NOT NULL,
    application_name character varying(512),
    task_name character varying(512),
    group_name character varying(512),
    status character varying(512),
    function_name character varying(512),
    uuid character varying(255),
    args text,
    vars text,
    enabled character(1),
    start_time timestamp without time zone,
    next_run_time timestamp without time zone,
    stop_time timestamp without time zone,
    repeats integer,
    retry_failed integer,
    period integer,
    prevent_drift character(1),
    timeout integer,
    sync_output integer,
    times_run integer,
    times_failed integer,
    last_run_time timestamp without time zone,
    assigned_worker_name character varying(512),
    calc_order integer
);


--
-- Name: cache; Type: TABLE; Schema: debug_to_be_dropped; Owner: -
--

CREATE TABLE debug_to_be_dropped.cache (
    id bigint,
    created_on timestamp without time zone,
    "timestamp" timestamp without time zone,
    value double precision,
    station_id bigint,
    type_id bigint,
    period integer
);


--
-- Name: elaborationhistory; Type: TABLE; Schema: debug_to_be_dropped; Owner: -
--

CREATE TABLE debug_to_be_dropped.elaborationhistory (
    id bigint,
    created_on timestamp without time zone,
    "timestamp" timestamp without time zone,
    value double precision,
    station_id bigint,
    type_id bigint,
    period integer
);


--
-- Name: sample_input; Type: TABLE; Schema: debug_to_be_dropped; Owner: -
--

CREATE TABLE debug_to_be_dropped.sample_input (
    id bigint,
    created_on timestamp without time zone,
    "timestamp" timestamp without time zone,
    value double precision,
    station_id bigint,
    type_id bigint,
    period integer
);


--
-- Name: scheduler_run; Type: TABLE; Schema: elaboration; Owner: -
--

CREATE TABLE elaboration.scheduler_run (
    id integer NOT NULL,
    task_id integer,
    status character varying(512),
    start_time timestamp without time zone,
    stop_time timestamp without time zone,
    run_output text,
    run_result text,
    traceback text,
    worker_name character varying(512)
);


--
-- Name: scheduler_run_id_seq; Type: SEQUENCE; Schema: elaboration; Owner: -
--

CREATE SEQUENCE elaboration.scheduler_run_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scheduler_run_id_seq; Type: SEQUENCE OWNED BY; Schema: elaboration; Owner: -
--

ALTER SEQUENCE elaboration.scheduler_run_id_seq OWNED BY elaboration.scheduler_run.id;


--
-- Name: scheduler_task; Type: TABLE; Schema: elaboration; Owner: -
--

CREATE TABLE elaboration.scheduler_task (
    id integer NOT NULL,
    application_name character varying(512),
    task_name character varying(512),
    group_name character varying(512),
    status character varying(512),
    function_name character varying(512),
    uuid character varying(255),
    args text,
    vars text,
    enabled character(1),
    start_time timestamp without time zone,
    next_run_time timestamp without time zone,
    stop_time timestamp without time zone,
    repeats integer,
    retry_failed integer,
    period integer,
    prevent_drift character(1),
    timeout integer,
    sync_output integer,
    times_run integer,
    times_failed integer,
    last_run_time timestamp without time zone,
    assigned_worker_name character varying(512),
    calc_order integer
);


--
-- Name: scheduler_task_id_seq; Type: SEQUENCE; Schema: elaboration; Owner: -
--

CREATE SEQUENCE elaboration.scheduler_task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scheduler_task_id_seq; Type: SEQUENCE OWNED BY; Schema: elaboration; Owner: -
--

ALTER SEQUENCE elaboration.scheduler_task_id_seq OWNED BY elaboration.scheduler_task.id;


--
-- Name: bdprole_seq; Type: SEQUENCE; Schema: intimev2; Owner: -
--

CREATE SEQUENCE intimev2.bdprole_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bdprole; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.bdprole (
    id bigint DEFAULT nextval('intimev2.bdprole_seq'::regclass) NOT NULL,
    description character varying(255),
    name character varying(255) NOT NULL,
    parent_id bigint
);


--
-- Name: bdproles_unrolled; Type: VIEW; Schema: intimev2; Owner: -
--

CREATE VIEW intimev2.bdproles_unrolled AS
 WITH RECURSIVE roles(role, subroles) AS (
         SELECT bdprole.id,
            ARRAY[bdprole.id] AS "array"
           FROM intimev2.bdprole
          WHERE (bdprole.parent_id IS NULL)
        UNION ALL
         SELECT t.id,
            (roles_1.subroles || t.id)
           FROM intimev2.bdprole t,
            roles roles_1
          WHERE (t.parent_id = roles_1.role)
        )
 SELECT roles.role,
    unnest(roles.subroles) AS sr
   FROM roles;


--
-- Name: bdprules_seq; Type: SEQUENCE; Schema: intimev2; Owner: -
--

CREATE SEQUENCE intimev2.bdprules_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bdprules; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.bdprules (
    id bigint DEFAULT nextval('intimev2.bdprules_seq'::regclass) NOT NULL,
    period integer,
    role_id bigint,
    station_id bigint,
    type_id bigint
);


--
-- Name: bdpfilters_unrolled; Type: VIEW; Schema: intimev2; Owner: -
--

CREATE VIEW intimev2.bdpfilters_unrolled AS
 SELECT DISTINCT x.role,
    f.station_id,
    f.type_id,
    f.period
   FROM (intimev2.bdprules f
     JOIN intimev2.bdproles_unrolled x ON ((f.role_id = x.sr)))
  ORDER BY x.role;


--
-- Name: bdppermissions; Type: MATERIALIZED VIEW; Schema: intimev2; Owner: -
--

CREATE MATERIALIZED VIEW intimev2.bdppermissions AS
 WITH x AS (
         SELECT row_number() OVER (ORDER BY bdpfilters_unrolled.role) AS uuid,
            bdpfilters_unrolled.role AS role_id,
            bdpfilters_unrolled.station_id,
            bdpfilters_unrolled.type_id,
            bdpfilters_unrolled.period,
            bool_or((bdpfilters_unrolled.station_id IS NULL)) OVER (PARTITION BY bdpfilters_unrolled.role) AS e_stationid,
            bool_or((bdpfilters_unrolled.type_id IS NULL)) OVER (PARTITION BY bdpfilters_unrolled.role, bdpfilters_unrolled.station_id) AS e_typeid,
            bool_or((bdpfilters_unrolled.period IS NULL)) OVER (PARTITION BY bdpfilters_unrolled.role, bdpfilters_unrolled.station_id, bdpfilters_unrolled.type_id) AS e_period
           FROM intimev2.bdpfilters_unrolled
          ORDER BY bdpfilters_unrolled.role, bdpfilters_unrolled.station_id, bdpfilters_unrolled.type_id, bdpfilters_unrolled.period
        )
 SELECT x.uuid,
    x.role_id,
    x.station_id,
    x.type_id,
    x.period
   FROM x
  WHERE (((x.station_id IS NULL) AND (x.type_id IS NULL) AND (x.period IS NULL)) OR ((x.station_id IS NOT NULL) AND (x.type_id IS NULL) AND (x.period IS NULL) AND (NOT x.e_stationid)) OR ((x.station_id IS NOT NULL) AND (x.type_id IS NOT NULL) AND (x.period IS NULL) AND (NOT x.e_stationid) AND (NOT x.e_typeid)) OR ((x.station_id IS NOT NULL) AND (x.type_id IS NULL) AND (x.period IS NOT NULL) AND (NOT x.e_stationid) AND (NOT x.e_period)) OR ((x.station_id IS NOT NULL) AND (x.type_id IS NOT NULL) AND (x.period IS NOT NULL) AND (NOT x.e_stationid) AND (NOT x.e_typeid) AND (NOT x.e_period)))
  WITH NO DATA;


--
-- Name: bdpuser_seq; Type: SEQUENCE; Schema: intimev2; Owner: -
--

CREATE SEQUENCE intimev2.bdpuser_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bdpuser; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.bdpuser (
    id bigint DEFAULT nextval('intimev2.bdpuser_seq'::regclass) NOT NULL,
    email character varying(255) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    password character varying(255) NOT NULL,
    token_expired boolean DEFAULT false NOT NULL
);


--
-- Name: bdpusers_bdproles; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.bdpusers_bdproles (
    user_id bigint NOT NULL,
    role_id bigint NOT NULL
);


--
-- Name: classification; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.classification (
    id integer NOT NULL,
    type_id integer,
    threshold character varying(512),
    min double precision,
    max double precision
);


--
-- Name: classification_id_seq; Type: SEQUENCE; Schema: intimev2; Owner: -
--

CREATE SEQUENCE intimev2.classification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: classification_id_seq; Type: SEQUENCE OWNED BY; Schema: intimev2; Owner: -
--

ALTER SEQUENCE intimev2.classification_id_seq OWNED BY intimev2.classification.id;


--
-- Name: copert_emisfact; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.copert_emisfact (
    type_id bigint NOT NULL,
    copert_parcom_id integer NOT NULL,
    v_min numeric(5,1) DEFAULT '-99.0'::numeric NOT NULL,
    v_max numeric(5,1) DEFAULT '-99.0'::numeric NOT NULL,
    coef_a real,
    coef_b real,
    coef_c real,
    coef_d real,
    coef_e real,
    id integer NOT NULL
);


--
-- Name: copert_emisfact_id_seq; Type: SEQUENCE; Schema: intimev2; Owner: -
--

CREATE SEQUENCE intimev2.copert_emisfact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: copert_emisfact_id_seq; Type: SEQUENCE OWNED BY; Schema: intimev2; Owner: -
--

ALTER SEQUENCE intimev2.copert_emisfact_id_seq OWNED BY intimev2.copert_emisfact.id;


--
-- Name: copert_parcom; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.copert_parcom (
    descriz character(80) NOT NULL,
    id integer NOT NULL,
    percent real,
    id_class smallint,
    eurocl smallint
);


--
-- Name: edge_seq; Type: SEQUENCE; Schema: intimev2; Owner: -
--

CREATE SEQUENCE intimev2.edge_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: edge; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.edge (
    id bigint DEFAULT nextval('intimev2.edge_seq'::regclass) NOT NULL,
    directed boolean DEFAULT true NOT NULL,
    linegeometry public.geometry(Geometry,25832),
    destination_id bigint NOT NULL,
    edge_data_id bigint,
    origin_id bigint NOT NULL
);


--
-- Name: measurement_seq; Type: SEQUENCE; Schema: intimev2; Owner: -
--

CREATE SEQUENCE intimev2.measurement_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measurement; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.measurement (
    id bigint DEFAULT nextval('intimev2.measurement_seq'::regclass) NOT NULL,
    created_on timestamp without time zone NOT NULL,
    period integer NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    double_value double precision NOT NULL,
    provenance_id bigint,
    station_id bigint NOT NULL,
    type_id bigint NOT NULL
);


--
-- Name: measurementmobile; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.measurementmobile (
    id bigint,
    ts_ms timestamp without time zone,
    af_1_sccm double precision,
    af_1_valid_b boolean,
    can_acc_lat_mean_mps2 double precision,
    can_acc_lat_mps2 double precision,
    can_acc_lat_var_m2ps4 double precision,
    can_acc_long_mean_mps2 double precision,
    can_acc_long_mps2 double precision,
    can_acc_long_var_m2ps4 double precision,
    can_speed_mps double precision,
    can_valid_b boolean,
    co_1_ppm double precision,
    co_1_runtime_s integer,
    co_1_valid_b boolean,
    gps_1_alt_m double precision,
    gps_1_hdg_deg double precision,
    gps_1_lat_deg double precision,
    gps_1_long_deg double precision,
    gps_1_speed_mps double precision,
    id_driver_nr integer,
    id_runtime_s integer,
    id_status_char character varying(255),
    id_system_nr integer,
    id_vehicle_nr integer,
    id_version_char character varying(255),
    imu_acc_lat_mean_mps2 double precision,
    imu_acc_lat_mps2 double precision,
    imu_acc_lat_var_m2ps4 double precision,
    imu_acc_long_mean_mps2 double precision,
    imu_acc_long_mps2 double precision,
    imu_acc_long_var_m2ps4 double precision,
    imu_speed_mps double precision,
    imu_valid_b boolean,
    no2_1_ppb double precision,
    no2_1_runtime_s integer,
    no2_1_valid_b boolean,
    no2_2_ppb double precision,
    no2_2_runtime_s integer,
    no2_2_valid_b boolean,
    res_1_a double precision,
    res_1_runtime_s integer,
    res_1_valid_b boolean,
    res_2_a double precision,
    res_2_runtime_s integer,
    res_2_valid_b boolean,
    rh_1_pct double precision,
    rh_1_valid_b boolean,
    temp_1_c double precision,
    temp_1_valid_b boolean,
    gps_1_sat_nr integer,
    gps_1_valid_b boolean,
    gps_1_pdop_nr double precision,
    o3_1_ppb double precision,
    o3_1_runtime_s integer,
    o3_1_valid_b boolean,
    the_geom public.geometry,
    station_id bigint,
    created_on timestamp without time zone,
    "position" public.geometry,
    realtime_delay bigint,
    no2_1_microgm3_ma double precision,
    no2_1_microgm3_exp double precision
);


--
-- Name: measurementmobilehistory; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.measurementmobilehistory (
    id bigint,
    ts_ms timestamp without time zone,
    af_1_sccm double precision,
    af_1_valid_b boolean,
    can_acc_lat_mean_mps2 double precision,
    can_acc_lat_mps2 double precision,
    can_acc_lat_var_m2ps4 double precision,
    can_acc_long_mean_mps2 double precision,
    can_acc_long_mps2 double precision,
    can_acc_long_var_m2ps4 double precision,
    can_speed_mps double precision,
    can_valid_b boolean,
    co_1_ppm double precision,
    co_1_runtime_s integer,
    co_1_valid_b boolean,
    gps_1_alt_m double precision,
    gps_1_hdg_deg double precision,
    gps_1_lat_deg double precision,
    gps_1_long_deg double precision,
    gps_1_speed_mps double precision,
    id_driver_nr integer,
    id_runtime_s integer,
    id_status_char character varying(255),
    id_system_nr integer,
    id_vehicle_nr integer,
    id_version_char character varying(255),
    imu_acc_lat_mean_mps2 double precision,
    imu_acc_lat_mps2 double precision,
    imu_acc_lat_var_m2ps4 double precision,
    imu_acc_long_mean_mps2 double precision,
    imu_acc_long_mps2 double precision,
    imu_acc_long_var_m2ps4 double precision,
    imu_speed_mps double precision,
    imu_valid_b boolean,
    no2_1_ppb double precision,
    no2_1_runtime_s integer,
    no2_1_valid_b boolean,
    no2_2_ppb double precision,
    no2_2_runtime_s integer,
    no2_2_valid_b boolean,
    res_1_a double precision,
    res_1_runtime_s integer,
    res_1_valid_b boolean,
    res_2_a double precision,
    res_2_runtime_s integer,
    res_2_valid_b boolean,
    rh_1_pct double precision,
    rh_1_valid_b boolean,
    temp_1_c double precision,
    temp_1_valid_b boolean,
    gps_1_sat_nr integer,
    gps_1_valid_b boolean,
    gps_1_pdop_nr double precision,
    o3_1_ppb double precision,
    o3_1_runtime_s integer,
    o3_1_valid_b boolean,
    station_id bigint,
    "position" public.geometry,
    created_on timestamp without time zone,
    realtime_delay bigint,
    no2_1_microgm3_ma double precision,
    no2_1_microgm3_exp double precision
);


--
-- Name: measurementstring_seq; Type: SEQUENCE; Schema: intimev2; Owner: -
--

CREATE SEQUENCE intimev2.measurementstring_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measurementstring; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.measurementstring (
    id bigint DEFAULT nextval('intimev2.measurementstring_seq'::regclass) NOT NULL,
    created_on timestamp without time zone NOT NULL,
    period integer NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    string_value character varying(255) NOT NULL,
    provenance_id bigint,
    station_id bigint NOT NULL,
    type_id bigint NOT NULL
);


--
-- Name: measurementstringhistory_seq; Type: SEQUENCE; Schema: intimev2; Owner: -
--

CREATE SEQUENCE intimev2.measurementstringhistory_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measurementstringhistory; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.measurementstringhistory (
    id bigint DEFAULT nextval('intimev2.measurementstringhistory_seq'::regclass) NOT NULL,
    created_on timestamp without time zone NOT NULL,
    period integer NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    string_value character varying(255) NOT NULL,
    provenance_id bigint,
    station_id bigint NOT NULL,
    type_id bigint NOT NULL
);


--
-- Name: metadata_seq; Type: SEQUENCE; Schema: intimev2; Owner: -
--

CREATE SEQUENCE intimev2.metadata_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metadata; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.metadata (
    id bigint DEFAULT nextval('intimev2.metadata_seq'::regclass) NOT NULL,
    created_on timestamp without time zone,
    json jsonb,
    station_id bigint
);


--
-- Name: provenance_seq; Type: SEQUENCE; Schema: intimev2; Owner: -
--

CREATE SEQUENCE intimev2.provenance_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: provenance; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.provenance (
    id bigint DEFAULT nextval('intimev2.provenance_seq'::regclass) NOT NULL,
    data_collector character varying(255) NOT NULL,
    data_collector_version character varying(255),
    lineage character varying(255) NOT NULL,
    uuid character varying(255)
);


--
-- Name: schemaversion; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.schemaversion (
    version character varying NOT NULL
);


--
-- Name: TABLE schemaversion; Type: COMMENT; Schema: intimev2; Owner: -
--

COMMENT ON TABLE intimev2.schemaversion IS 'Version of the current schema (used for scripted updates)';


--
-- Name: station_seq; Type: SEQUENCE; Schema: intimev2; Owner: -
--

CREATE SEQUENCE intimev2.station_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: station; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.station (
    id bigint DEFAULT nextval('intimev2.station_seq'::regclass) NOT NULL,
    active boolean,
    available boolean,
    name character varying(255) NOT NULL,
    origin character varying(255),
    pointprojection public.geometry,
    stationcode character varying(255) NOT NULL,
    stationtype character varying(255) NOT NULL,
    meta_data_id bigint,
    parent_id bigint
);


--
-- Name: type_seq; Type: SEQUENCE; Schema: intimev2; Owner: -
--

CREATE SEQUENCE intimev2.type_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: type; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.type (
    id bigint DEFAULT nextval('intimev2.type_seq'::regclass) NOT NULL,
    cname character varying(255) NOT NULL,
    created_on timestamp without time zone,
    cunit character varying(255),
    description character varying(255),
    rtype character varying(255),
    meta_data_id bigint
);


--
-- Name: type_metadata_seq; Type: SEQUENCE; Schema: intimev2; Owner: -
--

CREATE SEQUENCE intimev2.type_metadata_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: type_metadata; Type: TABLE; Schema: intimev2; Owner: -
--

CREATE TABLE intimev2.type_metadata (
    id bigint DEFAULT nextval('intimev2.type_metadata_seq'::regclass) NOT NULL,
    created_on timestamp without time zone,
    json jsonb,
    type_id bigint
);


--
-- Name: municipalities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.municipalities (
    gid integer NOT NULL,
    objectid integer,
    gem_id integer,
    name_i character varying(254),
    name_d character varying(254),
    name_l character varying(254),
    istat_code integer,
    area numeric,
    shape character varying(254),
    geom public.geometry(MultiPolygonZM,3044),
    geom_4326 public.geometry
);


--
-- Name: municipalities_gid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.municipalities_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: municipalities_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.municipalities_gid_seq OWNED BY public.municipalities.gid;


--
-- Name: elaborationhistory id; Type: DEFAULT; Schema: davide; Owner: -
--

ALTER TABLE ONLY davide.elaborationhistory ALTER COLUMN id SET DEFAULT nextval('davide.elaborationhistory_id_seq'::regclass);


--
-- Name: scheduler_run id; Type: DEFAULT; Schema: davide; Owner: -
--

ALTER TABLE ONLY davide.scheduler_run ALTER COLUMN id SET DEFAULT nextval('davide.scheduler_run_id_seq'::regclass);


--
-- Name: scheduler_run id; Type: DEFAULT; Schema: elaboration; Owner: -
--

ALTER TABLE ONLY elaboration.scheduler_run ALTER COLUMN id SET DEFAULT nextval('elaboration.scheduler_run_id_seq'::regclass);


--
-- Name: scheduler_task id; Type: DEFAULT; Schema: elaboration; Owner: -
--

ALTER TABLE ONLY elaboration.scheduler_task ALTER COLUMN id SET DEFAULT nextval('elaboration.scheduler_task_id_seq'::regclass);


--
-- Name: classification id; Type: DEFAULT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.classification ALTER COLUMN id SET DEFAULT nextval('intimev2.classification_id_seq'::regclass);


--
-- Name: copert_emisfact id; Type: DEFAULT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.copert_emisfact ALTER COLUMN id SET DEFAULT nextval('intimev2.copert_emisfact_id_seq'::regclass);


--
-- Name: municipalities gid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.municipalities ALTER COLUMN gid SET DEFAULT nextval('public.municipalities_gid_seq'::regclass);


--
-- Name: elaborationhistory_java elaborationhistory_java_pkey; Type: CONSTRAINT; Schema: davide; Owner: -
--

ALTER TABLE ONLY davide.elaborationhistory_java
    ADD CONSTRAINT elaborationhistory_java_pkey PRIMARY KEY (id);


--
-- Name: elaborationhistory_python elaborationhistory_python_pkey; Type: CONSTRAINT; Schema: davide; Owner: -
--

ALTER TABLE ONLY davide.elaborationhistory_python
    ADD CONSTRAINT elaborationhistory_python_pkey PRIMARY KEY (id);


--
-- Name: measurementstringhistory measurementstringhistory_pkey; Type: CONSTRAINT; Schema: davide; Owner: -
--

ALTER TABLE ONLY davide.measurementstringhistory
    ADD CONSTRAINT measurementstringhistory_pkey PRIMARY KEY (id);


--
-- Name: measurementstringhistory_python measurementstringhistory_pyth_timestamp_station_id_type_id__key; Type: CONSTRAINT; Schema: davide; Owner: -
--

ALTER TABLE ONLY davide.measurementstringhistory_python
    ADD CONSTRAINT measurementstringhistory_pyth_timestamp_station_id_type_id__key UNIQUE ("timestamp", station_id, type_id, period, value);


--
-- Name: measurementstringhistory_python measurementstringhistory_python_pkey; Type: CONSTRAINT; Schema: davide; Owner: -
--

ALTER TABLE ONLY davide.measurementstringhistory_python
    ADD CONSTRAINT measurementstringhistory_python_pkey PRIMARY KEY (id);


--
-- Name: measurementstringhistory measurementstringhistory_timestamp_station_id_type_id_perio_key; Type: CONSTRAINT; Schema: davide; Owner: -
--

ALTER TABLE ONLY davide.measurementstringhistory
    ADD CONSTRAINT measurementstringhistory_timestamp_station_id_type_id_perio_key UNIQUE ("timestamp", station_id, type_id, period, value);


--
-- Name: elaborationhistory pk_intime_elaborationhistory; Type: CONSTRAINT; Schema: davide; Owner: -
--

ALTER TABLE ONLY davide.elaborationhistory
    ADD CONSTRAINT pk_intime_elaborationhistory PRIMARY KEY (id);


--
-- Name: scheduler_run scheduler_run_pkey; Type: CONSTRAINT; Schema: davide; Owner: -
--

ALTER TABLE ONLY davide.scheduler_run
    ADD CONSTRAINT scheduler_run_pkey PRIMARY KEY (id);


--
-- Name: scheduler_task scheduler_task_pkey; Type: CONSTRAINT; Schema: davide; Owner: -
--

ALTER TABLE ONLY davide.scheduler_task
    ADD CONSTRAINT scheduler_task_pkey PRIMARY KEY (id);


--
-- Name: scheduler_task scheduler_task_uuid_key; Type: CONSTRAINT; Schema: davide; Owner: -
--

ALTER TABLE ONLY davide.scheduler_task
    ADD CONSTRAINT scheduler_task_uuid_key UNIQUE (uuid);


--
-- Name: scheduler_run scheduler_run_pkey; Type: CONSTRAINT; Schema: elaboration; Owner: -
--

ALTER TABLE ONLY elaboration.scheduler_run
    ADD CONSTRAINT scheduler_run_pkey PRIMARY KEY (id);


--
-- Name: scheduler_task scheduler_task_pkey; Type: CONSTRAINT; Schema: elaboration; Owner: -
--

ALTER TABLE ONLY elaboration.scheduler_task
    ADD CONSTRAINT scheduler_task_pkey PRIMARY KEY (id);


--
-- Name: scheduler_task scheduler_task_uuid_key; Type: CONSTRAINT; Schema: elaboration; Owner: -
--

ALTER TABLE ONLY elaboration.scheduler_task
    ADD CONSTRAINT scheduler_task_uuid_key UNIQUE (uuid);


--
-- Name: bdprole bdprole_pkey; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.bdprole
    ADD CONSTRAINT bdprole_pkey PRIMARY KEY (id);


--
-- Name: bdprules bdprules_pkey; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.bdprules
    ADD CONSTRAINT bdprules_pkey PRIMARY KEY (id);


--
-- Name: bdpuser bdpuser_pkey; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.bdpuser
    ADD CONSTRAINT bdpuser_pkey PRIMARY KEY (id);


--
-- Name: classification classification_pkey; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.classification
    ADD CONSTRAINT classification_pkey PRIMARY KEY (id);


--
-- Name: copert_emisfact copert_emisfact_pk; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.copert_emisfact
    ADD CONSTRAINT copert_emisfact_pk PRIMARY KEY (id);


--
-- Name: copert_parcom copert_parcom_id; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.copert_parcom
    ADD CONSTRAINT copert_parcom_id PRIMARY KEY (id);


--
-- Name: edge edge_pkey; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.edge
    ADD CONSTRAINT edge_pkey PRIMARY KEY (id);


--
-- Name: measurement measurement_pkey; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurement
    ADD CONSTRAINT measurement_pkey PRIMARY KEY (id);


--
-- Name: measurementhistory measurementhistory_pkey; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurementhistory
    ADD CONSTRAINT measurementhistory_pkey PRIMARY KEY (id);


--
-- Name: measurementstring measurementstring_pkey; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurementstring
    ADD CONSTRAINT measurementstring_pkey PRIMARY KEY (id);


--
-- Name: measurementstringhistory measurementstringhistory_pkey; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurementstringhistory
    ADD CONSTRAINT measurementstringhistory_pkey PRIMARY KEY (id);


--
-- Name: metadata metadata_pkey; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.metadata
    ADD CONSTRAINT metadata_pkey PRIMARY KEY (id);


--
-- Name: provenance provenance_pkey; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.provenance
    ADD CONSTRAINT provenance_pkey PRIMARY KEY (id);


--
-- Name: station station_pkey; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.station
    ADD CONSTRAINT station_pkey PRIMARY KEY (id);


--
-- Name: type_metadata type_metadata_pkey; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.type_metadata
    ADD CONSTRAINT type_metadata_pkey PRIMARY KEY (id);


--
-- Name: type type_pkey; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.type
    ADD CONSTRAINT type_pkey PRIMARY KEY (id);


--
-- Name: bdprole uc_bdprole_name; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.bdprole
    ADD CONSTRAINT uc_bdprole_name UNIQUE (name);


--
-- Name: bdpuser uc_bdpuser_email; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.bdpuser
    ADD CONSTRAINT uc_bdpuser_email UNIQUE (email);


--
-- Name: measurement uc_measurement_station_id_type_id_period; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurement
    ADD CONSTRAINT uc_measurement_station_id_type_id_period UNIQUE (station_id, type_id, period);


--
-- Name: measurementhistory uc_measurementhistory_station_i__timestamp_period_double_value_; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurementhistory
    ADD CONSTRAINT uc_measurementhistory_station_i__timestamp_period_double_value_ UNIQUE (station_id, type_id, "timestamp", period, double_value);


--
-- Name: measurementstring uc_measurementstring_station_id_type_id_period; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurementstring
    ADD CONSTRAINT uc_measurementstring_station_id_type_id_period UNIQUE (station_id, type_id, period);


--
-- Name: measurementstringhistory uc_measurementstringhistory_sta__timestamp_period_string_value_; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurementstringhistory
    ADD CONSTRAINT uc_measurementstringhistory_sta__timestamp_period_string_value_ UNIQUE (station_id, type_id, "timestamp", period, string_value);


--
-- Name: provenance uc_provenance_lineage_data_collector_data_collector_version; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.provenance
    ADD CONSTRAINT uc_provenance_lineage_data_collector_data_collector_version UNIQUE (lineage, data_collector, data_collector_version);


--
-- Name: provenance uc_provenance_uuid; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.provenance
    ADD CONSTRAINT uc_provenance_uuid UNIQUE (uuid);


--
-- Name: station uc_station_stationcode_stationtype; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.station
    ADD CONSTRAINT uc_station_stationcode_stationtype UNIQUE (stationcode, stationtype);


--
-- Name: type uc_type_cname; Type: CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.type
    ADD CONSTRAINT uc_type_cname UNIQUE (cname);


--
-- Name: municipalities municipalities_istat_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.municipalities
    ADD CONSTRAINT municipalities_istat_code_key UNIQUE (istat_code);


--
-- Name: municipalities municipalities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.municipalities
    ADD CONSTRAINT municipalities_pkey PRIMARY KEY (gid);


--
-- Name: all; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX "all" ON davide.elaborationhistory USING btree (type_id, period, "timestamp", station_id);


--
-- Name: elaborationhistory_java_period_type_id_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX elaborationhistory_java_period_type_id_idx ON davide.elaborationhistory_java USING btree (period, type_id);


--
-- Name: elaborationhistory_java_station_id_type_id_timestamp_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX elaborationhistory_java_station_id_type_id_timestamp_idx ON davide.elaborationhistory_java USING btree (station_id, type_id, "timestamp" DESC);


--
-- Name: elaborationhistory_java_timestamp_station_id_type_id_period_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE UNIQUE INDEX elaborationhistory_java_timestamp_station_id_type_id_period_idx ON davide.elaborationhistory_java USING btree ("timestamp", station_id, type_id, period) WHERE ((type_id <> 21) AND (type_id <> 921) AND (type_id <> 41));


--
-- Name: elaborationhistory_java_type_id_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX elaborationhistory_java_type_id_idx ON davide.elaborationhistory_java USING btree (type_id);


--
-- Name: elaborationhistory_java_type_id_period_timestamp_station_id_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX elaborationhistory_java_type_id_period_timestamp_station_id_idx ON davide.elaborationhistory_java USING btree (type_id, period, "timestamp", station_id);


--
-- Name: elaborationhistory_python_period_type_id_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX elaborationhistory_python_period_type_id_idx ON davide.elaborationhistory_python USING btree (period, type_id);


--
-- Name: elaborationhistory_python_station_id_type_id_timestamp_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX elaborationhistory_python_station_id_type_id_timestamp_idx ON davide.elaborationhistory_python USING btree (station_id, type_id, "timestamp" DESC);


--
-- Name: elaborationhistory_python_timestamp_station_id_type_id_peri_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE UNIQUE INDEX elaborationhistory_python_timestamp_station_id_type_id_peri_idx ON davide.elaborationhistory_python USING btree ("timestamp", station_id, type_id, period) WHERE ((type_id <> 21) AND (type_id <> 921) AND (type_id <> 41));


--
-- Name: elaborationhistory_python_type_id_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX elaborationhistory_python_type_id_idx ON davide.elaborationhistory_python USING btree (type_id);


--
-- Name: elaborationhistory_python_type_id_period_timestamp_station__idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX elaborationhistory_python_type_id_period_timestamp_station__idx ON davide.elaborationhistory_python USING btree (type_id, period, "timestamp", station_id);


--
-- Name: index type; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX "index type" ON davide.elaborationhistory USING btree (type_id);


--
-- Name: left join intime.elaborationhistory; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX "left join intime.elaborationhistory" ON davide.elaborationhistory USING btree (station_id, type_id, "timestamp" DESC);


--
-- Name: measurementstringhistory_pytho_station_id_type_id_timestamp_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX measurementstringhistory_pytho_station_id_type_id_timestamp_idx ON davide.measurementstringhistory_python USING btree (station_id, type_id, "timestamp" DESC);


--
-- Name: measurementstringhistory_python_station_id_timestamp_value_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX measurementstringhistory_python_station_id_timestamp_value_idx ON davide.measurementstringhistory_python USING btree (station_id, "timestamp" DESC, value DESC);


--
-- Name: measurementstringhistory_python_station_id_type_id_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX measurementstringhistory_python_station_id_type_id_idx ON davide.measurementstringhistory_python USING btree (station_id, type_id);


--
-- Name: measurementstringhistory_python_timestamp_created_on_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX measurementstringhistory_python_timestamp_created_on_idx ON davide.measurementstringhistory_python USING btree ("timestamp", created_on);


--
-- Name: measurementstringhistory_python_timestamp_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX measurementstringhistory_python_timestamp_idx ON davide.measurementstringhistory_python USING btree ("timestamp" DESC);


--
-- Name: measurementstringhistory_station_id_timestamp_value_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX measurementstringhistory_station_id_timestamp_value_idx ON davide.measurementstringhistory USING btree (station_id, "timestamp" DESC, value DESC);


--
-- Name: measurementstringhistory_station_id_type_id_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX measurementstringhistory_station_id_type_id_idx ON davide.measurementstringhistory USING btree (station_id, type_id);


--
-- Name: measurementstringhistory_station_id_type_id_timestamp_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX measurementstringhistory_station_id_type_id_timestamp_idx ON davide.measurementstringhistory USING btree (station_id, type_id, "timestamp" DESC);


--
-- Name: measurementstringhistory_timestamp_created_on_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX measurementstringhistory_timestamp_created_on_idx ON davide.measurementstringhistory USING btree ("timestamp", created_on);


--
-- Name: measurementstringhistory_timestamp_idx; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX measurementstringhistory_timestamp_idx ON davide.measurementstringhistory USING btree ("timestamp" DESC);


--
-- Name: stop_duplicates_elaborationhistory; Type: INDEX; Schema: davide; Owner: -
--

CREATE UNIQUE INDEX stop_duplicates_elaborationhistory ON davide.elaborationhistory USING btree ("timestamp", station_id, type_id, period) WHERE ((type_id <> 21) AND (type_id <> 921) AND (type_id <> 41));


--
-- Name: type+period; Type: INDEX; Schema: davide; Owner: -
--

CREATE INDEX "type+period" ON davide.elaborationhistory USING btree (period, type_id);


--
-- Name: idx_measurement_timestamp; Type: INDEX; Schema: intimev2; Owner: -
--

CREATE INDEX idx_measurement_timestamp ON intimev2.measurement USING btree ("timestamp" DESC);


--
-- Name: idx_measurementhistory_created_on; Type: INDEX; Schema: intimev2; Owner: -
--

CREATE INDEX idx_measurementhistory_created_on ON intimev2.measurementhistory USING btree (created_on DESC);


--
-- Name: idx_measurementhistory_station_id_type_id_timestamp_period; Type: INDEX; Schema: intimev2; Owner: -
--

CREATE INDEX idx_measurementhistory_station_id_type_id_timestamp_period ON intimev2.measurementhistory USING btree (station_id, type_id, "timestamp" DESC, period);


--
-- Name: idx_measurementmobilehistory_no2_1_microgm3_ma; Type: INDEX; Schema: intimev2; Owner: -
--

CREATE INDEX idx_measurementmobilehistory_no2_1_microgm3_ma ON intimev2.measurementmobilehistory USING btree (no2_1_microgm3_ma);


--
-- Name: idx_measurementmobilehistory_no2_1_ppb; Type: INDEX; Schema: intimev2; Owner: -
--

CREATE INDEX idx_measurementmobilehistory_no2_1_ppb ON intimev2.measurementmobilehistory USING btree (no2_1_ppb);


--
-- Name: idx_measurementmobilehistory_station_id; Type: INDEX; Schema: intimev2; Owner: -
--

CREATE INDEX idx_measurementmobilehistory_station_id ON intimev2.measurementmobilehistory USING btree (station_id);


--
-- Name: idx_measurementmobilehistory_ts_ms; Type: INDEX; Schema: intimev2; Owner: -
--

CREATE INDEX idx_measurementmobilehistory_ts_ms ON intimev2.measurementmobilehistory USING btree (ts_ms);


--
-- Name: idx_measurementstring_timestamp; Type: INDEX; Schema: intimev2; Owner: -
--

CREATE INDEX idx_measurementstring_timestamp ON intimev2.measurementstring USING btree ("timestamp" DESC);


--
-- Name: idx_measurementstringhistory_created_on; Type: INDEX; Schema: intimev2; Owner: -
--

CREATE INDEX idx_measurementstringhistory_created_on ON intimev2.measurementstringhistory USING btree (created_on DESC);


--
-- Name: idx_measurementstringhistory_st_on_id_type_id_timestamp_period_; Type: INDEX; Schema: intimev2; Owner: -
--

CREATE INDEX idx_measurementstringhistory_st_on_id_type_id_timestamp_period_ ON intimev2.measurementstringhistory USING btree (station_id, type_id, "timestamp" DESC, period);


--
-- Name: idx_municipalities_geom; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_municipalities_geom ON public.municipalities USING gist (geom);


--
-- Name: idx_municipalities_name_i; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_municipalities_name_i ON public.municipalities USING btree (name_i);


--
-- Name: municipalities_geom_4326_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX municipalities_geom_4326_index ON public.municipalities USING gist (geom_4326);


--
-- Name: scheduler_run scheduler_run_task_id_fkey; Type: FK CONSTRAINT; Schema: davide; Owner: -
--

ALTER TABLE ONLY davide.scheduler_run
    ADD CONSTRAINT scheduler_run_task_id_fkey FOREIGN KEY (task_id) REFERENCES davide.scheduler_task(id) ON DELETE CASCADE;


--
-- Name: scheduler_run scheduler_run_task_id_fkey; Type: FK CONSTRAINT; Schema: elaboration; Owner: -
--

ALTER TABLE ONLY elaboration.scheduler_run
    ADD CONSTRAINT scheduler_run_task_id_fkey FOREIGN KEY (task_id) REFERENCES elaboration.scheduler_task(id) ON DELETE CASCADE;


--
-- Name: classification classification_type_id_fkey; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.classification
    ADD CONSTRAINT classification_type_id_fkey FOREIGN KEY (type_id) REFERENCES intimev2.type(id) ON DELETE CASCADE;


--
-- Name: copert_emisfact copert_emisfact_fk_type; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.copert_emisfact
    ADD CONSTRAINT copert_emisfact_fk_type FOREIGN KEY (type_id) REFERENCES intimev2.type(id);


--
-- Name: copert_emisfact copert_emisfact_id; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.copert_emisfact
    ADD CONSTRAINT copert_emisfact_id FOREIGN KEY (copert_parcom_id) REFERENCES intimev2.copert_parcom(id);


--
-- Name: bdprole fk_bdprole_parent_id_bdprole_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.bdprole
    ADD CONSTRAINT fk_bdprole_parent_id_bdprole_pk FOREIGN KEY (parent_id) REFERENCES intimev2.bdprole(id);


--
-- Name: bdprules fk_bdprules_role_id_bdprole_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.bdprules
    ADD CONSTRAINT fk_bdprules_role_id_bdprole_pk FOREIGN KEY (role_id) REFERENCES intimev2.bdprole(id);


--
-- Name: bdprules fk_bdprules_station_id_station_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.bdprules
    ADD CONSTRAINT fk_bdprules_station_id_station_pk FOREIGN KEY (station_id) REFERENCES intimev2.station(id);


--
-- Name: bdprules fk_bdprules_type_id_type_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.bdprules
    ADD CONSTRAINT fk_bdprules_type_id_type_pk FOREIGN KEY (type_id) REFERENCES intimev2.type(id);


--
-- Name: bdpusers_bdproles fk_bdpusers_bdproles_role_id_bdprole_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.bdpusers_bdproles
    ADD CONSTRAINT fk_bdpusers_bdproles_role_id_bdprole_pk FOREIGN KEY (role_id) REFERENCES intimev2.bdprole(id);


--
-- Name: bdpusers_bdproles fk_bdpusers_bdproles_user_id_bdpuser_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.bdpusers_bdproles
    ADD CONSTRAINT fk_bdpusers_bdproles_user_id_bdpuser_pk FOREIGN KEY (user_id) REFERENCES intimev2.bdpuser(id);


--
-- Name: edge fk_edge_destination_id_station_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.edge
    ADD CONSTRAINT fk_edge_destination_id_station_pk FOREIGN KEY (destination_id) REFERENCES intimev2.station(id);


--
-- Name: edge fk_edge_edge_data_id_station_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.edge
    ADD CONSTRAINT fk_edge_edge_data_id_station_pk FOREIGN KEY (edge_data_id) REFERENCES intimev2.station(id);


--
-- Name: edge fk_edge_origin_id_station_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.edge
    ADD CONSTRAINT fk_edge_origin_id_station_pk FOREIGN KEY (origin_id) REFERENCES intimev2.station(id);


--
-- Name: measurement fk_measurement_provenance_id_provenance_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurement
    ADD CONSTRAINT fk_measurement_provenance_id_provenance_pk FOREIGN KEY (provenance_id) REFERENCES intimev2.provenance(id);


--
-- Name: measurement fk_measurement_station_id_station_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurement
    ADD CONSTRAINT fk_measurement_station_id_station_pk FOREIGN KEY (station_id) REFERENCES intimev2.station(id);


--
-- Name: measurement fk_measurement_type_id_type_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurement
    ADD CONSTRAINT fk_measurement_type_id_type_pk FOREIGN KEY (type_id) REFERENCES intimev2.type(id);


--
-- Name: measurementhistory fk_measurementhistory_provenance_id_provenance_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurementhistory
    ADD CONSTRAINT fk_measurementhistory_provenance_id_provenance_pk FOREIGN KEY (provenance_id) REFERENCES intimev2.provenance(id);


--
-- Name: measurementhistory fk_measurementhistory_station_id_station_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurementhistory
    ADD CONSTRAINT fk_measurementhistory_station_id_station_pk FOREIGN KEY (station_id) REFERENCES intimev2.station(id);


--
-- Name: measurementhistory fk_measurementhistory_type_id_type_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurementhistory
    ADD CONSTRAINT fk_measurementhistory_type_id_type_pk FOREIGN KEY (type_id) REFERENCES intimev2.type(id);


--
-- Name: measurementstring fk_measurementstring_provenance_id_provenance_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurementstring
    ADD CONSTRAINT fk_measurementstring_provenance_id_provenance_pk FOREIGN KEY (provenance_id) REFERENCES intimev2.provenance(id);


--
-- Name: measurementstring fk_measurementstring_station_id_station_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurementstring
    ADD CONSTRAINT fk_measurementstring_station_id_station_pk FOREIGN KEY (station_id) REFERENCES intimev2.station(id);


--
-- Name: measurementstring fk_measurementstring_type_id_type_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurementstring
    ADD CONSTRAINT fk_measurementstring_type_id_type_pk FOREIGN KEY (type_id) REFERENCES intimev2.type(id);


--
-- Name: measurementstringhistory fk_measurementstringhistory_provenance_id_provenance_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurementstringhistory
    ADD CONSTRAINT fk_measurementstringhistory_provenance_id_provenance_pk FOREIGN KEY (provenance_id) REFERENCES intimev2.provenance(id);


--
-- Name: measurementstringhistory fk_measurementstringhistory_station_id_station_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurementstringhistory
    ADD CONSTRAINT fk_measurementstringhistory_station_id_station_pk FOREIGN KEY (station_id) REFERENCES intimev2.station(id);


--
-- Name: measurementstringhistory fk_measurementstringhistory_type_id_type_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.measurementstringhistory
    ADD CONSTRAINT fk_measurementstringhistory_type_id_type_pk FOREIGN KEY (type_id) REFERENCES intimev2.type(id);


--
-- Name: metadata fk_metadata_station_id_station_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.metadata
    ADD CONSTRAINT fk_metadata_station_id_station_pk FOREIGN KEY (station_id) REFERENCES intimev2.station(id);


--
-- Name: station fk_station_meta_data_id_metadata_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.station
    ADD CONSTRAINT fk_station_meta_data_id_metadata_pk FOREIGN KEY (meta_data_id) REFERENCES intimev2.metadata(id);


--
-- Name: station fk_station_parent_id_station_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.station
    ADD CONSTRAINT fk_station_parent_id_station_pk FOREIGN KEY (parent_id) REFERENCES intimev2.station(id);


--
-- Name: type fk_type_meta_data_id_type_metadata_pk; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.type
    ADD CONSTRAINT fk_type_meta_data_id_type_metadata_pk FOREIGN KEY (meta_data_id) REFERENCES intimev2.type_metadata(id);


--
-- Name: type_metadata type_metadata_type_id_fkey; Type: FK CONSTRAINT; Schema: intimev2; Owner: -
--

ALTER TABLE ONLY intimev2.type_metadata
    ADD CONSTRAINT type_metadata_type_id_fkey FOREIGN KEY (type_id) REFERENCES intimev2.type(id);


--
-- PostgreSQL database dump complete
--

