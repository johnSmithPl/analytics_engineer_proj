{{ config(tags=["sales_mart"]) }}

select
    avg(time_to_5th_transaction) as overall_avg_time_to_5_transactions
from {{ ref('dtm_avg_time_to_5_transactions') }}
