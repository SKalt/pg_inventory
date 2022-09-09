--     MIT License
-- 
--     Copyright (c) Microsoft Corporation.
-- 
--     Permission is hereby granted, free of charge, to any person obtaining a copy
--     of this software and associated documentation files (the "Software"), to deal
--     in the Software without restriction, including without limitation the rights
--     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--     copies of the Software, and to permit persons to whom the Software is
--     furnished to do so, subject to the following conditions:
-- 
--     The above copyright notice and this permission notice shall be included in all
--     copies or substantial portions of the Software.
-- 
--     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--     SOFTWARE---- END LICENSE ----
--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;






--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.3 (Ubuntu 14.3-1.pgdg20.04+1)

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
-- PostgreSQL database dump complete
--

--
-- Database "poll" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.3 (Ubuntu 14.3-1.pgdg20.04+1)

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
-- Name: poll; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE poll WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE poll OWNER TO postgres;

\connect poll

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
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.3 (Ubuntu 14.3-1.pgdg20.04+1)

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
-- Name: poll_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.poll_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poll_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: poll; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poll (
    id bigint DEFAULT nextval('public.poll_seq'::regclass) NOT NULL,
    surveyhostid bigint NOT NULL,
    title character varying(75) NOT NULL,
    metatitle character varying(100),
    summary text,
    type smallint DEFAULT 0 NOT NULL,
    published smallint DEFAULT 0 NOT NULL,
    createdat timestamp(0) without time zone NOT NULL,
    updatedat timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    publishedat timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    startsat timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    endsat timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    content text
);


ALTER TABLE public.poll OWNER TO postgres;

--
-- Name: poll_answer_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.poll_answer_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poll_answer_seq OWNER TO postgres;

--
-- Name: poll_answer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poll_answer (
    id bigint DEFAULT nextval('public.poll_answer_seq'::regclass) NOT NULL,
    pollid bigint NOT NULL,
    questionid bigint NOT NULL,
    active smallint DEFAULT 0 NOT NULL,
    createdat timestamp(0) without time zone NOT NULL,
    updatedat timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    content text
);


ALTER TABLE public.poll_answer OWNER TO postgres;

--
-- Name: poll_meta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.poll_meta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poll_meta_seq OWNER TO postgres;

--
-- Name: poll_meta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poll_meta (
    id bigint DEFAULT nextval('public.poll_meta_seq'::regclass) NOT NULL,
    pollid bigint NOT NULL,
    key character varying(50) NOT NULL,
    content text
);


ALTER TABLE public.poll_meta OWNER TO postgres;

--
-- Name: poll_question_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.poll_question_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poll_question_seq OWNER TO postgres;

--
-- Name: poll_question; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poll_question (
    id bigint DEFAULT nextval('public.poll_question_seq'::regclass) NOT NULL,
    pollid bigint NOT NULL,
    type character varying(50) NOT NULL,
    active smallint DEFAULT 0 NOT NULL,
    createdat timestamp(0) without time zone NOT NULL,
    updatedat timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    content text
);


ALTER TABLE public.poll_question OWNER TO postgres;

--
-- Name: users_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_seq OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint DEFAULT nextval('public.users_seq'::regclass) NOT NULL,
    firstname character varying(50) DEFAULT NULL::character varying,
    lastname character varying(50) DEFAULT NULL::character varying,
    email character varying(50),
    passwordhash character varying(32) NOT NULL,
    host smallint DEFAULT 0 NOT NULL,
    registeredat timestamp(0) without time zone NOT NULL,
    lastlogin timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    intro text,
    displayname text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: poll_answer poll_answer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll_answer
    ADD CONSTRAINT poll_answer_pkey PRIMARY KEY (id);


--
-- Name: poll_meta poll_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll_meta
    ADD CONSTRAINT poll_meta_pkey PRIMARY KEY (id);


--
-- Name: poll poll_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll
    ADD CONSTRAINT poll_pkey PRIMARY KEY (id);


--
-- Name: poll_question poll_question_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll_question
    ADD CONSTRAINT poll_question_pkey PRIMARY KEY (id);


--
-- Name: poll_meta uq_poll_meta; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll_meta
    ADD CONSTRAINT uq_poll_meta UNIQUE (pollid, key);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_answer_poll; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_answer_poll ON public.poll_answer USING btree (pollid);


--
-- Name: idx_answer_question; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_answer_question ON public.poll_answer USING btree (questionid);


--
-- Name: idx_meta_poll; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_meta_poll ON public.poll_meta USING btree (pollid);


--
-- Name: idx_question_poll; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_question_poll ON public.poll_question USING btree (pollid);


--
-- Name: poll_answer fk_answer_poll; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll_answer
    ADD CONSTRAINT fk_answer_poll FOREIGN KEY (pollid) REFERENCES public.poll(id);


--
-- Name: poll_answer fk_answer_question; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll_answer
    ADD CONSTRAINT fk_answer_question FOREIGN KEY (questionid) REFERENCES public.poll_question(id);


--
-- Name: poll_meta fk_meta_poll; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll_meta
    ADD CONSTRAINT fk_meta_poll FOREIGN KEY (pollid) REFERENCES public.poll(id);


--
-- Name: poll fk_poll_host; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll
    ADD CONSTRAINT fk_poll_host FOREIGN KEY (surveyhostid) REFERENCES public.users(id);


--
-- Name: poll_question fk_question_poll; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poll_question
    ADD CONSTRAINT fk_question_poll FOREIGN KEY (pollid) REFERENCES public.poll(id);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

