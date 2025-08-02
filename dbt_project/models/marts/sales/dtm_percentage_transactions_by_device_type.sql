{{ config(tags=["sales_mart"]) }}

with transactions_by_device as (
    select
        dd.device_type,
        count(fct.transaction_id) as transaction_count
    from {{ ref('fct_transactions') }} as fct
    join {{ ref('dim_devices') }} as dd 
        on fct.device_id = dd.device_id
    group by 1
)

select
    device_type,
    transaction_count,
    transaction_count * 100.0 / sum(transaction_count) over () as percentage_of_transactions
from transactions_by_device
