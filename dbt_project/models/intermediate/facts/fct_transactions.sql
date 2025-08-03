
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
    where created_at > (select max(created_at) from {{ this }})
    {% endif %}
)

select * from transactions
