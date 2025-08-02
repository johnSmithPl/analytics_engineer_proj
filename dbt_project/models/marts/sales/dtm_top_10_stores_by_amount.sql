{{ config(tags=["sales_mart"]) }}

with source as (
    select
        dd.store_id,
        sum(fct.amount) as total_amount
    from {{ ref('fct_transactions') }} fct
    join {{ ref('dim_devices') }} dd 
        on fct.device_id = dd.device_id
    group by 1
),

ranked as (
    select
        s.store_id,
        ds.store_name,
        s.total_amount,
        rank() over (order by s.total_amount desc) as ranking
    from source s
    join {{ ref('dim_stores') }} ds 
    on s.store_id = ds.store_id
)

select
    store_id,
    store_name,
    total_amount
from ranked
where ranking <= 10
