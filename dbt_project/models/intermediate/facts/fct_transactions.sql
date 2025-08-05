
{{ config(
    tags=["intermediate"],
    materialized='incremental',
    unique_key='transaction_id',
) }}

with transactions as (
    select
        transaction_id,
        device_id,
        product_name,
        product_sku,
        category_name,
        amount,
        status,
        created_at,
        happened_at
    from {{ ref('stg_transactions') }}

    {% if is_incremental() %}
    where happened_at > (select max(happened_at) from {{ this }})
    {% endif %}
)

select
    transaction_id,
    device_id,
    product_name,
    product_sku,
    category_name,
    amount,
    status,
    created_at,
    happened_at
from transactions

-- note: I could have added statement: where fct.status = 'accepted' to optimazie performance
-- but loosing information about rejected transactions could be problematic for future business questions.
-- On the other hand new entity like fct_transactions_rejected or fct_transactions_accepted_enriched could be created.
-- It would be a good idea to discuss it with the business team.
