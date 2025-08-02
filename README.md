# analytics_engineer_proj

- excel .xlsx modified to .csv, delimited with ";"
- platform: linux/amd64 in dockercompose, explain
- docker exec -it dbt_env /bin/bash
- i did not post data to not leak any personal information, thats why its git ignored and you have to put it there
- picked most fresh and stable versions of postgres and dbt images source


to do:
- provide a link with data so they dont have to convert xlsx to csv and pay attention to delmiter etc
- clean the raw data in next layers as there are many commas etc.


# Data Loading Strategy

For this project, the initial data is loaded into the PostgreSQL database using a standard init.sql script placed in the /docker-entrypoint-initdb.d directory. This is a conventional and efficient method for initializing a database with a known dataset in a development or self-contained environment.

For a production system, I would implement a more robust data loading mechanism, which would decouple the database startup from the data loading process, ensuring the database can start independently and providing better error handling and logging if the data ingestion were to fail.

I loaded that everything has a string because because of some data that later on I can fix in the first layers on top of raw data.

# dbeaver
Host: localhost
Port: 5432
Database: dbt
Username: dbt
Password: dbt

dbt run --select tag:stage
dbt run --select tag:intermediate