{{ config(tags=["sales_mart"]) }}

with source as (
    select
        ds.typology,
        ds.country,
        avg(fct.amount) as avg_amount
    from {{ ref('fct_transactions') }} fct
    join {{ ref('dim_devices') }} dd 
        on fct.device_id = dd.device_id
    join {{ ref('dim_stores') }} ds
        on dd.store_id = ds.store_id
    group by 1, 2
)

select
    typology,
    country,
    avg_amount
from source
