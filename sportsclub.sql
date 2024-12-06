--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-12-07 00:27:29 +04

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
-- TOC entry 220 (class 1255 OID 26088)
-- Name: check_reservation_constraints(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_reservation_constraints() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.starttime < NOW() OR NEW.starttime > NOW() + INTERVAL '48 hours' THEN
        RAISE EXCEPTION 'Reservation starttime must be between the current time and the next 48 hours.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM reservation
        WHERE student_id = NEW.student_id
          AND NEW.starttime < endtime + INTERVAL '24 hours'
    ) THEN
        RAISE EXCEPTION 'Student % cannot make a reservation within 24 hours of a previous reservation.', NEW.student_id;
    END IF;

    IF EXISTS (
        SELECT 1
        FROM reservation
        WHERE student_id = NEW.student_id
          AND (
              NEW.starttime < endtime
              AND NEW.endtime > starttime
          )
    ) THEN
        RAISE EXCEPTION 'Student % cannot make overlapping or fully contained reservations.', NEW.student_id;
    END IF;

    IF EXISTS (
        SELECT 1
        FROM reservation
        WHERE stadium_id = NEW.stadium_id
          AND (
              NEW.starttime < endtime
              AND NEW.endtime > starttime
          )
    ) THEN
        RAISE EXCEPTION 'Stadium % cannot be reserved for overlapping times.', NEW.stadium_id;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_reservation_constraints() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 26069)
-- Name: reservation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservation (
    id integer NOT NULL,
    student_id integer NOT NULL,
    stadium_id integer NOT NULL,
    starttime timestamp without time zone NOT NULL,
    endtime timestamp without time zone NOT NULL,
    CONSTRAINT reservation_check CHECK (((endtime - starttime) <= '01:30:00'::interval))
);


ALTER TABLE public.reservation OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 26068)
-- Name: reservation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reservation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reservation_id_seq OWNER TO postgres;

--
-- TOC entry 3623 (class 0 OID 0)
-- Dependencies: 218
-- Name: reservation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reservation_id_seq OWNED BY public.reservation.id;


--
-- TOC entry 217 (class 1259 OID 26061)
-- Name: stadiums; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stadiums (
    id integer NOT NULL,
    capacity integer NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.stadiums OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 26052)
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    student_id integer NOT NULL,
    email character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    lastname character varying(50) NOT NULL,
    phone_number character varying(15) NOT NULL,
    CONSTRAINT students_email_check CHECK (((email)::text ~* '^([a-z]+)\.([a-z]+)@kiu\.edu\.ge$'::text))
);


ALTER TABLE public.students OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 26051)
-- Name: students_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_id_seq OWNER TO postgres;

--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 215
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_id_seq OWNED BY public.students.student_id;


--
-- TOC entry 3454 (class 2604 OID 26072)
-- Name: reservation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation ALTER COLUMN id SET DEFAULT nextval('public.reservation_id_seq'::regclass);


--
-- TOC entry 3453 (class 2604 OID 26055)
-- Name: students student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN student_id SET DEFAULT nextval('public.students_id_seq'::regclass);


--
-- TOC entry 3614 (class 0 OID 26052)
-- Dependencies: 216
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (student_id, email, name, lastname, phone_number) FROM stdin;
14	sulukhia.anastasia@kiu.edu.ge	Anastasia	Sulukhia	599119274
18	gagloshvili.guga@kiu.edu.ge	Guga	Gagloshvli	595748181
\.


--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 218
-- Name: reservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reservation_id_seq', 13, true);


--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 215
-- Name: students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_id_seq', 19, true);


--
-- TOC entry 3464 (class 2606 OID 26075)
-- Name: reservation reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (id);


--
-- TOC entry 3466 (class 2606 OID 26077)
-- Name: reservation reservation_student_id_stadium_id_starttime_endtime_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_student_id_stadium_id_starttime_endtime_key UNIQUE (student_id, stadium_id, starttime, endtime);


--
-- TOC entry 3462 (class 2606 OID 26067)
-- Name: stadiums stadiums_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stadiums
    ADD CONSTRAINT stadiums_pkey PRIMARY KEY (id);


--
-- TOC entry 3458 (class 2606 OID 26060)
-- Name: students students_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_email_key UNIQUE (email);


--
-- TOC entry 3460 (class 2606 OID 26058)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- TOC entry 3469 (class 2620 OID 26089)
-- Name: reservation enforce_reservation_constraints; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER enforce_reservation_constraints BEFORE INSERT OR UPDATE ON public.reservation FOR EACH ROW EXECUTE FUNCTION public.check_reservation_constraints();


--
-- TOC entry 3467 (class 2606 OID 26083)
-- Name: reservation reservation_stadium_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_stadium_id_fkey FOREIGN KEY (stadium_id) REFERENCES public.stadiums(id) ON DELETE CASCADE;


--
-- TOC entry 3468 (class 2606 OID 26078)
-- Name: reservation reservation_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


-- Completed on 2024-12-07 00:27:29 +04

--
-- PostgreSQL database dump complete
--

