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
--     SOFTWARE--
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
-- Name: humanresources; Type: SCHEMA; Schema: -; Owner: timchapman
--

CREATE SCHEMA humanresources;


ALTER SCHEMA humanresources OWNER TO timchapman;

--
-- Name: person; Type: SCHEMA; Schema: -; Owner: timchapman
--

CREATE SCHEMA person;


ALTER SCHEMA person OWNER TO timchapman;

--
-- Name: production; Type: SCHEMA; Schema: -; Owner: timchapman
--

CREATE SCHEMA production;


ALTER SCHEMA production OWNER TO timchapman;

--
-- Name: purchasing; Type: SCHEMA; Schema: -; Owner: timchapman
--

CREATE SCHEMA purchasing;


ALTER SCHEMA purchasing OWNER TO timchapman;

--
-- Name: sales; Type: SCHEMA; Schema: -; Owner: timchapman
--

CREATE SCHEMA sales;


ALTER SCHEMA sales OWNER TO timchapman;

--
-- Name: tablefunc; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;


--
-- Name: EXTENSION tablefunc; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION tablefunc IS 'functions that manipulate whole tables, including crosstab';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: AccountNumber; Type: DOMAIN; Schema: public; Owner: timchapman
--

CREATE DOMAIN public."AccountNumber" AS character varying(15);


ALTER DOMAIN public."AccountNumber" OWNER TO timchapman;

--
-- Name: Flag; Type: DOMAIN; Schema: public; Owner: timchapman
--

CREATE DOMAIN public."Flag" AS boolean NOT NULL;


ALTER DOMAIN public."Flag" OWNER TO timchapman;

--
-- Name: Name; Type: DOMAIN; Schema: public; Owner: timchapman
--

CREATE DOMAIN public."Name" AS character varying(50);


ALTER DOMAIN public."Name" OWNER TO timchapman;

--
-- Name: NameStyle; Type: DOMAIN; Schema: public; Owner: timchapman
--

CREATE DOMAIN public."NameStyle" AS boolean NOT NULL;


ALTER DOMAIN public."NameStyle" OWNER TO timchapman;

--
-- Name: OrderNumber; Type: DOMAIN; Schema: public; Owner: timchapman
--

CREATE DOMAIN public."OrderNumber" AS character varying(25);


ALTER DOMAIN public."OrderNumber" OWNER TO timchapman;

--
-- Name: Phone; Type: DOMAIN; Schema: public; Owner: timchapman
--

CREATE DOMAIN public."Phone" AS character varying(25);


ALTER DOMAIN public."Phone" OWNER TO timchapman;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: department; Type: TABLE; Schema: humanresources; Owner: timchapman
--

CREATE TABLE humanresources.department (
    departmentid integer NOT NULL,
    name public."Name" NOT NULL,
    groupname public."Name" NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE humanresources.department OWNER TO timchapman;

--
-- Name: department_departmentid_seq; Type: SEQUENCE; Schema: humanresources; Owner: timchapman
--

CREATE SEQUENCE humanresources.department_departmentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE humanresources.department_departmentid_seq OWNER TO timchapman;

--
-- Name: department_departmentid_seq; Type: SEQUENCE OWNED BY; Schema: humanresources; Owner: timchapman
--

ALTER SEQUENCE humanresources.department_departmentid_seq OWNED BY humanresources.department.departmentid;


--
-- Name: employee; Type: TABLE; Schema: humanresources; Owner: timchapman
--

CREATE TABLE humanresources.employee (
    businessentityid integer NOT NULL,
    nationalidnumber character varying(15) NOT NULL,
    loginid character varying(256) NOT NULL,
    organizationlevel integer,
    jobtitle character varying(50) NOT NULL,
    birthdate date NOT NULL,
    maritalstatus character(1) NOT NULL,
    gender character(1) NOT NULL,
    hiredate date NOT NULL,
    salariedflag public."Flag" DEFAULT true NOT NULL,
    vacationhours smallint DEFAULT 0 NOT NULL,
    sickleavehours smallint DEFAULT 0 NOT NULL,
    currentflag public."Flag" DEFAULT true NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    organizationnode character varying DEFAULT '/'::character varying,
    CONSTRAINT "CK_Employee_BirthDate" CHECK (((birthdate >= '1930-01-01'::date) AND (birthdate <= (now() - '18 years'::interval)))),
    CONSTRAINT "CK_Employee_Gender" CHECK ((upper((gender)::text) = ANY (ARRAY['M'::text, 'F'::text]))),
    CONSTRAINT "CK_Employee_HireDate" CHECK (((hiredate >= '1996-07-01'::date) AND (hiredate <= (now() + '1 day'::interval)))),
    CONSTRAINT "CK_Employee_MaritalStatus" CHECK ((upper((maritalstatus)::text) = ANY (ARRAY['M'::text, 'S'::text]))),
    CONSTRAINT "CK_Employee_SickLeaveHours" CHECK (((sickleavehours >= 0) AND (sickleavehours <= 120))),
    CONSTRAINT "CK_Employee_VacationHours" CHECK (((vacationhours >= '-40'::integer) AND (vacationhours <= 240)))
);


ALTER TABLE humanresources.employee OWNER TO timchapman;

--
-- Name: employeedepartmenthistory; Type: TABLE; Schema: humanresources; Owner: timchapman
--

CREATE TABLE humanresources.employeedepartmenthistory (
    businessentityid integer NOT NULL,
    departmentid smallint NOT NULL,
    shiftid smallint NOT NULL,
    startdate date NOT NULL,
    enddate date,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_EmployeeDepartmentHistory_EndDate" CHECK (((enddate >= startdate) OR (enddate IS NULL)))
);


ALTER TABLE humanresources.employeedepartmenthistory OWNER TO timchapman;

--
-- Name: employeepayhistory; Type: TABLE; Schema: humanresources; Owner: timchapman
--

CREATE TABLE humanresources.employeepayhistory (
    businessentityid integer NOT NULL,
    ratechangedate timestamp without time zone NOT NULL,
    rate numeric NOT NULL,
    payfrequency smallint NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_EmployeePayHistory_PayFrequency" CHECK ((payfrequency = ANY (ARRAY[1, 2]))),
    CONSTRAINT "CK_EmployeePayHistory_Rate" CHECK (((rate >= 6.50) AND (rate <= 200.00)))
);


ALTER TABLE humanresources.employeepayhistory OWNER TO timchapman;

--
-- Name: jobcandidate; Type: TABLE; Schema: humanresources; Owner: timchapman
--

CREATE TABLE humanresources.jobcandidate (
    jobcandidateid integer NOT NULL,
    businessentityid integer,
    resume xml,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE humanresources.jobcandidate OWNER TO timchapman;

--
-- Name: jobcandidate_jobcandidateid_seq; Type: SEQUENCE; Schema: humanresources; Owner: timchapman
--

CREATE SEQUENCE humanresources.jobcandidate_jobcandidateid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE humanresources.jobcandidate_jobcandidateid_seq OWNER TO timchapman;

--
-- Name: jobcandidate_jobcandidateid_seq; Type: SEQUENCE OWNED BY; Schema: humanresources; Owner: timchapman
--

ALTER SEQUENCE humanresources.jobcandidate_jobcandidateid_seq OWNED BY humanresources.jobcandidate.jobcandidateid;


--
-- Name: shift; Type: TABLE; Schema: humanresources; Owner: timchapman
--

CREATE TABLE humanresources.shift (
    shiftid integer NOT NULL,
    name public."Name" NOT NULL,
    starttime time without time zone NOT NULL,
    endtime time without time zone NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE humanresources.shift OWNER TO timchapman;

--
-- Name: shift_shiftid_seq; Type: SEQUENCE; Schema: humanresources; Owner: timchapman
--

CREATE SEQUENCE humanresources.shift_shiftid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE humanresources.shift_shiftid_seq OWNER TO timchapman;

--
-- Name: shift_shiftid_seq; Type: SEQUENCE OWNED BY; Schema: humanresources; Owner: timchapman
--

ALTER SEQUENCE humanresources.shift_shiftid_seq OWNED BY humanresources.shift.shiftid;


--
-- Name: address; Type: TABLE; Schema: person; Owner: timchapman
--

CREATE TABLE person.address (
    addressid integer NOT NULL,
    addressline1 character varying(60) NOT NULL,
    addressline2 character varying(60),
    city character varying(30) NOT NULL,
    stateprovinceid integer NOT NULL,
    postalcode character varying(15) NOT NULL,
    spatiallocation character varying(44),
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.address OWNER TO timchapman;

--
-- Name: businessentityaddress; Type: TABLE; Schema: person; Owner: timchapman
--

CREATE TABLE person.businessentityaddress (
    businessentityid integer NOT NULL,
    addressid integer NOT NULL,
    addresstypeid integer NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.businessentityaddress OWNER TO timchapman;

--
-- Name: countryregion; Type: TABLE; Schema: person; Owner: timchapman
--

CREATE TABLE person.countryregion (
    countryregioncode character varying(3) NOT NULL,
    name public."Name" NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.countryregion OWNER TO timchapman;

--
-- Name: emailaddress; Type: TABLE; Schema: person; Owner: timchapman
--

CREATE TABLE person.emailaddress (
    businessentityid integer NOT NULL,
    emailaddressid integer NOT NULL,
    emailaddress character varying(50),
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.emailaddress OWNER TO timchapman;

--
-- Name: person; Type: TABLE; Schema: person; Owner: timchapman
--

CREATE TABLE person.person (
    businessentityid integer NOT NULL,
    persontype character(2) NOT NULL,
    namestyle public."NameStyle" DEFAULT false NOT NULL,
    title character varying(8),
    firstname public."Name" NOT NULL,
    middlename public."Name",
    lastname public."Name" NOT NULL,
    suffix character varying(10),
    emailpromotion integer DEFAULT 0 NOT NULL,
    additionalcontactinfo xml,
    demographics xml,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_Person_EmailPromotion" CHECK (((emailpromotion >= 0) AND (emailpromotion <= 2))),
    CONSTRAINT "CK_Person_PersonType" CHECK (((persontype IS NULL) OR (upper((persontype)::text) = ANY (ARRAY['SC'::text, 'VC'::text, 'IN'::text, 'EM'::text, 'SP'::text, 'GC'::text]))))
);


ALTER TABLE person.person OWNER TO timchapman;

--
-- Name: personphone; Type: TABLE; Schema: person; Owner: timchapman
--

CREATE TABLE person.personphone (
    businessentityid integer NOT NULL,
    phonenumber public."Phone" NOT NULL,
    phonenumbertypeid integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.personphone OWNER TO timchapman;

--
-- Name: phonenumbertype; Type: TABLE; Schema: person; Owner: timchapman
--

CREATE TABLE person.phonenumbertype (
    phonenumbertypeid integer NOT NULL,
    name public."Name" NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.phonenumbertype OWNER TO timchapman;

--
-- Name: stateprovince; Type: TABLE; Schema: person; Owner: timchapman
--

CREATE TABLE person.stateprovince (
    stateprovinceid integer NOT NULL,
    stateprovincecode character(3) NOT NULL,
    countryregioncode character varying(3) NOT NULL,
    isonlystateprovinceflag public."Flag" DEFAULT true NOT NULL,
    name public."Name" NOT NULL,
    territoryid integer NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.stateprovince OWNER TO timchapman;

--
-- Name: vemployee; Type: VIEW; Schema: humanresources; Owner: timchapman
--

CREATE VIEW humanresources.vemployee AS
 SELECT e.businessentityid,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    e.jobtitle,
    pp.phonenumber,
    pnt.name AS phonenumbertype,
    ea.emailaddress,
    p.emailpromotion,
    a.addressline1,
    a.addressline2,
    a.city,
    sp.name AS stateprovincename,
    a.postalcode,
    cr.name AS countryregionname,
    p.additionalcontactinfo
   FROM ((((((((humanresources.employee e
     JOIN person.person p ON ((p.businessentityid = e.businessentityid)))
     JOIN person.businessentityaddress bea ON ((bea.businessentityid = e.businessentityid)))
     JOIN person.address a ON ((a.addressid = bea.addressid)))
     JOIN person.stateprovince sp ON ((sp.stateprovinceid = a.stateprovinceid)))
     JOIN person.countryregion cr ON (((cr.countryregioncode)::text = (sp.countryregioncode)::text)))
     LEFT JOIN person.personphone pp ON ((pp.businessentityid = p.businessentityid)))
     LEFT JOIN person.phonenumbertype pnt ON ((pp.phonenumbertypeid = pnt.phonenumbertypeid)))
     LEFT JOIN person.emailaddress ea ON ((p.businessentityid = ea.businessentityid)));


ALTER TABLE humanresources.vemployee OWNER TO timchapman;

--
-- Name: vemployeedepartment; Type: VIEW; Schema: humanresources; Owner: timchapman
--

CREATE VIEW humanresources.vemployeedepartment AS
 SELECT e.businessentityid,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    e.jobtitle,
    d.name AS department,
    d.groupname,
    edh.startdate
   FROM (((humanresources.employee e
     JOIN person.person p ON ((p.businessentityid = e.businessentityid)))
     JOIN humanresources.employeedepartmenthistory edh ON ((e.businessentityid = edh.businessentityid)))
     JOIN humanresources.department d ON ((edh.departmentid = d.departmentid)))
  WHERE (edh.enddate IS NULL);


ALTER TABLE humanresources.vemployeedepartment OWNER TO timchapman;

--
-- Name: vemployeedepartmenthistory; Type: VIEW; Schema: humanresources; Owner: timchapman
--

CREATE VIEW humanresources.vemployeedepartmenthistory AS
 SELECT e.businessentityid,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    s.name AS shift,
    d.name AS department,
    d.groupname,
    edh.startdate,
    edh.enddate
   FROM ((((humanresources.employee e
     JOIN person.person p ON ((p.businessentityid = e.businessentityid)))
     JOIN humanresources.employeedepartmenthistory edh ON ((e.businessentityid = edh.businessentityid)))
     JOIN humanresources.department d ON ((edh.departmentid = d.departmentid)))
     JOIN humanresources.shift s ON ((s.shiftid = edh.shiftid)));


ALTER TABLE humanresources.vemployeedepartmenthistory OWNER TO timchapman;

--
-- Name: vjobcandidate; Type: VIEW; Schema: humanresources; Owner: timchapman
--

CREATE VIEW humanresources.vjobcandidate AS
 SELECT jobcandidate.jobcandidateid,
    jobcandidate.businessentityid,
    ((xpath('/n:Resume/n:Name/n:Name.Prefix/text()'::text, jobcandidate.resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[]))[1])::character varying(30) AS "Name.Prefix",
    ((xpath('/n:Resume/n:Name/n:Name.First/text()'::text, jobcandidate.resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[]))[1])::character varying(30) AS "Name.First",
    ((xpath('/n:Resume/n:Name/n:Name.Middle/text()'::text, jobcandidate.resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[]))[1])::character varying(30) AS "Name.Middle",
    ((xpath('/n:Resume/n:Name/n:Name.Last/text()'::text, jobcandidate.resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[]))[1])::character varying(30) AS "Name.Last",
    ((xpath('/n:Resume/n:Name/n:Name.Suffix/text()'::text, jobcandidate.resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[]))[1])::character varying(30) AS "Name.Suffix",
    ((xpath('/n:Resume/n:Skills/text()'::text, jobcandidate.resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[]))[1])::character varying AS "Skills",
    ((xpath('n:Address/n:Addr.Type/text()'::text, jobcandidate.resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[]))[1])::character varying(30) AS "Addr.Type",
    ((xpath('n:Address/n:Addr.Location/n:Location/n:Loc.CountryRegion/text()'::text, jobcandidate.resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[]))[1])::character varying(100) AS "Addr.Loc.CountryRegion",
    ((xpath('n:Address/n:Addr.Location/n:Location/n:Loc.State/text()'::text, jobcandidate.resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[]))[1])::character varying(100) AS "Addr.Loc.State",
    ((xpath('n:Address/n:Addr.Location/n:Location/n:Loc.City/text()'::text, jobcandidate.resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[]))[1])::character varying(100) AS "Addr.Loc.City",
    ((xpath('n:Address/n:Addr.PostalCode/text()'::text, jobcandidate.resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[]))[1])::character varying(20) AS "Addr.PostalCode",
    ((xpath('/n:Resume/n:EMail/text()'::text, jobcandidate.resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[]))[1])::character varying AS "EMail",
    ((xpath('/n:Resume/n:WebSite/text()'::text, jobcandidate.resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[]))[1])::character varying AS "WebSite",
    jobcandidate.modifieddate
   FROM humanresources.jobcandidate;


ALTER TABLE humanresources.vjobcandidate OWNER TO timchapman;

--
-- Name: vjobcandidateeducation; Type: VIEW; Schema: humanresources; Owner: timchapman
--

CREATE VIEW humanresources.vjobcandidateeducation AS
 SELECT jc.jobcandidateid,
    ((xpath('/root/ns:Education/ns:Edu.Level/text()'::text, jc.doc, '{{ns,http://adventureworks.com}}'::text[]))[1])::character varying(50) AS "Edu.Level",
    (((xpath('/root/ns:Education/ns:Edu.StartDate/text()'::text, jc.doc, '{{ns,http://adventureworks.com}}'::text[]))[1])::character varying(20))::date AS "Edu.StartDate",
    (((xpath('/root/ns:Education/ns:Edu.EndDate/text()'::text, jc.doc, '{{ns,http://adventureworks.com}}'::text[]))[1])::character varying(20))::date AS "Edu.EndDate",
    ((xpath('/root/ns:Education/ns:Edu.Degree/text()'::text, jc.doc, '{{ns,http://adventureworks.com}}'::text[]))[1])::character varying(50) AS "Edu.Degree",
    ((xpath('/root/ns:Education/ns:Edu.Major/text()'::text, jc.doc, '{{ns,http://adventureworks.com}}'::text[]))[1])::character varying(50) AS "Edu.Major",
    ((xpath('/root/ns:Education/ns:Edu.Minor/text()'::text, jc.doc, '{{ns,http://adventureworks.com}}'::text[]))[1])::character varying(50) AS "Edu.Minor",
    ((xpath('/root/ns:Education/ns:Edu.GPA/text()'::text, jc.doc, '{{ns,http://adventureworks.com}}'::text[]))[1])::character varying(5) AS "Edu.GPA",
    ((xpath('/root/ns:Education/ns:Edu.GPAScale/text()'::text, jc.doc, '{{ns,http://adventureworks.com}}'::text[]))[1])::character varying(5) AS "Edu.GPAScale",
    ((xpath('/root/ns:Education/ns:Edu.School/text()'::text, jc.doc, '{{ns,http://adventureworks.com}}'::text[]))[1])::character varying(100) AS "Edu.School",
    ((xpath('/root/ns:Education/ns:Edu.Location/ns:Location/ns:Loc.CountryRegion/text()'::text, jc.doc, '{{ns,http://adventureworks.com}}'::text[]))[1])::character varying(100) AS "Edu.Loc.CountryRegion",
    ((xpath('/root/ns:Education/ns:Edu.Location/ns:Location/ns:Loc.State/text()'::text, jc.doc, '{{ns,http://adventureworks.com}}'::text[]))[1])::character varying(100) AS "Edu.Loc.State",
    ((xpath('/root/ns:Education/ns:Edu.Location/ns:Location/ns:Loc.City/text()'::text, jc.doc, '{{ns,http://adventureworks.com}}'::text[]))[1])::character varying(100) AS "Edu.Loc.City"
   FROM ( SELECT unnesting.jobcandidateid,
            ((('<root xmlns:ns="http://adventureworks.com">'::text || ((unnesting.education)::character varying)::text) || '</root>'::text))::xml AS doc
           FROM ( SELECT jobcandidate.jobcandidateid,
                    unnest(xpath('/ns:Resume/ns:Education'::text, jobcandidate.resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[])) AS education
                   FROM humanresources.jobcandidate) unnesting) jc;


ALTER TABLE humanresources.vjobcandidateeducation OWNER TO timchapman;

--
-- Name: vjobcandidateemployment; Type: VIEW; Schema: humanresources; Owner: timchapman
--

CREATE VIEW humanresources.vjobcandidateemployment AS
 SELECT jobcandidate.jobcandidateid,
    ((unnest(xpath('/ns:Resume/ns:Employment/ns:Emp.StartDate/text()'::text, jobcandidate.resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[])))::character varying(20))::date AS "Emp.StartDate",
    ((unnest(xpath('/ns:Resume/ns:Employment/ns:Emp.EndDate/text()'::text, jobcandidate.resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[])))::character varying(20))::date AS "Emp.EndDate",
    (unnest(xpath('/ns:Resume/ns:Employment/ns:Emp.OrgName/text()'::text, jobcandidate.resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[])))::character varying(100) AS "Emp.OrgName",
    (unnest(xpath('/ns:Resume/ns:Employment/ns:Emp.JobTitle/text()'::text, jobcandidate.resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[])))::character varying(100) AS "Emp.JobTitle",
    (unnest(xpath('/ns:Resume/ns:Employment/ns:Emp.Responsibility/text()'::text, jobcandidate.resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[])))::character varying AS "Emp.Responsibility",
    (unnest(xpath('/ns:Resume/ns:Employment/ns:Emp.FunctionCategory/text()'::text, jobcandidate.resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[])))::character varying AS "Emp.FunctionCategory",
    (unnest(xpath('/ns:Resume/ns:Employment/ns:Emp.IndustryCategory/text()'::text, jobcandidate.resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[])))::character varying AS "Emp.IndustryCategory",
    (unnest(xpath('/ns:Resume/ns:Employment/ns:Emp.Location/ns:Location/ns:Loc.CountryRegion/text()'::text, jobcandidate.resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[])))::character varying AS "Emp.Loc.CountryRegion",
    (unnest(xpath('/ns:Resume/ns:Employment/ns:Emp.Location/ns:Location/ns:Loc.State/text()'::text, jobcandidate.resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[])))::character varying AS "Emp.Loc.State",
    (unnest(xpath('/ns:Resume/ns:Employment/ns:Emp.Location/ns:Location/ns:Loc.City/text()'::text, jobcandidate.resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'::text[])))::character varying AS "Emp.Loc.City"
   FROM humanresources.jobcandidate;


ALTER TABLE humanresources.vjobcandidateemployment OWNER TO timchapman;

--
-- Name: address_addressid_seq; Type: SEQUENCE; Schema: person; Owner: timchapman
--

CREATE SEQUENCE person.address_addressid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person.address_addressid_seq OWNER TO timchapman;

--
-- Name: address_addressid_seq; Type: SEQUENCE OWNED BY; Schema: person; Owner: timchapman
--

ALTER SEQUENCE person.address_addressid_seq OWNED BY person.address.addressid;


--
-- Name: addresstype; Type: TABLE; Schema: person; Owner: timchapman
--

CREATE TABLE person.addresstype (
    addresstypeid integer NOT NULL,
    name public."Name" NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.addresstype OWNER TO timchapman;

--
-- Name: addresstype_addresstypeid_seq; Type: SEQUENCE; Schema: person; Owner: timchapman
--

CREATE SEQUENCE person.addresstype_addresstypeid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person.addresstype_addresstypeid_seq OWNER TO timchapman;

--
-- Name: addresstype_addresstypeid_seq; Type: SEQUENCE OWNED BY; Schema: person; Owner: timchapman
--

ALTER SEQUENCE person.addresstype_addresstypeid_seq OWNED BY person.addresstype.addresstypeid;


--
-- Name: businessentity; Type: TABLE; Schema: person; Owner: timchapman
--

CREATE TABLE person.businessentity (
    businessentityid integer NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.businessentity OWNER TO timchapman;

--
-- Name: businessentity_businessentityid_seq; Type: SEQUENCE; Schema: person; Owner: timchapman
--

CREATE SEQUENCE person.businessentity_businessentityid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person.businessentity_businessentityid_seq OWNER TO timchapman;

--
-- Name: businessentity_businessentityid_seq; Type: SEQUENCE OWNED BY; Schema: person; Owner: timchapman
--

ALTER SEQUENCE person.businessentity_businessentityid_seq OWNED BY person.businessentity.businessentityid;


--
-- Name: businessentitycontact; Type: TABLE; Schema: person; Owner: timchapman
--

CREATE TABLE person.businessentitycontact (
    businessentityid integer NOT NULL,
    personid integer NOT NULL,
    contacttypeid integer NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.businessentitycontact OWNER TO timchapman;

--
-- Name: contacttype; Type: TABLE; Schema: person; Owner: timchapman
--

CREATE TABLE person.contacttype (
    contacttypeid integer NOT NULL,
    name public."Name" NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.contacttype OWNER TO timchapman;

--
-- Name: contacttype_contacttypeid_seq; Type: SEQUENCE; Schema: person; Owner: timchapman
--

CREATE SEQUENCE person.contacttype_contacttypeid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person.contacttype_contacttypeid_seq OWNER TO timchapman;

--
-- Name: contacttype_contacttypeid_seq; Type: SEQUENCE OWNED BY; Schema: person; Owner: timchapman
--

ALTER SEQUENCE person.contacttype_contacttypeid_seq OWNED BY person.contacttype.contacttypeid;


--
-- Name: emailaddress_emailaddressid_seq; Type: SEQUENCE; Schema: person; Owner: timchapman
--

CREATE SEQUENCE person.emailaddress_emailaddressid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person.emailaddress_emailaddressid_seq OWNER TO timchapman;

--
-- Name: emailaddress_emailaddressid_seq; Type: SEQUENCE OWNED BY; Schema: person; Owner: timchapman
--

ALTER SEQUENCE person.emailaddress_emailaddressid_seq OWNED BY person.emailaddress.emailaddressid;


--
-- Name: password; Type: TABLE; Schema: person; Owner: timchapman
--

CREATE TABLE person.password (
    businessentityid integer NOT NULL,
    passwordhash character varying(128) NOT NULL,
    passwordsalt character varying(10) NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.password OWNER TO timchapman;

--
-- Name: phonenumbertype_phonenumbertypeid_seq; Type: SEQUENCE; Schema: person; Owner: timchapman
--

CREATE SEQUENCE person.phonenumbertype_phonenumbertypeid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person.phonenumbertype_phonenumbertypeid_seq OWNER TO timchapman;

--
-- Name: phonenumbertype_phonenumbertypeid_seq; Type: SEQUENCE OWNED BY; Schema: person; Owner: timchapman
--

ALTER SEQUENCE person.phonenumbertype_phonenumbertypeid_seq OWNED BY person.phonenumbertype.phonenumbertypeid;


--
-- Name: stateprovince_stateprovinceid_seq; Type: SEQUENCE; Schema: person; Owner: timchapman
--

CREATE SEQUENCE person.stateprovince_stateprovinceid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person.stateprovince_stateprovinceid_seq OWNER TO timchapman;

--
-- Name: stateprovince_stateprovinceid_seq; Type: SEQUENCE OWNED BY; Schema: person; Owner: timchapman
--

ALTER SEQUENCE person.stateprovince_stateprovinceid_seq OWNED BY person.stateprovince.stateprovinceid;


--
-- Name: vadditionalcontactinfo; Type: VIEW; Schema: person; Owner: timchapman
--

CREATE VIEW person.vadditionalcontactinfo AS
 SELECT p.businessentityid,
    p.firstname,
    p.middlename,
    p.lastname,
    (xpath('(act:telephoneNumber)[1]/act:number/text()'::text, additional.node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'::text[]))[1] AS telephonenumber,
    btrim((((xpath('(act:telephoneNumber)[1]/act:SpecialInstructions/text()'::text, additional.node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'::text[]))[1])::character varying)::text) AS telephonespecialinstructions,
    (xpath('(act:homePostalAddress)[1]/act:Street/text()'::text, additional.node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'::text[]))[1] AS street,
    (xpath('(act:homePostalAddress)[1]/act:City/text()'::text, additional.node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'::text[]))[1] AS city,
    (xpath('(act:homePostalAddress)[1]/act:StateProvince/text()'::text, additional.node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'::text[]))[1] AS stateprovince,
    (xpath('(act:homePostalAddress)[1]/act:PostalCode/text()'::text, additional.node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'::text[]))[1] AS postalcode,
    (xpath('(act:homePostalAddress)[1]/act:CountryRegion/text()'::text, additional.node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'::text[]))[1] AS countryregion,
    (xpath('(act:homePostalAddress)[1]/act:SpecialInstructions/text()'::text, additional.node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'::text[]))[1] AS homeaddressspecialinstructions,
    (xpath('(act:eMail)[1]/act:eMailAddress/text()'::text, additional.node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'::text[]))[1] AS emailaddress,
    btrim((((xpath('(act:eMail)[1]/act:SpecialInstructions/text()'::text, additional.node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'::text[]))[1])::character varying)::text) AS emailspecialinstructions,
    (xpath('((act:eMail)[1]/act:SpecialInstructions/act:telephoneNumber)[1]/act:number/text()'::text, additional.node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'::text[]))[1] AS emailtelephonenumber,
    p.rowguid,
    p.modifieddate
   FROM (person.person p
     LEFT JOIN ( SELECT person.businessentityid,
            unnest(xpath('/ci:AdditionalContactInfo'::text, person.additionalcontactinfo, '{{ci,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo}}'::text[])) AS node
           FROM person.person
          WHERE (person.additionalcontactinfo IS NOT NULL)) additional ON ((p.businessentityid = additional.businessentityid)));


ALTER TABLE person.vadditionalcontactinfo OWNER TO timchapman;

--
-- Name: vstateprovincecountryregion; Type: MATERIALIZED VIEW; Schema: person; Owner: timchapman
--

CREATE MATERIALIZED VIEW person.vstateprovincecountryregion AS
 SELECT sp.stateprovinceid,
    sp.stateprovincecode,
    sp.isonlystateprovinceflag,
    sp.name AS stateprovincename,
    sp.territoryid,
    cr.countryregioncode,
    cr.name AS countryregionname
   FROM (person.stateprovince sp
     JOIN person.countryregion cr ON (((sp.countryregioncode)::text = (cr.countryregioncode)::text)))
  WITH NO DATA;


ALTER TABLE person.vstateprovincecountryregion OWNER TO timchapman;

--
-- Name: billofmaterials; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.billofmaterials (
    billofmaterialsid integer NOT NULL,
    productassemblyid integer,
    componentid integer NOT NULL,
    startdate timestamp without time zone DEFAULT now() NOT NULL,
    enddate timestamp without time zone,
    unitmeasurecode character(3) NOT NULL,
    bomlevel smallint NOT NULL,
    perassemblyqty numeric(8,2) DEFAULT 1.00 NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_BillOfMaterials_BOMLevel" CHECK ((((productassemblyid IS NULL) AND (bomlevel = 0) AND (perassemblyqty = 1.00)) OR ((productassemblyid IS NOT NULL) AND (bomlevel >= 1)))),
    CONSTRAINT "CK_BillOfMaterials_EndDate" CHECK (((enddate > startdate) OR (enddate IS NULL))),
    CONSTRAINT "CK_BillOfMaterials_PerAssemblyQty" CHECK ((perassemblyqty >= 1.00)),
    CONSTRAINT "CK_BillOfMaterials_ProductAssemblyID" CHECK ((productassemblyid <> componentid))
);


ALTER TABLE production.billofmaterials OWNER TO timchapman;

--
-- Name: billofmaterials_billofmaterialsid_seq; Type: SEQUENCE; Schema: production; Owner: timchapman
--

CREATE SEQUENCE production.billofmaterials_billofmaterialsid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.billofmaterials_billofmaterialsid_seq OWNER TO timchapman;

--
-- Name: billofmaterials_billofmaterialsid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: timchapman
--

ALTER SEQUENCE production.billofmaterials_billofmaterialsid_seq OWNED BY production.billofmaterials.billofmaterialsid;


--
-- Name: culture; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.culture (
    cultureid character(6) NOT NULL,
    name public."Name" NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.culture OWNER TO timchapman;

--
-- Name: document; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.document (
    documentlevel integer,
    title character varying(50) NOT NULL,
    owner integer NOT NULL,
    folderflag public."Flag" DEFAULT false NOT NULL,
    filename character varying(400) NOT NULL,
    fileextension character varying(8),
    revision character(5) NOT NULL,
    changenumber integer DEFAULT 0 NOT NULL,
    status smallint NOT NULL,
    documentsummary text,
    document bytea,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    documentnode character varying DEFAULT '/'::character varying NOT NULL,
    CONSTRAINT "CK_Document_Status" CHECK (((status >= 1) AND (status <= 3)))
);


ALTER TABLE production.document OWNER TO timchapman;

--
-- Name: illustration; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.illustration (
    illustrationid integer NOT NULL,
    diagram xml,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.illustration OWNER TO timchapman;

--
-- Name: illustration_illustrationid_seq; Type: SEQUENCE; Schema: production; Owner: timchapman
--

CREATE SEQUENCE production.illustration_illustrationid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.illustration_illustrationid_seq OWNER TO timchapman;

--
-- Name: illustration_illustrationid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: timchapman
--

ALTER SEQUENCE production.illustration_illustrationid_seq OWNED BY production.illustration.illustrationid;


--
-- Name: location; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.location (
    locationid integer NOT NULL,
    name public."Name" NOT NULL,
    costrate numeric DEFAULT 0.00 NOT NULL,
    availability numeric(8,2) DEFAULT 0.00 NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_Location_Availability" CHECK ((availability >= 0.00)),
    CONSTRAINT "CK_Location_CostRate" CHECK ((costrate >= 0.00))
);


ALTER TABLE production.location OWNER TO timchapman;

--
-- Name: location_locationid_seq; Type: SEQUENCE; Schema: production; Owner: timchapman
--

CREATE SEQUENCE production.location_locationid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.location_locationid_seq OWNER TO timchapman;

--
-- Name: location_locationid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: timchapman
--

ALTER SEQUENCE production.location_locationid_seq OWNED BY production.location.locationid;


--
-- Name: product; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.product (
    productid integer NOT NULL,
    name public."Name" NOT NULL,
    productnumber character varying(25) NOT NULL,
    makeflag public."Flag" DEFAULT true NOT NULL,
    finishedgoodsflag public."Flag" DEFAULT true NOT NULL,
    color character varying(15),
    safetystocklevel smallint NOT NULL,
    reorderpoint smallint NOT NULL,
    standardcost numeric NOT NULL,
    listprice numeric NOT NULL,
    size character varying(5),
    sizeunitmeasurecode character(3),
    weightunitmeasurecode character(3),
    weight numeric(8,2),
    daystomanufacture integer NOT NULL,
    productline character(2),
    class character(2),
    style character(2),
    productsubcategoryid integer,
    productmodelid integer,
    sellstartdate timestamp without time zone NOT NULL,
    sellenddate timestamp without time zone,
    discontinueddate timestamp without time zone,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_Product_Class" CHECK (((upper((class)::text) = ANY (ARRAY['L'::text, 'M'::text, 'H'::text])) OR (class IS NULL))),
    CONSTRAINT "CK_Product_DaysToManufacture" CHECK ((daystomanufacture >= 0)),
    CONSTRAINT "CK_Product_ListPrice" CHECK ((listprice >= 0.00)),
    CONSTRAINT "CK_Product_ProductLine" CHECK (((upper((productline)::text) = ANY (ARRAY['S'::text, 'T'::text, 'M'::text, 'R'::text])) OR (productline IS NULL))),
    CONSTRAINT "CK_Product_ReorderPoint" CHECK ((reorderpoint > 0)),
    CONSTRAINT "CK_Product_SafetyStockLevel" CHECK ((safetystocklevel > 0)),
    CONSTRAINT "CK_Product_SellEndDate" CHECK (((sellenddate >= sellstartdate) OR (sellenddate IS NULL))),
    CONSTRAINT "CK_Product_StandardCost" CHECK ((standardcost >= 0.00)),
    CONSTRAINT "CK_Product_Style" CHECK (((upper((style)::text) = ANY (ARRAY['W'::text, 'M'::text, 'U'::text])) OR (style IS NULL))),
    CONSTRAINT "CK_Product_Weight" CHECK ((weight > 0.00))
);


ALTER TABLE production.product OWNER TO timchapman;

--
-- Name: product_productid_seq; Type: SEQUENCE; Schema: production; Owner: timchapman
--

CREATE SEQUENCE production.product_productid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.product_productid_seq OWNER TO timchapman;

--
-- Name: product_productid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: timchapman
--

ALTER SEQUENCE production.product_productid_seq OWNED BY production.product.productid;


--
-- Name: productcategory; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.productcategory (
    productcategoryid integer NOT NULL,
    name public."Name" NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productcategory OWNER TO timchapman;

--
-- Name: productcategory_productcategoryid_seq; Type: SEQUENCE; Schema: production; Owner: timchapman
--

CREATE SEQUENCE production.productcategory_productcategoryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.productcategory_productcategoryid_seq OWNER TO timchapman;

--
-- Name: productcategory_productcategoryid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: timchapman
--

ALTER SEQUENCE production.productcategory_productcategoryid_seq OWNED BY production.productcategory.productcategoryid;


--
-- Name: productcosthistory; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.productcosthistory (
    productid integer NOT NULL,
    startdate timestamp without time zone NOT NULL,
    enddate timestamp without time zone,
    standardcost numeric NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_ProductCostHistory_EndDate" CHECK (((enddate >= startdate) OR (enddate IS NULL))),
    CONSTRAINT "CK_ProductCostHistory_StandardCost" CHECK ((standardcost >= 0.00))
);


ALTER TABLE production.productcosthistory OWNER TO timchapman;

--
-- Name: productdescription; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.productdescription (
    productdescriptionid integer NOT NULL,
    description character varying(400) NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productdescription OWNER TO timchapman;

--
-- Name: productdescription_productdescriptionid_seq; Type: SEQUENCE; Schema: production; Owner: timchapman
--

CREATE SEQUENCE production.productdescription_productdescriptionid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.productdescription_productdescriptionid_seq OWNER TO timchapman;

--
-- Name: productdescription_productdescriptionid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: timchapman
--

ALTER SEQUENCE production.productdescription_productdescriptionid_seq OWNED BY production.productdescription.productdescriptionid;


--
-- Name: productdocument; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.productdocument (
    productid integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    documentnode character varying DEFAULT '/'::character varying NOT NULL
);


ALTER TABLE production.productdocument OWNER TO timchapman;

--
-- Name: productinventory; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.productinventory (
    productid integer NOT NULL,
    locationid smallint NOT NULL,
    shelf character varying(10) NOT NULL,
    bin smallint NOT NULL,
    quantity smallint DEFAULT 0 NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_ProductInventory_Bin" CHECK (((bin >= 0) AND (bin <= 100)))
);


ALTER TABLE production.productinventory OWNER TO timchapman;

--
-- Name: productlistpricehistory; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.productlistpricehistory (
    productid integer NOT NULL,
    startdate timestamp without time zone NOT NULL,
    enddate timestamp without time zone,
    listprice numeric NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_ProductListPriceHistory_EndDate" CHECK (((enddate >= startdate) OR (enddate IS NULL))),
    CONSTRAINT "CK_ProductListPriceHistory_ListPrice" CHECK ((listprice > 0.00))
);


ALTER TABLE production.productlistpricehistory OWNER TO timchapman;

--
-- Name: productmodel; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.productmodel (
    productmodelid integer NOT NULL,
    name public."Name" NOT NULL,
    catalogdescription xml,
    instructions xml,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productmodel OWNER TO timchapman;

--
-- Name: productmodel_productmodelid_seq; Type: SEQUENCE; Schema: production; Owner: timchapman
--

CREATE SEQUENCE production.productmodel_productmodelid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.productmodel_productmodelid_seq OWNER TO timchapman;

--
-- Name: productmodel_productmodelid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: timchapman
--

ALTER SEQUENCE production.productmodel_productmodelid_seq OWNED BY production.productmodel.productmodelid;


--
-- Name: productmodelillustration; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.productmodelillustration (
    productmodelid integer NOT NULL,
    illustrationid integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productmodelillustration OWNER TO timchapman;

--
-- Name: productmodelproductdescriptionculture; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.productmodelproductdescriptionculture (
    productmodelid integer NOT NULL,
    productdescriptionid integer NOT NULL,
    cultureid character(6) NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productmodelproductdescriptionculture OWNER TO timchapman;

--
-- Name: productphoto; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.productphoto (
    productphotoid integer NOT NULL,
    thumbnailphoto bytea,
    thumbnailphotofilename character varying(50),
    largephoto bytea,
    largephotofilename character varying(50),
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productphoto OWNER TO timchapman;

--
-- Name: productphoto_productphotoid_seq; Type: SEQUENCE; Schema: production; Owner: timchapman
--

CREATE SEQUENCE production.productphoto_productphotoid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.productphoto_productphotoid_seq OWNER TO timchapman;

--
-- Name: productphoto_productphotoid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: timchapman
--

ALTER SEQUENCE production.productphoto_productphotoid_seq OWNED BY production.productphoto.productphotoid;


--
-- Name: productproductphoto; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.productproductphoto (
    productid integer NOT NULL,
    productphotoid integer NOT NULL,
    "primary" public."Flag" DEFAULT false NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productproductphoto OWNER TO timchapman;

--
-- Name: productreview; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.productreview (
    productreviewid integer NOT NULL,
    productid integer NOT NULL,
    reviewername public."Name" NOT NULL,
    reviewdate timestamp without time zone DEFAULT now() NOT NULL,
    emailaddress character varying(50) NOT NULL,
    rating integer NOT NULL,
    comments character varying(3850),
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_ProductReview_Rating" CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE production.productreview OWNER TO timchapman;

--
-- Name: productreview_productreviewid_seq; Type: SEQUENCE; Schema: production; Owner: timchapman
--

CREATE SEQUENCE production.productreview_productreviewid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.productreview_productreviewid_seq OWNER TO timchapman;

--
-- Name: productreview_productreviewid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: timchapman
--

ALTER SEQUENCE production.productreview_productreviewid_seq OWNED BY production.productreview.productreviewid;


--
-- Name: productsubcategory; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.productsubcategory (
    productsubcategoryid integer NOT NULL,
    productcategoryid integer NOT NULL,
    name public."Name" NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productsubcategory OWNER TO timchapman;

--
-- Name: productsubcategory_productsubcategoryid_seq; Type: SEQUENCE; Schema: production; Owner: timchapman
--

CREATE SEQUENCE production.productsubcategory_productsubcategoryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.productsubcategory_productsubcategoryid_seq OWNER TO timchapman;

--
-- Name: productsubcategory_productsubcategoryid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: timchapman
--

ALTER SEQUENCE production.productsubcategory_productsubcategoryid_seq OWNED BY production.productsubcategory.productsubcategoryid;


--
-- Name: scrapreason; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.scrapreason (
    scrapreasonid integer NOT NULL,
    name public."Name" NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.scrapreason OWNER TO timchapman;

--
-- Name: scrapreason_scrapreasonid_seq; Type: SEQUENCE; Schema: production; Owner: timchapman
--

CREATE SEQUENCE production.scrapreason_scrapreasonid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.scrapreason_scrapreasonid_seq OWNER TO timchapman;

--
-- Name: scrapreason_scrapreasonid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: timchapman
--

ALTER SEQUENCE production.scrapreason_scrapreasonid_seq OWNED BY production.scrapreason.scrapreasonid;


--
-- Name: transactionhistory; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.transactionhistory (
    transactionid integer NOT NULL,
    productid integer NOT NULL,
    referenceorderid integer NOT NULL,
    referenceorderlineid integer DEFAULT 0 NOT NULL,
    transactiondate timestamp without time zone DEFAULT now() NOT NULL,
    transactiontype character(1) NOT NULL,
    quantity integer NOT NULL,
    actualcost numeric NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_TransactionHistory_TransactionType" CHECK ((upper((transactiontype)::text) = ANY (ARRAY['W'::text, 'S'::text, 'P'::text])))
);


ALTER TABLE production.transactionhistory OWNER TO timchapman;

--
-- Name: transactionhistory_transactionid_seq; Type: SEQUENCE; Schema: production; Owner: timchapman
--

CREATE SEQUENCE production.transactionhistory_transactionid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.transactionhistory_transactionid_seq OWNER TO timchapman;

--
-- Name: transactionhistory_transactionid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: timchapman
--

ALTER SEQUENCE production.transactionhistory_transactionid_seq OWNED BY production.transactionhistory.transactionid;


--
-- Name: transactionhistoryarchive; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.transactionhistoryarchive (
    transactionid integer NOT NULL,
    productid integer NOT NULL,
    referenceorderid integer NOT NULL,
    referenceorderlineid integer DEFAULT 0 NOT NULL,
    transactiondate timestamp without time zone DEFAULT now() NOT NULL,
    transactiontype character(1) NOT NULL,
    quantity integer NOT NULL,
    actualcost numeric NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_TransactionHistoryArchive_TransactionType" CHECK ((upper((transactiontype)::text) = ANY (ARRAY['W'::text, 'S'::text, 'P'::text])))
);


ALTER TABLE production.transactionhistoryarchive OWNER TO timchapman;

--
-- Name: unitmeasure; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.unitmeasure (
    unitmeasurecode character(3) NOT NULL,
    name public."Name" NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.unitmeasure OWNER TO timchapman;

--
-- Name: vproductanddescription; Type: MATERIALIZED VIEW; Schema: production; Owner: timchapman
--

CREATE MATERIALIZED VIEW production.vproductanddescription AS
 SELECT p.productid,
    p.name,
    pm.name AS productmodel,
    pmx.cultureid,
    pd.description
   FROM (((production.product p
     JOIN production.productmodel pm ON ((p.productmodelid = pm.productmodelid)))
     JOIN production.productmodelproductdescriptionculture pmx ON ((pm.productmodelid = pmx.productmodelid)))
     JOIN production.productdescription pd ON ((pmx.productdescriptionid = pd.productdescriptionid)))
  WITH NO DATA;


ALTER TABLE production.vproductanddescription OWNER TO timchapman;

--
-- Name: vproductmodelcatalogdescription; Type: VIEW; Schema: production; Owner: timchapman
--

CREATE VIEW production.vproductmodelcatalogdescription AS
 SELECT productmodel.productmodelid,
    productmodel.name,
    ((xpath('/p1:ProductDescription/p1:Summary/html:p/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{html,http://www.w3.org/1999/xhtml}}'::text[]))[1])::character varying AS "Summary",
    ((xpath('/p1:ProductDescription/p1:Manufacturer/p1:Name/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}'::text[]))[1])::character varying AS manufacturer,
    ((xpath('/p1:ProductDescription/p1:Manufacturer/p1:Copyright/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}'::text[]))[1])::character varying(30) AS copyright,
    ((xpath('/p1:ProductDescription/p1:Manufacturer/p1:ProductURL/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}'::text[]))[1])::character varying(256) AS producturl,
    ((xpath('/p1:ProductDescription/p1:Features/wm:Warranty/wm:WarrantyPeriod/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wm,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain}}'::text[]))[1])::character varying(256) AS warrantyperiod,
    ((xpath('/p1:ProductDescription/p1:Features/wm:Warranty/wm:Description/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wm,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain}}'::text[]))[1])::character varying(256) AS warrantydescription,
    ((xpath('/p1:ProductDescription/p1:Features/wm:Maintenance/wm:NoOfYears/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wm,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain}}'::text[]))[1])::character varying(256) AS noofyears,
    ((xpath('/p1:ProductDescription/p1:Features/wm:Maintenance/wm:Description/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wm,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain}}'::text[]))[1])::character varying(256) AS maintenancedescription,
    ((xpath('/p1:ProductDescription/p1:Features/wf:wheel/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wf,http://www.adventure-works.com/schemas/OtherFeatures}}'::text[]))[1])::character varying(256) AS wheel,
    ((xpath('/p1:ProductDescription/p1:Features/wf:saddle/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wf,http://www.adventure-works.com/schemas/OtherFeatures}}'::text[]))[1])::character varying(256) AS saddle,
    ((xpath('/p1:ProductDescription/p1:Features/wf:pedal/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wf,http://www.adventure-works.com/schemas/OtherFeatures}}'::text[]))[1])::character varying(256) AS pedal,
    ((xpath('/p1:ProductDescription/p1:Features/wf:BikeFrame/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wf,http://www.adventure-works.com/schemas/OtherFeatures}}'::text[]))[1])::character varying AS bikeframe,
    ((xpath('/p1:ProductDescription/p1:Features/wf:crankset/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wf,http://www.adventure-works.com/schemas/OtherFeatures}}'::text[]))[1])::character varying(256) AS crankset,
    ((xpath('/p1:ProductDescription/p1:Picture/p1:Angle/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}'::text[]))[1])::character varying(256) AS pictureangle,
    ((xpath('/p1:ProductDescription/p1:Picture/p1:Size/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}'::text[]))[1])::character varying(256) AS picturesize,
    ((xpath('/p1:ProductDescription/p1:Picture/p1:ProductPhotoID/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}'::text[]))[1])::character varying(256) AS productphotoid,
    ((xpath('/p1:ProductDescription/p1:Specifications/Material/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}'::text[]))[1])::character varying(256) AS material,
    ((xpath('/p1:ProductDescription/p1:Specifications/Color/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}'::text[]))[1])::character varying(256) AS color,
    ((xpath('/p1:ProductDescription/p1:Specifications/ProductLine/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}'::text[]))[1])::character varying(256) AS productline,
    ((xpath('/p1:ProductDescription/p1:Specifications/Style/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}'::text[]))[1])::character varying(256) AS style,
    ((xpath('/p1:ProductDescription/p1:Specifications/RiderExperience/text()'::text, productmodel.catalogdescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}'::text[]))[1])::character varying(1024) AS riderexperience,
    productmodel.rowguid,
    productmodel.modifieddate
   FROM production.productmodel
  WHERE (productmodel.catalogdescription IS NOT NULL);


ALTER TABLE production.vproductmodelcatalogdescription OWNER TO timchapman;

--
-- Name: vproductmodelinstructions; Type: VIEW; Schema: production; Owner: timchapman
--

CREATE VIEW production.vproductmodelinstructions AS
 SELECT pm.productmodelid,
    pm.name,
    ((xpath('/ns:root/text()'::text, pm.instructions, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions}}'::text[]))[1])::character varying AS instructions,
    (((xpath('@LocationID'::text, pm.mfginstructions))[1])::character varying)::integer AS "LocationID",
    (((xpath('@SetupHours'::text, pm.mfginstructions))[1])::character varying)::numeric(9,4) AS "SetupHours",
    (((xpath('@MachineHours'::text, pm.mfginstructions))[1])::character varying)::numeric(9,4) AS "MachineHours",
    (((xpath('@LaborHours'::text, pm.mfginstructions))[1])::character varying)::numeric(9,4) AS "LaborHours",
    (((xpath('@LotSize'::text, pm.mfginstructions))[1])::character varying)::integer AS "LotSize",
    ((xpath('/step/text()'::text, pm.step))[1])::character varying(1024) AS "Step",
    pm.rowguid,
    pm.modifieddate
   FROM ( SELECT locations.productmodelid,
            locations.name,
            locations.rowguid,
            locations.modifieddate,
            locations.instructions,
            locations.mfginstructions,
            unnest(xpath('step'::text, locations.mfginstructions)) AS step
           FROM ( SELECT productmodel.productmodelid,
                    productmodel.name,
                    productmodel.rowguid,
                    productmodel.modifieddate,
                    productmodel.instructions,
                    unnest(xpath('/ns:root/ns:Location'::text, productmodel.instructions, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions}}'::text[])) AS mfginstructions
                   FROM production.productmodel) locations) pm;


ALTER TABLE production.vproductmodelinstructions OWNER TO timchapman;

--
-- Name: workorder; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.workorder (
    workorderid integer NOT NULL,
    productid integer NOT NULL,
    orderqty integer NOT NULL,
    stockedqty integer,
    scrappedqty smallint NOT NULL,
    startdate timestamp without time zone NOT NULL,
    enddate timestamp without time zone,
    duedate timestamp without time zone NOT NULL,
    scrapreasonid smallint,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_WorkOrder_EndDate" CHECK (((enddate >= startdate) OR (enddate IS NULL))),
    CONSTRAINT "CK_WorkOrder_OrderQty" CHECK ((orderqty > 0)),
    CONSTRAINT "CK_WorkOrder_ScrappedQty" CHECK ((scrappedqty >= 0))
);


ALTER TABLE production.workorder OWNER TO timchapman;

--
-- Name: workorder_workorderid_seq; Type: SEQUENCE; Schema: production; Owner: timchapman
--

CREATE SEQUENCE production.workorder_workorderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.workorder_workorderid_seq OWNER TO timchapman;

--
-- Name: workorder_workorderid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: timchapman
--

ALTER SEQUENCE production.workorder_workorderid_seq OWNED BY production.workorder.workorderid;


--
-- Name: workorderrouting; Type: TABLE; Schema: production; Owner: timchapman
--

CREATE TABLE production.workorderrouting (
    workorderid integer NOT NULL,
    productid integer NOT NULL,
    operationsequence smallint NOT NULL,
    locationid smallint NOT NULL,
    scheduledstartdate timestamp without time zone NOT NULL,
    scheduledenddate timestamp without time zone NOT NULL,
    actualstartdate timestamp without time zone,
    actualenddate timestamp without time zone,
    actualresourcehrs numeric(9,4),
    plannedcost numeric NOT NULL,
    actualcost numeric,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_WorkOrderRouting_ActualCost" CHECK ((actualcost > 0.00)),
    CONSTRAINT "CK_WorkOrderRouting_ActualEndDate" CHECK (((actualenddate >= actualstartdate) OR (actualenddate IS NULL) OR (actualstartdate IS NULL))),
    CONSTRAINT "CK_WorkOrderRouting_ActualResourceHrs" CHECK ((actualresourcehrs >= 0.0000)),
    CONSTRAINT "CK_WorkOrderRouting_PlannedCost" CHECK ((plannedcost > 0.00)),
    CONSTRAINT "CK_WorkOrderRouting_ScheduledEndDate" CHECK ((scheduledenddate >= scheduledstartdate))
);


ALTER TABLE production.workorderrouting OWNER TO timchapman;

--
-- Name: productvendor; Type: TABLE; Schema: purchasing; Owner: timchapman
--

CREATE TABLE purchasing.productvendor (
    productid integer NOT NULL,
    businessentityid integer NOT NULL,
    averageleadtime integer NOT NULL,
    standardprice numeric NOT NULL,
    lastreceiptcost numeric,
    lastreceiptdate timestamp without time zone,
    minorderqty integer NOT NULL,
    maxorderqty integer NOT NULL,
    onorderqty integer,
    unitmeasurecode character(3) NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_ProductVendor_AverageLeadTime" CHECK ((averageleadtime >= 1)),
    CONSTRAINT "CK_ProductVendor_LastReceiptCost" CHECK ((lastreceiptcost > 0.00)),
    CONSTRAINT "CK_ProductVendor_MaxOrderQty" CHECK ((maxorderqty >= 1)),
    CONSTRAINT "CK_ProductVendor_MinOrderQty" CHECK ((minorderqty >= 1)),
    CONSTRAINT "CK_ProductVendor_OnOrderQty" CHECK ((onorderqty >= 0)),
    CONSTRAINT "CK_ProductVendor_StandardPrice" CHECK ((standardprice > 0.00))
);


ALTER TABLE purchasing.productvendor OWNER TO timchapman;

--
-- Name: purchaseorderdetail; Type: TABLE; Schema: purchasing; Owner: timchapman
--

CREATE TABLE purchasing.purchaseorderdetail (
    purchaseorderid integer NOT NULL,
    purchaseorderdetailid integer NOT NULL,
    duedate timestamp without time zone NOT NULL,
    orderqty smallint NOT NULL,
    productid integer NOT NULL,
    unitprice numeric NOT NULL,
    receivedqty numeric(8,2) NOT NULL,
    rejectedqty numeric(8,2) NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_PurchaseOrderDetail_OrderQty" CHECK ((orderqty > 0)),
    CONSTRAINT "CK_PurchaseOrderDetail_ReceivedQty" CHECK ((receivedqty >= 0.00)),
    CONSTRAINT "CK_PurchaseOrderDetail_RejectedQty" CHECK ((rejectedqty >= 0.00)),
    CONSTRAINT "CK_PurchaseOrderDetail_UnitPrice" CHECK ((unitprice >= 0.00))
);


ALTER TABLE purchasing.purchaseorderdetail OWNER TO timchapman;

--
-- Name: purchaseorderdetail_purchaseorderdetailid_seq; Type: SEQUENCE; Schema: purchasing; Owner: timchapman
--

CREATE SEQUENCE purchasing.purchaseorderdetail_purchaseorderdetailid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE purchasing.purchaseorderdetail_purchaseorderdetailid_seq OWNER TO timchapman;

--
-- Name: purchaseorderdetail_purchaseorderdetailid_seq; Type: SEQUENCE OWNED BY; Schema: purchasing; Owner: timchapman
--

ALTER SEQUENCE purchasing.purchaseorderdetail_purchaseorderdetailid_seq OWNED BY purchasing.purchaseorderdetail.purchaseorderdetailid;


--
-- Name: purchaseorderheader; Type: TABLE; Schema: purchasing; Owner: timchapman
--

CREATE TABLE purchasing.purchaseorderheader (
    purchaseorderid integer NOT NULL,
    revisionnumber smallint DEFAULT 0 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    employeeid integer NOT NULL,
    vendorid integer NOT NULL,
    shipmethodid integer NOT NULL,
    orderdate timestamp without time zone DEFAULT now() NOT NULL,
    shipdate timestamp without time zone,
    subtotal numeric DEFAULT 0.00 NOT NULL,
    taxamt numeric DEFAULT 0.00 NOT NULL,
    freight numeric DEFAULT 0.00 NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_PurchaseOrderHeader_Freight" CHECK ((freight >= 0.00)),
    CONSTRAINT "CK_PurchaseOrderHeader_ShipDate" CHECK (((shipdate >= orderdate) OR (shipdate IS NULL))),
    CONSTRAINT "CK_PurchaseOrderHeader_Status" CHECK (((status >= 1) AND (status <= 4))),
    CONSTRAINT "CK_PurchaseOrderHeader_SubTotal" CHECK ((subtotal >= 0.00)),
    CONSTRAINT "CK_PurchaseOrderHeader_TaxAmt" CHECK ((taxamt >= 0.00))
);


ALTER TABLE purchasing.purchaseorderheader OWNER TO timchapman;

--
-- Name: purchaseorderheader_purchaseorderid_seq; Type: SEQUENCE; Schema: purchasing; Owner: timchapman
--

CREATE SEQUENCE purchasing.purchaseorderheader_purchaseorderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE purchasing.purchaseorderheader_purchaseorderid_seq OWNER TO timchapman;

--
-- Name: purchaseorderheader_purchaseorderid_seq; Type: SEQUENCE OWNED BY; Schema: purchasing; Owner: timchapman
--

ALTER SEQUENCE purchasing.purchaseorderheader_purchaseorderid_seq OWNED BY purchasing.purchaseorderheader.purchaseorderid;


--
-- Name: shipmethod; Type: TABLE; Schema: purchasing; Owner: timchapman
--

CREATE TABLE purchasing.shipmethod (
    shipmethodid integer NOT NULL,
    name public."Name" NOT NULL,
    shipbase numeric DEFAULT 0.00 NOT NULL,
    shiprate numeric DEFAULT 0.00 NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_ShipMethod_ShipBase" CHECK ((shipbase > 0.00)),
    CONSTRAINT "CK_ShipMethod_ShipRate" CHECK ((shiprate > 0.00))
);


ALTER TABLE purchasing.shipmethod OWNER TO timchapman;

--
-- Name: shipmethod_shipmethodid_seq; Type: SEQUENCE; Schema: purchasing; Owner: timchapman
--

CREATE SEQUENCE purchasing.shipmethod_shipmethodid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE purchasing.shipmethod_shipmethodid_seq OWNER TO timchapman;

--
-- Name: shipmethod_shipmethodid_seq; Type: SEQUENCE OWNED BY; Schema: purchasing; Owner: timchapman
--

ALTER SEQUENCE purchasing.shipmethod_shipmethodid_seq OWNED BY purchasing.shipmethod.shipmethodid;


--
-- Name: vendor; Type: TABLE; Schema: purchasing; Owner: timchapman
--

CREATE TABLE purchasing.vendor (
    businessentityid integer NOT NULL,
    accountnumber public."AccountNumber" NOT NULL,
    name public."Name" NOT NULL,
    creditrating smallint NOT NULL,
    preferredvendorstatus public."Flag" DEFAULT true NOT NULL,
    activeflag public."Flag" DEFAULT true NOT NULL,
    purchasingwebserviceurl character varying(1024),
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_Vendor_CreditRating" CHECK (((creditrating >= 1) AND (creditrating <= 5)))
);


ALTER TABLE purchasing.vendor OWNER TO timchapman;

--
-- Name: vvendorwithaddresses; Type: VIEW; Schema: purchasing; Owner: timchapman
--

CREATE VIEW purchasing.vvendorwithaddresses AS
 SELECT v.businessentityid,
    v.name,
    at.name AS addresstype,
    a.addressline1,
    a.addressline2,
    a.city,
    sp.name AS stateprovincename,
    a.postalcode,
    cr.name AS countryregionname
   FROM (((((purchasing.vendor v
     JOIN person.businessentityaddress bea ON ((bea.businessentityid = v.businessentityid)))
     JOIN person.address a ON ((a.addressid = bea.addressid)))
     JOIN person.stateprovince sp ON ((sp.stateprovinceid = a.stateprovinceid)))
     JOIN person.countryregion cr ON (((cr.countryregioncode)::text = (sp.countryregioncode)::text)))
     JOIN person.addresstype at ON ((at.addresstypeid = bea.addresstypeid)));


ALTER TABLE purchasing.vvendorwithaddresses OWNER TO timchapman;

--
-- Name: vvendorwithcontacts; Type: VIEW; Schema: purchasing; Owner: timchapman
--

CREATE VIEW purchasing.vvendorwithcontacts AS
 SELECT v.businessentityid,
    v.name,
    ct.name AS contacttype,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    pp.phonenumber,
    pnt.name AS phonenumbertype,
    ea.emailaddress,
    p.emailpromotion
   FROM ((((((purchasing.vendor v
     JOIN person.businessentitycontact bec ON ((bec.businessentityid = v.businessentityid)))
     JOIN person.contacttype ct ON ((ct.contacttypeid = bec.contacttypeid)))
     JOIN person.person p ON ((p.businessentityid = bec.personid)))
     LEFT JOIN person.emailaddress ea ON ((ea.businessentityid = p.businessentityid)))
     LEFT JOIN person.personphone pp ON ((pp.businessentityid = p.businessentityid)))
     LEFT JOIN person.phonenumbertype pnt ON ((pnt.phonenumbertypeid = pp.phonenumbertypeid)));


ALTER TABLE purchasing.vvendorwithcontacts OWNER TO timchapman;

--
-- Name: countryregioncurrency; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.countryregioncurrency (
    countryregioncode character varying(3) NOT NULL,
    currencycode character(3) NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.countryregioncurrency OWNER TO timchapman;

--
-- Name: creditcard; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.creditcard (
    creditcardid integer NOT NULL,
    cardtype character varying(50) NOT NULL,
    cardnumber character varying(25) NOT NULL,
    expmonth smallint NOT NULL,
    expyear smallint NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.creditcard OWNER TO timchapman;

--
-- Name: creditcard_creditcardid_seq; Type: SEQUENCE; Schema: sales; Owner: timchapman
--

CREATE SEQUENCE sales.creditcard_creditcardid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.creditcard_creditcardid_seq OWNER TO timchapman;

--
-- Name: creditcard_creditcardid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: timchapman
--

ALTER SEQUENCE sales.creditcard_creditcardid_seq OWNED BY sales.creditcard.creditcardid;


--
-- Name: currency; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.currency (
    currencycode character(3) NOT NULL,
    name public."Name" NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.currency OWNER TO timchapman;

--
-- Name: currencyrate; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.currencyrate (
    currencyrateid integer NOT NULL,
    currencyratedate timestamp without time zone NOT NULL,
    fromcurrencycode character(3) NOT NULL,
    tocurrencycode character(3) NOT NULL,
    averagerate numeric NOT NULL,
    endofdayrate numeric NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.currencyrate OWNER TO timchapman;

--
-- Name: currencyrate_currencyrateid_seq; Type: SEQUENCE; Schema: sales; Owner: timchapman
--

CREATE SEQUENCE sales.currencyrate_currencyrateid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.currencyrate_currencyrateid_seq OWNER TO timchapman;

--
-- Name: currencyrate_currencyrateid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: timchapman
--

ALTER SEQUENCE sales.currencyrate_currencyrateid_seq OWNED BY sales.currencyrate.currencyrateid;


--
-- Name: customer; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.customer (
    customerid integer NOT NULL,
    personid integer,
    storeid integer,
    territoryid integer,
    accountnumber character varying,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.customer OWNER TO timchapman;

--
-- Name: customer_customerid_seq; Type: SEQUENCE; Schema: sales; Owner: timchapman
--

CREATE SEQUENCE sales.customer_customerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.customer_customerid_seq OWNER TO timchapman;

--
-- Name: customer_customerid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: timchapman
--

ALTER SEQUENCE sales.customer_customerid_seq OWNED BY sales.customer.customerid;


--
-- Name: personcreditcard; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.personcreditcard (
    businessentityid integer NOT NULL,
    creditcardid integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.personcreditcard OWNER TO timchapman;

--
-- Name: salesorderdetail; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.salesorderdetail (
    salesorderid integer NOT NULL,
    salesorderdetailid integer NOT NULL,
    carriertrackingnumber character varying(25),
    orderqty smallint NOT NULL,
    productid integer NOT NULL,
    specialofferid integer NOT NULL,
    unitprice numeric NOT NULL,
    unitpricediscount numeric DEFAULT 0.0 NOT NULL,
    linetotal numeric,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SalesOrderDetail_OrderQty" CHECK ((orderqty > 0)),
    CONSTRAINT "CK_SalesOrderDetail_UnitPrice" CHECK ((unitprice >= 0.00)),
    CONSTRAINT "CK_SalesOrderDetail_UnitPriceDiscount" CHECK ((unitpricediscount >= 0.00))
);


ALTER TABLE sales.salesorderdetail OWNER TO timchapman;

--
-- Name: salesorderdetail_salesorderdetailid_seq; Type: SEQUENCE; Schema: sales; Owner: timchapman
--

CREATE SEQUENCE sales.salesorderdetail_salesorderdetailid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.salesorderdetail_salesorderdetailid_seq OWNER TO timchapman;

--
-- Name: salesorderdetail_salesorderdetailid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: timchapman
--

ALTER SEQUENCE sales.salesorderdetail_salesorderdetailid_seq OWNED BY sales.salesorderdetail.salesorderdetailid;


--
-- Name: salesorderheader; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.salesorderheader (
    salesorderid integer NOT NULL,
    revisionnumber smallint DEFAULT 0 NOT NULL,
    orderdate timestamp without time zone DEFAULT now() NOT NULL,
    duedate timestamp without time zone NOT NULL,
    shipdate timestamp without time zone,
    status smallint DEFAULT 1 NOT NULL,
    onlineorderflag public."Flag" DEFAULT true NOT NULL,
    salesordernumber character varying(23),
    purchaseordernumber public."OrderNumber",
    accountnumber public."AccountNumber",
    customerid integer NOT NULL,
    salespersonid integer,
    territoryid integer,
    billtoaddressid integer NOT NULL,
    shiptoaddressid integer NOT NULL,
    shipmethodid integer NOT NULL,
    creditcardid integer,
    creditcardapprovalcode character varying(15),
    currencyrateid integer,
    subtotal numeric DEFAULT 0.00 NOT NULL,
    taxamt numeric DEFAULT 0.00 NOT NULL,
    freight numeric DEFAULT 0.00 NOT NULL,
    totaldue numeric,
    comment character varying(128),
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SalesOrderHeader_DueDate" CHECK ((duedate >= orderdate)),
    CONSTRAINT "CK_SalesOrderHeader_Freight" CHECK ((freight >= 0.00)),
    CONSTRAINT "CK_SalesOrderHeader_ShipDate" CHECK (((shipdate >= orderdate) OR (shipdate IS NULL))),
    CONSTRAINT "CK_SalesOrderHeader_Status" CHECK (((status >= 0) AND (status <= 8))),
    CONSTRAINT "CK_SalesOrderHeader_SubTotal" CHECK ((subtotal >= 0.00)),
    CONSTRAINT "CK_SalesOrderHeader_TaxAmt" CHECK ((taxamt >= 0.00))
);


ALTER TABLE sales.salesorderheader OWNER TO timchapman;

--
-- Name: salesorderheader_salesorderid_seq; Type: SEQUENCE; Schema: sales; Owner: timchapman
--

CREATE SEQUENCE sales.salesorderheader_salesorderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.salesorderheader_salesorderid_seq OWNER TO timchapman;

--
-- Name: salesorderheader_salesorderid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: timchapman
--

ALTER SEQUENCE sales.salesorderheader_salesorderid_seq OWNED BY sales.salesorderheader.salesorderid;


--
-- Name: salesorderheadersalesreason; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.salesorderheadersalesreason (
    salesorderid integer NOT NULL,
    salesreasonid integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.salesorderheadersalesreason OWNER TO timchapman;

--
-- Name: salesperson; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.salesperson (
    businessentityid integer NOT NULL,
    territoryid integer,
    salesquota numeric,
    bonus numeric DEFAULT 0.00 NOT NULL,
    commissionpct numeric DEFAULT 0.00 NOT NULL,
    salesytd numeric DEFAULT 0.00 NOT NULL,
    saleslastyear numeric DEFAULT 0.00 NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SalesPerson_Bonus" CHECK ((bonus >= 0.00)),
    CONSTRAINT "CK_SalesPerson_CommissionPct" CHECK ((commissionpct >= 0.00)),
    CONSTRAINT "CK_SalesPerson_SalesLastYear" CHECK ((saleslastyear >= 0.00)),
    CONSTRAINT "CK_SalesPerson_SalesQuota" CHECK ((salesquota > 0.00)),
    CONSTRAINT "CK_SalesPerson_SalesYTD" CHECK ((salesytd >= 0.00))
);


ALTER TABLE sales.salesperson OWNER TO timchapman;

--
-- Name: salespersonquotahistory; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.salespersonquotahistory (
    businessentityid integer NOT NULL,
    quotadate timestamp without time zone NOT NULL,
    salesquota numeric NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SalesPersonQuotaHistory_SalesQuota" CHECK ((salesquota > 0.00))
);


ALTER TABLE sales.salespersonquotahistory OWNER TO timchapman;

--
-- Name: salesreason; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.salesreason (
    salesreasonid integer NOT NULL,
    name public."Name" NOT NULL,
    reasontype public."Name" NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.salesreason OWNER TO timchapman;

--
-- Name: salesreason_salesreasonid_seq; Type: SEQUENCE; Schema: sales; Owner: timchapman
--

CREATE SEQUENCE sales.salesreason_salesreasonid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.salesreason_salesreasonid_seq OWNER TO timchapman;

--
-- Name: salesreason_salesreasonid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: timchapman
--

ALTER SEQUENCE sales.salesreason_salesreasonid_seq OWNED BY sales.salesreason.salesreasonid;


--
-- Name: salestaxrate; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.salestaxrate (
    salestaxrateid integer NOT NULL,
    stateprovinceid integer NOT NULL,
    taxtype smallint NOT NULL,
    taxrate numeric DEFAULT 0.00 NOT NULL,
    name public."Name" NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SalesTaxRate_TaxType" CHECK (((taxtype >= 1) AND (taxtype <= 3)))
);


ALTER TABLE sales.salestaxrate OWNER TO timchapman;

--
-- Name: salestaxrate_salestaxrateid_seq; Type: SEQUENCE; Schema: sales; Owner: timchapman
--

CREATE SEQUENCE sales.salestaxrate_salestaxrateid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.salestaxrate_salestaxrateid_seq OWNER TO timchapman;

--
-- Name: salestaxrate_salestaxrateid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: timchapman
--

ALTER SEQUENCE sales.salestaxrate_salestaxrateid_seq OWNED BY sales.salestaxrate.salestaxrateid;


--
-- Name: salesterritory; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.salesterritory (
    territoryid integer NOT NULL,
    name public."Name" NOT NULL,
    countryregioncode character varying(3) NOT NULL,
    "group" character varying(50) NOT NULL,
    salesytd numeric DEFAULT 0.00 NOT NULL,
    saleslastyear numeric DEFAULT 0.00 NOT NULL,
    costytd numeric DEFAULT 0.00 NOT NULL,
    costlastyear numeric DEFAULT 0.00 NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SalesTerritory_CostLastYear" CHECK ((costlastyear >= 0.00)),
    CONSTRAINT "CK_SalesTerritory_CostYTD" CHECK ((costytd >= 0.00)),
    CONSTRAINT "CK_SalesTerritory_SalesLastYear" CHECK ((saleslastyear >= 0.00)),
    CONSTRAINT "CK_SalesTerritory_SalesYTD" CHECK ((salesytd >= 0.00))
);


ALTER TABLE sales.salesterritory OWNER TO timchapman;

--
-- Name: salesterritory_territoryid_seq; Type: SEQUENCE; Schema: sales; Owner: timchapman
--

CREATE SEQUENCE sales.salesterritory_territoryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.salesterritory_territoryid_seq OWNER TO timchapman;

--
-- Name: salesterritory_territoryid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: timchapman
--

ALTER SEQUENCE sales.salesterritory_territoryid_seq OWNED BY sales.salesterritory.territoryid;


--
-- Name: salesterritoryhistory; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.salesterritoryhistory (
    businessentityid integer NOT NULL,
    territoryid integer NOT NULL,
    startdate timestamp without time zone NOT NULL,
    enddate timestamp without time zone,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SalesTerritoryHistory_EndDate" CHECK (((enddate >= startdate) OR (enddate IS NULL)))
);


ALTER TABLE sales.salesterritoryhistory OWNER TO timchapman;

--
-- Name: shoppingcartitem; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.shoppingcartitem (
    shoppingcartitemid integer NOT NULL,
    shoppingcartid character varying(50) NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    productid integer NOT NULL,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_ShoppingCartItem_Quantity" CHECK ((quantity >= 1))
);


ALTER TABLE sales.shoppingcartitem OWNER TO timchapman;

--
-- Name: shoppingcartitem_shoppingcartitemid_seq; Type: SEQUENCE; Schema: sales; Owner: timchapman
--

CREATE SEQUENCE sales.shoppingcartitem_shoppingcartitemid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.shoppingcartitem_shoppingcartitemid_seq OWNER TO timchapman;

--
-- Name: shoppingcartitem_shoppingcartitemid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: timchapman
--

ALTER SEQUENCE sales.shoppingcartitem_shoppingcartitemid_seq OWNED BY sales.shoppingcartitem.shoppingcartitemid;


--
-- Name: specialoffer; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.specialoffer (
    specialofferid integer NOT NULL,
    description character varying(255) NOT NULL,
    discountpct numeric DEFAULT 0.00 NOT NULL,
    type character varying(50) NOT NULL,
    category character varying(50) NOT NULL,
    startdate timestamp without time zone NOT NULL,
    enddate timestamp without time zone NOT NULL,
    minqty integer DEFAULT 0 NOT NULL,
    maxqty integer,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SpecialOffer_DiscountPct" CHECK ((discountpct >= 0.00)),
    CONSTRAINT "CK_SpecialOffer_EndDate" CHECK ((enddate >= startdate)),
    CONSTRAINT "CK_SpecialOffer_MaxQty" CHECK ((maxqty >= 0)),
    CONSTRAINT "CK_SpecialOffer_MinQty" CHECK ((minqty >= 0))
);


ALTER TABLE sales.specialoffer OWNER TO timchapman;

--
-- Name: specialoffer_specialofferid_seq; Type: SEQUENCE; Schema: sales; Owner: timchapman
--

CREATE SEQUENCE sales.specialoffer_specialofferid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.specialoffer_specialofferid_seq OWNER TO timchapman;

--
-- Name: specialoffer_specialofferid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: timchapman
--

ALTER SEQUENCE sales.specialoffer_specialofferid_seq OWNED BY sales.specialoffer.specialofferid;


--
-- Name: specialofferproduct; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.specialofferproduct (
    specialofferid integer NOT NULL,
    productid integer NOT NULL,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.specialofferproduct OWNER TO timchapman;

--
-- Name: store; Type: TABLE; Schema: sales; Owner: timchapman
--

CREATE TABLE sales.store (
    businessentityid integer NOT NULL,
    name public."Name" NOT NULL,
    salespersonid integer,
    demographics xml,
    rowguid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.store OWNER TO timchapman;

--
-- Name: vindividualcustomer; Type: VIEW; Schema: sales; Owner: timchapman
--

CREATE VIEW sales.vindividualcustomer AS
 SELECT p.businessentityid,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    pp.phonenumber,
    pnt.name AS phonenumbertype,
    ea.emailaddress,
    p.emailpromotion,
    at.name AS addresstype,
    a.addressline1,
    a.addressline2,
    a.city,
    sp.name AS stateprovincename,
    a.postalcode,
    cr.name AS countryregionname,
    p.demographics
   FROM (((((((((person.person p
     JOIN person.businessentityaddress bea ON ((bea.businessentityid = p.businessentityid)))
     JOIN person.address a ON ((a.addressid = bea.addressid)))
     JOIN person.stateprovince sp ON ((sp.stateprovinceid = a.stateprovinceid)))
     JOIN person.countryregion cr ON (((cr.countryregioncode)::text = (sp.countryregioncode)::text)))
     JOIN person.addresstype at ON ((at.addresstypeid = bea.addresstypeid)))
     JOIN sales.customer c ON ((c.personid = p.businessentityid)))
     LEFT JOIN person.emailaddress ea ON ((ea.businessentityid = p.businessentityid)))
     LEFT JOIN person.personphone pp ON ((pp.businessentityid = p.businessentityid)))
     LEFT JOIN person.phonenumbertype pnt ON ((pnt.phonenumbertypeid = pp.phonenumbertypeid)))
  WHERE (c.storeid IS NULL);


ALTER TABLE sales.vindividualcustomer OWNER TO timchapman;

--
-- Name: vpersondemographics; Type: VIEW; Schema: sales; Owner: timchapman
--

CREATE VIEW sales.vpersondemographics AS
 SELECT person.businessentityid,
    (((xpath('n:TotalPurchaseYTD/text()'::text, person.demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'::text[]))[1])::character varying)::money AS totalpurchaseytd,
    (((xpath('n:DateFirstPurchase/text()'::text, person.demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'::text[]))[1])::character varying)::date AS datefirstpurchase,
    (((xpath('n:BirthDate/text()'::text, person.demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'::text[]))[1])::character varying)::date AS birthdate,
    ((xpath('n:MaritalStatus/text()'::text, person.demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'::text[]))[1])::character varying(1) AS maritalstatus,
    ((xpath('n:YearlyIncome/text()'::text, person.demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'::text[]))[1])::character varying(30) AS yearlyincome,
    ((xpath('n:Gender/text()'::text, person.demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'::text[]))[1])::character varying(1) AS gender,
    (((xpath('n:TotalChildren/text()'::text, person.demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'::text[]))[1])::character varying)::integer AS totalchildren,
    (((xpath('n:NumberChildrenAtHome/text()'::text, person.demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'::text[]))[1])::character varying)::integer AS numberchildrenathome,
    ((xpath('n:Education/text()'::text, person.demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'::text[]))[1])::character varying(30) AS education,
    ((xpath('n:Occupation/text()'::text, person.demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'::text[]))[1])::character varying(30) AS occupation,
    (((xpath('n:HomeOwnerFlag/text()'::text, person.demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'::text[]))[1])::character varying)::boolean AS homeownerflag,
    (((xpath('n:NumberCarsOwned/text()'::text, person.demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'::text[]))[1])::character varying)::integer AS numbercarsowned
   FROM person.person
  WHERE (person.demographics IS NOT NULL);


ALTER TABLE sales.vpersondemographics OWNER TO timchapman;

--
-- Name: vsalesperson; Type: VIEW; Schema: sales; Owner: timchapman
--

CREATE VIEW sales.vsalesperson AS
 SELECT s.businessentityid,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    e.jobtitle,
    pp.phonenumber,
    pnt.name AS phonenumbertype,
    ea.emailaddress,
    p.emailpromotion,
    a.addressline1,
    a.addressline2,
    a.city,
    sp.name AS stateprovincename,
    a.postalcode,
    cr.name AS countryregionname,
    st.name AS territoryname,
    st."group" AS territorygroup,
    s.salesquota,
    s.salesytd,
    s.saleslastyear
   FROM ((((((((((sales.salesperson s
     JOIN humanresources.employee e ON ((e.businessentityid = s.businessentityid)))
     JOIN person.person p ON ((p.businessentityid = s.businessentityid)))
     JOIN person.businessentityaddress bea ON ((bea.businessentityid = s.businessentityid)))
     JOIN person.address a ON ((a.addressid = bea.addressid)))
     JOIN person.stateprovince sp ON ((sp.stateprovinceid = a.stateprovinceid)))
     JOIN person.countryregion cr ON (((cr.countryregioncode)::text = (sp.countryregioncode)::text)))
     LEFT JOIN sales.salesterritory st ON ((st.territoryid = s.territoryid)))
     LEFT JOIN person.emailaddress ea ON ((ea.businessentityid = p.businessentityid)))
     LEFT JOIN person.personphone pp ON ((pp.businessentityid = p.businessentityid)))
     LEFT JOIN person.phonenumbertype pnt ON ((pnt.phonenumbertypeid = pp.phonenumbertypeid)));


ALTER TABLE sales.vsalesperson OWNER TO timchapman;

--
-- Name: vsalespersonsalesbyfiscalyears; Type: VIEW; Schema: sales; Owner: timchapman
--

CREATE VIEW sales.vsalespersonsalesbyfiscalyears AS
 SELECT salestotal."SalesPersonID",
    salestotal."FullName",
    salestotal."JobTitle",
    salestotal."SalesTerritory",
    salestotal."2012",
    salestotal."2013",
    salestotal."2014"
   FROM public.crosstab('SELECT
    SalesPersonID
    ,FullName
    ,JobTitle
    ,SalesTerritory
    ,FiscalYear
    ,SalesTotal
FROM Sales.vSalesPersonSalesByFiscalYearsData
ORDER BY 2,4'::text, 'SELECT unnest(''{2012,2013,2014}''::text[])'::text) salestotal("SalesPersonID" integer, "FullName" text, "JobTitle" text, "SalesTerritory" text, "2012" numeric(12,4), "2013" numeric(12,4), "2014" numeric(12,4));


ALTER TABLE sales.vsalespersonsalesbyfiscalyears OWNER TO timchapman;

--
-- Name: vsalespersonsalesbyfiscalyearsdata; Type: VIEW; Schema: sales; Owner: timchapman
--

CREATE VIEW sales.vsalespersonsalesbyfiscalyearsdata AS
 SELECT granular.salespersonid,
    granular.fullname,
    granular.jobtitle,
    granular.salesterritory,
    sum(granular.subtotal) AS salestotal,
    granular.fiscalyear
   FROM ( SELECT soh.salespersonid,
            ((((p.firstname)::text || ' '::text) || COALESCE(((p.middlename)::text || ' '::text), ''::text)) || (p.lastname)::text) AS fullname,
            e.jobtitle,
            st.name AS salesterritory,
            soh.subtotal,
            date_part('year'::text, (soh.orderdate + '6 mons'::interval)) AS fiscalyear
           FROM ((((sales.salesperson sp
             JOIN sales.salesorderheader soh ON ((sp.businessentityid = soh.salespersonid)))
             JOIN sales.salesterritory st ON ((sp.territoryid = st.territoryid)))
             JOIN humanresources.employee e ON ((soh.salespersonid = e.businessentityid)))
             JOIN person.person p ON ((p.businessentityid = sp.businessentityid)))) granular
  GROUP BY granular.salespersonid, granular.fullname, granular.jobtitle, granular.salesterritory, granular.fiscalyear;


ALTER TABLE sales.vsalespersonsalesbyfiscalyearsdata OWNER TO timchapman;

--
-- Name: vstorewithaddresses; Type: VIEW; Schema: sales; Owner: timchapman
--

CREATE VIEW sales.vstorewithaddresses AS
 SELECT s.businessentityid,
    s.name,
    at.name AS addresstype,
    a.addressline1,
    a.addressline2,
    a.city,
    sp.name AS stateprovincename,
    a.postalcode,
    cr.name AS countryregionname
   FROM (((((sales.store s
     JOIN person.businessentityaddress bea ON ((bea.businessentityid = s.businessentityid)))
     JOIN person.address a ON ((a.addressid = bea.addressid)))
     JOIN person.stateprovince sp ON ((sp.stateprovinceid = a.stateprovinceid)))
     JOIN person.countryregion cr ON (((cr.countryregioncode)::text = (sp.countryregioncode)::text)))
     JOIN person.addresstype at ON ((at.addresstypeid = bea.addresstypeid)));


ALTER TABLE sales.vstorewithaddresses OWNER TO timchapman;

--
-- Name: vstorewithcontacts; Type: VIEW; Schema: sales; Owner: timchapman
--

CREATE VIEW sales.vstorewithcontacts AS
 SELECT s.businessentityid,
    s.name,
    ct.name AS contacttype,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    pp.phonenumber,
    pnt.name AS phonenumbertype,
    ea.emailaddress,
    p.emailpromotion
   FROM ((((((sales.store s
     JOIN person.businessentitycontact bec ON ((bec.businessentityid = s.businessentityid)))
     JOIN person.contacttype ct ON ((ct.contacttypeid = bec.contacttypeid)))
     JOIN person.person p ON ((p.businessentityid = bec.personid)))
     LEFT JOIN person.emailaddress ea ON ((ea.businessentityid = p.businessentityid)))
     LEFT JOIN person.personphone pp ON ((pp.businessentityid = p.businessentityid)))
     LEFT JOIN person.phonenumbertype pnt ON ((pnt.phonenumbertypeid = pp.phonenumbertypeid)));


ALTER TABLE sales.vstorewithcontacts OWNER TO timchapman;

--
-- Name: vstorewithdemographics; Type: VIEW; Schema: sales; Owner: timchapman
--

CREATE VIEW sales.vstorewithdemographics AS
 SELECT store.businessentityid,
    store.name,
    ((unnest(xpath('/ns:StoreSurvey/ns:AnnualSales/text()'::text, store.demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'::text[])))::character varying)::money AS "AnnualSales",
    ((unnest(xpath('/ns:StoreSurvey/ns:AnnualRevenue/text()'::text, store.demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'::text[])))::character varying)::money AS "AnnualRevenue",
    (unnest(xpath('/ns:StoreSurvey/ns:BankName/text()'::text, store.demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'::text[])))::character varying(50) AS "BankName",
    (unnest(xpath('/ns:StoreSurvey/ns:BusinessType/text()'::text, store.demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'::text[])))::character varying(5) AS "BusinessType",
    ((unnest(xpath('/ns:StoreSurvey/ns:YearOpened/text()'::text, store.demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'::text[])))::character varying)::integer AS "YearOpened",
    (unnest(xpath('/ns:StoreSurvey/ns:Specialty/text()'::text, store.demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'::text[])))::character varying(50) AS "Specialty",
    ((unnest(xpath('/ns:StoreSurvey/ns:SquareFeet/text()'::text, store.demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'::text[])))::character varying)::integer AS "SquareFeet",
    (unnest(xpath('/ns:StoreSurvey/ns:Brands/text()'::text, store.demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'::text[])))::character varying(30) AS "Brands",
    (unnest(xpath('/ns:StoreSurvey/ns:Internet/text()'::text, store.demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'::text[])))::character varying(30) AS "Internet",
    ((unnest(xpath('/ns:StoreSurvey/ns:NumberEmployees/text()'::text, store.demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'::text[])))::character varying)::integer AS "NumberEmployees"
   FROM sales.store;


ALTER TABLE sales.vstorewithdemographics OWNER TO timchapman;

--
-- Name: department departmentid; Type: DEFAULT; Schema: humanresources; Owner: timchapman
--

ALTER TABLE ONLY humanresources.department ALTER COLUMN departmentid SET DEFAULT nextval('humanresources.department_departmentid_seq'::regclass);


--
-- Name: jobcandidate jobcandidateid; Type: DEFAULT; Schema: humanresources; Owner: timchapman
--

ALTER TABLE ONLY humanresources.jobcandidate ALTER COLUMN jobcandidateid SET DEFAULT nextval('humanresources.jobcandidate_jobcandidateid_seq'::regclass);


--
-- Name: shift shiftid; Type: DEFAULT; Schema: humanresources; Owner: timchapman
--

ALTER TABLE ONLY humanresources.shift ALTER COLUMN shiftid SET DEFAULT nextval('humanresources.shift_shiftid_seq'::regclass);


--
-- Name: address addressid; Type: DEFAULT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.address ALTER COLUMN addressid SET DEFAULT nextval('person.address_addressid_seq'::regclass);


--
-- Name: addresstype addresstypeid; Type: DEFAULT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.addresstype ALTER COLUMN addresstypeid SET DEFAULT nextval('person.addresstype_addresstypeid_seq'::regclass);


--
-- Name: businessentity businessentityid; Type: DEFAULT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.businessentity ALTER COLUMN businessentityid SET DEFAULT nextval('person.businessentity_businessentityid_seq'::regclass);


--
-- Name: contacttype contacttypeid; Type: DEFAULT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.contacttype ALTER COLUMN contacttypeid SET DEFAULT nextval('person.contacttype_contacttypeid_seq'::regclass);


--
-- Name: emailaddress emailaddressid; Type: DEFAULT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.emailaddress ALTER COLUMN emailaddressid SET DEFAULT nextval('person.emailaddress_emailaddressid_seq'::regclass);


--
-- Name: phonenumbertype phonenumbertypeid; Type: DEFAULT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.phonenumbertype ALTER COLUMN phonenumbertypeid SET DEFAULT nextval('person.phonenumbertype_phonenumbertypeid_seq'::regclass);


--
-- Name: stateprovince stateprovinceid; Type: DEFAULT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.stateprovince ALTER COLUMN stateprovinceid SET DEFAULT nextval('person.stateprovince_stateprovinceid_seq'::regclass);


--
-- Name: billofmaterials billofmaterialsid; Type: DEFAULT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.billofmaterials ALTER COLUMN billofmaterialsid SET DEFAULT nextval('production.billofmaterials_billofmaterialsid_seq'::regclass);


--
-- Name: illustration illustrationid; Type: DEFAULT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.illustration ALTER COLUMN illustrationid SET DEFAULT nextval('production.illustration_illustrationid_seq'::regclass);


--
-- Name: location locationid; Type: DEFAULT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.location ALTER COLUMN locationid SET DEFAULT nextval('production.location_locationid_seq'::regclass);


--
-- Name: product productid; Type: DEFAULT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.product ALTER COLUMN productid SET DEFAULT nextval('production.product_productid_seq'::regclass);


--
-- Name: productcategory productcategoryid; Type: DEFAULT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productcategory ALTER COLUMN productcategoryid SET DEFAULT nextval('production.productcategory_productcategoryid_seq'::regclass);


--
-- Name: productdescription productdescriptionid; Type: DEFAULT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productdescription ALTER COLUMN productdescriptionid SET DEFAULT nextval('production.productdescription_productdescriptionid_seq'::regclass);


--
-- Name: productmodel productmodelid; Type: DEFAULT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productmodel ALTER COLUMN productmodelid SET DEFAULT nextval('production.productmodel_productmodelid_seq'::regclass);


--
-- Name: productphoto productphotoid; Type: DEFAULT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productphoto ALTER COLUMN productphotoid SET DEFAULT nextval('production.productphoto_productphotoid_seq'::regclass);


--
-- Name: productreview productreviewid; Type: DEFAULT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productreview ALTER COLUMN productreviewid SET DEFAULT nextval('production.productreview_productreviewid_seq'::regclass);


--
-- Name: productsubcategory productsubcategoryid; Type: DEFAULT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productsubcategory ALTER COLUMN productsubcategoryid SET DEFAULT nextval('production.productsubcategory_productsubcategoryid_seq'::regclass);


--
-- Name: scrapreason scrapreasonid; Type: DEFAULT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.scrapreason ALTER COLUMN scrapreasonid SET DEFAULT nextval('production.scrapreason_scrapreasonid_seq'::regclass);


--
-- Name: transactionhistory transactionid; Type: DEFAULT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.transactionhistory ALTER COLUMN transactionid SET DEFAULT nextval('production.transactionhistory_transactionid_seq'::regclass);


--
-- Name: workorder workorderid; Type: DEFAULT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.workorder ALTER COLUMN workorderid SET DEFAULT nextval('production.workorder_workorderid_seq'::regclass);


--
-- Name: purchaseorderdetail purchaseorderdetailid; Type: DEFAULT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.purchaseorderdetail ALTER COLUMN purchaseorderdetailid SET DEFAULT nextval('purchasing.purchaseorderdetail_purchaseorderdetailid_seq'::regclass);


--
-- Name: purchaseorderheader purchaseorderid; Type: DEFAULT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.purchaseorderheader ALTER COLUMN purchaseorderid SET DEFAULT nextval('purchasing.purchaseorderheader_purchaseorderid_seq'::regclass);


--
-- Name: shipmethod shipmethodid; Type: DEFAULT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.shipmethod ALTER COLUMN shipmethodid SET DEFAULT nextval('purchasing.shipmethod_shipmethodid_seq'::regclass);


--
-- Name: creditcard creditcardid; Type: DEFAULT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.creditcard ALTER COLUMN creditcardid SET DEFAULT nextval('sales.creditcard_creditcardid_seq'::regclass);


--
-- Name: currencyrate currencyrateid; Type: DEFAULT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.currencyrate ALTER COLUMN currencyrateid SET DEFAULT nextval('sales.currencyrate_currencyrateid_seq'::regclass);


--
-- Name: customer customerid; Type: DEFAULT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.customer ALTER COLUMN customerid SET DEFAULT nextval('sales.customer_customerid_seq'::regclass);


--
-- Name: salesorderdetail salesorderdetailid; Type: DEFAULT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderdetail ALTER COLUMN salesorderdetailid SET DEFAULT nextval('sales.salesorderdetail_salesorderdetailid_seq'::regclass);


--
-- Name: salesorderheader salesorderid; Type: DEFAULT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderheader ALTER COLUMN salesorderid SET DEFAULT nextval('sales.salesorderheader_salesorderid_seq'::regclass);


--
-- Name: salesreason salesreasonid; Type: DEFAULT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesreason ALTER COLUMN salesreasonid SET DEFAULT nextval('sales.salesreason_salesreasonid_seq'::regclass);


--
-- Name: salestaxrate salestaxrateid; Type: DEFAULT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salestaxrate ALTER COLUMN salestaxrateid SET DEFAULT nextval('sales.salestaxrate_salestaxrateid_seq'::regclass);


--
-- Name: salesterritory territoryid; Type: DEFAULT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesterritory ALTER COLUMN territoryid SET DEFAULT nextval('sales.salesterritory_territoryid_seq'::regclass);


--
-- Name: shoppingcartitem shoppingcartitemid; Type: DEFAULT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.shoppingcartitem ALTER COLUMN shoppingcartitemid SET DEFAULT nextval('sales.shoppingcartitem_shoppingcartitemid_seq'::regclass);


--
-- Name: specialoffer specialofferid; Type: DEFAULT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.specialoffer ALTER COLUMN specialofferid SET DEFAULT nextval('sales.specialoffer_specialofferid_seq'::regclass);


--
-- Name: department PK_Department_DepartmentID; Type: CONSTRAINT; Schema: humanresources; Owner: timchapman
--

ALTER TABLE ONLY humanresources.department
    ADD CONSTRAINT "PK_Department_DepartmentID" PRIMARY KEY (departmentid);

ALTER TABLE humanresources.department CLUSTER ON "PK_Department_DepartmentID";


--
-- Name: employeedepartmenthistory PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_Departm; Type: CONSTRAINT; Schema: humanresources; Owner: timchapman
--

ALTER TABLE ONLY humanresources.employeedepartmenthistory
    ADD CONSTRAINT "PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_Departm" PRIMARY KEY (businessentityid, startdate, departmentid, shiftid);

ALTER TABLE humanresources.employeedepartmenthistory CLUSTER ON "PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_Departm";


--
-- Name: employeepayhistory PK_EmployeePayHistory_BusinessEntityID_RateChangeDate; Type: CONSTRAINT; Schema: humanresources; Owner: timchapman
--

ALTER TABLE ONLY humanresources.employeepayhistory
    ADD CONSTRAINT "PK_EmployeePayHistory_BusinessEntityID_RateChangeDate" PRIMARY KEY (businessentityid, ratechangedate);

ALTER TABLE humanresources.employeepayhistory CLUSTER ON "PK_EmployeePayHistory_BusinessEntityID_RateChangeDate";


--
-- Name: employee PK_Employee_BusinessEntityID; Type: CONSTRAINT; Schema: humanresources; Owner: timchapman
--

ALTER TABLE ONLY humanresources.employee
    ADD CONSTRAINT "PK_Employee_BusinessEntityID" PRIMARY KEY (businessentityid);

ALTER TABLE humanresources.employee CLUSTER ON "PK_Employee_BusinessEntityID";


--
-- Name: jobcandidate PK_JobCandidate_JobCandidateID; Type: CONSTRAINT; Schema: humanresources; Owner: timchapman
--

ALTER TABLE ONLY humanresources.jobcandidate
    ADD CONSTRAINT "PK_JobCandidate_JobCandidateID" PRIMARY KEY (jobcandidateid);

ALTER TABLE humanresources.jobcandidate CLUSTER ON "PK_JobCandidate_JobCandidateID";


--
-- Name: shift PK_Shift_ShiftID; Type: CONSTRAINT; Schema: humanresources; Owner: timchapman
--

ALTER TABLE ONLY humanresources.shift
    ADD CONSTRAINT "PK_Shift_ShiftID" PRIMARY KEY (shiftid);

ALTER TABLE humanresources.shift CLUSTER ON "PK_Shift_ShiftID";


--
-- Name: addresstype PK_AddressType_AddressTypeID; Type: CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.addresstype
    ADD CONSTRAINT "PK_AddressType_AddressTypeID" PRIMARY KEY (addresstypeid);

ALTER TABLE person.addresstype CLUSTER ON "PK_AddressType_AddressTypeID";


--
-- Name: address PK_Address_AddressID; Type: CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.address
    ADD CONSTRAINT "PK_Address_AddressID" PRIMARY KEY (addressid);

ALTER TABLE person.address CLUSTER ON "PK_Address_AddressID";


--
-- Name: businessentityaddress PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressType; Type: CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.businessentityaddress
    ADD CONSTRAINT "PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressType" PRIMARY KEY (businessentityid, addressid, addresstypeid);

ALTER TABLE person.businessentityaddress CLUSTER ON "PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressType";


--
-- Name: businessentitycontact PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeI; Type: CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.businessentitycontact
    ADD CONSTRAINT "PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeI" PRIMARY KEY (businessentityid, personid, contacttypeid);

ALTER TABLE person.businessentitycontact CLUSTER ON "PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeI";


--
-- Name: businessentity PK_BusinessEntity_BusinessEntityID; Type: CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.businessentity
    ADD CONSTRAINT "PK_BusinessEntity_BusinessEntityID" PRIMARY KEY (businessentityid);

ALTER TABLE person.businessentity CLUSTER ON "PK_BusinessEntity_BusinessEntityID";


--
-- Name: contacttype PK_ContactType_ContactTypeID; Type: CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.contacttype
    ADD CONSTRAINT "PK_ContactType_ContactTypeID" PRIMARY KEY (contacttypeid);

ALTER TABLE person.contacttype CLUSTER ON "PK_ContactType_ContactTypeID";


--
-- Name: countryregion PK_CountryRegion_CountryRegionCode; Type: CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.countryregion
    ADD CONSTRAINT "PK_CountryRegion_CountryRegionCode" PRIMARY KEY (countryregioncode);

ALTER TABLE person.countryregion CLUSTER ON "PK_CountryRegion_CountryRegionCode";


--
-- Name: emailaddress PK_EmailAddress_BusinessEntityID_EmailAddressID; Type: CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.emailaddress
    ADD CONSTRAINT "PK_EmailAddress_BusinessEntityID_EmailAddressID" PRIMARY KEY (businessentityid, emailaddressid);

ALTER TABLE person.emailaddress CLUSTER ON "PK_EmailAddress_BusinessEntityID_EmailAddressID";


--
-- Name: password PK_Password_BusinessEntityID; Type: CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.password
    ADD CONSTRAINT "PK_Password_BusinessEntityID" PRIMARY KEY (businessentityid);

ALTER TABLE person.password CLUSTER ON "PK_Password_BusinessEntityID";


--
-- Name: personphone PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID; Type: CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.personphone
    ADD CONSTRAINT "PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID" PRIMARY KEY (businessentityid, phonenumber, phonenumbertypeid);

ALTER TABLE person.personphone CLUSTER ON "PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID";


--
-- Name: person PK_Person_BusinessEntityID; Type: CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.person
    ADD CONSTRAINT "PK_Person_BusinessEntityID" PRIMARY KEY (businessentityid);

ALTER TABLE person.person CLUSTER ON "PK_Person_BusinessEntityID";


--
-- Name: phonenumbertype PK_PhoneNumberType_PhoneNumberTypeID; Type: CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.phonenumbertype
    ADD CONSTRAINT "PK_PhoneNumberType_PhoneNumberTypeID" PRIMARY KEY (phonenumbertypeid);

ALTER TABLE person.phonenumbertype CLUSTER ON "PK_PhoneNumberType_PhoneNumberTypeID";


--
-- Name: stateprovince PK_StateProvince_StateProvinceID; Type: CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.stateprovince
    ADD CONSTRAINT "PK_StateProvince_StateProvinceID" PRIMARY KEY (stateprovinceid);

ALTER TABLE person.stateprovince CLUSTER ON "PK_StateProvince_StateProvinceID";


--
-- Name: billofmaterials PK_BillOfMaterials_BillOfMaterialsID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.billofmaterials
    ADD CONSTRAINT "PK_BillOfMaterials_BillOfMaterialsID" PRIMARY KEY (billofmaterialsid);


--
-- Name: culture PK_Culture_CultureID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.culture
    ADD CONSTRAINT "PK_Culture_CultureID" PRIMARY KEY (cultureid);

ALTER TABLE production.culture CLUSTER ON "PK_Culture_CultureID";


--
-- Name: document PK_Document_DocumentNode; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.document
    ADD CONSTRAINT "PK_Document_DocumentNode" PRIMARY KEY (documentnode);

ALTER TABLE production.document CLUSTER ON "PK_Document_DocumentNode";


--
-- Name: illustration PK_Illustration_IllustrationID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.illustration
    ADD CONSTRAINT "PK_Illustration_IllustrationID" PRIMARY KEY (illustrationid);

ALTER TABLE production.illustration CLUSTER ON "PK_Illustration_IllustrationID";


--
-- Name: location PK_Location_LocationID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.location
    ADD CONSTRAINT "PK_Location_LocationID" PRIMARY KEY (locationid);

ALTER TABLE production.location CLUSTER ON "PK_Location_LocationID";


--
-- Name: productcategory PK_ProductCategory_ProductCategoryID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productcategory
    ADD CONSTRAINT "PK_ProductCategory_ProductCategoryID" PRIMARY KEY (productcategoryid);

ALTER TABLE production.productcategory CLUSTER ON "PK_ProductCategory_ProductCategoryID";


--
-- Name: productcosthistory PK_ProductCostHistory_ProductID_StartDate; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productcosthistory
    ADD CONSTRAINT "PK_ProductCostHistory_ProductID_StartDate" PRIMARY KEY (productid, startdate);

ALTER TABLE production.productcosthistory CLUSTER ON "PK_ProductCostHistory_ProductID_StartDate";


--
-- Name: productdescription PK_ProductDescription_ProductDescriptionID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productdescription
    ADD CONSTRAINT "PK_ProductDescription_ProductDescriptionID" PRIMARY KEY (productdescriptionid);

ALTER TABLE production.productdescription CLUSTER ON "PK_ProductDescription_ProductDescriptionID";


--
-- Name: productdocument PK_ProductDocument_ProductID_DocumentNode; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productdocument
    ADD CONSTRAINT "PK_ProductDocument_ProductID_DocumentNode" PRIMARY KEY (productid, documentnode);

ALTER TABLE production.productdocument CLUSTER ON "PK_ProductDocument_ProductID_DocumentNode";


--
-- Name: productinventory PK_ProductInventory_ProductID_LocationID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productinventory
    ADD CONSTRAINT "PK_ProductInventory_ProductID_LocationID" PRIMARY KEY (productid, locationid);

ALTER TABLE production.productinventory CLUSTER ON "PK_ProductInventory_ProductID_LocationID";


--
-- Name: productlistpricehistory PK_ProductListPriceHistory_ProductID_StartDate; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productlistpricehistory
    ADD CONSTRAINT "PK_ProductListPriceHistory_ProductID_StartDate" PRIMARY KEY (productid, startdate);

ALTER TABLE production.productlistpricehistory CLUSTER ON "PK_ProductListPriceHistory_ProductID_StartDate";


--
-- Name: productmodelillustration PK_ProductModelIllustration_ProductModelID_IllustrationID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productmodelillustration
    ADD CONSTRAINT "PK_ProductModelIllustration_ProductModelID_IllustrationID" PRIMARY KEY (productmodelid, illustrationid);

ALTER TABLE production.productmodelillustration CLUSTER ON "PK_ProductModelIllustration_ProductModelID_IllustrationID";


--
-- Name: productmodelproductdescriptionculture PK_ProductModelProductDescriptionCulture_ProductModelID_Product; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productmodelproductdescriptionculture
    ADD CONSTRAINT "PK_ProductModelProductDescriptionCulture_ProductModelID_Product" PRIMARY KEY (productmodelid, productdescriptionid, cultureid);

ALTER TABLE production.productmodelproductdescriptionculture CLUSTER ON "PK_ProductModelProductDescriptionCulture_ProductModelID_Product";


--
-- Name: productmodel PK_ProductModel_ProductModelID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productmodel
    ADD CONSTRAINT "PK_ProductModel_ProductModelID" PRIMARY KEY (productmodelid);

ALTER TABLE production.productmodel CLUSTER ON "PK_ProductModel_ProductModelID";


--
-- Name: productphoto PK_ProductPhoto_ProductPhotoID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productphoto
    ADD CONSTRAINT "PK_ProductPhoto_ProductPhotoID" PRIMARY KEY (productphotoid);

ALTER TABLE production.productphoto CLUSTER ON "PK_ProductPhoto_ProductPhotoID";


--
-- Name: productproductphoto PK_ProductProductPhoto_ProductID_ProductPhotoID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productproductphoto
    ADD CONSTRAINT "PK_ProductProductPhoto_ProductID_ProductPhotoID" PRIMARY KEY (productid, productphotoid);


--
-- Name: productreview PK_ProductReview_ProductReviewID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productreview
    ADD CONSTRAINT "PK_ProductReview_ProductReviewID" PRIMARY KEY (productreviewid);

ALTER TABLE production.productreview CLUSTER ON "PK_ProductReview_ProductReviewID";


--
-- Name: productsubcategory PK_ProductSubcategory_ProductSubcategoryID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productsubcategory
    ADD CONSTRAINT "PK_ProductSubcategory_ProductSubcategoryID" PRIMARY KEY (productsubcategoryid);

ALTER TABLE production.productsubcategory CLUSTER ON "PK_ProductSubcategory_ProductSubcategoryID";


--
-- Name: product PK_Product_ProductID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.product
    ADD CONSTRAINT "PK_Product_ProductID" PRIMARY KEY (productid);

ALTER TABLE production.product CLUSTER ON "PK_Product_ProductID";


--
-- Name: scrapreason PK_ScrapReason_ScrapReasonID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.scrapreason
    ADD CONSTRAINT "PK_ScrapReason_ScrapReasonID" PRIMARY KEY (scrapreasonid);

ALTER TABLE production.scrapreason CLUSTER ON "PK_ScrapReason_ScrapReasonID";


--
-- Name: transactionhistoryarchive PK_TransactionHistoryArchive_TransactionID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.transactionhistoryarchive
    ADD CONSTRAINT "PK_TransactionHistoryArchive_TransactionID" PRIMARY KEY (transactionid);

ALTER TABLE production.transactionhistoryarchive CLUSTER ON "PK_TransactionHistoryArchive_TransactionID";


--
-- Name: transactionhistory PK_TransactionHistory_TransactionID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.transactionhistory
    ADD CONSTRAINT "PK_TransactionHistory_TransactionID" PRIMARY KEY (transactionid);

ALTER TABLE production.transactionhistory CLUSTER ON "PK_TransactionHistory_TransactionID";


--
-- Name: unitmeasure PK_UnitMeasure_UnitMeasureCode; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.unitmeasure
    ADD CONSTRAINT "PK_UnitMeasure_UnitMeasureCode" PRIMARY KEY (unitmeasurecode);

ALTER TABLE production.unitmeasure CLUSTER ON "PK_UnitMeasure_UnitMeasureCode";


--
-- Name: workorderrouting PK_WorkOrderRouting_WorkOrderID_ProductID_OperationSequence; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.workorderrouting
    ADD CONSTRAINT "PK_WorkOrderRouting_WorkOrderID_ProductID_OperationSequence" PRIMARY KEY (workorderid, productid, operationsequence);

ALTER TABLE production.workorderrouting CLUSTER ON "PK_WorkOrderRouting_WorkOrderID_ProductID_OperationSequence";


--
-- Name: workorder PK_WorkOrder_WorkOrderID; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.workorder
    ADD CONSTRAINT "PK_WorkOrder_WorkOrderID" PRIMARY KEY (workorderid);

ALTER TABLE production.workorder CLUSTER ON "PK_WorkOrder_WorkOrderID";


--
-- Name: document document_rowguid_key; Type: CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.document
    ADD CONSTRAINT document_rowguid_key UNIQUE (rowguid);


--
-- Name: productvendor PK_ProductVendor_ProductID_BusinessEntityID; Type: CONSTRAINT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.productvendor
    ADD CONSTRAINT "PK_ProductVendor_ProductID_BusinessEntityID" PRIMARY KEY (productid, businessentityid);

ALTER TABLE purchasing.productvendor CLUSTER ON "PK_ProductVendor_ProductID_BusinessEntityID";


--
-- Name: purchaseorderdetail PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID; Type: CONSTRAINT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.purchaseorderdetail
    ADD CONSTRAINT "PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID" PRIMARY KEY (purchaseorderid, purchaseorderdetailid);

ALTER TABLE purchasing.purchaseorderdetail CLUSTER ON "PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID";


--
-- Name: purchaseorderheader PK_PurchaseOrderHeader_PurchaseOrderID; Type: CONSTRAINT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.purchaseorderheader
    ADD CONSTRAINT "PK_PurchaseOrderHeader_PurchaseOrderID" PRIMARY KEY (purchaseorderid);

ALTER TABLE purchasing.purchaseorderheader CLUSTER ON "PK_PurchaseOrderHeader_PurchaseOrderID";


--
-- Name: shipmethod PK_ShipMethod_ShipMethodID; Type: CONSTRAINT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.shipmethod
    ADD CONSTRAINT "PK_ShipMethod_ShipMethodID" PRIMARY KEY (shipmethodid);

ALTER TABLE purchasing.shipmethod CLUSTER ON "PK_ShipMethod_ShipMethodID";


--
-- Name: vendor PK_Vendor_BusinessEntityID; Type: CONSTRAINT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.vendor
    ADD CONSTRAINT "PK_Vendor_BusinessEntityID" PRIMARY KEY (businessentityid);

ALTER TABLE purchasing.vendor CLUSTER ON "PK_Vendor_BusinessEntityID";


--
-- Name: countryregioncurrency PK_CountryRegionCurrency_CountryRegionCode_CurrencyCode; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.countryregioncurrency
    ADD CONSTRAINT "PK_CountryRegionCurrency_CountryRegionCode_CurrencyCode" PRIMARY KEY (countryregioncode, currencycode);

ALTER TABLE sales.countryregioncurrency CLUSTER ON "PK_CountryRegionCurrency_CountryRegionCode_CurrencyCode";


--
-- Name: creditcard PK_CreditCard_CreditCardID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.creditcard
    ADD CONSTRAINT "PK_CreditCard_CreditCardID" PRIMARY KEY (creditcardid);

ALTER TABLE sales.creditcard CLUSTER ON "PK_CreditCard_CreditCardID";


--
-- Name: currencyrate PK_CurrencyRate_CurrencyRateID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.currencyrate
    ADD CONSTRAINT "PK_CurrencyRate_CurrencyRateID" PRIMARY KEY (currencyrateid);

ALTER TABLE sales.currencyrate CLUSTER ON "PK_CurrencyRate_CurrencyRateID";


--
-- Name: currency PK_Currency_CurrencyCode; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.currency
    ADD CONSTRAINT "PK_Currency_CurrencyCode" PRIMARY KEY (currencycode);

ALTER TABLE sales.currency CLUSTER ON "PK_Currency_CurrencyCode";


--
-- Name: customer PK_Customer_CustomerID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.customer
    ADD CONSTRAINT "PK_Customer_CustomerID" PRIMARY KEY (customerid);

ALTER TABLE sales.customer CLUSTER ON "PK_Customer_CustomerID";


--
-- Name: personcreditcard PK_PersonCreditCard_BusinessEntityID_CreditCardID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.personcreditcard
    ADD CONSTRAINT "PK_PersonCreditCard_BusinessEntityID_CreditCardID" PRIMARY KEY (businessentityid, creditcardid);

ALTER TABLE sales.personcreditcard CLUSTER ON "PK_PersonCreditCard_BusinessEntityID_CreditCardID";


--
-- Name: salesorderdetail PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderdetail
    ADD CONSTRAINT "PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID" PRIMARY KEY (salesorderid, salesorderdetailid);

ALTER TABLE sales.salesorderdetail CLUSTER ON "PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID";


--
-- Name: salesorderheadersalesreason PK_SalesOrderHeaderSalesReason_SalesOrderID_SalesReasonID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderheadersalesreason
    ADD CONSTRAINT "PK_SalesOrderHeaderSalesReason_SalesOrderID_SalesReasonID" PRIMARY KEY (salesorderid, salesreasonid);

ALTER TABLE sales.salesorderheadersalesreason CLUSTER ON "PK_SalesOrderHeaderSalesReason_SalesOrderID_SalesReasonID";


--
-- Name: salesorderheader PK_SalesOrderHeader_SalesOrderID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderheader
    ADD CONSTRAINT "PK_SalesOrderHeader_SalesOrderID" PRIMARY KEY (salesorderid);

ALTER TABLE sales.salesorderheader CLUSTER ON "PK_SalesOrderHeader_SalesOrderID";


--
-- Name: salespersonquotahistory PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salespersonquotahistory
    ADD CONSTRAINT "PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate" PRIMARY KEY (businessentityid, quotadate);

ALTER TABLE sales.salespersonquotahistory CLUSTER ON "PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate";


--
-- Name: salesperson PK_SalesPerson_BusinessEntityID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesperson
    ADD CONSTRAINT "PK_SalesPerson_BusinessEntityID" PRIMARY KEY (businessentityid);

ALTER TABLE sales.salesperson CLUSTER ON "PK_SalesPerson_BusinessEntityID";


--
-- Name: salesreason PK_SalesReason_SalesReasonID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesreason
    ADD CONSTRAINT "PK_SalesReason_SalesReasonID" PRIMARY KEY (salesreasonid);

ALTER TABLE sales.salesreason CLUSTER ON "PK_SalesReason_SalesReasonID";


--
-- Name: salestaxrate PK_SalesTaxRate_SalesTaxRateID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salestaxrate
    ADD CONSTRAINT "PK_SalesTaxRate_SalesTaxRateID" PRIMARY KEY (salestaxrateid);

ALTER TABLE sales.salestaxrate CLUSTER ON "PK_SalesTaxRate_SalesTaxRateID";


--
-- Name: salesterritoryhistory PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesterritoryhistory
    ADD CONSTRAINT "PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID" PRIMARY KEY (businessentityid, startdate, territoryid);

ALTER TABLE sales.salesterritoryhistory CLUSTER ON "PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID";


--
-- Name: salesterritory PK_SalesTerritory_TerritoryID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesterritory
    ADD CONSTRAINT "PK_SalesTerritory_TerritoryID" PRIMARY KEY (territoryid);

ALTER TABLE sales.salesterritory CLUSTER ON "PK_SalesTerritory_TerritoryID";


--
-- Name: shoppingcartitem PK_ShoppingCartItem_ShoppingCartItemID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.shoppingcartitem
    ADD CONSTRAINT "PK_ShoppingCartItem_ShoppingCartItemID" PRIMARY KEY (shoppingcartitemid);

ALTER TABLE sales.shoppingcartitem CLUSTER ON "PK_ShoppingCartItem_ShoppingCartItemID";


--
-- Name: specialofferproduct PK_SpecialOfferProduct_SpecialOfferID_ProductID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.specialofferproduct
    ADD CONSTRAINT "PK_SpecialOfferProduct_SpecialOfferID_ProductID" PRIMARY KEY (specialofferid, productid);

ALTER TABLE sales.specialofferproduct CLUSTER ON "PK_SpecialOfferProduct_SpecialOfferID_ProductID";


--
-- Name: specialoffer PK_SpecialOffer_SpecialOfferID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.specialoffer
    ADD CONSTRAINT "PK_SpecialOffer_SpecialOfferID" PRIMARY KEY (specialofferid);

ALTER TABLE sales.specialoffer CLUSTER ON "PK_SpecialOffer_SpecialOfferID";


--
-- Name: store PK_Store_BusinessEntityID; Type: CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.store
    ADD CONSTRAINT "PK_Store_BusinessEntityID" PRIMARY KEY (businessentityid);

ALTER TABLE sales.store CLUSTER ON "PK_Store_BusinessEntityID";


--
-- Name: AK_Department_Name; Type: INDEX; Schema: humanresources; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Department_Name" ON humanresources.department USING btree (name);


--
-- Name: AK_Employee_LoginID; Type: INDEX; Schema: humanresources; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Employee_LoginID" ON humanresources.employee USING btree (loginid);


--
-- Name: AK_Employee_NationalIDNumber; Type: INDEX; Schema: humanresources; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Employee_NationalIDNumber" ON humanresources.employee USING btree (nationalidnumber);


--
-- Name: AK_Employee_rowguid; Type: INDEX; Schema: humanresources; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Employee_rowguid" ON humanresources.employee USING btree (rowguid);


--
-- Name: AK_Shift_Name; Type: INDEX; Schema: humanresources; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Shift_Name" ON humanresources.shift USING btree (name);


--
-- Name: AK_Shift_StartTime_EndTime; Type: INDEX; Schema: humanresources; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Shift_StartTime_EndTime" ON humanresources.shift USING btree (starttime, endtime);


--
-- Name: IX_EmployeeDepartmentHistory_DepartmentID; Type: INDEX; Schema: humanresources; Owner: timchapman
--

CREATE INDEX "IX_EmployeeDepartmentHistory_DepartmentID" ON humanresources.employeedepartmenthistory USING btree (departmentid);


--
-- Name: IX_EmployeeDepartmentHistory_ShiftID; Type: INDEX; Schema: humanresources; Owner: timchapman
--

CREATE INDEX "IX_EmployeeDepartmentHistory_ShiftID" ON humanresources.employeedepartmenthistory USING btree (shiftid);


--
-- Name: IX_Employee_OrganizationLevel_OrganizationNode; Type: INDEX; Schema: humanresources; Owner: timchapman
--

CREATE INDEX "IX_Employee_OrganizationLevel_OrganizationNode" ON humanresources.employee USING btree (organizationlevel, organizationnode);


--
-- Name: IX_Employee_OrganizationNode; Type: INDEX; Schema: humanresources; Owner: timchapman
--

CREATE INDEX "IX_Employee_OrganizationNode" ON humanresources.employee USING btree (organizationnode);


--
-- Name: IX_JobCandidate_BusinessEntityID; Type: INDEX; Schema: humanresources; Owner: timchapman
--

CREATE INDEX "IX_JobCandidate_BusinessEntityID" ON humanresources.jobcandidate USING btree (businessentityid);


--
-- Name: AK_AddressType_Name; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_AddressType_Name" ON person.addresstype USING btree (name);


--
-- Name: AK_AddressType_rowguid; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_AddressType_rowguid" ON person.addresstype USING btree (rowguid);


--
-- Name: AK_Address_rowguid; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Address_rowguid" ON person.address USING btree (rowguid);


--
-- Name: AK_BusinessEntityAddress_rowguid; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_BusinessEntityAddress_rowguid" ON person.businessentityaddress USING btree (rowguid);


--
-- Name: AK_BusinessEntityContact_rowguid; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_BusinessEntityContact_rowguid" ON person.businessentitycontact USING btree (rowguid);


--
-- Name: AK_BusinessEntity_rowguid; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_BusinessEntity_rowguid" ON person.businessentity USING btree (rowguid);


--
-- Name: AK_ContactType_Name; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_ContactType_Name" ON person.contacttype USING btree (name);


--
-- Name: AK_CountryRegion_Name; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_CountryRegion_Name" ON person.countryregion USING btree (name);


--
-- Name: AK_Person_rowguid; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Person_rowguid" ON person.person USING btree (rowguid);


--
-- Name: AK_StateProvince_Name; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_StateProvince_Name" ON person.stateprovince USING btree (name);


--
-- Name: AK_StateProvince_StateProvinceCode_CountryRegionCode; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_StateProvince_StateProvinceCode_CountryRegionCode" ON person.stateprovince USING btree (stateprovincecode, countryregioncode);


--
-- Name: AK_StateProvince_rowguid; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_StateProvince_rowguid" ON person.stateprovince USING btree (rowguid);


--
-- Name: IX_Address_AddressLine1_AddressLine2_CSZ; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE UNIQUE INDEX "IX_Address_AddressLine1_AddressLine2_CSZ" ON person.address USING btree (addressline1, addressline2, city, stateprovinceid, postalcode);


--
-- Name: IX_Address_StateProvinceID; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE INDEX "IX_Address_StateProvinceID" ON person.address USING btree (stateprovinceid);


--
-- Name: IX_BusinessEntityAddress_AddressID; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE INDEX "IX_BusinessEntityAddress_AddressID" ON person.businessentityaddress USING btree (addressid);


--
-- Name: IX_BusinessEntityAddress_AddressTypeID; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE INDEX "IX_BusinessEntityAddress_AddressTypeID" ON person.businessentityaddress USING btree (addresstypeid);


--
-- Name: IX_BusinessEntityContact_ContactTypeID; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE INDEX "IX_BusinessEntityContact_ContactTypeID" ON person.businessentitycontact USING btree (contacttypeid);


--
-- Name: IX_BusinessEntityContact_PersonID; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE INDEX "IX_BusinessEntityContact_PersonID" ON person.businessentitycontact USING btree (personid);


--
-- Name: IX_EmailAddress_EmailAddress; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE INDEX "IX_EmailAddress_EmailAddress" ON person.emailaddress USING btree (emailaddress);


--
-- Name: IX_PersonPhone_PhoneNumber; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE INDEX "IX_PersonPhone_PhoneNumber" ON person.personphone USING btree (phonenumber);


--
-- Name: IX_Person_LastName_FirstName_MiddleName; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE INDEX "IX_Person_LastName_FirstName_MiddleName" ON person.person USING btree (lastname, firstname, middlename);


--
-- Name: ix_vstateprovincecountryregion; Type: INDEX; Schema: person; Owner: timchapman
--

CREATE UNIQUE INDEX ix_vstateprovincecountryregion ON person.vstateprovincecountryregion USING btree (stateprovinceid, countryregioncode);

ALTER TABLE person.vstateprovincecountryregion CLUSTER ON ix_vstateprovincecountryregion;


--
-- Name: AK_Culture_Name; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Culture_Name" ON production.culture USING btree (name);


--
-- Name: AK_Document_DocumentLevel_DocumentNode; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Document_DocumentLevel_DocumentNode" ON production.document USING btree (documentlevel, documentnode);


--
-- Name: AK_Document_rowguid; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Document_rowguid" ON production.document USING btree (rowguid);


--
-- Name: AK_Location_Name; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Location_Name" ON production.location USING btree (name);


--
-- Name: AK_ProductCategory_Name; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_ProductCategory_Name" ON production.productcategory USING btree (name);


--
-- Name: AK_ProductCategory_rowguid; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_ProductCategory_rowguid" ON production.productcategory USING btree (rowguid);


--
-- Name: AK_ProductDescription_rowguid; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_ProductDescription_rowguid" ON production.productdescription USING btree (rowguid);


--
-- Name: AK_ProductModel_Name; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_ProductModel_Name" ON production.productmodel USING btree (name);


--
-- Name: AK_ProductModel_rowguid; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_ProductModel_rowguid" ON production.productmodel USING btree (rowguid);


--
-- Name: AK_ProductSubcategory_Name; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_ProductSubcategory_Name" ON production.productsubcategory USING btree (name);


--
-- Name: AK_ProductSubcategory_rowguid; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_ProductSubcategory_rowguid" ON production.productsubcategory USING btree (rowguid);


--
-- Name: AK_Product_Name; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Product_Name" ON production.product USING btree (name);


--
-- Name: AK_Product_ProductNumber; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Product_ProductNumber" ON production.product USING btree (productnumber);


--
-- Name: AK_Product_rowguid; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Product_rowguid" ON production.product USING btree (rowguid);


--
-- Name: AK_ScrapReason_Name; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_ScrapReason_Name" ON production.scrapreason USING btree (name);


--
-- Name: AK_UnitMeasure_Name; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_UnitMeasure_Name" ON production.unitmeasure USING btree (name);


--
-- Name: IX_BillOfMaterials_UnitMeasureCode; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE INDEX "IX_BillOfMaterials_UnitMeasureCode" ON production.billofmaterials USING btree (unitmeasurecode);


--
-- Name: IX_Document_FileName_Revision; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE INDEX "IX_Document_FileName_Revision" ON production.document USING btree (filename, revision);


--
-- Name: IX_ProductReview_ProductID_Name; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE INDEX "IX_ProductReview_ProductID_Name" ON production.productreview USING btree (productid, reviewername) INCLUDE (comments);


--
-- Name: IX_TransactionHistoryArchive_Keys; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE INDEX "IX_TransactionHistoryArchive_Keys" ON production.transactionhistoryarchive USING btree (referenceorderid, referenceorderlineid);


--
-- Name: IX_TransactionHistoryArchive_ProductID; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE INDEX "IX_TransactionHistoryArchive_ProductID" ON production.transactionhistoryarchive USING btree (productid);


--
-- Name: IX_TransactionHistory_ProductID; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE INDEX "IX_TransactionHistory_ProductID" ON production.transactionhistory USING btree (productid);


--
-- Name: IX_TransactionHistory_ReferenceOrderID_ReferenceOrderLineID; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE INDEX "IX_TransactionHistory_ReferenceOrderID_ReferenceOrderLineID" ON production.transactionhistory USING btree (referenceorderid, referenceorderlineid);


--
-- Name: IX_WorkOrderRouting_ProductID; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE INDEX "IX_WorkOrderRouting_ProductID" ON production.workorderrouting USING btree (productid);


--
-- Name: IX_WorkOrder_ProductID; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE INDEX "IX_WorkOrder_ProductID" ON production.workorder USING btree (productid);


--
-- Name: IX_WorkOrder_ScrapReasonID; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE INDEX "IX_WorkOrder_ScrapReasonID" ON production.workorder USING btree (scrapreasonid);


--
-- Name: ix_vproductanddescription; Type: INDEX; Schema: production; Owner: timchapman
--

CREATE UNIQUE INDEX ix_vproductanddescription ON production.vproductanddescription USING btree (cultureid, productid);

ALTER TABLE production.vproductanddescription CLUSTER ON ix_vproductanddescription;


--
-- Name: AK_ShipMethod_Name; Type: INDEX; Schema: purchasing; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_ShipMethod_Name" ON purchasing.shipmethod USING btree (name);


--
-- Name: AK_ShipMethod_rowguid; Type: INDEX; Schema: purchasing; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_ShipMethod_rowguid" ON purchasing.shipmethod USING btree (rowguid);


--
-- Name: AK_Vendor_AccountNumber; Type: INDEX; Schema: purchasing; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Vendor_AccountNumber" ON purchasing.vendor USING btree (accountnumber);


--
-- Name: IX_ProductVendor_BusinessEntityID; Type: INDEX; Schema: purchasing; Owner: timchapman
--

CREATE INDEX "IX_ProductVendor_BusinessEntityID" ON purchasing.productvendor USING btree (businessentityid);


--
-- Name: IX_ProductVendor_UnitMeasureCode; Type: INDEX; Schema: purchasing; Owner: timchapman
--

CREATE INDEX "IX_ProductVendor_UnitMeasureCode" ON purchasing.productvendor USING btree (unitmeasurecode);


--
-- Name: IX_PurchaseOrderDetail_ProductID; Type: INDEX; Schema: purchasing; Owner: timchapman
--

CREATE INDEX "IX_PurchaseOrderDetail_ProductID" ON purchasing.purchaseorderdetail USING btree (productid);


--
-- Name: IX_PurchaseOrderHeader_EmployeeID; Type: INDEX; Schema: purchasing; Owner: timchapman
--

CREATE INDEX "IX_PurchaseOrderHeader_EmployeeID" ON purchasing.purchaseorderheader USING btree (employeeid);


--
-- Name: IX_PurchaseOrderHeader_VendorID; Type: INDEX; Schema: purchasing; Owner: timchapman
--

CREATE INDEX "IX_PurchaseOrderHeader_VendorID" ON purchasing.purchaseorderheader USING btree (vendorid);


--
-- Name: AK_CreditCard_CardNumber; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_CreditCard_CardNumber" ON sales.creditcard USING btree (cardnumber);


--
-- Name: AK_CurrencyRate_CurrencyRateDate_Keys; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_CurrencyRate_CurrencyRateDate_Keys" ON sales.currencyrate USING btree (currencyratedate, fromcurrencycode, tocurrencycode);


--
-- Name: AK_Currency_Name; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Currency_Name" ON sales.currency USING btree (name);


--
-- Name: AK_Customer_AccountNumber; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Customer_AccountNumber" ON sales.customer USING btree (accountnumber);


--
-- Name: AK_Customer_rowguid; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Customer_rowguid" ON sales.customer USING btree (rowguid);


--
-- Name: AK_SalesOrderDetail_rowguid; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_SalesOrderDetail_rowguid" ON sales.salesorderdetail USING btree (rowguid);


--
-- Name: AK_SalesOrderHeader_SalesOrderNumber; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_SalesOrderHeader_SalesOrderNumber" ON sales.salesorderheader USING btree (salesordernumber);


--
-- Name: AK_SalesOrderHeader_rowguid; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_SalesOrderHeader_rowguid" ON sales.salesorderheader USING btree (rowguid);


--
-- Name: AK_SalesPersonQuotaHistory_rowguid; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_SalesPersonQuotaHistory_rowguid" ON sales.salespersonquotahistory USING btree (rowguid);


--
-- Name: AK_SalesPerson_rowguid; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_SalesPerson_rowguid" ON sales.salesperson USING btree (rowguid);


--
-- Name: AK_SalesTaxRate_StateProvinceID_TaxType; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_SalesTaxRate_StateProvinceID_TaxType" ON sales.salestaxrate USING btree (stateprovinceid, taxtype);


--
-- Name: AK_SalesTaxRate_rowguid; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_SalesTaxRate_rowguid" ON sales.salestaxrate USING btree (rowguid);


--
-- Name: AK_SalesTerritoryHistory_rowguid; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_SalesTerritoryHistory_rowguid" ON sales.salesterritoryhistory USING btree (rowguid);


--
-- Name: AK_SalesTerritory_Name; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_SalesTerritory_Name" ON sales.salesterritory USING btree (name);


--
-- Name: AK_SalesTerritory_rowguid; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_SalesTerritory_rowguid" ON sales.salesterritory USING btree (rowguid);


--
-- Name: AK_SpecialOfferProduct_rowguid; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_SpecialOfferProduct_rowguid" ON sales.specialofferproduct USING btree (rowguid);


--
-- Name: AK_SpecialOffer_rowguid; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_SpecialOffer_rowguid" ON sales.specialoffer USING btree (rowguid);


--
-- Name: AK_Store_rowguid; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE UNIQUE INDEX "AK_Store_rowguid" ON sales.store USING btree (rowguid);


--
-- Name: IX_CountryRegionCurrency_CurrencyCode; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE INDEX "IX_CountryRegionCurrency_CurrencyCode" ON sales.countryregioncurrency USING btree (currencycode);


--
-- Name: IX_Customer_TerritoryID; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE INDEX "IX_Customer_TerritoryID" ON sales.customer USING btree (territoryid);


--
-- Name: IX_SalesOrderDetail_ProductID; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE INDEX "IX_SalesOrderDetail_ProductID" ON sales.salesorderdetail USING btree (productid);


--
-- Name: IX_SalesOrderHeader_CustomerID; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE INDEX "IX_SalesOrderHeader_CustomerID" ON sales.salesorderheader USING btree (customerid);


--
-- Name: IX_SalesOrderHeader_SalesPersonID; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE INDEX "IX_SalesOrderHeader_SalesPersonID" ON sales.salesorderheader USING btree (salespersonid);


--
-- Name: IX_ShoppingCartItem_ShoppingCartID_ProductID; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE INDEX "IX_ShoppingCartItem_ShoppingCartID_ProductID" ON sales.shoppingcartitem USING btree (shoppingcartid, productid);


--
-- Name: IX_SpecialOfferProduct_ProductID; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE INDEX "IX_SpecialOfferProduct_ProductID" ON sales.specialofferproduct USING btree (productid);


--
-- Name: IX_Store_SalesPersonID; Type: INDEX; Schema: sales; Owner: timchapman
--

CREATE INDEX "IX_Store_SalesPersonID" ON sales.store USING btree (salespersonid);


--
-- Name: employeedepartmenthistory FK_EmployeeDepartmentHistory_Department_DepartmentID; Type: FK CONSTRAINT; Schema: humanresources; Owner: timchapman
--

ALTER TABLE ONLY humanresources.employeedepartmenthistory
    ADD CONSTRAINT "FK_EmployeeDepartmentHistory_Department_DepartmentID" FOREIGN KEY (departmentid) REFERENCES humanresources.department(departmentid);


--
-- Name: employeedepartmenthistory FK_EmployeeDepartmentHistory_Employee_BusinessEntityID; Type: FK CONSTRAINT; Schema: humanresources; Owner: timchapman
--

ALTER TABLE ONLY humanresources.employeedepartmenthistory
    ADD CONSTRAINT "FK_EmployeeDepartmentHistory_Employee_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES humanresources.employee(businessentityid);


--
-- Name: employeedepartmenthistory FK_EmployeeDepartmentHistory_Shift_ShiftID; Type: FK CONSTRAINT; Schema: humanresources; Owner: timchapman
--

ALTER TABLE ONLY humanresources.employeedepartmenthistory
    ADD CONSTRAINT "FK_EmployeeDepartmentHistory_Shift_ShiftID" FOREIGN KEY (shiftid) REFERENCES humanresources.shift(shiftid);


--
-- Name: employeepayhistory FK_EmployeePayHistory_Employee_BusinessEntityID; Type: FK CONSTRAINT; Schema: humanresources; Owner: timchapman
--

ALTER TABLE ONLY humanresources.employeepayhistory
    ADD CONSTRAINT "FK_EmployeePayHistory_Employee_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES humanresources.employee(businessentityid);


--
-- Name: employee FK_Employee_Person_BusinessEntityID; Type: FK CONSTRAINT; Schema: humanresources; Owner: timchapman
--

ALTER TABLE ONLY humanresources.employee
    ADD CONSTRAINT "FK_Employee_Person_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES person.person(businessentityid);


--
-- Name: jobcandidate FK_JobCandidate_Employee_BusinessEntityID; Type: FK CONSTRAINT; Schema: humanresources; Owner: timchapman
--

ALTER TABLE ONLY humanresources.jobcandidate
    ADD CONSTRAINT "FK_JobCandidate_Employee_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES humanresources.employee(businessentityid);


--
-- Name: address FK_Address_StateProvince_StateProvinceID; Type: FK CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.address
    ADD CONSTRAINT "FK_Address_StateProvince_StateProvinceID" FOREIGN KEY (stateprovinceid) REFERENCES person.stateprovince(stateprovinceid);


--
-- Name: businessentityaddress FK_BusinessEntityAddress_AddressType_AddressTypeID; Type: FK CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.businessentityaddress
    ADD CONSTRAINT "FK_BusinessEntityAddress_AddressType_AddressTypeID" FOREIGN KEY (addresstypeid) REFERENCES person.addresstype(addresstypeid);


--
-- Name: businessentityaddress FK_BusinessEntityAddress_Address_AddressID; Type: FK CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.businessentityaddress
    ADD CONSTRAINT "FK_BusinessEntityAddress_Address_AddressID" FOREIGN KEY (addressid) REFERENCES person.address(addressid);


--
-- Name: businessentityaddress FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID; Type: FK CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.businessentityaddress
    ADD CONSTRAINT "FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES person.businessentity(businessentityid);


--
-- Name: businessentitycontact FK_BusinessEntityContact_BusinessEntity_BusinessEntityID; Type: FK CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.businessentitycontact
    ADD CONSTRAINT "FK_BusinessEntityContact_BusinessEntity_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES person.businessentity(businessentityid);


--
-- Name: businessentitycontact FK_BusinessEntityContact_ContactType_ContactTypeID; Type: FK CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.businessentitycontact
    ADD CONSTRAINT "FK_BusinessEntityContact_ContactType_ContactTypeID" FOREIGN KEY (contacttypeid) REFERENCES person.contacttype(contacttypeid);


--
-- Name: businessentitycontact FK_BusinessEntityContact_Person_PersonID; Type: FK CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.businessentitycontact
    ADD CONSTRAINT "FK_BusinessEntityContact_Person_PersonID" FOREIGN KEY (personid) REFERENCES person.person(businessentityid);


--
-- Name: emailaddress FK_EmailAddress_Person_BusinessEntityID; Type: FK CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.emailaddress
    ADD CONSTRAINT "FK_EmailAddress_Person_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES person.person(businessentityid);


--
-- Name: password FK_Password_Person_BusinessEntityID; Type: FK CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.password
    ADD CONSTRAINT "FK_Password_Person_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES person.person(businessentityid);


--
-- Name: personphone FK_PersonPhone_Person_BusinessEntityID; Type: FK CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.personphone
    ADD CONSTRAINT "FK_PersonPhone_Person_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES person.person(businessentityid);


--
-- Name: personphone FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID; Type: FK CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.personphone
    ADD CONSTRAINT "FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID" FOREIGN KEY (phonenumbertypeid) REFERENCES person.phonenumbertype(phonenumbertypeid);


--
-- Name: person FK_Person_BusinessEntity_BusinessEntityID; Type: FK CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.person
    ADD CONSTRAINT "FK_Person_BusinessEntity_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES person.businessentity(businessentityid);


--
-- Name: stateprovince FK_StateProvince_CountryRegion_CountryRegionCode; Type: FK CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.stateprovince
    ADD CONSTRAINT "FK_StateProvince_CountryRegion_CountryRegionCode" FOREIGN KEY (countryregioncode) REFERENCES person.countryregion(countryregioncode);


--
-- Name: stateprovince FK_StateProvince_SalesTerritory_TerritoryID; Type: FK CONSTRAINT; Schema: person; Owner: timchapman
--

ALTER TABLE ONLY person.stateprovince
    ADD CONSTRAINT "FK_StateProvince_SalesTerritory_TerritoryID" FOREIGN KEY (territoryid) REFERENCES sales.salesterritory(territoryid);


--
-- Name: billofmaterials FK_BillOfMaterials_Product_ComponentID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.billofmaterials
    ADD CONSTRAINT "FK_BillOfMaterials_Product_ComponentID" FOREIGN KEY (componentid) REFERENCES production.product(productid);


--
-- Name: billofmaterials FK_BillOfMaterials_Product_ProductAssemblyID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.billofmaterials
    ADD CONSTRAINT "FK_BillOfMaterials_Product_ProductAssemblyID" FOREIGN KEY (productassemblyid) REFERENCES production.product(productid);


--
-- Name: billofmaterials FK_BillOfMaterials_UnitMeasure_UnitMeasureCode; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.billofmaterials
    ADD CONSTRAINT "FK_BillOfMaterials_UnitMeasure_UnitMeasureCode" FOREIGN KEY (unitmeasurecode) REFERENCES production.unitmeasure(unitmeasurecode);


--
-- Name: document FK_Document_Employee_Owner; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.document
    ADD CONSTRAINT "FK_Document_Employee_Owner" FOREIGN KEY (owner) REFERENCES humanresources.employee(businessentityid);


--
-- Name: productcosthistory FK_ProductCostHistory_Product_ProductID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productcosthistory
    ADD CONSTRAINT "FK_ProductCostHistory_Product_ProductID" FOREIGN KEY (productid) REFERENCES production.product(productid);


--
-- Name: productdocument FK_ProductDocument_Document_DocumentNode; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productdocument
    ADD CONSTRAINT "FK_ProductDocument_Document_DocumentNode" FOREIGN KEY (documentnode) REFERENCES production.document(documentnode);


--
-- Name: productdocument FK_ProductDocument_Product_ProductID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productdocument
    ADD CONSTRAINT "FK_ProductDocument_Product_ProductID" FOREIGN KEY (productid) REFERENCES production.product(productid);


--
-- Name: productinventory FK_ProductInventory_Location_LocationID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productinventory
    ADD CONSTRAINT "FK_ProductInventory_Location_LocationID" FOREIGN KEY (locationid) REFERENCES production.location(locationid);


--
-- Name: productinventory FK_ProductInventory_Product_ProductID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productinventory
    ADD CONSTRAINT "FK_ProductInventory_Product_ProductID" FOREIGN KEY (productid) REFERENCES production.product(productid);


--
-- Name: productlistpricehistory FK_ProductListPriceHistory_Product_ProductID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productlistpricehistory
    ADD CONSTRAINT "FK_ProductListPriceHistory_Product_ProductID" FOREIGN KEY (productid) REFERENCES production.product(productid);


--
-- Name: productmodelillustration FK_ProductModelIllustration_Illustration_IllustrationID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productmodelillustration
    ADD CONSTRAINT "FK_ProductModelIllustration_Illustration_IllustrationID" FOREIGN KEY (illustrationid) REFERENCES production.illustration(illustrationid);


--
-- Name: productmodelillustration FK_ProductModelIllustration_ProductModel_ProductModelID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productmodelillustration
    ADD CONSTRAINT "FK_ProductModelIllustration_ProductModel_ProductModelID" FOREIGN KEY (productmodelid) REFERENCES production.productmodel(productmodelid);


--
-- Name: productmodelproductdescriptionculture FK_ProductModelProductDescriptionCulture_Culture_CultureID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productmodelproductdescriptionculture
    ADD CONSTRAINT "FK_ProductModelProductDescriptionCulture_Culture_CultureID" FOREIGN KEY (cultureid) REFERENCES production.culture(cultureid);


--
-- Name: productmodelproductdescriptionculture FK_ProductModelProductDescriptionCulture_ProductDescription_Pro; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productmodelproductdescriptionculture
    ADD CONSTRAINT "FK_ProductModelProductDescriptionCulture_ProductDescription_Pro" FOREIGN KEY (productdescriptionid) REFERENCES production.productdescription(productdescriptionid);


--
-- Name: productmodelproductdescriptionculture FK_ProductModelProductDescriptionCulture_ProductModel_ProductMo; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productmodelproductdescriptionculture
    ADD CONSTRAINT "FK_ProductModelProductDescriptionCulture_ProductModel_ProductMo" FOREIGN KEY (productmodelid) REFERENCES production.productmodel(productmodelid);


--
-- Name: productproductphoto FK_ProductProductPhoto_ProductPhoto_ProductPhotoID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productproductphoto
    ADD CONSTRAINT "FK_ProductProductPhoto_ProductPhoto_ProductPhotoID" FOREIGN KEY (productphotoid) REFERENCES production.productphoto(productphotoid);


--
-- Name: productproductphoto FK_ProductProductPhoto_Product_ProductID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productproductphoto
    ADD CONSTRAINT "FK_ProductProductPhoto_Product_ProductID" FOREIGN KEY (productid) REFERENCES production.product(productid);


--
-- Name: productreview FK_ProductReview_Product_ProductID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productreview
    ADD CONSTRAINT "FK_ProductReview_Product_ProductID" FOREIGN KEY (productid) REFERENCES production.product(productid);


--
-- Name: productsubcategory FK_ProductSubcategory_ProductCategory_ProductCategoryID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.productsubcategory
    ADD CONSTRAINT "FK_ProductSubcategory_ProductCategory_ProductCategoryID" FOREIGN KEY (productcategoryid) REFERENCES production.productcategory(productcategoryid);


--
-- Name: product FK_Product_ProductModel_ProductModelID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.product
    ADD CONSTRAINT "FK_Product_ProductModel_ProductModelID" FOREIGN KEY (productmodelid) REFERENCES production.productmodel(productmodelid);


--
-- Name: product FK_Product_ProductSubcategory_ProductSubcategoryID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.product
    ADD CONSTRAINT "FK_Product_ProductSubcategory_ProductSubcategoryID" FOREIGN KEY (productsubcategoryid) REFERENCES production.productsubcategory(productsubcategoryid);


--
-- Name: product FK_Product_UnitMeasure_SizeUnitMeasureCode; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.product
    ADD CONSTRAINT "FK_Product_UnitMeasure_SizeUnitMeasureCode" FOREIGN KEY (sizeunitmeasurecode) REFERENCES production.unitmeasure(unitmeasurecode);


--
-- Name: product FK_Product_UnitMeasure_WeightUnitMeasureCode; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.product
    ADD CONSTRAINT "FK_Product_UnitMeasure_WeightUnitMeasureCode" FOREIGN KEY (weightunitmeasurecode) REFERENCES production.unitmeasure(unitmeasurecode);


--
-- Name: transactionhistory FK_TransactionHistory_Product_ProductID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.transactionhistory
    ADD CONSTRAINT "FK_TransactionHistory_Product_ProductID" FOREIGN KEY (productid) REFERENCES production.product(productid);


--
-- Name: workorderrouting FK_WorkOrderRouting_Location_LocationID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.workorderrouting
    ADD CONSTRAINT "FK_WorkOrderRouting_Location_LocationID" FOREIGN KEY (locationid) REFERENCES production.location(locationid);


--
-- Name: workorderrouting FK_WorkOrderRouting_WorkOrder_WorkOrderID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.workorderrouting
    ADD CONSTRAINT "FK_WorkOrderRouting_WorkOrder_WorkOrderID" FOREIGN KEY (workorderid) REFERENCES production.workorder(workorderid);


--
-- Name: workorder FK_WorkOrder_Product_ProductID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.workorder
    ADD CONSTRAINT "FK_WorkOrder_Product_ProductID" FOREIGN KEY (productid) REFERENCES production.product(productid);


--
-- Name: workorder FK_WorkOrder_ScrapReason_ScrapReasonID; Type: FK CONSTRAINT; Schema: production; Owner: timchapman
--

ALTER TABLE ONLY production.workorder
    ADD CONSTRAINT "FK_WorkOrder_ScrapReason_ScrapReasonID" FOREIGN KEY (scrapreasonid) REFERENCES production.scrapreason(scrapreasonid);


--
-- Name: productvendor FK_ProductVendor_Product_ProductID; Type: FK CONSTRAINT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.productvendor
    ADD CONSTRAINT "FK_ProductVendor_Product_ProductID" FOREIGN KEY (productid) REFERENCES production.product(productid);


--
-- Name: productvendor FK_ProductVendor_UnitMeasure_UnitMeasureCode; Type: FK CONSTRAINT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.productvendor
    ADD CONSTRAINT "FK_ProductVendor_UnitMeasure_UnitMeasureCode" FOREIGN KEY (unitmeasurecode) REFERENCES production.unitmeasure(unitmeasurecode);


--
-- Name: productvendor FK_ProductVendor_Vendor_BusinessEntityID; Type: FK CONSTRAINT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.productvendor
    ADD CONSTRAINT "FK_ProductVendor_Vendor_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES purchasing.vendor(businessentityid);


--
-- Name: purchaseorderdetail FK_PurchaseOrderDetail_Product_ProductID; Type: FK CONSTRAINT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.purchaseorderdetail
    ADD CONSTRAINT "FK_PurchaseOrderDetail_Product_ProductID" FOREIGN KEY (productid) REFERENCES production.product(productid);


--
-- Name: purchaseorderdetail FK_PurchaseOrderDetail_PurchaseOrderHeader_PurchaseOrderID; Type: FK CONSTRAINT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.purchaseorderdetail
    ADD CONSTRAINT "FK_PurchaseOrderDetail_PurchaseOrderHeader_PurchaseOrderID" FOREIGN KEY (purchaseorderid) REFERENCES purchasing.purchaseorderheader(purchaseorderid);


--
-- Name: purchaseorderheader FK_PurchaseOrderHeader_Employee_EmployeeID; Type: FK CONSTRAINT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.purchaseorderheader
    ADD CONSTRAINT "FK_PurchaseOrderHeader_Employee_EmployeeID" FOREIGN KEY (employeeid) REFERENCES humanresources.employee(businessentityid);


--
-- Name: purchaseorderheader FK_PurchaseOrderHeader_ShipMethod_ShipMethodID; Type: FK CONSTRAINT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.purchaseorderheader
    ADD CONSTRAINT "FK_PurchaseOrderHeader_ShipMethod_ShipMethodID" FOREIGN KEY (shipmethodid) REFERENCES purchasing.shipmethod(shipmethodid);


--
-- Name: purchaseorderheader FK_PurchaseOrderHeader_Vendor_VendorID; Type: FK CONSTRAINT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.purchaseorderheader
    ADD CONSTRAINT "FK_PurchaseOrderHeader_Vendor_VendorID" FOREIGN KEY (vendorid) REFERENCES purchasing.vendor(businessentityid);


--
-- Name: vendor FK_Vendor_BusinessEntity_BusinessEntityID; Type: FK CONSTRAINT; Schema: purchasing; Owner: timchapman
--

ALTER TABLE ONLY purchasing.vendor
    ADD CONSTRAINT "FK_Vendor_BusinessEntity_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES person.businessentity(businessentityid);


--
-- Name: countryregioncurrency FK_CountryRegionCurrency_CountryRegion_CountryRegionCode; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.countryregioncurrency
    ADD CONSTRAINT "FK_CountryRegionCurrency_CountryRegion_CountryRegionCode" FOREIGN KEY (countryregioncode) REFERENCES person.countryregion(countryregioncode);


--
-- Name: countryregioncurrency FK_CountryRegionCurrency_Currency_CurrencyCode; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.countryregioncurrency
    ADD CONSTRAINT "FK_CountryRegionCurrency_Currency_CurrencyCode" FOREIGN KEY (currencycode) REFERENCES sales.currency(currencycode);


--
-- Name: currencyrate FK_CurrencyRate_Currency_FromCurrencyCode; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.currencyrate
    ADD CONSTRAINT "FK_CurrencyRate_Currency_FromCurrencyCode" FOREIGN KEY (fromcurrencycode) REFERENCES sales.currency(currencycode);


--
-- Name: currencyrate FK_CurrencyRate_Currency_ToCurrencyCode; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.currencyrate
    ADD CONSTRAINT "FK_CurrencyRate_Currency_ToCurrencyCode" FOREIGN KEY (tocurrencycode) REFERENCES sales.currency(currencycode);


--
-- Name: customer FK_Customer_Person_PersonID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.customer
    ADD CONSTRAINT "FK_Customer_Person_PersonID" FOREIGN KEY (personid) REFERENCES person.person(businessentityid);


--
-- Name: customer FK_Customer_SalesTerritory_TerritoryID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.customer
    ADD CONSTRAINT "FK_Customer_SalesTerritory_TerritoryID" FOREIGN KEY (territoryid) REFERENCES sales.salesterritory(territoryid);


--
-- Name: customer FK_Customer_Store_StoreID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.customer
    ADD CONSTRAINT "FK_Customer_Store_StoreID" FOREIGN KEY (storeid) REFERENCES sales.store(businessentityid);


--
-- Name: personcreditcard FK_PersonCreditCard_CreditCard_CreditCardID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.personcreditcard
    ADD CONSTRAINT "FK_PersonCreditCard_CreditCard_CreditCardID" FOREIGN KEY (creditcardid) REFERENCES sales.creditcard(creditcardid);


--
-- Name: personcreditcard FK_PersonCreditCard_Person_BusinessEntityID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.personcreditcard
    ADD CONSTRAINT "FK_PersonCreditCard_Person_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES person.person(businessentityid);


--
-- Name: salesorderdetail FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderdetail
    ADD CONSTRAINT "FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID" FOREIGN KEY (salesorderid) REFERENCES sales.salesorderheader(salesorderid) ON DELETE CASCADE;


--
-- Name: salesorderdetail FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderdetail
    ADD CONSTRAINT "FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID" FOREIGN KEY (specialofferid, productid) REFERENCES sales.specialofferproduct(specialofferid, productid);


--
-- Name: salesorderheadersalesreason FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderheadersalesreason
    ADD CONSTRAINT "FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID" FOREIGN KEY (salesorderid) REFERENCES sales.salesorderheader(salesorderid) ON DELETE CASCADE;


--
-- Name: salesorderheadersalesreason FK_SalesOrderHeaderSalesReason_SalesReason_SalesReasonID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderheadersalesreason
    ADD CONSTRAINT "FK_SalesOrderHeaderSalesReason_SalesReason_SalesReasonID" FOREIGN KEY (salesreasonid) REFERENCES sales.salesreason(salesreasonid);


--
-- Name: salesorderheader FK_SalesOrderHeader_Address_BillToAddressID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderheader
    ADD CONSTRAINT "FK_SalesOrderHeader_Address_BillToAddressID" FOREIGN KEY (billtoaddressid) REFERENCES person.address(addressid);


--
-- Name: salesorderheader FK_SalesOrderHeader_Address_ShipToAddressID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderheader
    ADD CONSTRAINT "FK_SalesOrderHeader_Address_ShipToAddressID" FOREIGN KEY (shiptoaddressid) REFERENCES person.address(addressid);


--
-- Name: salesorderheader FK_SalesOrderHeader_CreditCard_CreditCardID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderheader
    ADD CONSTRAINT "FK_SalesOrderHeader_CreditCard_CreditCardID" FOREIGN KEY (creditcardid) REFERENCES sales.creditcard(creditcardid);


--
-- Name: salesorderheader FK_SalesOrderHeader_CurrencyRate_CurrencyRateID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderheader
    ADD CONSTRAINT "FK_SalesOrderHeader_CurrencyRate_CurrencyRateID" FOREIGN KEY (currencyrateid) REFERENCES sales.currencyrate(currencyrateid);


--
-- Name: salesorderheader FK_SalesOrderHeader_Customer_CustomerID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderheader
    ADD CONSTRAINT "FK_SalesOrderHeader_Customer_CustomerID" FOREIGN KEY (customerid) REFERENCES sales.customer(customerid);


--
-- Name: salesorderheader FK_SalesOrderHeader_SalesPerson_SalesPersonID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderheader
    ADD CONSTRAINT "FK_SalesOrderHeader_SalesPerson_SalesPersonID" FOREIGN KEY (salespersonid) REFERENCES sales.salesperson(businessentityid);


--
-- Name: salesorderheader FK_SalesOrderHeader_SalesTerritory_TerritoryID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderheader
    ADD CONSTRAINT "FK_SalesOrderHeader_SalesTerritory_TerritoryID" FOREIGN KEY (territoryid) REFERENCES sales.salesterritory(territoryid);


--
-- Name: salesorderheader FK_SalesOrderHeader_ShipMethod_ShipMethodID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesorderheader
    ADD CONSTRAINT "FK_SalesOrderHeader_ShipMethod_ShipMethodID" FOREIGN KEY (shipmethodid) REFERENCES purchasing.shipmethod(shipmethodid);


--
-- Name: salespersonquotahistory FK_SalesPersonQuotaHistory_SalesPerson_BusinessEntityID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salespersonquotahistory
    ADD CONSTRAINT "FK_SalesPersonQuotaHistory_SalesPerson_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES sales.salesperson(businessentityid);


--
-- Name: salesperson FK_SalesPerson_Employee_BusinessEntityID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesperson
    ADD CONSTRAINT "FK_SalesPerson_Employee_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES humanresources.employee(businessentityid);


--
-- Name: salesperson FK_SalesPerson_SalesTerritory_TerritoryID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesperson
    ADD CONSTRAINT "FK_SalesPerson_SalesTerritory_TerritoryID" FOREIGN KEY (territoryid) REFERENCES sales.salesterritory(territoryid);


--
-- Name: salestaxrate FK_SalesTaxRate_StateProvince_StateProvinceID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salestaxrate
    ADD CONSTRAINT "FK_SalesTaxRate_StateProvince_StateProvinceID" FOREIGN KEY (stateprovinceid) REFERENCES person.stateprovince(stateprovinceid);


--
-- Name: salesterritoryhistory FK_SalesTerritoryHistory_SalesPerson_BusinessEntityID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesterritoryhistory
    ADD CONSTRAINT "FK_SalesTerritoryHistory_SalesPerson_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES sales.salesperson(businessentityid);


--
-- Name: salesterritoryhistory FK_SalesTerritoryHistory_SalesTerritory_TerritoryID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesterritoryhistory
    ADD CONSTRAINT "FK_SalesTerritoryHistory_SalesTerritory_TerritoryID" FOREIGN KEY (territoryid) REFERENCES sales.salesterritory(territoryid);


--
-- Name: salesterritory FK_SalesTerritory_CountryRegion_CountryRegionCode; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.salesterritory
    ADD CONSTRAINT "FK_SalesTerritory_CountryRegion_CountryRegionCode" FOREIGN KEY (countryregioncode) REFERENCES person.countryregion(countryregioncode);


--
-- Name: shoppingcartitem FK_ShoppingCartItem_Product_ProductID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.shoppingcartitem
    ADD CONSTRAINT "FK_ShoppingCartItem_Product_ProductID" FOREIGN KEY (productid) REFERENCES production.product(productid);


--
-- Name: specialofferproduct FK_SpecialOfferProduct_Product_ProductID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.specialofferproduct
    ADD CONSTRAINT "FK_SpecialOfferProduct_Product_ProductID" FOREIGN KEY (productid) REFERENCES production.product(productid);


--
-- Name: specialofferproduct FK_SpecialOfferProduct_SpecialOffer_SpecialOfferID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.specialofferproduct
    ADD CONSTRAINT "FK_SpecialOfferProduct_SpecialOffer_SpecialOfferID" FOREIGN KEY (specialofferid) REFERENCES sales.specialoffer(specialofferid);


--
-- Name: store FK_Store_BusinessEntity_BusinessEntityID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.store
    ADD CONSTRAINT "FK_Store_BusinessEntity_BusinessEntityID" FOREIGN KEY (businessentityid) REFERENCES person.businessentity(businessentityid);


--
-- Name: store FK_Store_SalesPerson_SalesPersonID; Type: FK CONSTRAINT; Schema: sales; Owner: timchapman
--

ALTER TABLE ONLY sales.store
    ADD CONSTRAINT "FK_Store_SalesPerson_SalesPersonID" FOREIGN KEY (salespersonid) REFERENCES sales.salesperson(businessentityid);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO azure_pg_admin;


--
-- PostgreSQL database dump complete
--

