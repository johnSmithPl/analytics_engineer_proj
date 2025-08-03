{{ config(tags=["sales_mart"]) }}

-- Because instruction in the take home test "Average time for a store to perform its first 5 transactions"
-- is a bit ambiguous, this model calculates the overall average time to 5 transactions across all stores just in case.

select
    avg(time_to_5th_transaction) as overall_avg_time_to_5_transactions
from {{ ref('dtm_avg_time_to_5_transactions') }}
