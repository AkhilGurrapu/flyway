BEGIN TRANSACTION;

CREATE ROLE IF NOT EXISTS TEST1;

CREATE ROLE IF NOT EXISTS TEST2;

CREATE DATABASE ROLE DB_ROLE;

GRANT ALL ON DATABASE DEMO TO DB_ROLE;

GRANT ROLE ROLE DB_ROLE TO ROLE TEST1S;

COMMIT;