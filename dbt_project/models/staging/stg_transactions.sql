{{ config(tags=["staging"]) }}

with source as (
    select * from {{ source('postgres', 'transactions') }}
),

transactions as (
    select
        trim(id)::numeric as transaction_id,
        trim(device_id)::numeric as device_id,
        trim(product_name) as product_name,
        trim(product_sku) as product_sku,
        trim(category_name) as category_name,
        trim(amount)::numeric as amount,
        trim(status) as status,
        to_timestamp(created_at, 'MM/DD/YYYY HH24:MI:SS') as created_at,
        to_timestamp(happened_at, 'MM/DD/YYYY HH24:MI:SS') as happened_at
    from source
)

select * from transactions
