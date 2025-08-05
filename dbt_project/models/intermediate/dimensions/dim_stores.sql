{{ config(tags=["intermediate"]) }}

with stores as (
    select
        store_id,
        store_name,
        address,
        city,
        country,
        created_at,
        typology,
        customer_id
    from {{ ref('stg_stores') }}
)

select
    store_id,
    store_name,
    address,
    city,
    country,
    created_at,
    typology,
    customer_id
from stores
