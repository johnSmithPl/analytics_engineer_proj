
{{ config(tags=["staging"]) }}

with source as (

    select * from {{ source('postgres', 'devices') }}

),

devices as (

    select
        trim(id)::numeric as device_id,
        trim(type)::numeric as device_type,
        trim(store_id)::numeric as store_id

    from source

)

select * from devices
