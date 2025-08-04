# Analytics Engineer Project

## Overview

This project demonstrates a comprehensive data engineering and analytics workflow, from raw data ingestion to the creation of insightful
data marts. It uses dbt to transform and model data, and Docker-compose to create a reproducible environment.

## Project Structure

The project is organized into the following directories:

- `dbt_project/`: Contains the dbt project, including models, macros, and configuration.
- `postgres_init/`: Contains the initial data and the SQL script to load it into the PostgreSQL database.
- `instructions/`: Contains original instructions for take home assigment and git ingored folder data.
    Data was exported as CSV files from shared .xlsx files. They were just exported as they were, without any modifications.
    Delimiter was set to ";" to omit issues with file structure. I think it's a good enough solution for a take-home test
    with initial data. 
    
    These are the needed files:
    - `instructions/data/devices.csv`
    - `instructions/data/stores.csv`
    - `instructions/data/transactions.csv`

## Getting Started

### Prerequisites

- Docker

The docker-compose file is setup for `linux/amd64`, it works fine with MacOS M-series chip. The platform architecture is controled through 
this attribute in the [docker-compose.yml file](docker-compose.yml):
```
platform: linux/amd64
```

You can find more info about it in the [official docker docs](https://docs.docker.com/reference/compose-file/services/#platform).
It was not tested on other platforms, like windows.

### Setup

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/k-t-l/analytics_engineer_proj.git
    cd analytics_engineer_proj
    ```

2.  **Place prepared .csv files in the data folder:**
    Download the shared .csv files and place them in the `data` folder. If you prefer, you can also prepare them yourself, 
    following instructions in the [Project Structure](#project-structure) section.

    ```
    instructions/data/devices.csv
    instructions/data/stores.csv
    instructions/data/transactions.csv
    ```

3.  **Run the Docker environment:**

    ```bash
    docker-compose up -d
    ```

    This will start a PostgreSQL database and a dbt environment.

4.  **Run the dbt models:**

    ```bash
    docker exec -it dbt_env /bin/bash
    dbt run
    ```

    This will run all the dbt models, from staging to the final data marts. If you want you can run dbt layer by layer, with tags that have were set up:
    ```
    dbt run --select tag:staging
    dbt run --select tag:intermediate
    dbt run --select tag:sales_mart
    ```

    To run the tests:
    ```
    dbt test
    ```

    To run both the project and tests:
    ```
    dbt build
    ```


5.  **Docker images:**

    The Docker images in the `docker-compose.yml` file are chosen to be the most recent stable lightweight versions.

## Architecture

The project follows a layered data architecture, which is a best practice in data warehousing. This approach ensures that data flows through a series of well-defined stages, from raw data ingestion to the final data marts. Each layer has a specific purpose, and this separation of concerns makes the data pipeline more robust and easier to manage.

```
┌───────────────────┐
│   Raw Data (CSV)  │
└───────────────────┘
        │
        ▼
┌───────────────────┐
│ Staging Layer     │
└───────────────────┘
        │
        ▼
┌───────────────────┐
│ Intermediate Layer│
└───────────────────┘
        │
        ▼
┌───────────────────┐
│ Data Mart Layer   │
└───────────────────┘
```

### 1. Staging Layer

The staging layer is the first layer of the data model. It contains the raw data from the source systems, with minimal transformations. The purpose of the staging layer is to provide a clean and consistent view of the raw data, and to serve as a single source of truth for the rest of the data model.

The staging models perform the following transformations:

-   **Data type casting:** All columns are cast to their correct data types.
-   **Basic cleaning:** Leading and trailing whitespace is removed from all string columns.
-   **Timestamp conversion:** The `created_at` and `happened_at` columns are converted to timestamps.

### 2. Intermediate Layer

The intermediate layer is the second layer of the data model. It contains the transformed and enriched data from the staging layer. The purpose of the intermediate layer is to create a set of reusable and well-defined data models that can be used to build the final data marts.

The intermediate layer consists of the following models:

-   `dim_devices`: A dimension table that contains information about the devices.
-   `dim_stores`: A dimension table that contains information about the stores.
-   `fct_transactions`: A fact table that contains the transactions. This table is materialized as an incremental model, which means that only new or updated records are processed on each run. This is a key feature for scalability, as it avoids full table scans on large datasets.

### 3. Data Mart Layer

The data mart layer is the final layer of the data model. It contains the aggregated and summarized data from the intermediate layer, and is designed to answer specific business questions.

The data mart layer consists of the following models:

-   `dtm_avg_transacted_amount_by_typology_country`: Calculates the average transacted amount by store typology and country.
-   `dtm_avg_time_to_5_transactions`: Calculates the average time it takes for a store to have its first 5 transactions.
-   `dtm_overall_avg_time_to_5_transactions`: Calculates the overall average time it takes for a store to have its first 5 transactions.
        Instructions were a bit ambiguous about granularity of result for `dtm_avg_time_to_5_transactions`, so this one is included just in case for overall summary. As it was very easy to build.
-   `dtm_percentage_transactions_by_device_type`: Calculates the percentage of transactions by device type.
-   `dtm_top_10_products_sold`: Calculates the top 10 products sold.
-   `dtm_top_10_stores_by_amount`: Calculates the top 10 stores by transacted amount.

## Scalability and performance

### As implemented:
The data model leverages incremental models in the intermediate layer (e.g., fct_transactions). Each dbt run processes only new or changed rows and avoids full-table scans. In the datamart layer, models use efficient SQL patterns, like CTEs with early filtering, pre-aggregation before joins, and only necessary columns to minimize data movement and keep queries performant on growing datasets.

### Future considerations:
For the production setup, this could be improved further. However, it would heavily depend on database/warehouse technology. For PostgreSQL (as used here), this would involve indexing strategies on frequently queried columns, partitioning large tables (e.g., fct_transactions), etc. For analytical databases like Snowflake, it could mean manually defining clustering keys or relying on automatic clustering and micropartitioning. Solutions like materialized views, etc., could also be considered.

On the other hand, extremely beneficial could be well-designed orchestration with tools like Airflow.

## Data Loading Strategy

The initial data is loaded into the PostgreSQL database using a standard `init.sql` script placed in the `/docker-entrypoint-initdb.d` directory. This is a conventional and efficient method for initializing a database with a known dataset in a development or self-contained environment.

For a production system, a more robust data loading mechanism would be implemented, which would decouple the database startup from the data loading process, ensuring the database can start independently and providing better error handling and logging if the data ingestion were to fail.

## Database viewer

If you'd like to view the results, you can do so by configuring a DB connection in your database viewer tool of preference. For example, DBeaver.
Use the following details:

-   **Host:** localhost
-   **Port:** 5432
-   **Database:** dbt
-   **Username:** dbt
-   **Password:** dbt

## Feedback

Feedback is greatly appreciated. I aimed to complete the assignment to the best of my ability within the given time frame and welcome any suggestions for improvement.