
{{ config(tags=["staging"]) }}

with source as (

    select * from {{ source('postgres', 'devices') }}

),

devices as (

    select
        trim(id) as device_id,
        trim(type) as device_type,
        trim(store_id) as store_id

    from source

)

select * from devices
