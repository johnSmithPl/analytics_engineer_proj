{{ config(tags=["sales_mart"]) }}

with ranked_transactions as (
    select
        dd.store_id,
        fct.happened_at,
        row_number() over (partition by dd.store_id order by fct.happened_at) as transaction_rank
    from {{ ref('fct_transactions') }} fct
    join {{ ref('dim_devices') }} dd 
        on fct.device_id = dd.device_id
),

first_5_transactions as (
    select
        store_id,
        happened_at
    from ranked_transactions
    where transaction_rank = 5
),

first_transaction as (
    select
        dd.store_id,
        min(fct.happened_at) as first_transaction_at
    from {{ ref('fct_transactions') }} fct
    join {{ ref('dim_devices') }} dd
        on fct.device_id = dd.device_id
    group by 1
)

select
    f5.store_id,
    avg(f5.happened_at - f1.first_transaction_at) as avg_time_to_5_transactions
from first_5_transactions f5
join first_transaction f1 
    on f5.store_id = f1.store_id
group by 1