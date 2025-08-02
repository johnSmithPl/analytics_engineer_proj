
{{ config(tags=["staging"]) }}

with source as (

    select * from {{ source('postgres', 'stores') }}

),

stores as (

    select
        trim(id) as store_id,
        trim(name) as store_name,
        trim(address) as address,
        trim(city) as city,
        trim(country) as country,
        to_timestamp(created_at, 'MM/DD/YYYY HH24:MI:SS') as created_at,
        trim(typology) as typology,
        trim(customer_id) as customer_id

    from source

)

select * from stores
