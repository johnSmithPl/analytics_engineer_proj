{{ config(tags=["sales_mart"]) }}

with store_transactions as (
    select
        fct.amount,
        ds.typology,
        ds.country
    from {{ ref('fct_transactions') }} as fct
    join {{ ref('dim_devices') }} as dd on fct.device_id = dd.device_id
    join {{ ref('dim_stores') }} as ds on dd.store_id = ds.store_id
    where fct.status = 'accepted'
)

select
    typology,
    country,
    avg(amount) as avg_transacted_amount
from store_transactions
group by 1, 2
order by 1, 2