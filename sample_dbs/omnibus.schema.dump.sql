-- Portions Copyright © 1996-2022, The PostgreSQL Global Development Group
-- 
-- Portions Copyright © 1994, The Regents of the University of California
-- 
-- Permission to use, copy, modify, and distribute this software and its documentation for any purpose, without fee, and without a written agreement is hereby granted, provided that the above copyright notice and this paragraph and the following two paragraphs appear in all copies.
-- 
-- IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-- 
-- THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATIONS TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
---- END LICENSE ----
--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE alice;
ALTER ROLE alice WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE am_owner;
ALTER ROLE am_owner WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE base_type_owner;
ALTER ROLE base_type_owner WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE blade_runner;
ALTER ROLE blade_runner WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE bob;
ALTER ROLE bob WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE carl;
ALTER ROLE carl WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE castor;
ALTER ROLE castor WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE composite_type_owner;
ALTER ROLE composite_type_owner WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE conversion_owner;
ALTER ROLE conversion_owner WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE db_consumer;
ALTER ROLE db_consumer WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE db_creator;
ALTER ROLE db_creator WITH NOSUPERUSER INHERIT NOCREATEROLE CREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE db_owner;
ALTER ROLE db_owner WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE domain_owner;
ALTER ROLE domain_owner WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE enum_owner;
ALTER ROLE enum_owner WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE example_users;
ALTER ROLE example_users WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE extension_user;
ALTER ROLE extension_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE fn_owner;
ALTER ROLE fn_owner WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE foreign_db_owner;
ALTER ROLE foreign_db_owner WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:2FQZdVLolRTNzxLp/dY5Og==$FOotcI266v31LFjzARmD6Sz49HR3QYeSc7mPR8XxwtI=:EO3+Za7PTwI/Hc0/ywc5uqIW+YZDjhsy8XUyxz9yAiA=';
CREATE ROLE inheritor;
ALTER ROLE inheritor WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE no_create_role;
ALTER ROLE no_create_role WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE no_rls;
ALTER ROLE no_rls WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION BYPASSRLS;
CREATE ROLE nope;
ALTER ROLE nope WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE normal_user;
ALTER ROLE normal_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE ordinary_table_owner;
ALTER ROLE ordinary_table_owner WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;
CREATE ROLE regress_rls_alice;
ALTER ROLE regress_rls_alice WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE regress_rls_bob;
ALTER ROLE regress_rls_bob WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE regress_rls_carol;
ALTER ROLE regress_rls_carol WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE regress_rls_dave;
ALTER ROLE regress_rls_dave WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE regress_rls_dob_role1;
ALTER ROLE regress_rls_dob_role1 WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE regress_rls_dob_role2;
ALTER ROLE regress_rls_dob_role2 WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE regress_rls_eve;
ALTER ROLE regress_rls_eve WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE regress_rls_exempt_user;
ALTER ROLE regress_rls_exempt_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION BYPASSRLS;
CREATE ROLE regress_rls_frank;
ALTER ROLE regress_rls_frank WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE regress_rls_group1;
ALTER ROLE regress_rls_group1 WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE regress_rls_group2;
ALTER ROLE regress_rls_group2 WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE replicant;
ALTER ROLE replicant WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN REPLICATION NOBYPASSRLS;
CREATE ROLE rls_enforced;
ALTER ROLE rls_enforced WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE role_progenitor;
ALTER ROLE role_progenitor WITH NOSUPERUSER INHERIT CREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE super_user;
ALTER ROLE super_user WITH SUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE tablespace_owner;
ALTER ROLE tablespace_owner WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;


--
-- Role memberships
--

GRANT db_creator TO inheritor GRANTED BY postgres;
GRANT db_creator TO nope GRANTED BY postgres;
GRANT example_users TO alice GRANTED BY postgres;
GRANT example_users TO bob GRANTED BY postgres;
GRANT example_users TO carl GRANTED BY postgres;
GRANT normal_user TO inheritor GRANTED BY postgres;
GRANT normal_user TO nope GRANTED BY postgres;
GRANT regress_rls_group1 TO regress_rls_bob GRANTED BY postgres;
GRANT regress_rls_group2 TO regress_rls_carol GRANTED BY postgres;
GRANT replicant TO inheritor GRANTED BY postgres;
GRANT replicant TO nope GRANTED BY postgres;
GRANT role_progenitor TO inheritor GRANTED BY postgres;
GRANT role_progenitor TO nope GRANTED BY postgres;


--
-- Tablespaces
--

CREATE TABLESPACE example_tablespace OWNER postgres LOCATION '/data/example_tablespace';
CREATE TABLESPACE indexspace OWNER tablespace_owner LOCATION '/data/indices_tablespace';


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
-- Database "db_in_tablespace" dump
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
-- Name: db_in_tablespace; Type: DATABASE; Schema: -; Owner: tablespace_owner
--

CREATE DATABASE db_in_tablespace WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8' TABLESPACE = example_tablespace;


ALTER DATABASE db_in_tablespace OWNER TO tablespace_owner;

\connect db_in_tablespace

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
-- Database "example" dump
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
-- Name: example; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE example WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE example OWNER TO postgres;

\connect example

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
-- Database "example_cloned" dump
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
-- Name: example_cloned; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE example_cloned WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE example_cloned OWNER TO postgres;

\connect example_cloned

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
-- Database "example_owned" dump
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
-- Name: example_owned; Type: DATABASE; Schema: -; Owner: db_owner
--

CREATE DATABASE example_owned WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE example_owned OWNER TO db_owner;

\connect example_owned

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
-- Database "example_owned_template" dump
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
-- Name: example_owned_template; Type: DATABASE; Schema: -; Owner: db_owner
--

CREATE DATABASE example_owned_template WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE example_owned_template OWNER TO db_owner;

\connect example_owned_template

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
-- Name: example_owned_template; Type: DATABASE PROPERTIES; Schema: -; Owner: db_owner
--

ALTER DATABASE example_owned_template IS_TEMPLATE = true;


\connect example_owned_template

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
-- Database "example_utf8" dump
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
-- Name: example_utf8; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE example_utf8 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE example_utf8 OWNER TO postgres;

\connect example_utf8

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
-- Database "other_db" dump
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
-- Name: other_db; Type: DATABASE; Schema: -; Owner: foreign_db_owner
--

CREATE DATABASE other_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE other_db OWNER TO foreign_db_owner;

\connect other_db

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
-- Name: agg_ex; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA agg_ex;


ALTER SCHEMA agg_ex OWNER TO postgres;

--
-- Name: am_examples; Type: SCHEMA; Schema: -; Owner: am_owner
--

CREATE SCHEMA am_examples;


ALTER SCHEMA am_examples OWNER TO am_owner;

--
-- Name: base_type_examples; Type: SCHEMA; Schema: -; Owner: base_type_owner
--

CREATE SCHEMA base_type_examples;


ALTER SCHEMA base_type_examples OWNER TO base_type_owner;

--
-- Name: collation_ex; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA collation_ex;


ALTER SCHEMA collation_ex OWNER TO postgres;

--
-- Name: composite_type_examples; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA composite_type_examples;


ALTER SCHEMA composite_type_examples OWNER TO postgres;

--
-- Name: conversion_example; Type: SCHEMA; Schema: -; Owner: conversion_owner
--

CREATE SCHEMA conversion_example;


ALTER SCHEMA conversion_example OWNER TO conversion_owner;

--
-- Name: create_cast; Type: SCHEMA; Schema: -; Owner: castor
--

CREATE SCHEMA create_cast;


ALTER SCHEMA create_cast OWNER TO castor;

--
-- Name: domain_examples; Type: SCHEMA; Schema: -; Owner: domain_owner
--

CREATE SCHEMA domain_examples;


ALTER SCHEMA domain_examples OWNER TO domain_owner;

--
-- Name: enum_example; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA enum_example;


ALTER SCHEMA enum_example OWNER TO postgres;

--
-- Name: extension_example; Type: SCHEMA; Schema: -; Owner: extension_user
--

CREATE SCHEMA extension_example;


ALTER SCHEMA extension_example OWNER TO extension_user;

--
-- Name: fn_examples; Type: SCHEMA; Schema: -; Owner: fn_owner
--

CREATE SCHEMA fn_examples;


ALTER SCHEMA fn_examples OWNER TO fn_owner;

--
-- Name: foreign_db_example; Type: SCHEMA; Schema: -; Owner: foreign_db_owner
--

CREATE SCHEMA foreign_db_example;


ALTER SCHEMA foreign_db_example OWNER TO foreign_db_owner;

--
-- Name: idx_ex; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA idx_ex;


ALTER SCHEMA idx_ex OWNER TO postgres;

--
-- Name: ordinary_tables; Type: SCHEMA; Schema: -; Owner: ordinary_table_owner
--

CREATE SCHEMA ordinary_tables;


ALTER SCHEMA ordinary_tables OWNER TO ordinary_table_owner;

--
-- Name: regress_rls_schema; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA regress_rls_schema;


ALTER SCHEMA regress_rls_schema OWNER TO postgres;

--
-- Name: tablespace_dependencies; Type: SCHEMA; Schema: -; Owner: tablespace_owner
--

CREATE SCHEMA tablespace_dependencies;


ALTER SCHEMA tablespace_dependencies OWNER TO tablespace_owner;

--
-- Name: trigger_test; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA trigger_test;


ALTER SCHEMA trigger_test OWNER TO postgres;

--
-- Name: bad_french; Type: COLLATION; Schema: collation_ex; Owner: postgres
--

CREATE COLLATION collation_ex.bad_french (provider = libc, locale = 'fr_FR.utf8');


ALTER COLLATION collation_ex.bad_french OWNER TO postgres;

--
-- Name: french; Type: COLLATION; Schema: collation_ex; Owner: postgres
--

CREATE COLLATION collation_ex.french (provider = libc, locale = 'fr_FR.utf8');


ALTER COLLATION collation_ex.french OWNER TO postgres;

--
-- Name: german_phonebook; Type: COLLATION; Schema: collation_ex; Owner: postgres
--

CREATE COLLATION collation_ex.german_phonebook (provider = icu, locale = 'de-u-co-phonebk');


ALTER COLLATION collation_ex.german_phonebook OWNER TO postgres;

--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA extension_example;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'extensions are effectively global, despite the WITH SCHEMA clause';


--
-- Name: postgres_fdw; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgres_fdw WITH SCHEMA foreign_db_example;


--
-- Name: EXTENSION postgres_fdw; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgres_fdw IS 'foreign-data wrapper for remote PostgreSQL servers';


--
-- Name: avg_state; Type: TYPE; Schema: agg_ex; Owner: postgres
--

CREATE TYPE agg_ex.avg_state AS (
	total bigint,
	count bigint
);


ALTER TYPE agg_ex.avg_state OWNER TO postgres;

--
-- Name: base_type; Type: SHELL TYPE; Schema: base_type_examples; Owner: postgres
--

CREATE TYPE base_type_examples.base_type;


--
-- Name: base_fn_in(cstring); Type: FUNCTION; Schema: base_type_examples; Owner: postgres
--

CREATE FUNCTION base_type_examples.base_fn_in(cstring) RETURNS base_type_examples.base_type
    LANGUAGE internal IMMUTABLE STRICT
    AS $$boolin$$;


ALTER FUNCTION base_type_examples.base_fn_in(cstring) OWNER TO postgres;

--
-- Name: base_fn_out(base_type_examples.base_type); Type: FUNCTION; Schema: base_type_examples; Owner: postgres
--

CREATE FUNCTION base_type_examples.base_fn_out(base_type_examples.base_type) RETURNS cstring
    LANGUAGE internal IMMUTABLE STRICT
    AS $$boolout$$;


ALTER FUNCTION base_type_examples.base_fn_out(base_type_examples.base_type) OWNER TO postgres;

--
-- Name: base_type; Type: TYPE; Schema: base_type_examples; Owner: postgres
--

CREATE TYPE base_type_examples.base_type (
    INTERNALLENGTH = variable,
    INPUT = base_type_examples.base_fn_in,
    OUTPUT = base_type_examples.base_fn_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE base_type_examples.base_type OWNER TO postgres;

--
-- Name: int42; Type: SHELL TYPE; Schema: base_type_examples; Owner: postgres
--

CREATE TYPE base_type_examples.int42;


--
-- Name: int42_in(cstring); Type: FUNCTION; Schema: base_type_examples; Owner: postgres
--

CREATE FUNCTION base_type_examples.int42_in(cstring) RETURNS base_type_examples.int42
    LANGUAGE internal IMMUTABLE STRICT
    AS $$int4in$$;


ALTER FUNCTION base_type_examples.int42_in(cstring) OWNER TO postgres;

--
-- Name: int42_out(base_type_examples.int42); Type: FUNCTION; Schema: base_type_examples; Owner: postgres
--

CREATE FUNCTION base_type_examples.int42_out(base_type_examples.int42) RETURNS cstring
    LANGUAGE internal IMMUTABLE STRICT
    AS $$int4out$$;


ALTER FUNCTION base_type_examples.int42_out(base_type_examples.int42) OWNER TO postgres;

--
-- Name: int42; Type: TYPE; Schema: base_type_examples; Owner: postgres
--

CREATE TYPE base_type_examples.int42 (
    INTERNALLENGTH = 4,
    INPUT = base_type_examples.int42_in,
    OUTPUT = base_type_examples.int42_out,
    DEFAULT = '42',
    ALIGNMENT = int4,
    STORAGE = plain,
    PASSEDBYVALUE
);


ALTER TYPE base_type_examples.int42 OWNER TO postgres;

--
-- Name: text_w_default; Type: SHELL TYPE; Schema: base_type_examples; Owner: postgres
--

CREATE TYPE base_type_examples.text_w_default;


--
-- Name: text_w_default_in(cstring); Type: FUNCTION; Schema: base_type_examples; Owner: postgres
--

CREATE FUNCTION base_type_examples.text_w_default_in(cstring) RETURNS base_type_examples.text_w_default
    LANGUAGE internal IMMUTABLE STRICT
    AS $$textin$$;


ALTER FUNCTION base_type_examples.text_w_default_in(cstring) OWNER TO postgres;

--
-- Name: text_w_default_out(base_type_examples.text_w_default); Type: FUNCTION; Schema: base_type_examples; Owner: postgres
--

CREATE FUNCTION base_type_examples.text_w_default_out(base_type_examples.text_w_default) RETURNS cstring
    LANGUAGE internal IMMUTABLE STRICT
    AS $$textout$$;


ALTER FUNCTION base_type_examples.text_w_default_out(base_type_examples.text_w_default) OWNER TO postgres;

--
-- Name: text_w_default; Type: TYPE; Schema: base_type_examples; Owner: postgres
--

CREATE TYPE base_type_examples.text_w_default (
    INTERNALLENGTH = variable,
    INPUT = base_type_examples.text_w_default_in,
    OUTPUT = base_type_examples.text_w_default_out,
    DEFAULT = 'zippo',
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE base_type_examples.text_w_default OWNER TO postgres;

--
-- Name: default_test_row; Type: TYPE; Schema: base_type_examples; Owner: postgres
--

CREATE TYPE base_type_examples.default_test_row AS (
	f1 base_type_examples.text_w_default,
	f2 base_type_examples.int42
);


ALTER TYPE base_type_examples.default_test_row OWNER TO postgres;

--
-- Name: TYPE default_test_row; Type: COMMENT; Schema: base_type_examples; Owner: postgres
--

COMMENT ON TYPE base_type_examples.default_test_row IS 'good comment';


--
-- Name: COLUMN default_test_row.f1; Type: COMMENT; Schema: base_type_examples; Owner: postgres
--

COMMENT ON COLUMN base_type_examples.default_test_row.f1 IS 'good comment';


--
-- Name: myvarchar; Type: SHELL TYPE; Schema: base_type_examples; Owner: postgres
--

CREATE TYPE base_type_examples.myvarchar;


--
-- Name: myvarcharin(cstring, oid, integer); Type: FUNCTION; Schema: base_type_examples; Owner: postgres
--

CREATE FUNCTION base_type_examples.myvarcharin(cstring, oid, integer) RETURNS base_type_examples.myvarchar
    LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE
    AS $$varcharin$$;


ALTER FUNCTION base_type_examples.myvarcharin(cstring, oid, integer) OWNER TO postgres;

--
-- Name: myvarcharout(base_type_examples.myvarchar); Type: FUNCTION; Schema: base_type_examples; Owner: postgres
--

CREATE FUNCTION base_type_examples.myvarcharout(base_type_examples.myvarchar) RETURNS cstring
    LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE
    AS $$varcharout$$;


ALTER FUNCTION base_type_examples.myvarcharout(base_type_examples.myvarchar) OWNER TO postgres;

--
-- Name: myvarcharrecv(internal, oid, integer); Type: FUNCTION; Schema: base_type_examples; Owner: postgres
--

CREATE FUNCTION base_type_examples.myvarcharrecv(internal, oid, integer) RETURNS base_type_examples.myvarchar
    LANGUAGE internal STABLE STRICT PARALLEL SAFE
    AS $$varcharrecv$$;


ALTER FUNCTION base_type_examples.myvarcharrecv(internal, oid, integer) OWNER TO postgres;

--
-- Name: myvarcharsend(base_type_examples.myvarchar); Type: FUNCTION; Schema: base_type_examples; Owner: postgres
--

CREATE FUNCTION base_type_examples.myvarcharsend(base_type_examples.myvarchar) RETURNS bytea
    LANGUAGE internal STABLE STRICT PARALLEL SAFE
    AS $$varcharsend$$;


ALTER FUNCTION base_type_examples.myvarcharsend(base_type_examples.myvarchar) OWNER TO postgres;

--
-- Name: myvarchar; Type: TYPE; Schema: base_type_examples; Owner: postgres
--

CREATE TYPE base_type_examples.myvarchar (
    INTERNALLENGTH = variable,
    INPUT = base_type_examples.myvarcharin,
    OUTPUT = base_type_examples.myvarcharout,
    RECEIVE = base_type_examples.myvarcharrecv,
    SEND = base_type_examples.myvarcharsend,
    TYPMOD_IN = varchartypmodin,
    TYPMOD_OUT = varchartypmodout,
    ANALYZE = ts_typanalyze,
    SUBSCRIPT = raw_array_subscript_handler,
    ALIGNMENT = int4,
    STORAGE = extended
);


ALTER TYPE base_type_examples.myvarchar OWNER TO postgres;

--
-- Name: myvarchardom; Type: DOMAIN; Schema: base_type_examples; Owner: postgres
--

CREATE DOMAIN base_type_examples.myvarchardom AS base_type_examples.myvarchar;


ALTER DOMAIN base_type_examples.myvarchardom OWNER TO postgres;

--
-- Name: shell; Type: TYPE; Schema: base_type_examples; Owner: postgres
--

CREATE TYPE base_type_examples.shell;


ALTER TYPE base_type_examples.shell OWNER TO postgres;

--
-- Name: basic_comp_type; Type: TYPE; Schema: composite_type_examples; Owner: postgres
--

CREATE TYPE composite_type_examples.basic_comp_type AS (
	f1 integer,
	f2 text
);


ALTER TYPE composite_type_examples.basic_comp_type OWNER TO postgres;

--
-- Name: enum_abc; Type: TYPE; Schema: composite_type_examples; Owner: postgres
--

CREATE TYPE composite_type_examples.enum_abc AS ENUM (
    'a',
    'b',
    'c'
);


ALTER TYPE composite_type_examples.enum_abc OWNER TO postgres;

--
-- Name: nested; Type: TYPE; Schema: composite_type_examples; Owner: postgres
--

CREATE TYPE composite_type_examples.nested AS (
	foo composite_type_examples.basic_comp_type,
	bar composite_type_examples.enum_abc
);


ALTER TYPE composite_type_examples.nested OWNER TO postgres;

--
-- Name: abc; Type: TYPE; Schema: create_cast; Owner: postgres
--

CREATE TYPE create_cast.abc AS ENUM (
    'a',
    'b',
    'c'
);


ALTER TYPE create_cast.abc OWNER TO postgres;

--
-- Name: is_positive(integer); Type: FUNCTION; Schema: domain_examples; Owner: postgres
--

CREATE FUNCTION domain_examples.is_positive(i integer) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
  SELECT i > 0
$$;


ALTER FUNCTION domain_examples.is_positive(i integer) OWNER TO postgres;

--
-- Name: positive_number; Type: DOMAIN; Schema: domain_examples; Owner: postgres
--

CREATE DOMAIN domain_examples.positive_number AS integer
	CONSTRAINT should_be_positive CHECK (domain_examples.is_positive(VALUE));


ALTER DOMAIN domain_examples.positive_number OWNER TO postgres;

--
-- Name: is_even(domain_examples.positive_number); Type: FUNCTION; Schema: domain_examples; Owner: postgres
--

CREATE FUNCTION domain_examples.is_even(i domain_examples.positive_number) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
  SELECT (i % 2) = 0
$$;


ALTER FUNCTION domain_examples.is_even(i domain_examples.positive_number) OWNER TO postgres;

--
-- Name: positive_even_number; Type: DOMAIN; Schema: domain_examples; Owner: postgres
--

CREATE DOMAIN domain_examples.positive_even_number AS domain_examples.positive_number
	CONSTRAINT should_be_even CHECK (domain_examples.is_even(VALUE));


ALTER DOMAIN domain_examples.positive_even_number OWNER TO postgres;

--
-- Name: us_postal_code; Type: DOMAIN; Schema: domain_examples; Owner: postgres
--

CREATE DOMAIN domain_examples.us_postal_code AS text
	CONSTRAINT check_postal_code_regex CHECK (((VALUE ~ '^\d{5}$'::text) OR (VALUE ~ '^\d{5}-\d{4}$'::text)));


ALTER DOMAIN domain_examples.us_postal_code OWNER TO postgres;

--
-- Name: DOMAIN us_postal_code; Type: COMMENT; Schema: domain_examples; Owner: postgres
--

COMMENT ON DOMAIN domain_examples.us_postal_code IS 'US postal code';


--
-- Name: bug_severity; Type: TYPE; Schema: enum_example; Owner: postgres
--

CREATE TYPE enum_example.bug_severity AS ENUM (
    'low',
    'med',
    'high'
);


ALTER TYPE enum_example.bug_severity OWNER TO postgres;

--
-- Name: bug_status; Type: TYPE; Schema: enum_example; Owner: postgres
--

CREATE TYPE enum_example.bug_status AS ENUM (
    'new',
    'open',
    'closed'
);


ALTER TYPE enum_example.bug_status OWNER TO postgres;

--
-- Name: TYPE bug_status; Type: COMMENT; Schema: enum_example; Owner: postgres
--

COMMENT ON TYPE enum_example.bug_status IS 'ENUM type';


--
-- Name: bug_info; Type: TYPE; Schema: enum_example; Owner: postgres
--

CREATE TYPE enum_example.bug_info AS (
	status enum_example.bug_status,
	severity enum_example.bug_severity
);


ALTER TYPE enum_example.bug_info OWNER TO postgres;

--
-- Name: example_type; Type: TYPE; Schema: foreign_db_example; Owner: postgres
--

CREATE TYPE foreign_db_example.example_type AS (
	a integer,
	b text
);


ALTER TYPE foreign_db_example.example_type OWNER TO postgres;

--
-- Name: is_positive(integer); Type: FUNCTION; Schema: foreign_db_example; Owner: postgres
--

CREATE FUNCTION foreign_db_example.is_positive(i integer) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
  SELECT i > 0
$$;


ALTER FUNCTION foreign_db_example.is_positive(i integer) OWNER TO postgres;

--
-- Name: positive_number; Type: DOMAIN; Schema: foreign_db_example; Owner: postgres
--

CREATE DOMAIN foreign_db_example.positive_number AS integer NOT NULL
	CONSTRAINT positive_number_check CHECK (foreign_db_example.is_positive(VALUE));


ALTER DOMAIN foreign_db_example.positive_number OWNER TO postgres;

--
-- Name: transmogrify(create_cast.abc); Type: FUNCTION; Schema: create_cast; Owner: postgres
--

CREATE FUNCTION create_cast.transmogrify(input create_cast.abc) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $$
  SELECT 1;
$$;


ALTER FUNCTION create_cast.transmogrify(input create_cast.abc) OWNER TO postgres;

--
-- Name: CAST (create_cast.abc AS integer); Type: CAST; Schema: -; Owner: -
--

CREATE CAST (create_cast.abc AS integer) WITH FUNCTION create_cast.transmogrify(create_cast.abc) AS ASSIGNMENT;


--
-- Name: avg_finalfn(agg_ex.avg_state); Type: FUNCTION; Schema: agg_ex; Owner: postgres
--

CREATE FUNCTION agg_ex.avg_finalfn(state agg_ex.avg_state) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	if state is null then
		return NULL;
	else
		return state.total / state.count;
	end if;
end
$$;


ALTER FUNCTION agg_ex.avg_finalfn(state agg_ex.avg_state) OWNER TO postgres;

--
-- Name: avg_transfn(agg_ex.avg_state, integer); Type: FUNCTION; Schema: agg_ex; Owner: postgres
--

CREATE FUNCTION agg_ex.avg_transfn(state agg_ex.avg_state, n integer) RETURNS agg_ex.avg_state
    LANGUAGE plpgsql
    AS $$
declare new_state agg_ex.avg_state;
begin
	raise notice 'agg_ex.avg_transfn called with %', n;
	if state is null then
		if n is not null then
			new_state.total := n;
			new_state.count := 1;
			return new_state;
		end if;
		return null;
	elsif n is not null then
		state.total := state.total + n;
		state.count := state.count + 1;
		return state;
	end if;

	return null;
end
$$;


ALTER FUNCTION agg_ex.avg_transfn(state agg_ex.avg_state, n integer) OWNER TO postgres;

--
-- Name: sum_finalfn(agg_ex.avg_state); Type: FUNCTION; Schema: agg_ex; Owner: postgres
--

CREATE FUNCTION agg_ex.sum_finalfn(state agg_ex.avg_state) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	if state is null then
		return NULL;
	else
		return state.total;
	end if;
end
$$;


ALTER FUNCTION agg_ex.sum_finalfn(state agg_ex.avg_state) OWNER TO postgres;

--
-- Name: fake_op(point, base_type_examples.int42); Type: FUNCTION; Schema: base_type_examples; Owner: postgres
--

CREATE FUNCTION base_type_examples.fake_op(point, base_type_examples.int42) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$ select true $$;


ALTER FUNCTION base_type_examples.fake_op(point, base_type_examples.int42) OWNER TO postgres;

--
-- Name: get_default_test(); Type: FUNCTION; Schema: base_type_examples; Owner: postgres
--

CREATE FUNCTION base_type_examples.get_default_test() RETURNS SETOF base_type_examples.default_test_row
    LANGUAGE sql
    AS $$
  SELECT * FROM base_type_examples.default_test;
$$;


ALTER FUNCTION base_type_examples.get_default_test() OWNER TO postgres;

--
-- Name: get_basic(); Type: FUNCTION; Schema: composite_type_examples; Owner: postgres
--

CREATE FUNCTION composite_type_examples.get_basic() RETURNS SETOF composite_type_examples.basic_comp_type
    LANGUAGE sql
    AS $$
  SELECT f1, f2 FROM composite_type_examples.equivalent_rowtype
$$;


ALTER FUNCTION composite_type_examples.get_basic() OWNER TO postgres;

--
-- Name: make_bug_info(enum_example.bug_status, enum_example.bug_severity); Type: FUNCTION; Schema: enum_example; Owner: postgres
--

CREATE FUNCTION enum_example.make_bug_info(status enum_example.bug_status, severity enum_example.bug_severity) RETURNS enum_example.bug_info
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT status, severity
  $$;


ALTER FUNCTION enum_example.make_bug_info(status enum_example.bug_status, severity enum_example.bug_severity) OWNER TO postgres;

--
-- Name: should_raise_alarm(enum_example.bug_info); Type: FUNCTION; Schema: enum_example; Owner: postgres
--

CREATE FUNCTION enum_example.should_raise_alarm(info enum_example.bug_info) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT info.status = 'new' AND info.severity = 'high'
  $$;


ALTER FUNCTION enum_example.should_raise_alarm(info enum_example.bug_info) OWNER TO postgres;

--
-- Name: _hstore(record); Type: FUNCTION; Schema: extension_example; Owner: postgres
--

CREATE FUNCTION extension_example._hstore(r record) RETURNS extension_example.hstore
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
    BEGIN
      return extension_example.hstore(r);
    END;
  $$;


ALTER FUNCTION extension_example._hstore(r record) OWNER TO postgres;

--
-- Name: depends_on_table_column(); Type: FUNCTION; Schema: fn_examples; Owner: postgres
--

CREATE FUNCTION fn_examples.depends_on_table_column() RETURNS integer
    LANGUAGE sql
    AS $$
  SELECT id FROM fn_examples.ordinary_table LIMIT 1
$$;


ALTER FUNCTION fn_examples.depends_on_table_column() OWNER TO postgres;

--
-- Name: depends_on_table_column_type(); Type: FUNCTION; Schema: fn_examples; Owner: postgres
--

CREATE FUNCTION fn_examples.depends_on_table_column_type() RETURNS integer
    LANGUAGE sql
    AS $$
    SELECT id FROM fn_examples.ordinary_table LIMIT 1
  $$;


ALTER FUNCTION fn_examples.depends_on_table_column_type() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ordinary_table; Type: TABLE; Schema: fn_examples; Owner: postgres
--

CREATE TABLE fn_examples.ordinary_table (
    id integer
);


ALTER TABLE fn_examples.ordinary_table OWNER TO postgres;

--
-- Name: depends_on_table_rowtype(); Type: FUNCTION; Schema: fn_examples; Owner: postgres
--

CREATE FUNCTION fn_examples.depends_on_table_rowtype() RETURNS fn_examples.ordinary_table
    LANGUAGE sql
    AS $$
  SELECT * FROM fn_examples.ordinary_table LIMIT 1
$$;


ALTER FUNCTION fn_examples.depends_on_table_rowtype() OWNER TO postgres;

--
-- Name: depends_on_view_column(); Type: FUNCTION; Schema: fn_examples; Owner: postgres
--

CREATE FUNCTION fn_examples.depends_on_view_column() RETURNS integer
    LANGUAGE sql
    AS $$
  SELECT id FROM fn_examples.basic_view LIMIT 1
$$;


ALTER FUNCTION fn_examples.depends_on_view_column() OWNER TO postgres;

--
-- Name: depends_on_view_column_type(); Type: FUNCTION; Schema: fn_examples; Owner: postgres
--

CREATE FUNCTION fn_examples.depends_on_view_column_type() RETURNS integer
    LANGUAGE sql
    AS $$
  SELECT id FROM fn_examples.basic_view LIMIT 1
$$;


ALTER FUNCTION fn_examples.depends_on_view_column_type() OWNER TO postgres;

--
-- Name: insert_to_table(); Type: PROCEDURE; Schema: fn_examples; Owner: postgres
--

CREATE PROCEDURE fn_examples.insert_to_table()
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF fn_examples.is_even(2) THEN
      INSERT INTO fn_examples.ordinary_table(id) VALUES (1);
    END IF;
  END;
$$;


ALTER PROCEDURE fn_examples.insert_to_table() OWNER TO postgres;

--
-- Name: is_even(integer); Type: FUNCTION; Schema: fn_examples; Owner: postgres
--

CREATE FUNCTION fn_examples.is_even(i integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF i % 2 = 0 THEN
    RETURN true;
  ELSE
    RETURN false;
  end if;
END;
$$;


ALTER FUNCTION fn_examples.is_even(i integer) OWNER TO postgres;

--
-- Name: is_odd(integer); Type: FUNCTION; Schema: fn_examples; Owner: postgres
--

CREATE FUNCTION fn_examples.is_odd(i integer) RETURNS boolean
    LANGUAGE sql
    AS $$
  SELECT (fn_examples.is_even(i) IS NOT true)
$$;


ALTER FUNCTION fn_examples.is_odd(i integer) OWNER TO postgres;

--
-- Name: polyf(anyelement); Type: FUNCTION; Schema: fn_examples; Owner: postgres
--

CREATE FUNCTION fn_examples.polyf(x anyelement) RETURNS anyelement
    LANGUAGE sql
    AS $$
  select x + 1
$$;


ALTER FUNCTION fn_examples.polyf(x anyelement) OWNER TO postgres;

--
-- Name: log_table_alteration(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_table_alteration() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE NOTICE 'command % issued', tg_tag;
END;
$$;


ALTER FUNCTION public.log_table_alteration() OWNER TO postgres;

--
-- Name: f_leak(text); Type: FUNCTION; Schema: regress_rls_schema; Owner: postgres
--

CREATE FUNCTION regress_rls_schema.f_leak(text) RETURNS boolean
    LANGUAGE plpgsql COST 1e-07
    AS $_$BEGIN RAISE NOTICE 'f_leak => %', $1; RETURN true; END$_$;


ALTER FUNCTION regress_rls_schema.f_leak(text) OWNER TO postgres;

--
-- Name: op_leak(integer, integer); Type: FUNCTION; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE FUNCTION regress_rls_schema.op_leak(integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$BEGIN RAISE NOTICE 'op_leak => %, %', $1, $2; RETURN $1 < $2; END$_$;


ALTER FUNCTION regress_rls_schema.op_leak(integer, integer) OWNER TO regress_rls_alice;

--
-- Name: check_account_update(); Type: FUNCTION; Schema: trigger_test; Owner: postgres
--

CREATE FUNCTION trigger_test.check_account_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
      RAISE NOTICE 'trigger_func(%) called: action = %, when = %, level = %, old = %, new = %',
                        TG_ARGV[0], TG_OP, TG_WHEN, TG_LEVEL, OLD, NEW;
      RETURN NULL;
    END;
  $$;


ALTER FUNCTION trigger_test.check_account_update() OWNER TO postgres;

--
-- Name: log_account_update(); Type: FUNCTION; Schema: trigger_test; Owner: postgres
--

CREATE FUNCTION trigger_test.log_account_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
      INSERT INTO trigger_test.update_log(account_id) VALUES (1);
      RETURN NULL;
    END;
  $$;


ALTER FUNCTION trigger_test.log_account_update() OWNER TO postgres;

--
-- Name: view_insert_row(); Type: FUNCTION; Schema: trigger_test; Owner: postgres
--

CREATE FUNCTION trigger_test.view_insert_row() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
      INSERT INTO trigger_test.accounts(id, balance) VALUES (NEW.id, NEW.balance);
      RETURN NEW;
    END;
  $$;


ALTER FUNCTION trigger_test.view_insert_row() OWNER TO postgres;

--
-- Name: my_avg(integer); Type: AGGREGATE; Schema: agg_ex; Owner: postgres
--

CREATE AGGREGATE agg_ex.my_avg(integer) (
    SFUNC = agg_ex.avg_transfn,
    STYPE = agg_ex.avg_state,
    FINALFUNC = agg_ex.avg_finalfn
);


ALTER AGGREGATE agg_ex.my_avg(integer) OWNER TO postgres;

--
-- Name: my_sum(integer); Type: AGGREGATE; Schema: agg_ex; Owner: postgres
--

CREATE AGGREGATE agg_ex.my_sum(integer) (
    SFUNC = agg_ex.avg_transfn,
    STYPE = agg_ex.avg_state,
    FINALFUNC = agg_ex.sum_finalfn
);


ALTER AGGREGATE agg_ex.my_sum(integer) OWNER TO postgres;

--
-- Name: gist2; Type: ACCESS METHOD; Schema: -; Owner: -
--

CREATE ACCESS METHOD gist2 TYPE INDEX HANDLER gisthandler;


--
-- Name: heap2; Type: ACCESS METHOD; Schema: -; Owner: -
--

CREATE ACCESS METHOD heap2 TYPE TABLE HANDLER heap_tableam_handler;


--
-- Name: <%; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR public.<% (
    FUNCTION = base_type_examples.fake_op,
    LEFTARG = point,
    RIGHTARG = base_type_examples.int42,
    COMMUTATOR = OPERATOR(public.>%),
    NEGATOR = OPERATOR(public.>=%)
);


ALTER OPERATOR public.<% (point, base_type_examples.int42) OWNER TO postgres;

--
-- Name: <<<; Type: OPERATOR; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE OPERATOR regress_rls_schema.<<< (
    FUNCTION = regress_rls_schema.op_leak,
    LEFTARG = integer,
    RIGHTARG = integer,
    RESTRICT = scalarltsel
);


ALTER OPERATOR regress_rls_schema.<<< (integer, integer) OWNER TO regress_rls_alice;

--
-- Name: box_ops; Type: OPERATOR FAMILY; Schema: am_examples; Owner: postgres
--

CREATE OPERATOR FAMILY am_examples.box_ops USING gist2;
ALTER OPERATOR FAMILY am_examples.box_ops USING gist2 ADD
    OPERATOR 1 <<(box,box) ,
    OPERATOR 2 &<(box,box) ,
    OPERATOR 3 &&(box,box) ,
    OPERATOR 4 &>(box,box) ,
    OPERATOR 5 >>(box,box) ,
    OPERATOR 6 ~=(box,box) ,
    OPERATOR 7 @>(box,box) ,
    OPERATOR 8 <@(box,box) ,
    OPERATOR 9 &<|(box,box) ,
    OPERATOR 10 <<|(box,box) ,
    OPERATOR 11 |>>(box,box) ,
    OPERATOR 12 |&>(box,box);


ALTER OPERATOR FAMILY am_examples.box_ops USING gist2 OWNER TO postgres;

--
-- Name: box_ops; Type: OPERATOR CLASS; Schema: am_examples; Owner: postgres
--

CREATE OPERATOR CLASS am_examples.box_ops
    DEFAULT FOR TYPE box USING gist2 FAMILY am_examples.box_ops AS
    FUNCTION 1 (box, box) gist_box_consistent(internal,box,smallint,oid,internal) ,
    FUNCTION 2 (box, box) gist_box_union(internal,internal) ,
    FUNCTION 5 (box, box) gist_box_penalty(internal,internal,internal) ,
    FUNCTION 6 (box, box) gist_box_picksplit(internal,internal) ,
    FUNCTION 7 (box, box) gist_box_same(box,box,internal);


ALTER OPERATOR CLASS am_examples.box_ops USING gist2 OWNER TO postgres;

--
-- Name: gist2_fam; Type: OPERATOR FAMILY; Schema: am_examples; Owner: postgres
--

CREATE OPERATOR FAMILY am_examples.gist2_fam USING gist2;


ALTER OPERATOR FAMILY am_examples.gist2_fam USING gist2 OWNER TO postgres;

--
-- Name: myconv; Type: CONVERSION; Schema: conversion_example; Owner: postgres
--

CREATE CONVERSION conversion_example.myconv FOR 'LATIN1' TO 'UTF8' FROM iso8859_1_to_utf8;


ALTER CONVERSION conversion_example.myconv OWNER TO postgres;

--
-- Name: technically_this_server; Type: SERVER; Schema: -; Owner: postgres
--

CREATE SERVER technically_this_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    dbname 'other_db',
    host 'localhost',
    port '5432'
);


ALTER SERVER technically_this_server OWNER TO postgres;

--
-- Name: USER MAPPING foreign_db_owner SERVER technically_this_server; Type: USER MAPPING; Schema: -; Owner: postgres
--

CREATE USER MAPPING FOR foreign_db_owner SERVER technically_this_server OPTIONS (
    password 'password',
    "user" 'foreign_db_owner'
);


--
-- Name: my_table; Type: TABLE; Schema: agg_ex; Owner: postgres
--

CREATE TABLE agg_ex.my_table (
    i integer
);


ALTER TABLE agg_ex.my_table OWNER TO postgres;

--
-- Name: my_view; Type: VIEW; Schema: agg_ex; Owner: postgres
--

CREATE VIEW agg_ex.my_view AS
 SELECT agg_ex.my_sum(my_table.i) AS my_sum,
    agg_ex.my_avg(my_table.i) AS my_avg
   FROM agg_ex.my_table;


ALTER TABLE agg_ex.my_view OWNER TO postgres;

--
-- Name: am_partitioned; Type: TABLE; Schema: am_examples; Owner: postgres
--

CREATE TABLE am_examples.am_partitioned (
    x integer,
    y integer
)
PARTITION BY HASH (x);


ALTER TABLE am_examples.am_partitioned OWNER TO postgres;

--
-- Name: fast_emp4000; Type: TABLE; Schema: am_examples; Owner: postgres
--

CREATE TABLE am_examples.fast_emp4000 (
    home_base box
);


ALTER TABLE am_examples.fast_emp4000 OWNER TO postgres;

SET default_table_access_method = heap2;

--
-- Name: heaptable; Type: TABLE; Schema: am_examples; Owner: postgres
--

CREATE TABLE am_examples.heaptable (
    a integer,
    repeat text
);


ALTER TABLE am_examples.heaptable OWNER TO postgres;

--
-- Name: heapmv; Type: MATERIALIZED VIEW; Schema: am_examples; Owner: postgres
--

CREATE MATERIALIZED VIEW am_examples.heapmv AS
 SELECT heaptable.a,
    heaptable.repeat
   FROM am_examples.heaptable
  WITH NO DATA;


ALTER TABLE am_examples.heapmv OWNER TO postgres;

--
-- Name: tableam_parted_heapx; Type: TABLE; Schema: am_examples; Owner: postgres
--

CREATE TABLE am_examples.tableam_parted_heapx (
    a text,
    b integer
)
PARTITION BY LIST (a);


ALTER TABLE am_examples.tableam_parted_heapx OWNER TO postgres;

SET default_table_access_method = heap;

--
-- Name: tableam_parted_1_heapx; Type: TABLE; Schema: am_examples; Owner: postgres
--

CREATE TABLE am_examples.tableam_parted_1_heapx (
    a text,
    b integer
);


ALTER TABLE am_examples.tableam_parted_1_heapx OWNER TO postgres;

--
-- Name: tableam_parted_2_heapx; Type: TABLE; Schema: am_examples; Owner: postgres
--

CREATE TABLE am_examples.tableam_parted_2_heapx (
    a text,
    b integer
);


ALTER TABLE am_examples.tableam_parted_2_heapx OWNER TO postgres;

--
-- Name: tableam_parted_heap2; Type: TABLE; Schema: am_examples; Owner: postgres
--

CREATE TABLE am_examples.tableam_parted_heap2 (
    a text,
    b integer
)
PARTITION BY LIST (a);


ALTER TABLE am_examples.tableam_parted_heap2 OWNER TO postgres;

--
-- Name: tableam_parted_c_heap2; Type: TABLE; Schema: am_examples; Owner: postgres
--

CREATE TABLE am_examples.tableam_parted_c_heap2 (
    a text,
    b integer
);


ALTER TABLE am_examples.tableam_parted_c_heap2 OWNER TO postgres;

SET default_table_access_method = heap2;

--
-- Name: tableam_parted_d_heap2; Type: TABLE; Schema: am_examples; Owner: postgres
--

CREATE TABLE am_examples.tableam_parted_d_heap2 (
    a text,
    b integer
);


ALTER TABLE am_examples.tableam_parted_d_heap2 OWNER TO postgres;

--
-- Name: tableam_tbl_heap2; Type: TABLE; Schema: am_examples; Owner: postgres
--

CREATE TABLE am_examples.tableam_tbl_heap2 (
    f1 integer
);


ALTER TABLE am_examples.tableam_tbl_heap2 OWNER TO postgres;

SET default_table_access_method = heap;

--
-- Name: tableam_tbl_heapx; Type: TABLE; Schema: am_examples; Owner: postgres
--

CREATE TABLE am_examples.tableam_tbl_heapx (
    f1 integer
);


ALTER TABLE am_examples.tableam_tbl_heapx OWNER TO postgres;

SET default_table_access_method = heap2;

--
-- Name: tableam_tblas_heap2; Type: TABLE; Schema: am_examples; Owner: postgres
--

CREATE TABLE am_examples.tableam_tblas_heap2 (
    f1 integer
);


ALTER TABLE am_examples.tableam_tblas_heap2 OWNER TO postgres;

SET default_table_access_method = heap;

--
-- Name: tableam_tblas_heapx; Type: TABLE; Schema: am_examples; Owner: postgres
--

CREATE TABLE am_examples.tableam_tblas_heapx (
    f1 integer
);


ALTER TABLE am_examples.tableam_tblas_heapx OWNER TO postgres;

SET default_table_access_method = heap2;

--
-- Name: tableam_tblmv_heapx; Type: MATERIALIZED VIEW; Schema: am_examples; Owner: postgres
--

CREATE MATERIALIZED VIEW am_examples.tableam_tblmv_heapx AS
 SELECT tableam_tbl_heapx.f1
   FROM am_examples.tableam_tbl_heapx
  WITH NO DATA;


ALTER TABLE am_examples.tableam_tblmv_heapx OWNER TO postgres;

SET default_table_access_method = heap;

--
-- Name: default_test; Type: TABLE; Schema: base_type_examples; Owner: postgres
--

CREATE TABLE base_type_examples.default_test (
    f1 base_type_examples.text_w_default,
    f2 base_type_examples.int42
);


ALTER TABLE base_type_examples.default_test OWNER TO postgres;

--
-- Name: ordinary_table; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.ordinary_table (
    basic_ composite_type_examples.basic_comp_type,
    _basic composite_type_examples.basic_comp_type GENERATED ALWAYS AS (basic_) STORED,
    nested composite_type_examples.nested,
    _nested composite_type_examples.nested GENERATED ALWAYS AS (nested) STORED,
    CONSTRAINT check_f1_gt_1 CHECK (((basic_).f1 > 1)),
    CONSTRAINT check_f1_gt_1_again CHECK (((_basic).f1 > 1)),
    CONSTRAINT check_nested_f1_gt_1 CHECK (((nested).foo.f1 > 1)),
    CONSTRAINT check_nested_f1_gt_1_again CHECK (((_nested).foo.f1 > 1))
);


ALTER TABLE composite_type_examples.ordinary_table OWNER TO postgres;

--
-- Name: basic_view; Type: VIEW; Schema: composite_type_examples; Owner: postgres
--

CREATE VIEW composite_type_examples.basic_view AS
 SELECT ordinary_table.basic_,
    ordinary_table._basic,
    ordinary_table.nested,
    ordinary_table._nested
   FROM composite_type_examples.ordinary_table;


ALTER TABLE composite_type_examples.basic_view OWNER TO postgres;

--
-- Name: equivalent_rowtype; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.equivalent_rowtype (
    f1 integer,
    f2 text
);


ALTER TABLE composite_type_examples.equivalent_rowtype OWNER TO postgres;

--
-- Name: i_0; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_0 (
    i integer
);


ALTER TABLE composite_type_examples.i_0 OWNER TO postgres;

--
-- Name: i_1; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_1 (
    i composite_type_examples.i_0
);


ALTER TABLE composite_type_examples.i_1 OWNER TO postgres;

--
-- Name: i_2; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_2 (
    i composite_type_examples.i_1
);


ALTER TABLE composite_type_examples.i_2 OWNER TO postgres;

--
-- Name: i_3; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_3 (
    i composite_type_examples.i_2
);


ALTER TABLE composite_type_examples.i_3 OWNER TO postgres;

--
-- Name: i_4; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_4 (
    i composite_type_examples.i_3
);


ALTER TABLE composite_type_examples.i_4 OWNER TO postgres;

--
-- Name: i_5; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_5 (
    i composite_type_examples.i_4
);


ALTER TABLE composite_type_examples.i_5 OWNER TO postgres;

--
-- Name: i_6; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_6 (
    i composite_type_examples.i_5
);


ALTER TABLE composite_type_examples.i_6 OWNER TO postgres;

--
-- Name: i_7; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_7 (
    i composite_type_examples.i_6
);


ALTER TABLE composite_type_examples.i_7 OWNER TO postgres;

--
-- Name: i_8; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_8 (
    i composite_type_examples.i_7
);


ALTER TABLE composite_type_examples.i_8 OWNER TO postgres;

--
-- Name: i_9; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_9 (
    i composite_type_examples.i_8
);


ALTER TABLE composite_type_examples.i_9 OWNER TO postgres;

--
-- Name: i_10; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_10 (
    i composite_type_examples.i_9
);


ALTER TABLE composite_type_examples.i_10 OWNER TO postgres;

--
-- Name: i_11; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_11 (
    i composite_type_examples.i_10
);


ALTER TABLE composite_type_examples.i_11 OWNER TO postgres;

--
-- Name: i_12; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_12 (
    i composite_type_examples.i_11
);


ALTER TABLE composite_type_examples.i_12 OWNER TO postgres;

--
-- Name: i_13; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_13 (
    i composite_type_examples.i_12
);


ALTER TABLE composite_type_examples.i_13 OWNER TO postgres;

--
-- Name: i_14; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_14 (
    i composite_type_examples.i_13
);


ALTER TABLE composite_type_examples.i_14 OWNER TO postgres;

--
-- Name: i_15; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_15 (
    i composite_type_examples.i_14
);


ALTER TABLE composite_type_examples.i_15 OWNER TO postgres;

--
-- Name: i_16; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_16 (
    i composite_type_examples.i_15
);


ALTER TABLE composite_type_examples.i_16 OWNER TO postgres;

--
-- Name: i_17; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_17 (
    i composite_type_examples.i_16
);


ALTER TABLE composite_type_examples.i_17 OWNER TO postgres;

--
-- Name: i_18; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_18 (
    i composite_type_examples.i_17
);


ALTER TABLE composite_type_examples.i_18 OWNER TO postgres;

--
-- Name: i_19; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_19 (
    i composite_type_examples.i_18
);


ALTER TABLE composite_type_examples.i_19 OWNER TO postgres;

--
-- Name: i_20; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_20 (
    i composite_type_examples.i_19
);


ALTER TABLE composite_type_examples.i_20 OWNER TO postgres;

--
-- Name: i_21; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_21 (
    i composite_type_examples.i_20
);


ALTER TABLE composite_type_examples.i_21 OWNER TO postgres;

--
-- Name: i_22; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_22 (
    i composite_type_examples.i_21
);


ALTER TABLE composite_type_examples.i_22 OWNER TO postgres;

--
-- Name: i_23; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_23 (
    i composite_type_examples.i_22
);


ALTER TABLE composite_type_examples.i_23 OWNER TO postgres;

--
-- Name: i_24; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_24 (
    i composite_type_examples.i_23
);


ALTER TABLE composite_type_examples.i_24 OWNER TO postgres;

--
-- Name: i_25; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_25 (
    i composite_type_examples.i_24
);


ALTER TABLE composite_type_examples.i_25 OWNER TO postgres;

--
-- Name: i_26; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_26 (
    i composite_type_examples.i_25
);


ALTER TABLE composite_type_examples.i_26 OWNER TO postgres;

--
-- Name: i_27; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_27 (
    i composite_type_examples.i_26
);


ALTER TABLE composite_type_examples.i_27 OWNER TO postgres;

--
-- Name: i_28; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_28 (
    i composite_type_examples.i_27
);


ALTER TABLE composite_type_examples.i_28 OWNER TO postgres;

--
-- Name: i_29; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_29 (
    i composite_type_examples.i_28
);


ALTER TABLE composite_type_examples.i_29 OWNER TO postgres;

--
-- Name: i_30; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_30 (
    i composite_type_examples.i_29
);


ALTER TABLE composite_type_examples.i_30 OWNER TO postgres;

--
-- Name: i_31; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_31 (
    i composite_type_examples.i_30
);


ALTER TABLE composite_type_examples.i_31 OWNER TO postgres;

--
-- Name: i_32; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_32 (
    i composite_type_examples.i_31
);


ALTER TABLE composite_type_examples.i_32 OWNER TO postgres;

--
-- Name: i_33; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_33 (
    i composite_type_examples.i_32
);


ALTER TABLE composite_type_examples.i_33 OWNER TO postgres;

--
-- Name: i_34; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_34 (
    i composite_type_examples.i_33
);


ALTER TABLE composite_type_examples.i_34 OWNER TO postgres;

--
-- Name: i_35; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_35 (
    i composite_type_examples.i_34
);


ALTER TABLE composite_type_examples.i_35 OWNER TO postgres;

--
-- Name: i_36; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_36 (
    i composite_type_examples.i_35
);


ALTER TABLE composite_type_examples.i_36 OWNER TO postgres;

--
-- Name: i_37; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_37 (
    i composite_type_examples.i_36
);


ALTER TABLE composite_type_examples.i_37 OWNER TO postgres;

--
-- Name: i_38; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_38 (
    i composite_type_examples.i_37
);


ALTER TABLE composite_type_examples.i_38 OWNER TO postgres;

--
-- Name: i_39; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_39 (
    i composite_type_examples.i_38
);


ALTER TABLE composite_type_examples.i_39 OWNER TO postgres;

--
-- Name: i_40; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_40 (
    i composite_type_examples.i_39
);


ALTER TABLE composite_type_examples.i_40 OWNER TO postgres;

--
-- Name: i_41; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_41 (
    i composite_type_examples.i_40
);


ALTER TABLE composite_type_examples.i_41 OWNER TO postgres;

--
-- Name: i_42; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_42 (
    i composite_type_examples.i_41
);


ALTER TABLE composite_type_examples.i_42 OWNER TO postgres;

--
-- Name: i_43; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_43 (
    i composite_type_examples.i_42
);


ALTER TABLE composite_type_examples.i_43 OWNER TO postgres;

--
-- Name: i_44; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_44 (
    i composite_type_examples.i_43
);


ALTER TABLE composite_type_examples.i_44 OWNER TO postgres;

--
-- Name: i_45; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_45 (
    i composite_type_examples.i_44
);


ALTER TABLE composite_type_examples.i_45 OWNER TO postgres;

--
-- Name: i_46; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_46 (
    i composite_type_examples.i_45
);


ALTER TABLE composite_type_examples.i_46 OWNER TO postgres;

--
-- Name: i_47; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_47 (
    i composite_type_examples.i_46
);


ALTER TABLE composite_type_examples.i_47 OWNER TO postgres;

--
-- Name: i_48; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_48 (
    i composite_type_examples.i_47
);


ALTER TABLE composite_type_examples.i_48 OWNER TO postgres;

--
-- Name: i_49; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_49 (
    i composite_type_examples.i_48
);


ALTER TABLE composite_type_examples.i_49 OWNER TO postgres;

--
-- Name: i_50; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_50 (
    i composite_type_examples.i_49
);


ALTER TABLE composite_type_examples.i_50 OWNER TO postgres;

--
-- Name: i_51; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_51 (
    i composite_type_examples.i_50
);


ALTER TABLE composite_type_examples.i_51 OWNER TO postgres;

--
-- Name: i_52; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_52 (
    i composite_type_examples.i_51
);


ALTER TABLE composite_type_examples.i_52 OWNER TO postgres;

--
-- Name: i_53; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_53 (
    i composite_type_examples.i_52
);


ALTER TABLE composite_type_examples.i_53 OWNER TO postgres;

--
-- Name: i_54; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_54 (
    i composite_type_examples.i_53
);


ALTER TABLE composite_type_examples.i_54 OWNER TO postgres;

--
-- Name: i_55; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_55 (
    i composite_type_examples.i_54
);


ALTER TABLE composite_type_examples.i_55 OWNER TO postgres;

--
-- Name: i_56; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_56 (
    i composite_type_examples.i_55
);


ALTER TABLE composite_type_examples.i_56 OWNER TO postgres;

--
-- Name: i_57; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_57 (
    i composite_type_examples.i_56
);


ALTER TABLE composite_type_examples.i_57 OWNER TO postgres;

--
-- Name: i_58; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_58 (
    i composite_type_examples.i_57
);


ALTER TABLE composite_type_examples.i_58 OWNER TO postgres;

--
-- Name: i_59; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_59 (
    i composite_type_examples.i_58
);


ALTER TABLE composite_type_examples.i_59 OWNER TO postgres;

--
-- Name: i_60; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_60 (
    i composite_type_examples.i_59
);


ALTER TABLE composite_type_examples.i_60 OWNER TO postgres;

--
-- Name: i_61; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_61 (
    i composite_type_examples.i_60
);


ALTER TABLE composite_type_examples.i_61 OWNER TO postgres;

--
-- Name: i_62; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_62 (
    i composite_type_examples.i_61
);


ALTER TABLE composite_type_examples.i_62 OWNER TO postgres;

--
-- Name: i_63; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_63 (
    i composite_type_examples.i_62
);


ALTER TABLE composite_type_examples.i_63 OWNER TO postgres;

--
-- Name: i_64; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_64 (
    i composite_type_examples.i_63
);


ALTER TABLE composite_type_examples.i_64 OWNER TO postgres;

--
-- Name: i_65; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_65 (
    i composite_type_examples.i_64
);


ALTER TABLE composite_type_examples.i_65 OWNER TO postgres;

--
-- Name: i_66; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_66 (
    i composite_type_examples.i_65
);


ALTER TABLE composite_type_examples.i_66 OWNER TO postgres;

--
-- Name: i_67; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_67 (
    i composite_type_examples.i_66
);


ALTER TABLE composite_type_examples.i_67 OWNER TO postgres;

--
-- Name: i_68; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_68 (
    i composite_type_examples.i_67
);


ALTER TABLE composite_type_examples.i_68 OWNER TO postgres;

--
-- Name: i_69; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_69 (
    i composite_type_examples.i_68
);


ALTER TABLE composite_type_examples.i_69 OWNER TO postgres;

--
-- Name: i_70; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_70 (
    i composite_type_examples.i_69
);


ALTER TABLE composite_type_examples.i_70 OWNER TO postgres;

--
-- Name: i_71; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_71 (
    i composite_type_examples.i_70
);


ALTER TABLE composite_type_examples.i_71 OWNER TO postgres;

--
-- Name: i_72; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_72 (
    i composite_type_examples.i_71
);


ALTER TABLE composite_type_examples.i_72 OWNER TO postgres;

--
-- Name: i_73; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_73 (
    i composite_type_examples.i_72
);


ALTER TABLE composite_type_examples.i_73 OWNER TO postgres;

--
-- Name: i_74; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_74 (
    i composite_type_examples.i_73
);


ALTER TABLE composite_type_examples.i_74 OWNER TO postgres;

--
-- Name: i_75; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_75 (
    i composite_type_examples.i_74
);


ALTER TABLE composite_type_examples.i_75 OWNER TO postgres;

--
-- Name: i_76; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_76 (
    i composite_type_examples.i_75
);


ALTER TABLE composite_type_examples.i_76 OWNER TO postgres;

--
-- Name: i_77; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_77 (
    i composite_type_examples.i_76
);


ALTER TABLE composite_type_examples.i_77 OWNER TO postgres;

--
-- Name: i_78; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_78 (
    i composite_type_examples.i_77
);


ALTER TABLE composite_type_examples.i_78 OWNER TO postgres;

--
-- Name: i_79; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_79 (
    i composite_type_examples.i_78
);


ALTER TABLE composite_type_examples.i_79 OWNER TO postgres;

--
-- Name: i_80; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_80 (
    i composite_type_examples.i_79
);


ALTER TABLE composite_type_examples.i_80 OWNER TO postgres;

--
-- Name: i_81; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_81 (
    i composite_type_examples.i_80
);


ALTER TABLE composite_type_examples.i_81 OWNER TO postgres;

--
-- Name: i_82; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_82 (
    i composite_type_examples.i_81
);


ALTER TABLE composite_type_examples.i_82 OWNER TO postgres;

--
-- Name: i_83; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_83 (
    i composite_type_examples.i_82
);


ALTER TABLE composite_type_examples.i_83 OWNER TO postgres;

--
-- Name: i_84; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_84 (
    i composite_type_examples.i_83
);


ALTER TABLE composite_type_examples.i_84 OWNER TO postgres;

--
-- Name: i_85; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_85 (
    i composite_type_examples.i_84
);


ALTER TABLE composite_type_examples.i_85 OWNER TO postgres;

--
-- Name: i_86; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_86 (
    i composite_type_examples.i_85
);


ALTER TABLE composite_type_examples.i_86 OWNER TO postgres;

--
-- Name: i_87; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_87 (
    i composite_type_examples.i_86
);


ALTER TABLE composite_type_examples.i_87 OWNER TO postgres;

--
-- Name: i_88; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_88 (
    i composite_type_examples.i_87
);


ALTER TABLE composite_type_examples.i_88 OWNER TO postgres;

--
-- Name: i_89; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_89 (
    i composite_type_examples.i_88
);


ALTER TABLE composite_type_examples.i_89 OWNER TO postgres;

--
-- Name: i_90; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_90 (
    i composite_type_examples.i_89
);


ALTER TABLE composite_type_examples.i_90 OWNER TO postgres;

--
-- Name: i_91; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_91 (
    i composite_type_examples.i_90
);


ALTER TABLE composite_type_examples.i_91 OWNER TO postgres;

--
-- Name: i_92; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_92 (
    i composite_type_examples.i_91
);


ALTER TABLE composite_type_examples.i_92 OWNER TO postgres;

--
-- Name: i_93; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_93 (
    i composite_type_examples.i_92
);


ALTER TABLE composite_type_examples.i_93 OWNER TO postgres;

--
-- Name: i_94; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_94 (
    i composite_type_examples.i_93
);


ALTER TABLE composite_type_examples.i_94 OWNER TO postgres;

--
-- Name: i_95; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_95 (
    i composite_type_examples.i_94
);


ALTER TABLE composite_type_examples.i_95 OWNER TO postgres;

--
-- Name: i_96; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_96 (
    i composite_type_examples.i_95
);


ALTER TABLE composite_type_examples.i_96 OWNER TO postgres;

--
-- Name: i_97; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_97 (
    i composite_type_examples.i_96
);


ALTER TABLE composite_type_examples.i_97 OWNER TO postgres;

--
-- Name: i_98; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_98 (
    i composite_type_examples.i_97
);


ALTER TABLE composite_type_examples.i_98 OWNER TO postgres;

--
-- Name: i_99; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_99 (
    i composite_type_examples.i_98
);


ALTER TABLE composite_type_examples.i_99 OWNER TO postgres;

--
-- Name: i_100; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_100 (
    i composite_type_examples.i_99
);


ALTER TABLE composite_type_examples.i_100 OWNER TO postgres;

--
-- Name: i_101; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_101 (
    i composite_type_examples.i_100
);


ALTER TABLE composite_type_examples.i_101 OWNER TO postgres;

--
-- Name: i_102; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_102 (
    i composite_type_examples.i_101
);


ALTER TABLE composite_type_examples.i_102 OWNER TO postgres;

--
-- Name: i_103; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_103 (
    i composite_type_examples.i_102
);


ALTER TABLE composite_type_examples.i_103 OWNER TO postgres;

--
-- Name: i_104; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_104 (
    i composite_type_examples.i_103
);


ALTER TABLE composite_type_examples.i_104 OWNER TO postgres;

--
-- Name: i_105; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_105 (
    i composite_type_examples.i_104
);


ALTER TABLE composite_type_examples.i_105 OWNER TO postgres;

--
-- Name: i_106; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_106 (
    i composite_type_examples.i_105
);


ALTER TABLE composite_type_examples.i_106 OWNER TO postgres;

--
-- Name: i_107; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_107 (
    i composite_type_examples.i_106
);


ALTER TABLE composite_type_examples.i_107 OWNER TO postgres;

--
-- Name: i_108; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_108 (
    i composite_type_examples.i_107
);


ALTER TABLE composite_type_examples.i_108 OWNER TO postgres;

--
-- Name: i_109; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_109 (
    i composite_type_examples.i_108
);


ALTER TABLE composite_type_examples.i_109 OWNER TO postgres;

--
-- Name: i_110; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_110 (
    i composite_type_examples.i_109
);


ALTER TABLE composite_type_examples.i_110 OWNER TO postgres;

--
-- Name: i_111; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_111 (
    i composite_type_examples.i_110
);


ALTER TABLE composite_type_examples.i_111 OWNER TO postgres;

--
-- Name: i_112; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_112 (
    i composite_type_examples.i_111
);


ALTER TABLE composite_type_examples.i_112 OWNER TO postgres;

--
-- Name: i_113; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_113 (
    i composite_type_examples.i_112
);


ALTER TABLE composite_type_examples.i_113 OWNER TO postgres;

--
-- Name: i_114; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_114 (
    i composite_type_examples.i_113
);


ALTER TABLE composite_type_examples.i_114 OWNER TO postgres;

--
-- Name: i_115; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_115 (
    i composite_type_examples.i_114
);


ALTER TABLE composite_type_examples.i_115 OWNER TO postgres;

--
-- Name: i_116; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_116 (
    i composite_type_examples.i_115
);


ALTER TABLE composite_type_examples.i_116 OWNER TO postgres;

--
-- Name: i_117; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_117 (
    i composite_type_examples.i_116
);


ALTER TABLE composite_type_examples.i_117 OWNER TO postgres;

--
-- Name: i_118; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_118 (
    i composite_type_examples.i_117
);


ALTER TABLE composite_type_examples.i_118 OWNER TO postgres;

--
-- Name: i_119; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_119 (
    i composite_type_examples.i_118
);


ALTER TABLE composite_type_examples.i_119 OWNER TO postgres;

--
-- Name: i_120; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_120 (
    i composite_type_examples.i_119
);


ALTER TABLE composite_type_examples.i_120 OWNER TO postgres;

--
-- Name: i_121; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_121 (
    i composite_type_examples.i_120
);


ALTER TABLE composite_type_examples.i_121 OWNER TO postgres;

--
-- Name: i_122; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_122 (
    i composite_type_examples.i_121
);


ALTER TABLE composite_type_examples.i_122 OWNER TO postgres;

--
-- Name: i_123; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_123 (
    i composite_type_examples.i_122
);


ALTER TABLE composite_type_examples.i_123 OWNER TO postgres;

--
-- Name: i_124; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_124 (
    i composite_type_examples.i_123
);


ALTER TABLE composite_type_examples.i_124 OWNER TO postgres;

--
-- Name: i_125; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_125 (
    i composite_type_examples.i_124
);


ALTER TABLE composite_type_examples.i_125 OWNER TO postgres;

--
-- Name: i_126; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_126 (
    i composite_type_examples.i_125
);


ALTER TABLE composite_type_examples.i_126 OWNER TO postgres;

--
-- Name: i_127; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_127 (
    i composite_type_examples.i_126
);


ALTER TABLE composite_type_examples.i_127 OWNER TO postgres;

--
-- Name: i_128; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_128 (
    i composite_type_examples.i_127
);


ALTER TABLE composite_type_examples.i_128 OWNER TO postgres;

--
-- Name: i_129; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_129 (
    i composite_type_examples.i_128
);


ALTER TABLE composite_type_examples.i_129 OWNER TO postgres;

--
-- Name: i_130; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_130 (
    i composite_type_examples.i_129
);


ALTER TABLE composite_type_examples.i_130 OWNER TO postgres;

--
-- Name: i_131; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_131 (
    i composite_type_examples.i_130
);


ALTER TABLE composite_type_examples.i_131 OWNER TO postgres;

--
-- Name: i_132; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_132 (
    i composite_type_examples.i_131
);


ALTER TABLE composite_type_examples.i_132 OWNER TO postgres;

--
-- Name: i_133; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_133 (
    i composite_type_examples.i_132
);


ALTER TABLE composite_type_examples.i_133 OWNER TO postgres;

--
-- Name: i_134; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_134 (
    i composite_type_examples.i_133
);


ALTER TABLE composite_type_examples.i_134 OWNER TO postgres;

--
-- Name: i_135; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_135 (
    i composite_type_examples.i_134
);


ALTER TABLE composite_type_examples.i_135 OWNER TO postgres;

--
-- Name: i_136; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_136 (
    i composite_type_examples.i_135
);


ALTER TABLE composite_type_examples.i_136 OWNER TO postgres;

--
-- Name: i_137; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_137 (
    i composite_type_examples.i_136
);


ALTER TABLE composite_type_examples.i_137 OWNER TO postgres;

--
-- Name: i_138; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_138 (
    i composite_type_examples.i_137
);


ALTER TABLE composite_type_examples.i_138 OWNER TO postgres;

--
-- Name: i_139; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_139 (
    i composite_type_examples.i_138
);


ALTER TABLE composite_type_examples.i_139 OWNER TO postgres;

--
-- Name: i_140; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_140 (
    i composite_type_examples.i_139
);


ALTER TABLE composite_type_examples.i_140 OWNER TO postgres;

--
-- Name: i_141; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_141 (
    i composite_type_examples.i_140
);


ALTER TABLE composite_type_examples.i_141 OWNER TO postgres;

--
-- Name: i_142; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_142 (
    i composite_type_examples.i_141
);


ALTER TABLE composite_type_examples.i_142 OWNER TO postgres;

--
-- Name: i_143; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_143 (
    i composite_type_examples.i_142
);


ALTER TABLE composite_type_examples.i_143 OWNER TO postgres;

--
-- Name: i_144; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_144 (
    i composite_type_examples.i_143
);


ALTER TABLE composite_type_examples.i_144 OWNER TO postgres;

--
-- Name: i_145; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_145 (
    i composite_type_examples.i_144
);


ALTER TABLE composite_type_examples.i_145 OWNER TO postgres;

--
-- Name: i_146; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_146 (
    i composite_type_examples.i_145
);


ALTER TABLE composite_type_examples.i_146 OWNER TO postgres;

--
-- Name: i_147; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_147 (
    i composite_type_examples.i_146
);


ALTER TABLE composite_type_examples.i_147 OWNER TO postgres;

--
-- Name: i_148; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_148 (
    i composite_type_examples.i_147
);


ALTER TABLE composite_type_examples.i_148 OWNER TO postgres;

--
-- Name: i_149; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_149 (
    i composite_type_examples.i_148
);


ALTER TABLE composite_type_examples.i_149 OWNER TO postgres;

--
-- Name: i_150; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_150 (
    i composite_type_examples.i_149
);


ALTER TABLE composite_type_examples.i_150 OWNER TO postgres;

--
-- Name: i_151; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_151 (
    i composite_type_examples.i_150
);


ALTER TABLE composite_type_examples.i_151 OWNER TO postgres;

--
-- Name: i_152; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_152 (
    i composite_type_examples.i_151
);


ALTER TABLE composite_type_examples.i_152 OWNER TO postgres;

--
-- Name: i_153; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_153 (
    i composite_type_examples.i_152
);


ALTER TABLE composite_type_examples.i_153 OWNER TO postgres;

--
-- Name: i_154; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_154 (
    i composite_type_examples.i_153
);


ALTER TABLE composite_type_examples.i_154 OWNER TO postgres;

--
-- Name: i_155; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_155 (
    i composite_type_examples.i_154
);


ALTER TABLE composite_type_examples.i_155 OWNER TO postgres;

--
-- Name: i_156; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_156 (
    i composite_type_examples.i_155
);


ALTER TABLE composite_type_examples.i_156 OWNER TO postgres;

--
-- Name: i_157; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_157 (
    i composite_type_examples.i_156
);


ALTER TABLE composite_type_examples.i_157 OWNER TO postgres;

--
-- Name: i_158; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_158 (
    i composite_type_examples.i_157
);


ALTER TABLE composite_type_examples.i_158 OWNER TO postgres;

--
-- Name: i_159; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_159 (
    i composite_type_examples.i_158
);


ALTER TABLE composite_type_examples.i_159 OWNER TO postgres;

--
-- Name: i_160; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_160 (
    i composite_type_examples.i_159
);


ALTER TABLE composite_type_examples.i_160 OWNER TO postgres;

--
-- Name: i_161; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_161 (
    i composite_type_examples.i_160
);


ALTER TABLE composite_type_examples.i_161 OWNER TO postgres;

--
-- Name: i_162; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_162 (
    i composite_type_examples.i_161
);


ALTER TABLE composite_type_examples.i_162 OWNER TO postgres;

--
-- Name: i_163; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_163 (
    i composite_type_examples.i_162
);


ALTER TABLE composite_type_examples.i_163 OWNER TO postgres;

--
-- Name: i_164; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_164 (
    i composite_type_examples.i_163
);


ALTER TABLE composite_type_examples.i_164 OWNER TO postgres;

--
-- Name: i_165; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_165 (
    i composite_type_examples.i_164
);


ALTER TABLE composite_type_examples.i_165 OWNER TO postgres;

--
-- Name: i_166; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_166 (
    i composite_type_examples.i_165
);


ALTER TABLE composite_type_examples.i_166 OWNER TO postgres;

--
-- Name: i_167; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_167 (
    i composite_type_examples.i_166
);


ALTER TABLE composite_type_examples.i_167 OWNER TO postgres;

--
-- Name: i_168; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_168 (
    i composite_type_examples.i_167
);


ALTER TABLE composite_type_examples.i_168 OWNER TO postgres;

--
-- Name: i_169; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_169 (
    i composite_type_examples.i_168
);


ALTER TABLE composite_type_examples.i_169 OWNER TO postgres;

--
-- Name: i_170; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_170 (
    i composite_type_examples.i_169
);


ALTER TABLE composite_type_examples.i_170 OWNER TO postgres;

--
-- Name: i_171; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_171 (
    i composite_type_examples.i_170
);


ALTER TABLE composite_type_examples.i_171 OWNER TO postgres;

--
-- Name: i_172; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_172 (
    i composite_type_examples.i_171
);


ALTER TABLE composite_type_examples.i_172 OWNER TO postgres;

--
-- Name: i_173; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_173 (
    i composite_type_examples.i_172
);


ALTER TABLE composite_type_examples.i_173 OWNER TO postgres;

--
-- Name: i_174; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_174 (
    i composite_type_examples.i_173
);


ALTER TABLE composite_type_examples.i_174 OWNER TO postgres;

--
-- Name: i_175; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_175 (
    i composite_type_examples.i_174
);


ALTER TABLE composite_type_examples.i_175 OWNER TO postgres;

--
-- Name: i_176; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_176 (
    i composite_type_examples.i_175
);


ALTER TABLE composite_type_examples.i_176 OWNER TO postgres;

--
-- Name: i_177; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_177 (
    i composite_type_examples.i_176
);


ALTER TABLE composite_type_examples.i_177 OWNER TO postgres;

--
-- Name: i_178; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_178 (
    i composite_type_examples.i_177
);


ALTER TABLE composite_type_examples.i_178 OWNER TO postgres;

--
-- Name: i_179; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_179 (
    i composite_type_examples.i_178
);


ALTER TABLE composite_type_examples.i_179 OWNER TO postgres;

--
-- Name: i_180; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_180 (
    i composite_type_examples.i_179
);


ALTER TABLE composite_type_examples.i_180 OWNER TO postgres;

--
-- Name: i_181; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_181 (
    i composite_type_examples.i_180
);


ALTER TABLE composite_type_examples.i_181 OWNER TO postgres;

--
-- Name: i_182; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_182 (
    i composite_type_examples.i_181
);


ALTER TABLE composite_type_examples.i_182 OWNER TO postgres;

--
-- Name: i_183; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_183 (
    i composite_type_examples.i_182
);


ALTER TABLE composite_type_examples.i_183 OWNER TO postgres;

--
-- Name: i_184; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_184 (
    i composite_type_examples.i_183
);


ALTER TABLE composite_type_examples.i_184 OWNER TO postgres;

--
-- Name: i_185; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_185 (
    i composite_type_examples.i_184
);


ALTER TABLE composite_type_examples.i_185 OWNER TO postgres;

--
-- Name: i_186; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_186 (
    i composite_type_examples.i_185
);


ALTER TABLE composite_type_examples.i_186 OWNER TO postgres;

--
-- Name: i_187; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_187 (
    i composite_type_examples.i_186
);


ALTER TABLE composite_type_examples.i_187 OWNER TO postgres;

--
-- Name: i_188; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_188 (
    i composite_type_examples.i_187
);


ALTER TABLE composite_type_examples.i_188 OWNER TO postgres;

--
-- Name: i_189; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_189 (
    i composite_type_examples.i_188
);


ALTER TABLE composite_type_examples.i_189 OWNER TO postgres;

--
-- Name: i_190; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_190 (
    i composite_type_examples.i_189
);


ALTER TABLE composite_type_examples.i_190 OWNER TO postgres;

--
-- Name: i_191; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_191 (
    i composite_type_examples.i_190
);


ALTER TABLE composite_type_examples.i_191 OWNER TO postgres;

--
-- Name: i_192; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_192 (
    i composite_type_examples.i_191
);


ALTER TABLE composite_type_examples.i_192 OWNER TO postgres;

--
-- Name: i_193; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_193 (
    i composite_type_examples.i_192
);


ALTER TABLE composite_type_examples.i_193 OWNER TO postgres;

--
-- Name: i_194; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_194 (
    i composite_type_examples.i_193
);


ALTER TABLE composite_type_examples.i_194 OWNER TO postgres;

--
-- Name: i_195; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_195 (
    i composite_type_examples.i_194
);


ALTER TABLE composite_type_examples.i_195 OWNER TO postgres;

--
-- Name: i_196; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_196 (
    i composite_type_examples.i_195
);


ALTER TABLE composite_type_examples.i_196 OWNER TO postgres;

--
-- Name: i_197; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_197 (
    i composite_type_examples.i_196
);


ALTER TABLE composite_type_examples.i_197 OWNER TO postgres;

--
-- Name: i_198; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_198 (
    i composite_type_examples.i_197
);


ALTER TABLE composite_type_examples.i_198 OWNER TO postgres;

--
-- Name: i_199; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_199 (
    i composite_type_examples.i_198
);


ALTER TABLE composite_type_examples.i_199 OWNER TO postgres;

--
-- Name: i_200; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_200 (
    i composite_type_examples.i_199
);


ALTER TABLE composite_type_examples.i_200 OWNER TO postgres;

--
-- Name: i_201; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_201 (
    i composite_type_examples.i_200
);


ALTER TABLE composite_type_examples.i_201 OWNER TO postgres;

--
-- Name: i_202; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_202 (
    i composite_type_examples.i_201
);


ALTER TABLE composite_type_examples.i_202 OWNER TO postgres;

--
-- Name: i_203; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_203 (
    i composite_type_examples.i_202
);


ALTER TABLE composite_type_examples.i_203 OWNER TO postgres;

--
-- Name: i_204; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_204 (
    i composite_type_examples.i_203
);


ALTER TABLE composite_type_examples.i_204 OWNER TO postgres;

--
-- Name: i_205; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_205 (
    i composite_type_examples.i_204
);


ALTER TABLE composite_type_examples.i_205 OWNER TO postgres;

--
-- Name: i_206; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_206 (
    i composite_type_examples.i_205
);


ALTER TABLE composite_type_examples.i_206 OWNER TO postgres;

--
-- Name: i_207; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_207 (
    i composite_type_examples.i_206
);


ALTER TABLE composite_type_examples.i_207 OWNER TO postgres;

--
-- Name: i_208; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_208 (
    i composite_type_examples.i_207
);


ALTER TABLE composite_type_examples.i_208 OWNER TO postgres;

--
-- Name: i_209; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_209 (
    i composite_type_examples.i_208
);


ALTER TABLE composite_type_examples.i_209 OWNER TO postgres;

--
-- Name: i_210; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_210 (
    i composite_type_examples.i_209
);


ALTER TABLE composite_type_examples.i_210 OWNER TO postgres;

--
-- Name: i_211; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_211 (
    i composite_type_examples.i_210
);


ALTER TABLE composite_type_examples.i_211 OWNER TO postgres;

--
-- Name: i_212; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_212 (
    i composite_type_examples.i_211
);


ALTER TABLE composite_type_examples.i_212 OWNER TO postgres;

--
-- Name: i_213; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_213 (
    i composite_type_examples.i_212
);


ALTER TABLE composite_type_examples.i_213 OWNER TO postgres;

--
-- Name: i_214; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_214 (
    i composite_type_examples.i_213
);


ALTER TABLE composite_type_examples.i_214 OWNER TO postgres;

--
-- Name: i_215; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_215 (
    i composite_type_examples.i_214
);


ALTER TABLE composite_type_examples.i_215 OWNER TO postgres;

--
-- Name: i_216; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_216 (
    i composite_type_examples.i_215
);


ALTER TABLE composite_type_examples.i_216 OWNER TO postgres;

--
-- Name: i_217; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_217 (
    i composite_type_examples.i_216
);


ALTER TABLE composite_type_examples.i_217 OWNER TO postgres;

--
-- Name: i_218; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_218 (
    i composite_type_examples.i_217
);


ALTER TABLE composite_type_examples.i_218 OWNER TO postgres;

--
-- Name: i_219; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_219 (
    i composite_type_examples.i_218
);


ALTER TABLE composite_type_examples.i_219 OWNER TO postgres;

--
-- Name: i_220; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_220 (
    i composite_type_examples.i_219
);


ALTER TABLE composite_type_examples.i_220 OWNER TO postgres;

--
-- Name: i_221; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_221 (
    i composite_type_examples.i_220
);


ALTER TABLE composite_type_examples.i_221 OWNER TO postgres;

--
-- Name: i_222; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_222 (
    i composite_type_examples.i_221
);


ALTER TABLE composite_type_examples.i_222 OWNER TO postgres;

--
-- Name: i_223; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_223 (
    i composite_type_examples.i_222
);


ALTER TABLE composite_type_examples.i_223 OWNER TO postgres;

--
-- Name: i_224; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_224 (
    i composite_type_examples.i_223
);


ALTER TABLE composite_type_examples.i_224 OWNER TO postgres;

--
-- Name: i_225; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_225 (
    i composite_type_examples.i_224
);


ALTER TABLE composite_type_examples.i_225 OWNER TO postgres;

--
-- Name: i_226; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_226 (
    i composite_type_examples.i_225
);


ALTER TABLE composite_type_examples.i_226 OWNER TO postgres;

--
-- Name: i_227; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_227 (
    i composite_type_examples.i_226
);


ALTER TABLE composite_type_examples.i_227 OWNER TO postgres;

--
-- Name: i_228; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_228 (
    i composite_type_examples.i_227
);


ALTER TABLE composite_type_examples.i_228 OWNER TO postgres;

--
-- Name: i_229; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_229 (
    i composite_type_examples.i_228
);


ALTER TABLE composite_type_examples.i_229 OWNER TO postgres;

--
-- Name: i_230; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_230 (
    i composite_type_examples.i_229
);


ALTER TABLE composite_type_examples.i_230 OWNER TO postgres;

--
-- Name: i_231; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_231 (
    i composite_type_examples.i_230
);


ALTER TABLE composite_type_examples.i_231 OWNER TO postgres;

--
-- Name: i_232; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_232 (
    i composite_type_examples.i_231
);


ALTER TABLE composite_type_examples.i_232 OWNER TO postgres;

--
-- Name: i_233; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_233 (
    i composite_type_examples.i_232
);


ALTER TABLE composite_type_examples.i_233 OWNER TO postgres;

--
-- Name: i_234; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_234 (
    i composite_type_examples.i_233
);


ALTER TABLE composite_type_examples.i_234 OWNER TO postgres;

--
-- Name: i_235; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_235 (
    i composite_type_examples.i_234
);


ALTER TABLE composite_type_examples.i_235 OWNER TO postgres;

--
-- Name: i_236; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_236 (
    i composite_type_examples.i_235
);


ALTER TABLE composite_type_examples.i_236 OWNER TO postgres;

--
-- Name: i_237; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_237 (
    i composite_type_examples.i_236
);


ALTER TABLE composite_type_examples.i_237 OWNER TO postgres;

--
-- Name: i_238; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_238 (
    i composite_type_examples.i_237
);


ALTER TABLE composite_type_examples.i_238 OWNER TO postgres;

--
-- Name: i_239; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_239 (
    i composite_type_examples.i_238
);


ALTER TABLE composite_type_examples.i_239 OWNER TO postgres;

--
-- Name: i_240; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_240 (
    i composite_type_examples.i_239
);


ALTER TABLE composite_type_examples.i_240 OWNER TO postgres;

--
-- Name: i_241; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_241 (
    i composite_type_examples.i_240
);


ALTER TABLE composite_type_examples.i_241 OWNER TO postgres;

--
-- Name: i_242; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_242 (
    i composite_type_examples.i_241
);


ALTER TABLE composite_type_examples.i_242 OWNER TO postgres;

--
-- Name: i_243; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_243 (
    i composite_type_examples.i_242
);


ALTER TABLE composite_type_examples.i_243 OWNER TO postgres;

--
-- Name: i_244; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_244 (
    i composite_type_examples.i_243
);


ALTER TABLE composite_type_examples.i_244 OWNER TO postgres;

--
-- Name: i_245; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_245 (
    i composite_type_examples.i_244
);


ALTER TABLE composite_type_examples.i_245 OWNER TO postgres;

--
-- Name: i_246; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_246 (
    i composite_type_examples.i_245
);


ALTER TABLE composite_type_examples.i_246 OWNER TO postgres;

--
-- Name: i_247; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_247 (
    i composite_type_examples.i_246
);


ALTER TABLE composite_type_examples.i_247 OWNER TO postgres;

--
-- Name: i_248; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_248 (
    i composite_type_examples.i_247
);


ALTER TABLE composite_type_examples.i_248 OWNER TO postgres;

--
-- Name: i_249; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_249 (
    i composite_type_examples.i_248
);


ALTER TABLE composite_type_examples.i_249 OWNER TO postgres;

--
-- Name: i_250; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_250 (
    i composite_type_examples.i_249
);


ALTER TABLE composite_type_examples.i_250 OWNER TO postgres;

--
-- Name: i_251; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_251 (
    i composite_type_examples.i_250
);


ALTER TABLE composite_type_examples.i_251 OWNER TO postgres;

--
-- Name: i_252; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_252 (
    i composite_type_examples.i_251
);


ALTER TABLE composite_type_examples.i_252 OWNER TO postgres;

--
-- Name: i_253; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_253 (
    i composite_type_examples.i_252
);


ALTER TABLE composite_type_examples.i_253 OWNER TO postgres;

--
-- Name: i_254; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_254 (
    i composite_type_examples.i_253
);


ALTER TABLE composite_type_examples.i_254 OWNER TO postgres;

--
-- Name: i_255; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_255 (
    i composite_type_examples.i_254
);


ALTER TABLE composite_type_examples.i_255 OWNER TO postgres;

--
-- Name: i_256; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.i_256 (
    i composite_type_examples.i_255
);


ALTER TABLE composite_type_examples.i_256 OWNER TO postgres;

--
-- Name: inherited_table; Type: TABLE; Schema: composite_type_examples; Owner: postgres
--

CREATE TABLE composite_type_examples.inherited_table (
)
INHERITS (composite_type_examples.ordinary_table);


ALTER TABLE composite_type_examples.inherited_table OWNER TO postgres;

--
-- Name: even_numbers; Type: TABLE; Schema: domain_examples; Owner: postgres
--

CREATE TABLE domain_examples.even_numbers (
    e domain_examples.positive_even_number
);


ALTER TABLE domain_examples.even_numbers OWNER TO postgres;

--
-- Name: us_snail_addy; Type: TABLE; Schema: domain_examples; Owner: postgres
--

CREATE TABLE domain_examples.us_snail_addy (
    address_id integer NOT NULL,
    street1 text NOT NULL,
    street2 text,
    street3 text,
    city text NOT NULL,
    postal domain_examples.us_postal_code NOT NULL
);


ALTER TABLE domain_examples.us_snail_addy OWNER TO postgres;

--
-- Name: us_snail_addy_address_id_seq; Type: SEQUENCE; Schema: domain_examples; Owner: postgres
--

CREATE SEQUENCE domain_examples.us_snail_addy_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE domain_examples.us_snail_addy_address_id_seq OWNER TO postgres;

--
-- Name: us_snail_addy_address_id_seq; Type: SEQUENCE OWNED BY; Schema: domain_examples; Owner: postgres
--

ALTER SEQUENCE domain_examples.us_snail_addy_address_id_seq OWNED BY domain_examples.us_snail_addy.address_id;


--
-- Name: _bug_severity; Type: TABLE; Schema: enum_example; Owner: postgres
--

CREATE TABLE enum_example._bug_severity (
    id integer,
    severity enum_example.bug_severity
);


ALTER TABLE enum_example._bug_severity OWNER TO postgres;

--
-- Name: bugs; Type: TABLE; Schema: enum_example; Owner: postgres
--

CREATE TABLE enum_example.bugs (
    id integer NOT NULL,
    description text,
    status enum_example.bug_status,
    _status enum_example.bug_status GENERATED ALWAYS AS (status) STORED,
    severity enum_example.bug_severity,
    _severity enum_example.bug_severity GENERATED ALWAYS AS (severity) STORED,
    info enum_example.bug_info GENERATED ALWAYS AS (enum_example.make_bug_info(status, severity)) STORED
);


ALTER TABLE enum_example.bugs OWNER TO postgres;

--
-- Name: _bugs; Type: VIEW; Schema: enum_example; Owner: postgres
--

CREATE VIEW enum_example._bugs AS
 SELECT bugs.id,
    bugs.status
   FROM enum_example.bugs;


ALTER TABLE enum_example._bugs OWNER TO postgres;

--
-- Name: bugs_clone; Type: TABLE; Schema: enum_example; Owner: postgres
--

CREATE TABLE enum_example.bugs_clone (
)
INHERITS (enum_example.bugs);


ALTER TABLE enum_example.bugs_clone OWNER TO postgres;

--
-- Name: bugs_id_seq; Type: SEQUENCE; Schema: enum_example; Owner: postgres
--

CREATE SEQUENCE enum_example.bugs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE enum_example.bugs_id_seq OWNER TO postgres;

--
-- Name: bugs_id_seq; Type: SEQUENCE OWNED BY; Schema: enum_example; Owner: postgres
--

ALTER SEQUENCE enum_example.bugs_id_seq OWNED BY enum_example.bugs.id;


--
-- Name: dependent_view; Type: VIEW; Schema: extension_example; Owner: postgres
--

CREATE VIEW extension_example.dependent_view AS
 SELECT each.key,
    each.value
   FROM extension_example.each('""=>"1", "b"=>NULL, "aaa"=>"bq"'::extension_example.hstore) each(key, value);


ALTER TABLE extension_example.dependent_view OWNER TO postgres;

--
-- Name: testhstore; Type: TABLE; Schema: extension_example; Owner: postgres
--

CREATE TABLE extension_example.testhstore (
    h extension_example.hstore
);


ALTER TABLE extension_example.testhstore OWNER TO postgres;

--
-- Name: basic_view; Type: VIEW; Schema: fn_examples; Owner: postgres
--

CREATE VIEW fn_examples.basic_view AS
 SELECT ordinary_table.id
   FROM fn_examples.ordinary_table;


ALTER TABLE fn_examples.basic_view OWNER TO postgres;

--
-- Name: technically_doesnt_exist; Type: FOREIGN TABLE; Schema: foreign_db_example; Owner: postgres
--

CREATE FOREIGN TABLE foreign_db_example.technically_doesnt_exist (
    id integer,
    uses_type foreign_db_example.example_type,
    _uses_type foreign_db_example.example_type GENERATED ALWAYS AS (uses_type) STORED,
    positive_number foreign_db_example.positive_number,
    _positive_number foreign_db_example.positive_number GENERATED ALWAYS AS (positive_number) STORED,
    CONSTRAINT imaginary_table_id_gt_1 CHECK ((id > 1))
)
SERVER technically_this_server;


ALTER FOREIGN TABLE foreign_db_example.technically_doesnt_exist OWNER TO postgres;

--
-- Name: films; Type: TABLE; Schema: idx_ex; Owner: postgres
--

CREATE TABLE idx_ex.films (
    id integer NOT NULL,
    title text,
    director text,
    rating integer,
    code text
);


ALTER TABLE idx_ex.films OWNER TO postgres;

--
-- Name: binary_examples; Type: TABLE; Schema: ordinary_tables; Owner: postgres
--

CREATE TABLE ordinary_tables.binary_examples (
    bytes bytea NOT NULL
);


ALTER TABLE ordinary_tables.binary_examples OWNER TO postgres;

--
-- Name: bit_string_examples; Type: TABLE; Schema: ordinary_tables; Owner: postgres
--

CREATE TABLE ordinary_tables.bit_string_examples (
    bit_example bit(10),
    bit_varyint_example bit varying(20)
);


ALTER TABLE ordinary_tables.bit_string_examples OWNER TO postgres;

--
-- Name: boolean_examples; Type: TABLE; Schema: ordinary_tables; Owner: postgres
--

CREATE TABLE ordinary_tables.boolean_examples (
    b boolean
);


ALTER TABLE ordinary_tables.boolean_examples OWNER TO postgres;

--
-- Name: character_examples; Type: TABLE; Schema: ordinary_tables; Owner: postgres
--

CREATE TABLE ordinary_tables.character_examples (
    id text NOT NULL,
    a_varchar character varying,
    a_limited_varchar character varying(10),
    a_single_char character(1),
    n_char character(11)
);


ALTER TABLE ordinary_tables.character_examples OWNER TO postgres;

--
-- Name: geometric_examples; Type: TABLE; Schema: ordinary_tables; Owner: postgres
--

CREATE TABLE ordinary_tables.geometric_examples (
    point_example point,
    line_example line,
    lseg_example lseg,
    box_example box,
    path_example path,
    polygon_example polygon,
    circle_example circle
);


ALTER TABLE ordinary_tables.geometric_examples OWNER TO postgres;

--
-- Name: money_example; Type: TABLE; Schema: ordinary_tables; Owner: postgres
--

CREATE TABLE ordinary_tables.money_example (
    money money
);


ALTER TABLE ordinary_tables.money_example OWNER TO postgres;

--
-- Name: network_addr_examples; Type: TABLE; Schema: ordinary_tables; Owner: postgres
--

CREATE TABLE ordinary_tables.network_addr_examples (
    cidr_example cidr,
    inet_example inet,
    macaddr_example macaddr,
    macaddr8_example macaddr8
);


ALTER TABLE ordinary_tables.network_addr_examples OWNER TO postgres;

--
-- Name: numeric_type_examples; Type: TABLE; Schema: ordinary_tables; Owner: postgres
--

CREATE TABLE ordinary_tables.numeric_type_examples (
    id integer NOT NULL,
    an_integer integer NOT NULL,
    an_int integer,
    an_int4 integer,
    an_int8 bigint,
    a_bigint bigint,
    a_smallint smallint,
    a_decimal numeric,
    a_numeric numeric,
    a_real real,
    a_double double precision,
    a_smallserial smallint NOT NULL,
    a_bigserial bigint NOT NULL,
    another_numeric numeric(3,0),
    yet_another_numeric numeric(6,4)
);


ALTER TABLE ordinary_tables.numeric_type_examples OWNER TO postgres;

--
-- Name: TABLE numeric_type_examples; Type: COMMENT; Schema: ordinary_tables; Owner: postgres
--

COMMENT ON TABLE ordinary_tables.numeric_type_examples IS 'examples of numeric types';


--
-- Name: COLUMN numeric_type_examples.id; Type: COMMENT; Schema: ordinary_tables; Owner: postgres
--

COMMENT ON COLUMN ordinary_tables.numeric_type_examples.id IS 'serial id';


--
-- Name: numeric_type_examples_a_bigserial_seq; Type: SEQUENCE; Schema: ordinary_tables; Owner: postgres
--

CREATE SEQUENCE ordinary_tables.numeric_type_examples_a_bigserial_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ordinary_tables.numeric_type_examples_a_bigserial_seq OWNER TO postgres;

--
-- Name: numeric_type_examples_a_bigserial_seq; Type: SEQUENCE OWNED BY; Schema: ordinary_tables; Owner: postgres
--

ALTER SEQUENCE ordinary_tables.numeric_type_examples_a_bigserial_seq OWNED BY ordinary_tables.numeric_type_examples.a_bigserial;


--
-- Name: numeric_type_examples_a_smallserial_seq; Type: SEQUENCE; Schema: ordinary_tables; Owner: postgres
--

CREATE SEQUENCE ordinary_tables.numeric_type_examples_a_smallserial_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ordinary_tables.numeric_type_examples_a_smallserial_seq OWNER TO postgres;

--
-- Name: numeric_type_examples_a_smallserial_seq; Type: SEQUENCE OWNED BY; Schema: ordinary_tables; Owner: postgres
--

ALTER SEQUENCE ordinary_tables.numeric_type_examples_a_smallserial_seq OWNED BY ordinary_tables.numeric_type_examples.a_smallserial;


--
-- Name: numeric_type_examples_id_seq; Type: SEQUENCE; Schema: ordinary_tables; Owner: postgres
--

CREATE SEQUENCE ordinary_tables.numeric_type_examples_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ordinary_tables.numeric_type_examples_id_seq OWNER TO postgres;

--
-- Name: numeric_type_examples_id_seq; Type: SEQUENCE OWNED BY; Schema: ordinary_tables; Owner: postgres
--

ALTER SEQUENCE ordinary_tables.numeric_type_examples_id_seq OWNED BY ordinary_tables.numeric_type_examples.id;


--
-- Name: time; Type: TABLE; Schema: ordinary_tables; Owner: postgres
--

CREATE TABLE ordinary_tables."time" (
    ts_with_tz timestamp with time zone,
    ts_with_tz_precision timestamp(2) with time zone,
    ts_with_ntz timestamp without time zone,
    ts_with_ntz_precision timestamp(3) without time zone,
    t_with_tz time with time zone,
    t_with_tz_precision time(4) with time zone,
    t_with_ntz time without time zone,
    t_with_ntz_precision time(5) without time zone,
    date date,
    interval_year interval year,
    interval_month interval month,
    interval_day interval day,
    interval_hour interval hour,
    interval_minute interval minute,
    interval_second interval second,
    interval_year_to_month interval year to month,
    interval_day_to_hour interval day to hour,
    interval_day_to_minute interval day to minute,
    interval_day_to_second interval day to second,
    interval_hour_to_minute interval hour to minute,
    interval_hour_to_second interval hour to second,
    interval_minute_to_second interval minute to second
);


ALTER TABLE ordinary_tables."time" OWNER TO postgres;

--
-- Name: foreign_db_example; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.foreign_db_example AS
 SELECT technically_doesnt_exist.id,
    technically_doesnt_exist.uses_type,
    technically_doesnt_exist._uses_type,
    technically_doesnt_exist.positive_number,
    technically_doesnt_exist._positive_number
   FROM foreign_db_example.technically_doesnt_exist;


ALTER TABLE public.foreign_db_example OWNER TO postgres;

--
-- Name: b1; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.b1 (
    a integer,
    b text
);


ALTER TABLE regress_rls_schema.b1 OWNER TO regress_rls_alice;

--
-- Name: bv1; Type: VIEW; Schema: regress_rls_schema; Owner: regress_rls_bob
--

CREATE VIEW regress_rls_schema.bv1 WITH (security_barrier='true') AS
 SELECT b1.a,
    b1.b
   FROM regress_rls_schema.b1
  WHERE (b1.a > 0)
  WITH CASCADED CHECK OPTION;


ALTER TABLE regress_rls_schema.bv1 OWNER TO regress_rls_bob;

--
-- Name: category; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.category (
    cid integer NOT NULL,
    cname text
);


ALTER TABLE regress_rls_schema.category OWNER TO regress_rls_alice;

--
-- Name: dependee; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.dependee (
    x integer,
    y integer
);


ALTER TABLE regress_rls_schema.dependee OWNER TO regress_rls_alice;

--
-- Name: dependent; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.dependent (
    x integer,
    y integer
);


ALTER TABLE regress_rls_schema.dependent OWNER TO regress_rls_alice;

--
-- Name: dob_t1; Type: TABLE; Schema: regress_rls_schema; Owner: postgres
--

CREATE TABLE regress_rls_schema.dob_t1 (
    c1 integer
);


ALTER TABLE regress_rls_schema.dob_t1 OWNER TO postgres;

--
-- Name: dob_t2; Type: TABLE; Schema: regress_rls_schema; Owner: postgres
--

CREATE TABLE regress_rls_schema.dob_t2 (
    c1 integer
)
PARTITION BY RANGE (c1);


ALTER TABLE regress_rls_schema.dob_t2 OWNER TO postgres;

--
-- Name: document; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.document (
    did integer NOT NULL,
    cid integer,
    dlevel integer NOT NULL,
    dauthor name,
    dtitle text,
    dnotes text DEFAULT ''::text
);


ALTER TABLE regress_rls_schema.document OWNER TO regress_rls_alice;

--
-- Name: part_document; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.part_document (
    did integer,
    cid integer,
    dlevel integer NOT NULL,
    dauthor name,
    dtitle text
)
PARTITION BY RANGE (cid);


ALTER TABLE regress_rls_schema.part_document OWNER TO regress_rls_alice;

--
-- Name: part_document_fiction; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.part_document_fiction (
    did integer,
    cid integer,
    dlevel integer NOT NULL,
    dauthor name,
    dtitle text
);


ALTER TABLE regress_rls_schema.part_document_fiction OWNER TO regress_rls_alice;

--
-- Name: part_document_nonfiction; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.part_document_nonfiction (
    did integer,
    cid integer,
    dlevel integer NOT NULL,
    dauthor name,
    dtitle text
);


ALTER TABLE regress_rls_schema.part_document_nonfiction OWNER TO regress_rls_alice;

--
-- Name: part_document_satire; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.part_document_satire (
    did integer,
    cid integer,
    dlevel integer NOT NULL,
    dauthor name,
    dtitle text
);


ALTER TABLE regress_rls_schema.part_document_satire OWNER TO regress_rls_alice;

--
-- Name: r1; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.r1 (
    a integer NOT NULL
);


ALTER TABLE regress_rls_schema.r1 OWNER TO regress_rls_alice;

--
-- Name: r1_2; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.r1_2 (
    a integer
);

ALTER TABLE ONLY regress_rls_schema.r1_2 FORCE ROW LEVEL SECURITY;


ALTER TABLE regress_rls_schema.r1_2 OWNER TO regress_rls_alice;

--
-- Name: r1_3; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.r1_3 (
    a integer NOT NULL
);

ALTER TABLE ONLY regress_rls_schema.r1_3 FORCE ROW LEVEL SECURITY;


ALTER TABLE regress_rls_schema.r1_3 OWNER TO regress_rls_alice;

--
-- Name: r1_4; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.r1_4 (
    a integer NOT NULL
);


ALTER TABLE regress_rls_schema.r1_4 OWNER TO regress_rls_alice;

--
-- Name: r1_5; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.r1_5 (
    a integer NOT NULL
);


ALTER TABLE regress_rls_schema.r1_5 OWNER TO regress_rls_alice;

--
-- Name: r2; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.r2 (
    a integer
);


ALTER TABLE regress_rls_schema.r2 OWNER TO regress_rls_alice;

--
-- Name: r2_3; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.r2_3 (
    a integer
);

ALTER TABLE ONLY regress_rls_schema.r2_3 FORCE ROW LEVEL SECURITY;


ALTER TABLE regress_rls_schema.r2_3 OWNER TO regress_rls_alice;

--
-- Name: r2_4; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.r2_4 (
    a integer
);

ALTER TABLE ONLY regress_rls_schema.r2_4 FORCE ROW LEVEL SECURITY;


ALTER TABLE regress_rls_schema.r2_4 OWNER TO regress_rls_alice;

--
-- Name: r2_5; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.r2_5 (
    a integer
);

ALTER TABLE ONLY regress_rls_schema.r2_5 FORCE ROW LEVEL SECURITY;


ALTER TABLE regress_rls_schema.r2_5 OWNER TO regress_rls_alice;

--
-- Name: rec1; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.rec1 (
    x integer,
    y integer
);


ALTER TABLE regress_rls_schema.rec1 OWNER TO regress_rls_alice;

--
-- Name: rec1v; Type: VIEW; Schema: regress_rls_schema; Owner: regress_rls_bob
--

CREATE VIEW regress_rls_schema.rec1v AS
 SELECT rec1.x,
    rec1.y
   FROM regress_rls_schema.rec1;


ALTER TABLE regress_rls_schema.rec1v OWNER TO regress_rls_bob;

--
-- Name: rec1v_2; Type: VIEW; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE VIEW regress_rls_schema.rec1v_2 WITH (security_barrier='true') AS
 SELECT rec1.x,
    rec1.y
   FROM regress_rls_schema.rec1;


ALTER TABLE regress_rls_schema.rec1v_2 OWNER TO regress_rls_alice;

--
-- Name: rec2; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.rec2 (
    a integer,
    b integer
);


ALTER TABLE regress_rls_schema.rec2 OWNER TO regress_rls_alice;

--
-- Name: rec2v; Type: VIEW; Schema: regress_rls_schema; Owner: regress_rls_bob
--

CREATE VIEW regress_rls_schema.rec2v AS
 SELECT rec2.a,
    rec2.b
   FROM regress_rls_schema.rec2;


ALTER TABLE regress_rls_schema.rec2v OWNER TO regress_rls_bob;

--
-- Name: rec2v_2; Type: VIEW; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE VIEW regress_rls_schema.rec2v_2 WITH (security_barrier='true') AS
 SELECT rec2.a,
    rec2.b
   FROM regress_rls_schema.rec2;


ALTER TABLE regress_rls_schema.rec2v_2 OWNER TO regress_rls_alice;

--
-- Name: ref_tbl; Type: TABLE; Schema: regress_rls_schema; Owner: postgres
--

CREATE TABLE regress_rls_schema.ref_tbl (
    a integer
);


ALTER TABLE regress_rls_schema.ref_tbl OWNER TO postgres;

--
-- Name: y1; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.y1 (
    a integer,
    b text
);


ALTER TABLE regress_rls_schema.y1 OWNER TO regress_rls_alice;

--
-- Name: rls_sbv; Type: VIEW; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE VIEW regress_rls_schema.rls_sbv WITH (security_barrier='true') AS
 SELECT y1.a,
    y1.b
   FROM regress_rls_schema.y1
  WHERE regress_rls_schema.f_leak(y1.b);


ALTER TABLE regress_rls_schema.rls_sbv OWNER TO regress_rls_alice;

--
-- Name: rls_sbv_2; Type: VIEW; Schema: regress_rls_schema; Owner: regress_rls_bob
--

CREATE VIEW regress_rls_schema.rls_sbv_2 WITH (security_barrier='true') AS
 SELECT y1.a,
    y1.b
   FROM regress_rls_schema.y1
  WHERE regress_rls_schema.f_leak(y1.b);


ALTER TABLE regress_rls_schema.rls_sbv_2 OWNER TO regress_rls_bob;

--
-- Name: rls_tbl; Type: TABLE; Schema: regress_rls_schema; Owner: postgres
--

CREATE TABLE regress_rls_schema.rls_tbl (
    a integer
);


ALTER TABLE regress_rls_schema.rls_tbl OWNER TO postgres;

--
-- Name: rls_tbl_2; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.rls_tbl_2 (
    a integer
);


ALTER TABLE regress_rls_schema.rls_tbl_2 OWNER TO regress_rls_alice;

--
-- Name: rls_tbl_3; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.rls_tbl_3 (
    a integer,
    b integer,
    c integer
);

ALTER TABLE ONLY regress_rls_schema.rls_tbl_3 FORCE ROW LEVEL SECURITY;


ALTER TABLE regress_rls_schema.rls_tbl_3 OWNER TO regress_rls_alice;

--
-- Name: rls_view; Type: VIEW; Schema: regress_rls_schema; Owner: regress_rls_bob
--

CREATE VIEW regress_rls_schema.rls_view AS
 SELECT rls_tbl.a
   FROM regress_rls_schema.rls_tbl;


ALTER TABLE regress_rls_schema.rls_view OWNER TO regress_rls_bob;

--
-- Name: z1; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.z1 (
    a integer,
    b text
);


ALTER TABLE regress_rls_schema.z1 OWNER TO regress_rls_alice;

--
-- Name: rls_view_2; Type: VIEW; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE VIEW regress_rls_schema.rls_view_2 AS
 SELECT z1.a,
    z1.b
   FROM regress_rls_schema.z1
  WHERE regress_rls_schema.f_leak(z1.b);


ALTER TABLE regress_rls_schema.rls_view_2 OWNER TO regress_rls_alice;

--
-- Name: rls_view_3; Type: VIEW; Schema: regress_rls_schema; Owner: regress_rls_bob
--

CREATE VIEW regress_rls_schema.rls_view_3 AS
 SELECT z1.a,
    z1.b
   FROM regress_rls_schema.z1
  WHERE regress_rls_schema.f_leak(z1.b);


ALTER TABLE regress_rls_schema.rls_view_3 OWNER TO regress_rls_bob;

--
-- Name: rls_view_4; Type: VIEW; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE VIEW regress_rls_schema.rls_view_4 AS
 SELECT z1.a,
    z1.b
   FROM regress_rls_schema.z1
  WHERE regress_rls_schema.f_leak(z1.b);


ALTER TABLE regress_rls_schema.rls_view_4 OWNER TO regress_rls_alice;

--
-- Name: s1; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.s1 (
    a integer,
    b text
);


ALTER TABLE regress_rls_schema.s1 OWNER TO regress_rls_alice;

--
-- Name: s2; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.s2 (
    x integer,
    y text
);


ALTER TABLE regress_rls_schema.s2 OWNER TO regress_rls_alice;

--
-- Name: t; Type: TABLE; Schema: regress_rls_schema; Owner: postgres
--

CREATE TABLE regress_rls_schema.t (
    c integer
);


ALTER TABLE regress_rls_schema.t OWNER TO postgres;

--
-- Name: t1; Type: TABLE; Schema: regress_rls_schema; Owner: postgres
--

CREATE TABLE regress_rls_schema.t1 (
    id integer NOT NULL,
    a integer,
    b text
);


ALTER TABLE regress_rls_schema.t1 OWNER TO postgres;

--
-- Name: t1_2; Type: TABLE; Schema: regress_rls_schema; Owner: postgres
--

CREATE TABLE regress_rls_schema.t1_2 (
    a integer
);


ALTER TABLE regress_rls_schema.t1_2 OWNER TO postgres;

--
-- Name: t1_3; Type: TABLE; Schema: regress_rls_schema; Owner: postgres
--

CREATE TABLE regress_rls_schema.t1_3 (
    a integer,
    b text
);


ALTER TABLE regress_rls_schema.t1_3 OWNER TO postgres;

--
-- Name: t2; Type: TABLE; Schema: regress_rls_schema; Owner: postgres
--

CREATE TABLE regress_rls_schema.t2 (
    c double precision
)
INHERITS (regress_rls_schema.t1);


ALTER TABLE regress_rls_schema.t2 OWNER TO postgres;

--
-- Name: t2_3; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_bob
--

CREATE TABLE regress_rls_schema.t2_3 (
    a integer,
    b text
);


ALTER TABLE regress_rls_schema.t2_3 OWNER TO regress_rls_bob;

--
-- Name: t3_3; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.t3_3 (
    id integer NOT NULL,
    c text,
    b text,
    a integer
)
INHERITS (regress_rls_schema.t1_3);


ALTER TABLE regress_rls_schema.t3_3 OWNER TO regress_rls_alice;

--
-- Name: tbl1; Type: TABLE; Schema: regress_rls_schema; Owner: postgres
--

CREATE TABLE regress_rls_schema.tbl1 (
    c text
);


ALTER TABLE regress_rls_schema.tbl1 OWNER TO postgres;

--
-- Name: test_qual_pushdown; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_bob
--

CREATE TABLE regress_rls_schema.test_qual_pushdown (
    abc text
);


ALTER TABLE regress_rls_schema.test_qual_pushdown OWNER TO regress_rls_bob;

--
-- Name: uaccount; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.uaccount (
    pguser name NOT NULL,
    seclv integer
);


ALTER TABLE regress_rls_schema.uaccount OWNER TO regress_rls_alice;

--
-- Name: v2; Type: VIEW; Schema: regress_rls_schema; Owner: regress_rls_bob
--

CREATE VIEW regress_rls_schema.v2 AS
 SELECT s2.x,
    s2.y
   FROM regress_rls_schema.s2
  WHERE (s2.y ~~ '%af%'::text);


ALTER TABLE regress_rls_schema.v2 OWNER TO regress_rls_bob;

--
-- Name: x1; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.x1 (
    a integer,
    b text,
    c text
);


ALTER TABLE regress_rls_schema.x1 OWNER TO regress_rls_alice;

--
-- Name: y2; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.y2 (
    a integer,
    b text
);


ALTER TABLE regress_rls_schema.y2 OWNER TO regress_rls_alice;

--
-- Name: z1_blacklist; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.z1_blacklist (
    a integer
);


ALTER TABLE regress_rls_schema.z1_blacklist OWNER TO regress_rls_alice;

--
-- Name: z2; Type: TABLE; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE TABLE regress_rls_schema.z2 (
    a integer,
    b text
);


ALTER TABLE regress_rls_schema.z2 OWNER TO regress_rls_alice;

SET default_tablespace = example_tablespace;

--
-- Name: example_table; Type: TABLE; Schema: tablespace_dependencies; Owner: postgres; Tablespace: example_tablespace
--

CREATE TABLE tablespace_dependencies.example_table (
    id integer NOT NULL
);


ALTER TABLE tablespace_dependencies.example_table OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: accounts; Type: TABLE; Schema: trigger_test; Owner: postgres
--

CREATE TABLE trigger_test.accounts (
    id integer NOT NULL,
    balance real
);


ALTER TABLE trigger_test.accounts OWNER TO postgres;

--
-- Name: accounts_view; Type: VIEW; Schema: trigger_test; Owner: postgres
--

CREATE VIEW trigger_test.accounts_view AS
 SELECT accounts.id,
    accounts.balance
   FROM trigger_test.accounts;


ALTER TABLE trigger_test.accounts_view OWNER TO postgres;

--
-- Name: update_log; Type: TABLE; Schema: trigger_test; Owner: postgres
--

CREATE TABLE trigger_test.update_log (
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL,
    account_id integer NOT NULL
);


ALTER TABLE trigger_test.update_log OWNER TO postgres;

--
-- Name: tableam_parted_1_heapx; Type: TABLE ATTACH; Schema: am_examples; Owner: postgres
--

ALTER TABLE ONLY am_examples.tableam_parted_heapx ATTACH PARTITION am_examples.tableam_parted_1_heapx FOR VALUES IN ('a', 'b');


--
-- Name: tableam_parted_2_heapx; Type: TABLE ATTACH; Schema: am_examples; Owner: postgres
--

ALTER TABLE ONLY am_examples.tableam_parted_heapx ATTACH PARTITION am_examples.tableam_parted_2_heapx FOR VALUES IN ('c', 'd');


--
-- Name: tableam_parted_c_heap2; Type: TABLE ATTACH; Schema: am_examples; Owner: postgres
--

ALTER TABLE ONLY am_examples.tableam_parted_heap2 ATTACH PARTITION am_examples.tableam_parted_c_heap2 FOR VALUES IN ('c');


--
-- Name: tableam_parted_d_heap2; Type: TABLE ATTACH; Schema: am_examples; Owner: postgres
--

ALTER TABLE ONLY am_examples.tableam_parted_heap2 ATTACH PARTITION am_examples.tableam_parted_d_heap2 FOR VALUES IN ('d');


--
-- Name: part_document_fiction; Type: TABLE ATTACH; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE ONLY regress_rls_schema.part_document ATTACH PARTITION regress_rls_schema.part_document_fiction FOR VALUES FROM (11) TO (12);


--
-- Name: part_document_nonfiction; Type: TABLE ATTACH; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE ONLY regress_rls_schema.part_document ATTACH PARTITION regress_rls_schema.part_document_nonfiction FOR VALUES FROM (99) TO (100);


--
-- Name: part_document_satire; Type: TABLE ATTACH; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE ONLY regress_rls_schema.part_document ATTACH PARTITION regress_rls_schema.part_document_satire FOR VALUES FROM (55) TO (56);


--
-- Name: us_snail_addy address_id; Type: DEFAULT; Schema: domain_examples; Owner: postgres
--

ALTER TABLE ONLY domain_examples.us_snail_addy ALTER COLUMN address_id SET DEFAULT nextval('domain_examples.us_snail_addy_address_id_seq'::regclass);


--
-- Name: bugs id; Type: DEFAULT; Schema: enum_example; Owner: postgres
--

ALTER TABLE ONLY enum_example.bugs ALTER COLUMN id SET DEFAULT nextval('enum_example.bugs_id_seq'::regclass);


--
-- Name: bugs_clone id; Type: DEFAULT; Schema: enum_example; Owner: postgres
--

ALTER TABLE ONLY enum_example.bugs_clone ALTER COLUMN id SET DEFAULT nextval('enum_example.bugs_id_seq'::regclass);


--
-- Name: numeric_type_examples id; Type: DEFAULT; Schema: ordinary_tables; Owner: postgres
--

ALTER TABLE ONLY ordinary_tables.numeric_type_examples ALTER COLUMN id SET DEFAULT nextval('ordinary_tables.numeric_type_examples_id_seq'::regclass);


--
-- Name: numeric_type_examples a_smallserial; Type: DEFAULT; Schema: ordinary_tables; Owner: postgres
--

ALTER TABLE ONLY ordinary_tables.numeric_type_examples ALTER COLUMN a_smallserial SET DEFAULT nextval('ordinary_tables.numeric_type_examples_a_smallserial_seq'::regclass);


--
-- Name: numeric_type_examples a_bigserial; Type: DEFAULT; Schema: ordinary_tables; Owner: postgres
--

ALTER TABLE ONLY ordinary_tables.numeric_type_examples ALTER COLUMN a_bigserial SET DEFAULT nextval('ordinary_tables.numeric_type_examples_a_bigserial_seq'::regclass);


--
-- Name: us_snail_addy us_snail_addy_pkey; Type: CONSTRAINT; Schema: domain_examples; Owner: postgres
--

ALTER TABLE ONLY domain_examples.us_snail_addy
    ADD CONSTRAINT us_snail_addy_pkey PRIMARY KEY (address_id);


--
-- Name: films films_pkey; Type: CONSTRAINT; Schema: idx_ex; Owner: postgres
--

ALTER TABLE ONLY idx_ex.films
    ADD CONSTRAINT films_pkey PRIMARY KEY (id);


--
-- Name: binary_examples binary_examples_pkey; Type: CONSTRAINT; Schema: ordinary_tables; Owner: postgres
--

ALTER TABLE ONLY ordinary_tables.binary_examples
    ADD CONSTRAINT binary_examples_pkey PRIMARY KEY (bytes);


--
-- Name: character_examples character_examples_pkey; Type: CONSTRAINT; Schema: ordinary_tables; Owner: postgres
--

ALTER TABLE ONLY ordinary_tables.character_examples
    ADD CONSTRAINT character_examples_pkey PRIMARY KEY (id);


--
-- Name: numeric_type_examples numeric_type_examples_pkey; Type: CONSTRAINT; Schema: ordinary_tables; Owner: postgres
--

ALTER TABLE ONLY ordinary_tables.numeric_type_examples
    ADD CONSTRAINT numeric_type_examples_pkey PRIMARY KEY (id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE ONLY regress_rls_schema.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (cid);


--
-- Name: document document_pkey; Type: CONSTRAINT; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE ONLY regress_rls_schema.document
    ADD CONSTRAINT document_pkey PRIMARY KEY (did);


--
-- Name: r1_3 r1_3_pkey; Type: CONSTRAINT; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE ONLY regress_rls_schema.r1_3
    ADD CONSTRAINT r1_3_pkey PRIMARY KEY (a);


--
-- Name: r1_4 r1_4_pkey; Type: CONSTRAINT; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE ONLY regress_rls_schema.r1_4
    ADD CONSTRAINT r1_4_pkey PRIMARY KEY (a);


--
-- Name: r1_5 r1_5_pkey; Type: CONSTRAINT; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE ONLY regress_rls_schema.r1_5
    ADD CONSTRAINT r1_5_pkey PRIMARY KEY (a);


--
-- Name: r1 r1_pkey; Type: CONSTRAINT; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE ONLY regress_rls_schema.r1
    ADD CONSTRAINT r1_pkey PRIMARY KEY (a);


--
-- Name: t1 t1_pkey; Type: CONSTRAINT; Schema: regress_rls_schema; Owner: postgres
--

ALTER TABLE ONLY regress_rls_schema.t1
    ADD CONSTRAINT t1_pkey PRIMARY KEY (id);


--
-- Name: t3_3 t3_3_pkey; Type: CONSTRAINT; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE ONLY regress_rls_schema.t3_3
    ADD CONSTRAINT t3_3_pkey PRIMARY KEY (id);


--
-- Name: uaccount uaccount_pkey; Type: CONSTRAINT; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE ONLY regress_rls_schema.uaccount
    ADD CONSTRAINT uaccount_pkey PRIMARY KEY (pguser);


--
-- Name: example_table example_table_pk; Type: CONSTRAINT; Schema: tablespace_dependencies; Owner: postgres
--

ALTER TABLE ONLY tablespace_dependencies.example_table
    ADD CONSTRAINT example_table_pk PRIMARY KEY (id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: trigger_test; Owner: postgres
--

ALTER TABLE ONLY trigger_test.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: update_log update_log_pk; Type: CONSTRAINT; Schema: trigger_test; Owner: postgres
--

ALTER TABLE ONLY trigger_test.update_log
    ADD CONSTRAINT update_log_pk PRIMARY KEY ("timestamp", account_id);


--
-- Name: grect2ind2; Type: INDEX; Schema: am_examples; Owner: postgres
--

CREATE INDEX grect2ind2 ON am_examples.fast_emp4000 USING gist2 (home_base);


--
-- Name: grect2ind3; Type: INDEX; Schema: am_examples; Owner: postgres
--

CREATE INDEX grect2ind3 ON am_examples.fast_emp4000 USING gist2 (home_base);


--
-- Name: idx_1; Type: INDEX; Schema: composite_type_examples; Owner: postgres
--

CREATE INDEX idx_1 ON composite_type_examples.ordinary_table USING btree (basic_);


--
-- Name: hidx; Type: INDEX; Schema: extension_example; Owner: postgres
--

CREATE INDEX hidx ON extension_example.testhstore USING gist (h extension_example.gist_hstore_ops (siglen='32'));


--
-- Name: gin_idx; Type: INDEX; Schema: idx_ex; Owner: postgres
--

CREATE INDEX gin_idx ON idx_ex.films USING gin (to_tsvector('english'::regconfig, title)) WITH (fastupdate=off);


--
-- Name: title_idx; Type: INDEX; Schema: idx_ex; Owner: postgres
--

CREATE UNIQUE INDEX title_idx ON idx_ex.films USING btree (title) WITH (fillfactor='70');


--
-- Name: title_idx_lower; Type: INDEX; Schema: idx_ex; Owner: postgres
--

CREATE INDEX title_idx_lower ON idx_ex.films USING btree (lower(title));


--
-- Name: title_idx_nulls_low; Type: INDEX; Schema: idx_ex; Owner: postgres
--

CREATE INDEX title_idx_nulls_low ON idx_ex.films USING btree (title NULLS FIRST);


--
-- Name: title_idx_u1; Type: INDEX; Schema: idx_ex; Owner: postgres
--

CREATE UNIQUE INDEX title_idx_u1 ON idx_ex.films USING btree (title);


--
-- Name: title_idx_u2; Type: INDEX; Schema: idx_ex; Owner: postgres
--

CREATE UNIQUE INDEX title_idx_u2 ON idx_ex.films USING btree (title) INCLUDE (director, rating);


--
-- Name: title_idx_with_duplicates; Type: INDEX; Schema: idx_ex; Owner: postgres
--

CREATE INDEX title_idx_with_duplicates ON idx_ex.films USING btree (title) WITH (deduplicate_items=off);


SET default_tablespace = indexspace;

--
-- Name: example_index; Type: INDEX; Schema: tablespace_dependencies; Owner: postgres; Tablespace: indexspace
--

CREATE INDEX example_index ON tablespace_dependencies.example_table USING btree (id);


--
-- Name: accounts check_balance_update; Type: TRIGGER; Schema: trigger_test; Owner: postgres
--

CREATE TRIGGER check_balance_update BEFORE UPDATE OF balance ON trigger_test.accounts FOR EACH ROW EXECUTE FUNCTION trigger_test.check_account_update();


--
-- Name: accounts check_update; Type: TRIGGER; Schema: trigger_test; Owner: postgres
--

CREATE TRIGGER check_update BEFORE UPDATE ON trigger_test.accounts FOR EACH ROW EXECUTE FUNCTION trigger_test.check_account_update();


--
-- Name: accounts check_update_when_difft_balance; Type: TRIGGER; Schema: trigger_test; Owner: postgres
--

CREATE TRIGGER check_update_when_difft_balance BEFORE UPDATE ON trigger_test.accounts FOR EACH ROW WHEN ((old.balance IS DISTINCT FROM new.balance)) EXECUTE FUNCTION trigger_test.check_account_update();


--
-- Name: accounts log_update; Type: TRIGGER; Schema: trigger_test; Owner: postgres
--

CREATE TRIGGER log_update AFTER UPDATE ON trigger_test.accounts FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE FUNCTION trigger_test.log_account_update();


--
-- Name: accounts_view view_insert; Type: TRIGGER; Schema: trigger_test; Owner: postgres
--

CREATE TRIGGER view_insert INSTEAD OF INSERT ON trigger_test.accounts_view FOR EACH ROW EXECUTE FUNCTION trigger_test.view_insert_row();


--
-- Name: document document_cid_fkey; Type: FK CONSTRAINT; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE ONLY regress_rls_schema.document
    ADD CONSTRAINT document_cid_fkey FOREIGN KEY (cid) REFERENCES regress_rls_schema.category(cid);


--
-- Name: r2_3 r2_3_a_fkey; Type: FK CONSTRAINT; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE ONLY regress_rls_schema.r2_3
    ADD CONSTRAINT r2_3_a_fkey FOREIGN KEY (a) REFERENCES regress_rls_schema.r1(a);


--
-- Name: r2_4 r2_4_a_fkey; Type: FK CONSTRAINT; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE ONLY regress_rls_schema.r2_4
    ADD CONSTRAINT r2_4_a_fkey FOREIGN KEY (a) REFERENCES regress_rls_schema.r1(a) ON DELETE CASCADE;


--
-- Name: r2_5 r2_5_a_fkey; Type: FK CONSTRAINT; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE ONLY regress_rls_schema.r2_5
    ADD CONSTRAINT r2_5_a_fkey FOREIGN KEY (a) REFERENCES regress_rls_schema.r1(a) ON UPDATE CASCADE;


--
-- Name: update_log update_log_account_id_fkey; Type: FK CONSTRAINT; Schema: trigger_test; Owner: postgres
--

ALTER TABLE ONLY trigger_test.update_log
    ADD CONSTRAINT update_log_account_id_fkey FOREIGN KEY (account_id) REFERENCES trigger_test.accounts(id);


--
-- Name: b1; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.b1 ENABLE ROW LEVEL SECURITY;

--
-- Name: dependent d1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY d1 ON regress_rls_schema.dependent USING ((x = ( SELECT d.x
   FROM regress_rls_schema.dependee d
  WHERE (d.y = d.y))));


--
-- Name: document; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.document ENABLE ROW LEVEL SECURITY;

--
-- Name: t p; Type: POLICY; Schema: regress_rls_schema; Owner: postgres
--

CREATE POLICY p ON regress_rls_schema.t USING (((c % 2) = 1));


--
-- Name: tbl1 p; Type: POLICY; Schema: regress_rls_schema; Owner: postgres
--

CREATE POLICY p ON regress_rls_schema.tbl1 TO regress_rls_eve, regress_rls_frank USING (true);


--
-- Name: x1 p0; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p0 ON regress_rls_schema.x1 USING ((c = CURRENT_USER));


--
-- Name: b1 p1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1 ON regress_rls_schema.b1 USING (((a % 2) = 0));


--
-- Name: dob_t1 p1; Type: POLICY; Schema: regress_rls_schema; Owner: postgres
--

CREATE POLICY p1 ON regress_rls_schema.dob_t1 TO regress_rls_dob_role1 USING (true);


--
-- Name: dob_t2 p1; Type: POLICY; Schema: regress_rls_schema; Owner: postgres
--

CREATE POLICY p1 ON regress_rls_schema.dob_t2 TO regress_rls_dob_role1, regress_rls_dob_role2 USING (true);


--
-- Name: document p1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1 ON regress_rls_schema.document USING ((dlevel <= ( SELECT uaccount.seclv
   FROM regress_rls_schema.uaccount
  WHERE (uaccount.pguser = CURRENT_USER))));


--
-- Name: r1 p1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1 ON regress_rls_schema.r1 USING (true);


--
-- Name: r1_2 p1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1 ON regress_rls_schema.r1_2 USING (false);


--
-- Name: r1_3 p1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1 ON regress_rls_schema.r1_3 USING (false);


--
-- Name: r2 p1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1 ON regress_rls_schema.r2 FOR SELECT USING (true);


--
-- Name: r2_3 p1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1 ON regress_rls_schema.r2_3 USING (false);


--
-- Name: r2_4 p1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1 ON regress_rls_schema.r2_4 USING (false);


--
-- Name: r2_5 p1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1 ON regress_rls_schema.r2_5 USING (false);


--
-- Name: rls_tbl p1; Type: POLICY; Schema: regress_rls_schema; Owner: postgres
--

CREATE POLICY p1 ON regress_rls_schema.rls_tbl USING ((EXISTS ( SELECT 1
   FROM regress_rls_schema.ref_tbl)));


--
-- Name: rls_tbl_3 p1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1 ON regress_rls_schema.rls_tbl_3 USING ((rls_tbl_3.* >= ROW(1, 1, 1)));


--
-- Name: s1 p1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1 ON regress_rls_schema.s1 USING ((a IN ( SELECT s2.x
   FROM regress_rls_schema.s2
  WHERE (s2.y ~~ '%2f%'::text))));


--
-- Name: t1 p1; Type: POLICY; Schema: regress_rls_schema; Owner: postgres
--

CREATE POLICY p1 ON regress_rls_schema.t1 USING (((a % 2) = 0));


--
-- Name: t1_2 p1; Type: POLICY; Schema: regress_rls_schema; Owner: postgres
--

CREATE POLICY p1 ON regress_rls_schema.t1_2 TO regress_rls_bob USING (((a % 2) = 0));


--
-- Name: t1_3 p1; Type: POLICY; Schema: regress_rls_schema; Owner: postgres
--

CREATE POLICY p1 ON regress_rls_schema.t1_3 USING (((a % 2) = 0));


--
-- Name: x1 p1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1 ON regress_rls_schema.x1 FOR SELECT USING (((a % 2) = 0));


--
-- Name: y1 p1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1 ON regress_rls_schema.y1 USING (((a % 2) = 0));


--
-- Name: y2 p1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1 ON regress_rls_schema.y2 USING (((a % 2) = 0));


--
-- Name: z1 p1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1 ON regress_rls_schema.z1 TO regress_rls_group1 USING (((a % 2) = 0));


--
-- Name: dob_t1 p1_2; Type: POLICY; Schema: regress_rls_schema; Owner: postgres
--

CREATE POLICY p1_2 ON regress_rls_schema.dob_t1 TO regress_rls_dob_role1, regress_rls_dob_role2 USING (true);


--
-- Name: s1 p1_2; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1_2 ON regress_rls_schema.s1 USING ((a IN ( SELECT v2.x
   FROM regress_rls_schema.v2)));


--
-- Name: t1_3 p1_2; Type: POLICY; Schema: regress_rls_schema; Owner: postgres
--

CREATE POLICY p1_2 ON regress_rls_schema.t1_3 USING (((a % 2) = 0));


--
-- Name: y1 p1_2; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1_2 ON regress_rls_schema.y1 FOR SELECT USING (((a % 2) = 1));


--
-- Name: dob_t1 p1_3; Type: POLICY; Schema: regress_rls_schema; Owner: postgres
--

CREATE POLICY p1_3 ON regress_rls_schema.dob_t1 TO regress_rls_dob_role1 USING (true);


--
-- Name: document p1_3; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1_3 ON regress_rls_schema.document FOR SELECT USING (true);


--
-- Name: dob_t1 p1_4; Type: POLICY; Schema: regress_rls_schema; Owner: postgres
--

CREATE POLICY p1_4 ON regress_rls_schema.dob_t1 TO regress_rls_dob_role1, regress_rls_dob_role2 USING (true);


--
-- Name: document p1_4; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1_4 ON regress_rls_schema.document FOR SELECT USING (true);


--
-- Name: document p1r; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p1r ON regress_rls_schema.document AS RESTRICTIVE TO regress_rls_dave USING ((cid <> 44));


--
-- Name: r2 p2; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p2 ON regress_rls_schema.r2 FOR INSERT WITH CHECK (false);


--
-- Name: s2 p2; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p2 ON regress_rls_schema.s2 USING ((x IN ( SELECT s1.a
   FROM regress_rls_schema.s1
  WHERE (s1.b ~~ '%22%'::text))));


--
-- Name: t1_2 p2; Type: POLICY; Schema: regress_rls_schema; Owner: postgres
--

CREATE POLICY p2 ON regress_rls_schema.t1_2 TO regress_rls_carol USING (((a % 4) = 0));


--
-- Name: t2 p2; Type: POLICY; Schema: regress_rls_schema; Owner: postgres
--

CREATE POLICY p2 ON regress_rls_schema.t2 USING (((a % 2) = 1));


--
-- Name: t2_3 p2; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_bob
--

CREATE POLICY p2 ON regress_rls_schema.t2_3 USING (((a % 2) = 1));


--
-- Name: x1 p2; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p2 ON regress_rls_schema.x1 FOR INSERT WITH CHECK (((a % 2) = 1));


--
-- Name: y1 p2; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p2 ON regress_rls_schema.y1 FOR SELECT USING ((a > 2));


--
-- Name: y2 p2; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p2 ON regress_rls_schema.y2 USING (((a % 3) = 0));


--
-- Name: z1 p2; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p2 ON regress_rls_schema.z1 TO regress_rls_group2 USING (((a % 2) = 1));


--
-- Name: s2 p2_2; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p2_2 ON regress_rls_schema.s2 USING ((x IN ( SELECT s1.a
   FROM regress_rls_schema.s1
  WHERE (s1.b ~~ '%d2%'::text))));


--
-- Name: document p2_3; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p2_3 ON regress_rls_schema.document FOR INSERT WITH CHECK ((dauthor = CURRENT_USER));


--
-- Name: document p2_4; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p2_4 ON regress_rls_schema.document FOR INSERT WITH CHECK ((dauthor = CURRENT_USER));


--
-- Name: document p2r; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p2r ON regress_rls_schema.document AS RESTRICTIVE TO regress_rls_dave USING (((cid <> 44) AND (cid < 50)));


--
-- Name: r2 p3; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p3 ON regress_rls_schema.r2 FOR UPDATE USING (false);


--
-- Name: s1 p3; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p3 ON regress_rls_schema.s1 FOR INSERT WITH CHECK ((a = ( SELECT s1_1.a
   FROM regress_rls_schema.s1 s1_1)));


--
-- Name: x1 p3; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p3 ON regress_rls_schema.x1 FOR UPDATE USING (((a % 2) = 0));


--
-- Name: y2 p3; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p3 ON regress_rls_schema.y2 USING (((a % 4) = 0));


--
-- Name: z1 p3; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p3 ON regress_rls_schema.z1 AS RESTRICTIVE USING ((NOT (a IN ( SELECT z1_blacklist.a
   FROM regress_rls_schema.z1_blacklist))));


--
-- Name: z1 p3_2; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p3_2 ON regress_rls_schema.z1 AS RESTRICTIVE USING ((NOT (a IN ( SELECT z1_blacklist.a
   FROM regress_rls_schema.z1_blacklist))));


--
-- Name: document p3_3; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p3_3 ON regress_rls_schema.document FOR UPDATE USING ((cid = ( SELECT category.cid
   FROM regress_rls_schema.category
  WHERE (category.cname = 'novel'::text)))) WITH CHECK ((dauthor = CURRENT_USER));


--
-- Name: document p3_4; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p3_4 ON regress_rls_schema.document FOR UPDATE USING ((cid = ( SELECT category.cid
   FROM regress_rls_schema.category
  WHERE (category.cname = 'novel'::text)))) WITH CHECK ((dauthor = CURRENT_USER));


--
-- Name: document p3_with_all; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p3_with_all ON regress_rls_schema.document USING ((cid = ( SELECT category.cid
   FROM regress_rls_schema.category
  WHERE (category.cname = 'novel'::text)))) WITH CHECK ((dauthor = CURRENT_USER));


--
-- Name: document p3_with_default; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p3_with_default ON regress_rls_schema.document FOR UPDATE USING ((cid = ( SELECT category.cid
   FROM regress_rls_schema.category
  WHERE (category.cname = 'novel'::text))));


--
-- Name: r2 p4; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p4 ON regress_rls_schema.r2 FOR DELETE USING (false);


--
-- Name: x1 p4; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p4 ON regress_rls_schema.x1 FOR DELETE USING ((a < 8));


--
-- Name: document p4_4; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY p4_4 ON regress_rls_schema.document FOR DELETE USING ((cid = ( SELECT category.cid
   FROM regress_rls_schema.category
  WHERE (category.cname = 'manga'::text))));


--
-- Name: part_document; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.part_document ENABLE ROW LEVEL SECURITY;

--
-- Name: part_document pp1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY pp1 ON regress_rls_schema.part_document USING ((dlevel <= ( SELECT uaccount.seclv
   FROM regress_rls_schema.uaccount
  WHERE (uaccount.pguser = CURRENT_USER))));


--
-- Name: part_document pp1r; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY pp1r ON regress_rls_schema.part_document AS RESTRICTIVE TO regress_rls_dave USING ((cid < 55));


--
-- Name: r1; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.r1 ENABLE ROW LEVEL SECURITY;

--
-- Name: rec1 r1; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY r1 ON regress_rls_schema.rec1 USING ((x = ( SELECT r.x
   FROM regress_rls_schema.rec1 r
  WHERE (r.y = r.y))));


--
-- Name: r1_2; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.r1_2 ENABLE ROW LEVEL SECURITY;

--
-- Name: rec1 r1_2; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY r1_2 ON regress_rls_schema.rec1 USING ((x = ( SELECT rec2.a
   FROM regress_rls_schema.rec2
  WHERE (rec2.b = rec1.y))));


--
-- Name: r1_3; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.r1_3 ENABLE ROW LEVEL SECURITY;

--
-- Name: rec1 r1_3; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY r1_3 ON regress_rls_schema.rec1 USING ((x = ( SELECT rec2v.a
   FROM regress_rls_schema.rec2v
  WHERE (rec2v.b = rec1.y))));


--
-- Name: rec1 r1_4; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY r1_4 ON regress_rls_schema.rec1 USING ((x = ( SELECT rec2v_2.a
   FROM regress_rls_schema.rec2v_2
  WHERE (rec2v_2.b = rec1.y))));


--
-- Name: r2; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.r2 ENABLE ROW LEVEL SECURITY;

--
-- Name: rec2 r2; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY r2 ON regress_rls_schema.rec2 USING ((a = ( SELECT rec1.x
   FROM regress_rls_schema.rec1
  WHERE (rec1.y = rec2.b))));


--
-- Name: rec2 r2_2; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY r2_2 ON regress_rls_schema.rec2 USING ((a = ( SELECT rec1v_2.x
   FROM regress_rls_schema.rec1v_2
  WHERE (rec1v_2.y = rec2.b))));


--
-- Name: r2_3; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.r2_3 ENABLE ROW LEVEL SECURITY;

--
-- Name: rec2 r2_3; Type: POLICY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

CREATE POLICY r2_3 ON regress_rls_schema.rec2 USING ((a = ( SELECT rec1v.x
   FROM regress_rls_schema.rec1v
  WHERE (rec1v.y = rec2.b))));


--
-- Name: r2_4; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.r2_4 ENABLE ROW LEVEL SECURITY;

--
-- Name: r2_5; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.r2_5 ENABLE ROW LEVEL SECURITY;

--
-- Name: rec1; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.rec1 ENABLE ROW LEVEL SECURITY;

--
-- Name: rec2; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.rec2 ENABLE ROW LEVEL SECURITY;

--
-- Name: rls_tbl; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: postgres
--

ALTER TABLE regress_rls_schema.rls_tbl ENABLE ROW LEVEL SECURITY;

--
-- Name: rls_tbl_2; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.rls_tbl_2 ENABLE ROW LEVEL SECURITY;

--
-- Name: rls_tbl_3; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.rls_tbl_3 ENABLE ROW LEVEL SECURITY;

--
-- Name: s1; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.s1 ENABLE ROW LEVEL SECURITY;

--
-- Name: s2; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.s2 ENABLE ROW LEVEL SECURITY;

--
-- Name: t; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: postgres
--

ALTER TABLE regress_rls_schema.t ENABLE ROW LEVEL SECURITY;

--
-- Name: t1; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: postgres
--

ALTER TABLE regress_rls_schema.t1 ENABLE ROW LEVEL SECURITY;

--
-- Name: t1_2; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: postgres
--

ALTER TABLE regress_rls_schema.t1_2 ENABLE ROW LEVEL SECURITY;

--
-- Name: t1_3; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: postgres
--

ALTER TABLE regress_rls_schema.t1_3 ENABLE ROW LEVEL SECURITY;

--
-- Name: t2; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: postgres
--

ALTER TABLE regress_rls_schema.t2 ENABLE ROW LEVEL SECURITY;

--
-- Name: t2_3; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_bob
--

ALTER TABLE regress_rls_schema.t2_3 ENABLE ROW LEVEL SECURITY;

--
-- Name: x1; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.x1 ENABLE ROW LEVEL SECURITY;

--
-- Name: y1; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.y1 ENABLE ROW LEVEL SECURITY;

--
-- Name: y2; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.y2 ENABLE ROW LEVEL SECURITY;

--
-- Name: z1; Type: ROW SECURITY; Schema: regress_rls_schema; Owner: regress_rls_alice
--

ALTER TABLE regress_rls_schema.z1 ENABLE ROW LEVEL SECURITY;

--
-- Name: SCHEMA regress_rls_schema; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA regress_rls_schema TO PUBLIC;


--
-- Name: TABLE b1; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT ALL ON TABLE regress_rls_schema.b1 TO regress_rls_bob;


--
-- Name: TABLE bv1; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_bob
--

GRANT ALL ON TABLE regress_rls_schema.bv1 TO regress_rls_carol;


--
-- Name: TABLE category; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT ALL ON TABLE regress_rls_schema.category TO PUBLIC;


--
-- Name: TABLE document; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT ALL ON TABLE regress_rls_schema.document TO PUBLIC;


--
-- Name: TABLE part_document; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT ALL ON TABLE regress_rls_schema.part_document TO PUBLIC;


--
-- Name: TABLE part_document_fiction; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT ALL ON TABLE regress_rls_schema.part_document_fiction TO PUBLIC;


--
-- Name: TABLE part_document_nonfiction; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT ALL ON TABLE regress_rls_schema.part_document_nonfiction TO PUBLIC;


--
-- Name: TABLE part_document_satire; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT ALL ON TABLE regress_rls_schema.part_document_satire TO PUBLIC;


--
-- Name: TABLE r1; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT ALL ON TABLE regress_rls_schema.r1 TO regress_rls_bob;


--
-- Name: TABLE r2; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT ALL ON TABLE regress_rls_schema.r2 TO regress_rls_bob;


--
-- Name: TABLE y1; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT ALL ON TABLE regress_rls_schema.y1 TO regress_rls_bob;


--
-- Name: TABLE rls_view; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_bob
--

GRANT SELECT ON TABLE regress_rls_schema.rls_view TO regress_rls_alice;


--
-- Name: TABLE z1; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT SELECT ON TABLE regress_rls_schema.z1 TO regress_rls_group1;
GRANT SELECT ON TABLE regress_rls_schema.z1 TO regress_rls_group2;
GRANT SELECT ON TABLE regress_rls_schema.z1 TO regress_rls_bob;
GRANT SELECT ON TABLE regress_rls_schema.z1 TO regress_rls_carol;


--
-- Name: TABLE rls_view_2; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT SELECT ON TABLE regress_rls_schema.rls_view_2 TO regress_rls_bob;
GRANT SELECT ON TABLE regress_rls_schema.rls_view_2 TO regress_rls_carol;


--
-- Name: TABLE rls_view_3; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_bob
--

GRANT SELECT ON TABLE regress_rls_schema.rls_view_3 TO regress_rls_alice;
GRANT SELECT ON TABLE regress_rls_schema.rls_view_3 TO regress_rls_carol;


--
-- Name: TABLE rls_view_4; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT SELECT ON TABLE regress_rls_schema.rls_view_4 TO regress_rls_bob;


--
-- Name: TABLE s1; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT SELECT ON TABLE regress_rls_schema.s1 TO regress_rls_bob;


--
-- Name: TABLE s2; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT SELECT ON TABLE regress_rls_schema.s2 TO regress_rls_bob;


--
-- Name: TABLE t1; Type: ACL; Schema: regress_rls_schema; Owner: postgres
--

GRANT ALL ON TABLE regress_rls_schema.t1 TO PUBLIC;


--
-- Name: TABLE t1_2; Type: ACL; Schema: regress_rls_schema; Owner: postgres
--

GRANT SELECT ON TABLE regress_rls_schema.t1_2 TO regress_rls_bob;
GRANT SELECT ON TABLE regress_rls_schema.t1_2 TO regress_rls_carol;


--
-- Name: TABLE t1_3; Type: ACL; Schema: regress_rls_schema; Owner: postgres
--

GRANT ALL ON TABLE regress_rls_schema.t1_3 TO regress_rls_bob;


--
-- Name: TABLE t2_3; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_bob
--

GRANT ALL ON TABLE regress_rls_schema.t2_3 TO PUBLIC;


--
-- Name: TABLE t3_3; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT ALL ON TABLE regress_rls_schema.t3_3 TO PUBLIC;


--
-- Name: TABLE tbl1; Type: ACL; Schema: regress_rls_schema; Owner: postgres
--

GRANT SELECT ON TABLE regress_rls_schema.tbl1 TO regress_rls_eve;


--
-- Name: TABLE uaccount; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT SELECT ON TABLE regress_rls_schema.uaccount TO PUBLIC;


--
-- Name: TABLE x1; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT ALL ON TABLE regress_rls_schema.x1 TO PUBLIC;


--
-- Name: TABLE y2; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT ALL ON TABLE regress_rls_schema.y2 TO regress_rls_bob;


--
-- Name: TABLE z1_blacklist; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT SELECT ON TABLE regress_rls_schema.z1_blacklist TO regress_rls_carol;


--
-- Name: TABLE z2; Type: ACL; Schema: regress_rls_schema; Owner: regress_rls_alice
--

GRANT SELECT ON TABLE regress_rls_schema.z2 TO regress_rls_group1;
GRANT SELECT ON TABLE regress_rls_schema.z2 TO regress_rls_group2;
GRANT SELECT ON TABLE regress_rls_schema.z2 TO regress_rls_bob;
GRANT SELECT ON TABLE regress_rls_schema.z2 TO regress_rls_carol;


--
-- Name: log_table_alteration; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER log_table_alteration ON table_rewrite
   EXECUTE FUNCTION public.log_table_alteration();


ALTER EVENT TRIGGER log_table_alteration OWNER TO postgres;

--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

