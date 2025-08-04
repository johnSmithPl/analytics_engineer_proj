# Analytics Engineer Project

This project demonstrates a comprehensive data engineering and analytics workflow, from raw data ingestion to the creation of insightful
data marts. It uses dbt to transform and model data, and Docker-compose to create a reproducible environment.

## Project Structure

The project is organized into the following directories:

- `dbt_project/`: Contains the dbt project, including models, macros, and configuration.
- `postgres_init/`: Contains the initial data and the SQL script to load it into the PostgreSQL database.
- `instructions/`: Contains original instructions for take home assigment and git ingored folder data.
    Data was exported as cvs files from shared .xlsx files. They were just exported as they were, without any modifications.
    Delimiter was set up to ";" to ommit issues with file structure. I think it's good enough solution for take home test
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
    Download the shared .csv files and place them in the `data` folder. If you prefere, you can also prepare them yourself. 
    Following instructions in the [Project Structure](#project-structure) section.

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
    dbt run test
    ```

    To run both the project and tests:
    ```
    dbt build
    ```


5.  **Docker images:**
    The Docker images in the `docker-compose.yml` file are chosen to be the most recent stable ligt-weight versions.
