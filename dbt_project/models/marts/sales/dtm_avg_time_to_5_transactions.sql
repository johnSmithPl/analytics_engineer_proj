{{ config(tags=["sales_mart"]) }}

with store_transactions as (
    -- First, join and rank transactions for each store.
    -- This is the most expensive step, as it requires a full scan and sort.
    select
        dd.store_id,
        fct.happened_at,
        row_number() over (partition by dd.store_id order by fct.happened_at asc) as ranking
    from {{ ref('fct_transactions') }} as fct
    join {{ ref('dim_devices') }} as dd
        on fct.device_id = dd.device_id
    where fct.status = 'accepted'
),

first_and_fifth_transactions as (
    -- Filter the results to only the 1st and 5th transaction for each store.
    -- This reduces the dataset for subsequent steps.
    select
        store_id,
        happened_at,
        ranking
    from store_transactions
    where ranking in (1, 5)
),

store_times as (
    -- Pivot the data to have one row per store with the first and fifth transaction times.
    select
        store_id,
        min(case when ranking = 1 then happened_at end) as first_transaction_at,
        max(case when ranking = 5 then happened_at end) as fifth_transaction_at
    from first_and_fifth_transactions
    group by store_id
)

select
    store_id,
    fifth_transaction_at - first_transaction_at as time_to_5th_transaction
from store_times
where fifth_transaction_at is not null
