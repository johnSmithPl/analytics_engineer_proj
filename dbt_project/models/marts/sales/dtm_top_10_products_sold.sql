{{ config(tags=["sales_mart"]) }}

with source as (
    select
        product_name,
        count(*) as times_sold
    from {{ ref('fct_transactions') }}
    where status = 'accepted'
    group by product_name
),

ranked as (
    select
        product_name,
        times_sold,
        rank() over (order by times_sold desc) as ranking
    from source
)

select
    product_name,
    times_sold
from ranked
where ranking <= 10
-- note: this can produce ties, so it may return more than 10 products
