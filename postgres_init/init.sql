CREATE SCHEMA IF NOT EXISTS raw;


CREATE TABLE raw.stores (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(255),
    country VARCHAR(255),
    created_at VARCHAR(255),
    typology VARCHAR(255),
    customer_id VARCHAR(255)
);


CREATE TABLE raw.devices (
    id VARCHAR(255) PRIMARY KEY,
    type VARCHAR(255),
    store_id VARCHAR(255)
);


CREATE TABLE raw.transactions (
    id VARCHAR(255) PRIMARY KEY,
    device_id VARCHAR(255),
    product_name VARCHAR(255),
    product_sku VARCHAR(255),
    category_name VARCHAR(255),
    amount VARCHAR(255),
    status VARCHAR(255),
    card_number VARCHAR(255),
    cvv VARCHAR(255),
    created_at VARCHAR(255),
    happened_at VARCHAR(255)
);


COPY raw.stores(id, name, address, city, country, created_at, typology, customer_id)
FROM '/docker-entrypoint-initdb.d/data/stores.csv'
DELIMITER ';'
CSV HEADER;


COPY raw.devices(id, type, store_id)
FROM '/docker-entrypoint-initdb.d/data/devices.csv'
DELIMITER ';'
CSV HEADER;


COPY raw.transactions(id, device_id, product_name, product_sku, category_name, amount, status, card_number, cvv, created_at, happened_at)
FROM '/docker-entrypoint-initdb.d/data/transactions.csv'
DELIMITER ';'
CSV HEADER;