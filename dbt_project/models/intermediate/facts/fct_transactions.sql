
{{ config(
    tags=["intermediate"],
    materialized='incremental',
    unique_key='transaction_id',
) }}

with transactions as (
    select
        *
    from {{ ref('stg_transactions') }}

    {% if is_incremental() %}
    where happened_at > (select max(happened_at) from {{ this }})
    {% endif %}
)

select * from transactions

-- note: I could have added statement: where fct.status = 'accepted' to optimazie performance
-- but loosing information about rejected transactions could be problematic for future business questions