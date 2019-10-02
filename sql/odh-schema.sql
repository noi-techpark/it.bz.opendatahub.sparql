--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5 (Ubuntu 11.5-1.pgdg19.04+1)
-- Dumped by pg_dump version 11.5 (Ubuntu 11.5-1.pgdg19.04+1)

-- Started on 2019-09-16 15:57:31 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
--SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3 (class 3079 OID 54870)
-- Name: cube; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS cube WITH SCHEMA public;


--
-- TOC entry 2 (class 3079 OID 54957)
-- Name: earthdistance; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS earthdistance WITH SCHEMA public;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 198 (class 1259 OID 54973)
-- Name: AspNetRoles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."AspNetRoles" (
    "Id" character varying(128) NOT NULL,
    "Name" character varying(256) NOT NULL
);


--
-- TOC entry 199 (class 1259 OID 54976)
-- Name: AspNetUserClaims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."AspNetUserClaims" (
    "Id" integer NOT NULL,
    "ClaimType" character varying(256),
    "ClaimValue" character varying(256),
    "UserId" character varying(128) NOT NULL
);


--
-- TOC entry 200 (class 1259 OID 54982)
-- Name: AspNetUserClaims_Id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."AspNetUserClaims_Id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3456 (class 0 OID 0)
-- Dependencies: 200
-- Name: AspNetUserClaims_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."AspNetUserClaims_Id_seq" OWNED BY public."AspNetUserClaims"."Id";


--
-- TOC entry 201 (class 1259 OID 54984)
-- Name: AspNetUserLogins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."AspNetUserLogins" (
    "UserId" character varying(128) NOT NULL,
    "LoginProvider" character varying(128) NOT NULL,
    "ProviderKey" character varying(128) NOT NULL
);


--
-- TOC entry 202 (class 1259 OID 54987)
-- Name: AspNetUserRoles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."AspNetUserRoles" (
    "UserId" character varying(128) NOT NULL,
    "RoleId" character varying(128) NOT NULL
);


--
-- TOC entry 203 (class 1259 OID 54990)
-- Name: AspNetUsers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."AspNetUsers" (
    "Id" character varying(128) NOT NULL,
    "UserName" character varying(256) NOT NULL,
    "PasswordHash" character varying(256),
    "SecurityStamp" character varying(256),
    "Email" character varying(256) DEFAULT NULL::character varying,
    "EmailConfirmed" boolean DEFAULT false NOT NULL
);


--
-- TOC entry 204 (class 1259 OID 54998)
-- Name: accommodationrooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accommodationrooms (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 205 (class 1259 OID 55004)
-- Name: accommodationroomsopen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accommodationroomsopen (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 206 (class 1259 OID 55010)
-- Name: accommodations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accommodations (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 207 (class 1259 OID 55016)
-- Name: accommodationsopen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accommodationsopen (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 208 (class 1259 OID 55022)
-- Name: accothemesmobiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accothemesmobiles (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 209 (class 1259 OID 55028)
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 210 (class 1259 OID 55034)
-- Name: activitiesopen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activitiesopen (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 211 (class 1259 OID 55040)
-- Name: alpinebits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alpinebits (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 212 (class 1259 OID 55046)
-- Name: appmessages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appmessages (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 213 (class 1259 OID 55052)
-- Name: appsuggestions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appsuggestions (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 214 (class 1259 OID 55058)
-- Name: areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.areas (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 215 (class 1259 OID 55064)
-- Name: articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.articles (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 216 (class 1259 OID 55070)
-- Name: articlesopen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.articlesopen (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 217 (class 1259 OID 55076)
-- Name: districts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.districts (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 218 (class 1259 OID 55082)
-- Name: districtsopen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.districtsopen (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 219 (class 1259 OID 55088)
-- Name: eventeuracnoi; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.eventeuracnoi (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 220 (class 1259 OID 55094)
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id character varying(50) NOT NULL,
    data jsonb,
    latitude double precision,
    longitude double precision,
    begindate timestamp without time zone,
    enddate timestamp without time zone,
    nextbegindate timestamp without time zone
);


--
-- TOC entry 221 (class 1259 OID 55100)
-- Name: eventsopen; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 222 (class 1259 OID 55106)
-- Name: experienceareas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.experienceareas (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 223 (class 1259 OID 55112)
-- Name: experienceareasopen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.experienceareasopen (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 224 (class 1259 OID 55118)
-- Name: gastronomies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gastronomies (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 225 (class 1259 OID 55124)
-- Name: gastronomiesopen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gastronomiesopen (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 226 (class 1259 OID 55130)
-- Name: ltstaggingtypes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ltstaggingtypes (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 227 (class 1259 OID 55136)
-- Name: marketinggroups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.marketinggroups (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 228 (class 1259 OID 55142)
-- Name: measuringpoints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measuringpoints (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 229 (class 1259 OID 55148)
-- Name: metaregions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metaregions (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 230 (class 1259 OID 55154)
-- Name: metaregionsopen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metaregionsopen (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 231 (class 1259 OID 55160)
-- Name: mobilehtmls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mobilehtmls (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 232 (class 1259 OID 55166)
-- Name: municipalities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.municipalities (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 233 (class 1259 OID 55172)
-- Name: municipalitiesopen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.municipalitiesopen (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 234 (class 1259 OID 55178)
-- Name: natureparks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.natureparks (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 235 (class 1259 OID 55184)
-- Name: packages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.packages (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 236 (class 1259 OID 55190)
-- Name: pois; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pois (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 237 (class 1259 OID 55196)
-- Name: poisopen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poisopen (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 238 (class 1259 OID 55202)
-- Name: regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regions (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 239 (class 1259 OID 55208)
-- Name: regionsopen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regionsopen (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 240 (class 1259 OID 55214)
-- Name: skiareas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skiareas (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 241 (class 1259 OID 55220)
-- Name: skiareasopen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skiareasopen (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 242 (class 1259 OID 55226)
-- Name: skiregions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skiregions (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 243 (class 1259 OID 55232)
-- Name: skiregionsopen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skiregionsopen (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 244 (class 1259 OID 55238)
-- Name: smgpois; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smgpois (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 245 (class 1259 OID 55244)
-- Name: smgpoismobilefilters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smgpoismobilefilters (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 246 (class 1259 OID 55250)
-- Name: smgpoismobiletypes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smgpoismobiletypes (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 247 (class 1259 OID 55256)
-- Name: smgpoisopen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smgpoisopen (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 248 (class 1259 OID 55262)
-- Name: smgtags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smgtags (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 249 (class 1259 OID 55268)
-- Name: suedtiroltypes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.suedtiroltypes (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 250 (class 1259 OID 55274)
-- Name: tripplaners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tripplaners (
    id character varying(100) NOT NULL,
    data jsonb
);


--
-- TOC entry 251 (class 1259 OID 55280)
-- Name: tutorials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tutorials (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 252 (class 1259 OID 55286)
-- Name: tvs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tvs (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 253 (class 1259 OID 55292)
-- Name: tvsopen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tvsopen (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 254 (class 1259 OID 55298)
-- Name: userdevices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.userdevices (
    id character varying(100) NOT NULL,
    data jsonb
);


--
-- TOC entry 255 (class 1259 OID 55304)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id character varying(100) NOT NULL,
    data jsonb
);


--
-- TOC entry 256 (class 1259 OID 55310)
-- Name: wines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wines (
    id character varying(50) NOT NULL,
    data jsonb
);


--
-- TOC entry 3170 (class 2604 OID 55316)
-- Name: AspNetUserClaims Id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AspNetUserClaims" ALTER COLUMN "Id" SET DEFAULT nextval('public."AspNetUserClaims_Id_seq"'::regclass);


--
-- TOC entry 3174 (class 2606 OID 55318)
-- Name: AspNetRoles AspNetRoles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AspNetRoles"
    ADD CONSTRAINT "AspNetRoles_pkey" PRIMARY KEY ("Id");


--
-- TOC entry 3176 (class 2606 OID 55320)
-- Name: AspNetUserClaims AspNetUserClaims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AspNetUserClaims"
    ADD CONSTRAINT "AspNetUserClaims_pkey" PRIMARY KEY ("Id");


--
-- TOC entry 3179 (class 2606 OID 55322)
-- Name: AspNetUserLogins AspNetUserLogins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AspNetUserLogins"
    ADD CONSTRAINT "AspNetUserLogins_pkey" PRIMARY KEY ("UserId", "LoginProvider", "ProviderKey");


--
-- TOC entry 3182 (class 2606 OID 55324)
-- Name: AspNetUserRoles AspNetUserRoles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AspNetUserRoles"
    ADD CONSTRAINT "AspNetUserRoles_pkey" PRIMARY KEY ("UserId", "RoleId");


--
-- TOC entry 3186 (class 2606 OID 55326)
-- Name: AspNetUsers AspNetUsers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AspNetUsers"
    ADD CONSTRAINT "AspNetUsers_pkey" PRIMARY KEY ("Id");


--
-- TOC entry 3188 (class 2606 OID 55328)
-- Name: accommodationrooms accommodationrooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accommodationrooms
    ADD CONSTRAINT accommodationrooms_pkey PRIMARY KEY (id);


--
-- TOC entry 3191 (class 2606 OID 55330)
-- Name: accommodationroomsopen accommodationroomsopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accommodationroomsopen
    ADD CONSTRAINT accommodationroomsopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3195 (class 2606 OID 55332)
-- Name: accommodations accommodations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accommodations
    ADD CONSTRAINT accommodations_pkey PRIMARY KEY (id);


--
-- TOC entry 3199 (class 2606 OID 55334)
-- Name: accommodationsopen accommodationsopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accommodationsopen
    ADD CONSTRAINT accommodationsopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3204 (class 2606 OID 55336)
-- Name: accothemesmobiles accothemesmobiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accothemesmobiles
    ADD CONSTRAINT accothemesmobiles_pkey PRIMARY KEY (id);


--
-- TOC entry 3206 (class 2606 OID 55338)
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- TOC entry 3210 (class 2606 OID 55340)
-- Name: activitiesopen activitiesopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activitiesopen
    ADD CONSTRAINT activitiesopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3214 (class 2606 OID 55342)
-- Name: alpinebits alpinebits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alpinebits
    ADD CONSTRAINT alpinebits_pkey PRIMARY KEY (id);


--
-- TOC entry 3216 (class 2606 OID 55344)
-- Name: appmessages appmessages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appmessages
    ADD CONSTRAINT appmessages_pkey PRIMARY KEY (id);


--
-- TOC entry 3218 (class 2606 OID 55346)
-- Name: appsuggestions appsuggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appsuggestions
    ADD CONSTRAINT appsuggestions_pkey PRIMARY KEY (id);


--
-- TOC entry 3220 (class 2606 OID 55348)
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id);


--
-- TOC entry 3222 (class 2606 OID 55350)
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- TOC entry 3225 (class 2606 OID 55352)
-- Name: articlesopen articlesopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articlesopen
    ADD CONSTRAINT articlesopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3228 (class 2606 OID 55354)
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


--
-- TOC entry 3230 (class 2606 OID 55356)
-- Name: districtsopen districtsopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.districtsopen
    ADD CONSTRAINT districtsopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3232 (class 2606 OID 55358)
-- Name: eventeuracnoi eventeuracnoi_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventeuracnoi
    ADD CONSTRAINT eventeuracnoi_pkey PRIMARY KEY (id);


--
-- TOC entry 3235 (class 2606 OID 55360)
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- TOC entry 3239 (class 2606 OID 55362)
-- Name: eventsopen eventsopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventsopen
    ADD CONSTRAINT eventsopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3243 (class 2606 OID 55364)
-- Name: experienceareas experienceareas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experienceareas
    ADD CONSTRAINT experienceareas_pkey PRIMARY KEY (id);


--
-- TOC entry 3245 (class 2606 OID 55366)
-- Name: experienceareasopen experienceareasopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experienceareasopen
    ADD CONSTRAINT experienceareasopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3247 (class 2606 OID 55368)
-- Name: gastronomies gastronomies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gastronomies
    ADD CONSTRAINT gastronomies_pkey PRIMARY KEY (id);


--
-- TOC entry 3251 (class 2606 OID 55370)
-- Name: gastronomiesopen gastronomiesopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gastronomiesopen
    ADD CONSTRAINT gastronomiesopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3255 (class 2606 OID 55372)
-- Name: ltstaggingtypes ltstaggingtypes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ltstaggingtypes
    ADD CONSTRAINT ltstaggingtypes_pkey PRIMARY KEY (id);


--
-- TOC entry 3257 (class 2606 OID 55374)
-- Name: marketinggroups marketinggroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.marketinggroups
    ADD CONSTRAINT marketinggroups_pkey PRIMARY KEY (id);


--
-- TOC entry 3259 (class 2606 OID 55376)
-- Name: measuringpoints measuringpoints_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measuringpoints
    ADD CONSTRAINT measuringpoints_pkey PRIMARY KEY (id);


--
-- TOC entry 3261 (class 2606 OID 55378)
-- Name: metaregions metaregions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metaregions
    ADD CONSTRAINT metaregions_pkey PRIMARY KEY (id);


--
-- TOC entry 3263 (class 2606 OID 55380)
-- Name: metaregionsopen metaregionsopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metaregionsopen
    ADD CONSTRAINT metaregionsopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3265 (class 2606 OID 55382)
-- Name: mobilehtmls mobilehtmls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mobilehtmls
    ADD CONSTRAINT mobilehtmls_pkey PRIMARY KEY (id);


--
-- TOC entry 3267 (class 2606 OID 55384)
-- Name: municipalities municipalities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.municipalities
    ADD CONSTRAINT municipalities_pkey PRIMARY KEY (id);


--
-- TOC entry 3269 (class 2606 OID 55386)
-- Name: municipalitiesopen municipalitiesopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.municipalitiesopen
    ADD CONSTRAINT municipalitiesopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3271 (class 2606 OID 55388)
-- Name: natureparks natureparks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.natureparks
    ADD CONSTRAINT natureparks_pkey PRIMARY KEY (id);


--
-- TOC entry 3273 (class 2606 OID 55390)
-- Name: packages packages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- TOC entry 3276 (class 2606 OID 55392)
-- Name: pois pois_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pois
    ADD CONSTRAINT pois_pkey PRIMARY KEY (id);


--
-- TOC entry 3280 (class 2606 OID 55394)
-- Name: poisopen poisopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poisopen
    ADD CONSTRAINT poisopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3284 (class 2606 OID 55396)
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- TOC entry 3286 (class 2606 OID 55398)
-- Name: regionsopen regionsopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regionsopen
    ADD CONSTRAINT regionsopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3288 (class 2606 OID 55400)
-- Name: skiareas skiareas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skiareas
    ADD CONSTRAINT skiareas_pkey PRIMARY KEY (id);


--
-- TOC entry 3290 (class 2606 OID 55402)
-- Name: skiareasopen skiareasopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skiareasopen
    ADD CONSTRAINT skiareasopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3292 (class 2606 OID 55404)
-- Name: skiregions skiregions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skiregions
    ADD CONSTRAINT skiregions_pkey PRIMARY KEY (id);


--
-- TOC entry 3294 (class 2606 OID 55406)
-- Name: skiregionsopen skiregionsopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skiregionsopen
    ADD CONSTRAINT skiregionsopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3296 (class 2606 OID 55408)
-- Name: smgpois smgpois_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smgpois
    ADD CONSTRAINT smgpois_pkey PRIMARY KEY (id);


--
-- TOC entry 3300 (class 2606 OID 55410)
-- Name: smgpoismobilefilters smgpoismobilefilters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smgpoismobilefilters
    ADD CONSTRAINT smgpoismobilefilters_pkey PRIMARY KEY (id);


--
-- TOC entry 3302 (class 2606 OID 55412)
-- Name: smgpoismobiletypes smgpoismobiletypes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smgpoismobiletypes
    ADD CONSTRAINT smgpoismobiletypes_pkey PRIMARY KEY (id);


--
-- TOC entry 3306 (class 2606 OID 55414)
-- Name: smgpoisopen smgpoisopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smgpoisopen
    ADD CONSTRAINT smgpoisopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3308 (class 2606 OID 55416)
-- Name: smgtags smgtags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smgtags
    ADD CONSTRAINT smgtags_pkey PRIMARY KEY (id);


--
-- TOC entry 3311 (class 2606 OID 55418)
-- Name: suedtiroltypes suedtiroltypes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suedtiroltypes
    ADD CONSTRAINT suedtiroltypes_pkey PRIMARY KEY (id);


--
-- TOC entry 3313 (class 2606 OID 55420)
-- Name: tripplaners tripplaners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tripplaners
    ADD CONSTRAINT tripplaners_pkey PRIMARY KEY (id);


--
-- TOC entry 3315 (class 2606 OID 55422)
-- Name: tutorials tutorials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tutorials
    ADD CONSTRAINT tutorials_pkey PRIMARY KEY (id);


--
-- TOC entry 3317 (class 2606 OID 55424)
-- Name: tvs tvs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tvs
    ADD CONSTRAINT tvs_pkey PRIMARY KEY (id);


--
-- TOC entry 3319 (class 2606 OID 55426)
-- Name: tvsopen tvsopen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tvsopen
    ADD CONSTRAINT tvsopen_pkey PRIMARY KEY (id);


--
-- TOC entry 3321 (class 2606 OID 55428)
-- Name: userdevices userdevices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userdevices
    ADD CONSTRAINT userdevices_pkey PRIMARY KEY (id);


--
-- TOC entry 3323 (class 2606 OID 55430)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3325 (class 2606 OID 55432)
-- Name: wines wines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wines
    ADD CONSTRAINT wines_pkey PRIMARY KEY (id);


--
-- TOC entry 3177 (class 1259 OID 55433)
-- Name: IX_AspNetUserClaims_UserId; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IX_AspNetUserClaims_UserId" ON public."AspNetUserClaims" USING btree ("UserId");


--
-- TOC entry 3180 (class 1259 OID 55434)
-- Name: IX_AspNetUserLogins_UserId; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IX_AspNetUserLogins_UserId" ON public."AspNetUserLogins" USING btree ("UserId");


--
-- TOC entry 3183 (class 1259 OID 55435)
-- Name: IX_AspNetUserRoles_RoleId; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IX_AspNetUserRoles_RoleId" ON public."AspNetUserRoles" USING btree ("RoleId");


--
-- TOC entry 3184 (class 1259 OID 55436)
-- Name: IX_AspNetUserRoles_UserId; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IX_AspNetUserRoles_UserId" ON public."AspNetUserRoles" USING btree ("UserId");


--
-- TOC entry 3193 (class 1259 OID 55437)
-- Name: accoearthix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX accoearthix ON public.accommodations USING gist (public.ll_to_earth(((data ->> 'Latitude'::text))::double precision, ((data ->> 'Longitude'::text))::double precision));


--
-- TOC entry 3200 (class 1259 OID 55438)
-- Name: accoopenearthix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX accoopenearthix ON public.accommodationsopen USING gist (public.ll_to_earth(((data ->> 'Latitude'::text))::double precision, ((data ->> 'Longitude'::text))::double precision));


--
-- TOC entry 3201 (class 1259 OID 55439)
-- Name: accoopenshortnamebtreeix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX accoopenshortnamebtreeix ON public.accommodationsopen USING btree (((data ->> 'Shortname'::text)));


--
-- TOC entry 3189 (class 1259 OID 55440)
-- Name: accoroomsa0ridbtreeix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX accoroomsa0ridbtreeix ON public.accommodationrooms USING btree (((data ->> 'A0RID'::text)));


--
-- TOC entry 3192 (class 1259 OID 55441)
-- Name: accoroomsopena0ridbtreeix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX accoroomsopena0ridbtreeix ON public.accommodationroomsopen USING btree (((data ->> 'A0RID'::text)));


--
-- TOC entry 3196 (class 1259 OID 55442)
-- Name: accosginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX accosginix ON public.accommodations USING gin (data);


--
-- TOC entry 3197 (class 1259 OID 55443)
-- Name: accoshortnamebtreeix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX accoshortnamebtreeix ON public.accommodations USING btree (((data ->> 'Shortname'::text)));


--
-- TOC entry 3202 (class 1259 OID 55444)
-- Name: accosopenginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX accosopenginix ON public.accommodationsopen USING gin (data);


--
-- TOC entry 3207 (class 1259 OID 55445)
-- Name: activitiesearthix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activitiesearthix ON public.activities USING gist (public.ll_to_earth(((((data -> 'GpsPoints'::text) -> 'position'::text) ->> 'Latitude'::text))::double precision, ((((data -> 'GpsPoints'::text) -> 'position'::text) ->> 'Longitude'::text))::double precision));


--
-- TOC entry 3208 (class 1259 OID 55446)
-- Name: activitiesginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activitiesginix ON public.activities USING gin (data);


--
-- TOC entry 3211 (class 1259 OID 55447)
-- Name: activitiesopenearthix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activitiesopenearthix ON public.activitiesopen USING gist (public.ll_to_earth(((((data -> 'GpsPoints'::text) -> 'position'::text) ->> 'Latitude'::text))::double precision, ((((data -> 'GpsPoints'::text) -> 'position'::text) ->> 'Longitude'::text))::double precision));


--
-- TOC entry 3212 (class 1259 OID 55448)
-- Name: activitiesopenginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activitiesopenginix ON public.activitiesopen USING gin (data);


--
-- TOC entry 3223 (class 1259 OID 55449)
-- Name: articlesginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX articlesginix ON public.articles USING gin (data);


--
-- TOC entry 3226 (class 1259 OID 55450)
-- Name: articlesopenginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX articlesopenginix ON public.articlesopen USING gin (data);


--
-- TOC entry 3233 (class 1259 OID 55451)
-- Name: eventeuracnoiginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX eventeuracnoiginix ON public.eventeuracnoi USING gin (data);


--
-- TOC entry 3236 (class 1259 OID 55452)
-- Name: eventsearthix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX eventsearthix ON public.events USING gist (public.ll_to_earth(((data ->> 'Latitude'::text))::double precision, ((data ->> 'Longitude'::text))::double precision));


--
-- TOC entry 3237 (class 1259 OID 55453)
-- Name: eventsginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX eventsginix ON public.events USING gin (data);


--
-- TOC entry 3240 (class 1259 OID 55454)
-- Name: eventsopenearthix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX eventsopenearthix ON public.eventsopen USING gist (public.ll_to_earth(((data ->> 'Latitude'::text))::double precision, ((data ->> 'Longitude'::text))::double precision));


--
-- TOC entry 3241 (class 1259 OID 55455)
-- Name: eventsopenginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX eventsopenginix ON public.eventsopen USING gin (data);


--
-- TOC entry 3248 (class 1259 OID 55456)
-- Name: gastronomiesearthix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gastronomiesearthix ON public.gastronomies USING gist (public.ll_to_earth(((data ->> 'Latitude'::text))::double precision, ((data ->> 'Longitude'::text))::double precision));


--
-- TOC entry 3249 (class 1259 OID 55457)
-- Name: gastronomiesginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gastronomiesginix ON public.gastronomies USING gin (data);


--
-- TOC entry 3252 (class 1259 OID 55458)
-- Name: gastronomiesopenearthix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gastronomiesopenearthix ON public.gastronomiesopen USING gist (public.ll_to_earth(((data ->> 'Latitude'::text))::double precision, ((data ->> 'Longitude'::text))::double precision));


--
-- TOC entry 3253 (class 1259 OID 55459)
-- Name: gastronomiesopenginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gastronomiesopenginix ON public.gastronomiesopen USING gin (data);


--
-- TOC entry 3274 (class 1259 OID 55460)
-- Name: packagesginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX packagesginix ON public.packages USING gin (data);


--
-- TOC entry 3277 (class 1259 OID 55461)
-- Name: poisearthix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX poisearthix ON public.pois USING gist (public.ll_to_earth(((((data -> 'GpsPoints'::text) -> 'position'::text) ->> 'Latitude'::text))::double precision, ((((data -> 'GpsPoints'::text) -> 'position'::text) ->> 'Longitude'::text))::double precision));


--
-- TOC entry 3278 (class 1259 OID 55462)
-- Name: poisginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX poisginix ON public.pois USING gin (data);


--
-- TOC entry 3281 (class 1259 OID 55463)
-- Name: poisopenearthix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX poisopenearthix ON public.poisopen USING gist (public.ll_to_earth(((((data -> 'GpsPoints'::text) -> 'position'::text) ->> 'Latitude'::text))::double precision, ((((data -> 'GpsPoints'::text) -> 'position'::text) ->> 'Longitude'::text))::double precision));


--
-- TOC entry 3282 (class 1259 OID 55464)
-- Name: poisopenginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX poisopenginix ON public.poisopen USING gin (data);


--
-- TOC entry 3303 (class 1259 OID 55465)
-- Name: smgpoiopensearthix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smgpoiopensearthix ON public.smgpoisopen USING gist (public.ll_to_earth(((((data -> 'GpsPoints'::text) -> 'position'::text) ->> 'Latitude'::text))::double precision, ((((data -> 'GpsPoints'::text) -> 'position'::text) ->> 'Longitude'::text))::double precision));


--
-- TOC entry 3304 (class 1259 OID 55466)
-- Name: smgpoiopensginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smgpoiopensginix ON public.smgpoisopen USING gin (data);


--
-- TOC entry 3297 (class 1259 OID 55467)
-- Name: smgpoisearthix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smgpoisearthix ON public.smgpois USING gist (public.ll_to_earth(((((data -> 'GpsPoints'::text) -> 'position'::text) ->> 'Latitude'::text))::double precision, ((((data -> 'GpsPoints'::text) -> 'position'::text) ->> 'Longitude'::text))::double precision));


--
-- TOC entry 3298 (class 1259 OID 55468)
-- Name: smgpoisginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smgpoisginix ON public.smgpois USING gin (data);


--
-- TOC entry 3309 (class 1259 OID 55469)
-- Name: smgtagsginix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smgtagsginix ON public.smgtags USING gin (data);


--
-- TOC entry 3326 (class 2606 OID 55470)
-- Name: AspNetUserClaims FK_AspNetUserClaims_AspNetUsers_User_Id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AspNetUserClaims"
    ADD CONSTRAINT "FK_AspNetUserClaims_AspNetUsers_User_Id" FOREIGN KEY ("UserId") REFERENCES public."AspNetUsers"("Id") ON DELETE CASCADE;


--
-- TOC entry 3327 (class 2606 OID 55475)
-- Name: AspNetUserLogins FK_AspNetUserLogins_AspNetUsers_UserId; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AspNetUserLogins"
    ADD CONSTRAINT "FK_AspNetUserLogins_AspNetUsers_UserId" FOREIGN KEY ("UserId") REFERENCES public."AspNetUsers"("Id") ON DELETE CASCADE;


--
-- TOC entry 3328 (class 2606 OID 55480)
-- Name: AspNetUserRoles FK_AspNetUserRoles_AspNetRoles_RoleId; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AspNetUserRoles"
    ADD CONSTRAINT "FK_AspNetUserRoles_AspNetRoles_RoleId" FOREIGN KEY ("RoleId") REFERENCES public."AspNetRoles"("Id") ON DELETE CASCADE;


--
-- TOC entry 3329 (class 2606 OID 55485)
-- Name: AspNetUserRoles FK_AspNetUserRoles_AspNetUsers_UserId; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AspNetUserRoles"
    ADD CONSTRAINT "FK_AspNetUserRoles_AspNetUsers_UserId" FOREIGN KEY ("UserId") REFERENCES public."AspNetUsers"("Id") ON DELETE CASCADE;


-- Completed on 2019-09-16 15:57:31 CEST

--
-- PostgreSQL database dump complete
--

