--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.11
-- Dumped by pg_dump version 11.2

-- Started on 2019-11-12 10:25:10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
--SELECT pg_catalog.set_config('search_path', 'public', false);
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

-- BCOGREL ADDED
-- CREATE EXTENSION earthdistance CASCADE;

--
-- TOC entry 209 (class 1259 OID 20286628)
-- Name: accommodationroomsopen; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.accommodationroomsopen (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.accommodationroomsopen OWNER TO tourismuser;

--
-- TOC entry 207 (class 1259 OID 20267163)
-- Name: accommodationsopen; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.accommodationsopen (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.accommodationsopen OWNER TO tourismuser;

--
-- TOC entry 201 (class 1259 OID 20159500)
-- Name: activitiesopen; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.activitiesopen (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.activitiesopen OWNER TO tourismuser;

--
-- TOC entry 225 (class 1259 OID 20337093)
-- Name: areas; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.areas (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.areas OWNER TO tourismuser;

--
-- TOC entry 211 (class 1259 OID 20328282)
-- Name: articlesopen; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.articlesopen (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.articlesopen OWNER TO tourismuser;

--
-- TOC entry 224 (class 1259 OID 20337085)
-- Name: districtsopen; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.districtsopen (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.districtsopen OWNER TO tourismuser;

--
-- TOC entry 196 (class 1259 OID 3240997)
-- Name: eventeuracnoi; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.eventeuracnoi (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.eventeuracnoi OWNER TO tourismuser;

--
-- TOC entry 245 (class 1259 OID 20337343)
-- Name: eventsopen; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.eventsopen (
    id character varying(50) NOT NULL,
    data jsonb,
    latitude double precision,
    longitude double precision,
    begindate timestamp without time zone,
    enddate timestamp without time zone,
    nextbegindate timestamp without time zone
);


ALTER TABLE public.eventsopen OWNER TO tourismuser;

--
-- TOC entry 198 (class 1259 OID 20159476)
-- Name: experienceareas; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.experienceareas (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.experienceareas OWNER TO tourismuser;

--
-- TOC entry 214 (class 1259 OID 20332882)
-- Name: gastronomiesopen; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.gastronomiesopen (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.gastronomiesopen OWNER TO tourismuser;

--
-- TOC entry 232 (class 1259 OID 20337211)
-- Name: ltstaggingtypes; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.ltstaggingtypes (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.ltstaggingtypes OWNER TO tourismuser;

--
-- TOC entry 231 (class 1259 OID 20337203)
-- Name: measuringpoints; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.measuringpoints (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.measuringpoints OWNER TO tourismuser;

--
-- TOC entry 216 (class 1259 OID 20336835)
-- Name: metaregionsopen; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.metaregionsopen (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.metaregionsopen OWNER TO tourismuser;

--
-- TOC entry 222 (class 1259 OID 20337063)
-- Name: municipalitiesopen; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.municipalitiesopen (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.municipalitiesopen OWNER TO tourismuser;

--
-- TOC entry 203 (class 1259 OID 20169381)
-- Name: poisopen; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.poisopen (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.poisopen OWNER TO tourismuser;

--
-- TOC entry 218 (class 1259 OID 20336853)
-- Name: regionsopen; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.regionsopen (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.regionsopen OWNER TO tourismuser;

--
-- TOC entry 227 (class 1259 OID 20337109)
-- Name: skiareasopen; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.skiareasopen (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.skiareasopen OWNER TO tourismuser;

--
-- TOC entry 229 (class 1259 OID 20337179)
-- Name: skiregionsopen; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.skiregionsopen (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.skiregionsopen OWNER TO tourismuser;

--
-- TOC entry 205 (class 1259 OID 20237119)
-- Name: smgpoisopen; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.smgpoisopen (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.smgpoisopen OWNER TO tourismuser;

--
-- TOC entry 234 (class 1259 OID 20337227)
-- Name: smgtags; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.smgtags (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.smgtags OWNER TO tourismuser;

--
-- TOC entry 233 (class 1259 OID 20337219)
-- Name: suedtiroltypes; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.suedtiroltypes (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.suedtiroltypes OWNER TO tourismuser;

--
-- TOC entry 220 (class 1259 OID 20336893)
-- Name: tvsopen; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.tvsopen (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.tvsopen OWNER TO tourismuser;

--
-- TOC entry 230 (class 1259 OID 20337195)
-- Name: wines; Type: TABLE; Schema: public; Owner: tourismuser
--

CREATE TABLE public.wines (
    id character varying(50) NOT NULL,
    data jsonb
);


ALTER TABLE public.wines OWNER TO tourismuser;
