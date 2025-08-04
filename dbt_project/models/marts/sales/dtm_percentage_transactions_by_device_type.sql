{{ config(tags=["sales_mart"]) }}

with transaction_counts as (
    select
        device_id,
        count(transaction_id) as transactions
    from {{ ref('fct_transactions') }}
    group by 1
),

transactions_by_device_type as (
    -- devices are joined with transactions table that was already aggreaged 
    -- to reduce the number of rows on join statement to improve performance
    select
        dd.device_type,
        sum(tc.transactions) as transaction_count
    from transaction_counts as tc
    join {{ ref('dim_devices') }} as dd 
        on tc.device_id = dd.device_id
    group by 1
)

select
    device_type,
    transaction_count,
    round(
        transaction_count * 100.0 / sum(transaction_count) over (), 2
    ) as percentage_of_transactions
from transactions_by_device_type
order by percentage_of_transactions desc
