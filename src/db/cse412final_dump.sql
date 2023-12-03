--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4 (Homebrew)
-- Dumped by pg_dump version 15.4 (Homebrew)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: assignments; Type: TABLE; Schema: public; Owner: ameya
--

CREATE TABLE public.assignments (
    assignmentid integer NOT NULL,
    moduleid integer NOT NULL,
    assignmentname character varying(255) NOT NULL
);


ALTER TABLE public.assignments OWNER TO ameya;

--
-- Name: assignments_assignmentid_seq; Type: SEQUENCE; Schema: public; Owner: ameya
--

CREATE SEQUENCE public.assignments_assignmentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assignments_assignmentid_seq OWNER TO ameya;

--
-- Name: assignments_assignmentid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ameya
--

ALTER SEQUENCE public.assignments_assignmentid_seq OWNED BY public.assignments.assignmentid;


--
-- Name: courseinfo; Type: TABLE; Schema: public; Owner: ameya
--

CREATE TABLE public.courseinfo (
    courseinfoid integer NOT NULL,
    moduleid integer NOT NULL,
    information text
);


ALTER TABLE public.courseinfo OWNER TO ameya;

--
-- Name: courseinfo_courseinfoid_seq; Type: SEQUENCE; Schema: public; Owner: ameya
--

CREATE SEQUENCE public.courseinfo_courseinfoid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.courseinfo_courseinfoid_seq OWNER TO ameya;

--
-- Name: courseinfo_courseinfoid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ameya
--

ALTER SEQUENCE public.courseinfo_courseinfoid_seq OWNED BY public.courseinfo.courseinfoid;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: ameya
--

CREATE TABLE public.courses (
    courseid integer NOT NULL,
    teacherid integer NOT NULL,
    coursename character varying(255) NOT NULL,
    description text
);


ALTER TABLE public.courses OWNER TO ameya;

--
-- Name: courses_courseid_seq; Type: SEQUENCE; Schema: public; Owner: ameya
--

CREATE SEQUENCE public.courses_courseid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.courses_courseid_seq OWNER TO ameya;

--
-- Name: courses_courseid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ameya
--

ALTER SEQUENCE public.courses_courseid_seq OWNED BY public.courses.courseid;


--
-- Name: grades; Type: TABLE; Schema: public; Owner: ameya
--

CREATE TABLE public.grades (
    gradeid integer NOT NULL,
    studentid integer NOT NULL,
    testid integer,
    assignmentid integer,
    grade character varying(10)
);


ALTER TABLE public.grades OWNER TO ameya;

--
-- Name: grades_gradeid_seq; Type: SEQUENCE; Schema: public; Owner: ameya
--

CREATE SEQUENCE public.grades_gradeid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grades_gradeid_seq OWNER TO ameya;

--
-- Name: grades_gradeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ameya
--

ALTER SEQUENCE public.grades_gradeid_seq OWNED BY public.grades.gradeid;


--
-- Name: modules; Type: TABLE; Schema: public; Owner: ameya
--

CREATE TABLE public.modules (
    moduleid integer NOT NULL,
    courseid integer NOT NULL,
    modulename character varying(255) NOT NULL,
    description text
);


ALTER TABLE public.modules OWNER TO ameya;

--
-- Name: modules_moduleid_seq; Type: SEQUENCE; Schema: public; Owner: ameya
--

CREATE SEQUENCE public.modules_moduleid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.modules_moduleid_seq OWNER TO ameya;

--
-- Name: modules_moduleid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ameya
--

ALTER SEQUENCE public.modules_moduleid_seq OWNED BY public.modules.moduleid;


--
-- Name: studentcourse; Type: TABLE; Schema: public; Owner: ameya
--

CREATE TABLE public.studentcourse (
    studentid integer NOT NULL,
    courseid integer NOT NULL
);


ALTER TABLE public.studentcourse OWNER TO ameya;

--
-- Name: students; Type: TABLE; Schema: public; Owner: ameya
--

CREATE TABLE public.students (
    studentid integer NOT NULL,
    userid integer NOT NULL
);


ALTER TABLE public.students OWNER TO ameya;

--
-- Name: students_studentid_seq; Type: SEQUENCE; Schema: public; Owner: ameya
--

CREATE SEQUENCE public.students_studentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.students_studentid_seq OWNER TO ameya;

--
-- Name: students_studentid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ameya
--

ALTER SEQUENCE public.students_studentid_seq OWNED BY public.students.studentid;


--
-- Name: teachers; Type: TABLE; Schema: public; Owner: ameya
--

CREATE TABLE public.teachers (
    teacherid integer NOT NULL,
    userid integer NOT NULL
);


ALTER TABLE public.teachers OWNER TO ameya;

--
-- Name: teachers_teacherid_seq; Type: SEQUENCE; Schema: public; Owner: ameya
--

CREATE SEQUENCE public.teachers_teacherid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teachers_teacherid_seq OWNER TO ameya;

--
-- Name: teachers_teacherid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ameya
--

ALTER SEQUENCE public.teachers_teacherid_seq OWNED BY public.teachers.teacherid;


--
-- Name: tests; Type: TABLE; Schema: public; Owner: ameya
--

CREATE TABLE public.tests (
    testid integer NOT NULL,
    moduleid integer NOT NULL,
    testname character varying(255) NOT NULL
);


ALTER TABLE public.tests OWNER TO ameya;

--
-- Name: tests_testid_seq; Type: SEQUENCE; Schema: public; Owner: ameya
--

CREATE SEQUENCE public.tests_testid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tests_testid_seq OWNER TO ameya;

--
-- Name: tests_testid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ameya
--

ALTER SEQUENCE public.tests_testid_seq OWNED BY public.tests.testid;


--
-- Name: users; Type: TABLE; Schema: public; Owner: ameya
--

CREATE TABLE public.users (
    userid integer NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    usertype character varying(50),
    CONSTRAINT users_usertype_check CHECK (((usertype)::text = ANY ((ARRAY['Student'::character varying, 'Teacher'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO ameya;

--
-- Name: users_userid_seq; Type: SEQUENCE; Schema: public; Owner: ameya
--

CREATE SEQUENCE public.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_userid_seq OWNER TO ameya;

--
-- Name: users_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ameya
--

ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.userid;


--
-- Name: assignments assignmentid; Type: DEFAULT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.assignments ALTER COLUMN assignmentid SET DEFAULT nextval('public.assignments_assignmentid_seq'::regclass);


--
-- Name: courseinfo courseinfoid; Type: DEFAULT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.courseinfo ALTER COLUMN courseinfoid SET DEFAULT nextval('public.courseinfo_courseinfoid_seq'::regclass);


--
-- Name: courses courseid; Type: DEFAULT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.courses ALTER COLUMN courseid SET DEFAULT nextval('public.courses_courseid_seq'::regclass);


--
-- Name: grades gradeid; Type: DEFAULT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.grades ALTER COLUMN gradeid SET DEFAULT nextval('public.grades_gradeid_seq'::regclass);


--
-- Name: modules moduleid; Type: DEFAULT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.modules ALTER COLUMN moduleid SET DEFAULT nextval('public.modules_moduleid_seq'::regclass);


--
-- Name: students studentid; Type: DEFAULT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.students ALTER COLUMN studentid SET DEFAULT nextval('public.students_studentid_seq'::regclass);


--
-- Name: teachers teacherid; Type: DEFAULT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.teachers ALTER COLUMN teacherid SET DEFAULT nextval('public.teachers_teacherid_seq'::regclass);


--
-- Name: tests testid; Type: DEFAULT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.tests ALTER COLUMN testid SET DEFAULT nextval('public.tests_testid_seq'::regclass);


--
-- Name: users userid; Type: DEFAULT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);


--
-- Data for Name: assignments; Type: TABLE DATA; Schema: public; Owner: ameya
--

COPY public.assignments (assignmentid, moduleid, assignmentname) FROM stdin;
1	1	Assn1
2	1	Assn1
3	1	Assignment 1
4	1	Assignment 2
5	3	Assignment 1
6	3	Assignment 2
\.


--
-- Data for Name: courseinfo; Type: TABLE DATA; Schema: public; Owner: ameya
--

COPY public.courseinfo (courseinfoid, moduleid, information) FROM stdin;
1	1	This is a test course.
3	3	History is the study of past events, particularly those that have shaped the development of human societies and civilizations. It involves the examination and analysis of historical records, documents, artifacts, and the accounts of eyewitnesses to understand and interpret the actions, decisions, and consequences of people and societies from earlier times. Historians aim to uncover the causes and effects of historical events and movements, providing valuable insights into the evolution of human culture, politics, economics, and social structures. Studying history helps us gain a deeper appreciation of the world's rich and complex tapestry and provides valuable lessons for the present and future.
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: ameya
--

COPY public.courses (courseid, teacherid, coursename, description) FROM stdin;
3	1	Test	Test
4	2	Test1	Test1
5	2	Test2	Test
6	2	Test3	Test
7	2	Test4	Test
8	2	Test5	Test
9	2	Introduction to Modern Web Development	Dive into the world of modern web development with this comprehensive course designed for aspiring web developers. Learn the fundamentals of HTML, CSS, and JavaScript, and how these technologies come together to create interactive and responsive websites. Explore the latest frameworks and libraries such as React and Node.js, and understand the principles of responsive design and web accessibility. By the end of this course, you'll have the skills to build your own web applications and a solid foundation for advanced web development topics. No prior experience required – this course is perfect for beginners! Dive into the world of modern web development with this comprehensive course designed for aspiring web developers. Learn the fundamentals of HTML, CSS, and JavaScript, and how these technologies come together to create interactive and responsive websites. Explore the latest frameworks and libraries such as React and Node.js, and understand the principles of responsive design and web accessibility. By the end of this course, you'll have the skills to build your own web applications and a solid foundation for advanced web development topics. No prior experience required – this course is perfect for beginners!
10	1	History	A study of past events.
\.


--
-- Data for Name: grades; Type: TABLE DATA; Schema: public; Owner: ameya
--

COPY public.grades (gradeid, studentid, testid, assignmentid, grade) FROM stdin;
\.


--
-- Data for Name: modules; Type: TABLE DATA; Schema: public; Owner: ameya
--

COPY public.modules (moduleid, courseid, modulename, description) FROM stdin;
1	3	New Module for 3	Auto-generated module for 3
3	10	New Module for 10	Auto-generated module for 10
\.


--
-- Data for Name: studentcourse; Type: TABLE DATA; Schema: public; Owner: ameya
--

COPY public.studentcourse (studentid, courseid) FROM stdin;
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: ameya
--

COPY public.students (studentid, userid) FROM stdin;
1	2
2	4
\.


--
-- Data for Name: teachers; Type: TABLE DATA; Schema: public; Owner: ameya
--

COPY public.teachers (teacherid, userid) FROM stdin;
1	3
2	5
\.


--
-- Data for Name: tests; Type: TABLE DATA; Schema: public; Owner: ameya
--

COPY public.tests (testid, moduleid, testname) FROM stdin;
1	1	Assn1
2	1	Assn1
3	1	Test 1
4	1	Midterm Test
5	1	Test 2
6	1	Final Exam
7	3	Exam 1
8	3	Exam 2
9	3	Exam 3
10	3	Final Exam
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: ameya
--

COPY public.users (userid, username, password, usertype) FROM stdin;
2	newuser	\\x2432622431322446324c4d34396c423971784f3668766e4b526643724f346a6b7239427674643458326842494c2e6d4d38665656553361365a53636d	Student
3	newteacher	\\x2432622431322475626a4e35736c63784230514353482e4a3667706475304a44322f74414535636f613855752e352e4e6170613356796e6264797a4b	Teacher
4	aakash	\\x243262243132247a654c58332f65526353546d4c532e6f4d5936707a65767335554f78497652644c52594730486b4c386d7572435870766d58337957	Student
5	t	\\x24326224313224566c312e37544471562f37442f736f666d5775797a2e55704c394c464c445879434947434a444b6741704b3637384d5649384d3169	Teacher
\.


--
-- Name: assignments_assignmentid_seq; Type: SEQUENCE SET; Schema: public; Owner: ameya
--

SELECT pg_catalog.setval('public.assignments_assignmentid_seq', 6, true);


--
-- Name: courseinfo_courseinfoid_seq; Type: SEQUENCE SET; Schema: public; Owner: ameya
--

SELECT pg_catalog.setval('public.courseinfo_courseinfoid_seq', 3, true);


--
-- Name: courses_courseid_seq; Type: SEQUENCE SET; Schema: public; Owner: ameya
--

SELECT pg_catalog.setval('public.courses_courseid_seq', 10, true);


--
-- Name: grades_gradeid_seq; Type: SEQUENCE SET; Schema: public; Owner: ameya
--

SELECT pg_catalog.setval('public.grades_gradeid_seq', 1, false);


--
-- Name: modules_moduleid_seq; Type: SEQUENCE SET; Schema: public; Owner: ameya
--

SELECT pg_catalog.setval('public.modules_moduleid_seq', 3, true);


--
-- Name: students_studentid_seq; Type: SEQUENCE SET; Schema: public; Owner: ameya
--

SELECT pg_catalog.setval('public.students_studentid_seq', 2, true);


--
-- Name: teachers_teacherid_seq; Type: SEQUENCE SET; Schema: public; Owner: ameya
--

SELECT pg_catalog.setval('public.teachers_teacherid_seq', 2, true);


--
-- Name: tests_testid_seq; Type: SEQUENCE SET; Schema: public; Owner: ameya
--

SELECT pg_catalog.setval('public.tests_testid_seq', 10, true);


--
-- Name: users_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: ameya
--

SELECT pg_catalog.setval('public.users_userid_seq', 5, true);


--
-- Name: assignments assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (assignmentid);


--
-- Name: courseinfo courseinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.courseinfo
    ADD CONSTRAINT courseinfo_pkey PRIMARY KEY (courseinfoid);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (courseid);


--
-- Name: grades grades_pkey; Type: CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_pkey PRIMARY KEY (gradeid);


--
-- Name: modules modules_pkey; Type: CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_pkey PRIMARY KEY (moduleid);


--
-- Name: studentcourse studentcourse_pkey; Type: CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.studentcourse
    ADD CONSTRAINT studentcourse_pkey PRIMARY KEY (studentid, courseid);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (studentid);


--
-- Name: students students_userid_key; Type: CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_userid_key UNIQUE (userid);


--
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (teacherid);


--
-- Name: teachers teachers_userid_key; Type: CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_userid_key UNIQUE (userid);


--
-- Name: tests tests_pkey; Type: CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_pkey PRIMARY KEY (testid);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: assignments assignments_moduleid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT assignments_moduleid_fkey FOREIGN KEY (moduleid) REFERENCES public.modules(moduleid);


--
-- Name: courseinfo courseinfo_moduleid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.courseinfo
    ADD CONSTRAINT courseinfo_moduleid_fkey FOREIGN KEY (moduleid) REFERENCES public.modules(moduleid);


--
-- Name: courses courses_teacherid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_teacherid_fkey FOREIGN KEY (teacherid) REFERENCES public.teachers(teacherid);


--
-- Name: grades grades_assignmentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_assignmentid_fkey FOREIGN KEY (assignmentid) REFERENCES public.assignments(assignmentid);


--
-- Name: grades grades_studentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_studentid_fkey FOREIGN KEY (studentid) REFERENCES public.students(studentid);


--
-- Name: grades grades_testid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_testid_fkey FOREIGN KEY (testid) REFERENCES public.tests(testid);


--
-- Name: modules modules_courseid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_courseid_fkey FOREIGN KEY (courseid) REFERENCES public.courses(courseid);


--
-- Name: studentcourse studentcourse_courseid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.studentcourse
    ADD CONSTRAINT studentcourse_courseid_fkey FOREIGN KEY (courseid) REFERENCES public.courses(courseid);


--
-- Name: studentcourse studentcourse_studentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.studentcourse
    ADD CONSTRAINT studentcourse_studentid_fkey FOREIGN KEY (studentid) REFERENCES public.students(studentid);


--
-- Name: students students_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(userid);


--
-- Name: teachers teachers_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(userid);


--
-- Name: tests tests_moduleid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ameya
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_moduleid_fkey FOREIGN KEY (moduleid) REFERENCES public.modules(moduleid);


--
-- PostgreSQL database dump complete
--

