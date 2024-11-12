USE DATABASE prod;
CREATE SCHEMA IF NOT EXISTS DEMO_new;
USE SCHEMA DEMO_new;

CREATE OR REPLACE TABLE DEMO_new.EMPLOYEES (
    ID NUMBER AUTOINCREMENT,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    EMAIL VARCHAR(100),
    CREATED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- V2__create_tables.sql
USE SCHEMA DEMO_new;

CREATE OR REPLACE TABLE DEMO_new.DEPARTMENTS (
    ID NUMBER AUTOINCREMENT,
    DEPT_NAME VARCHAR(100),
    CREATED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);
