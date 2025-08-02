with devices as (

    select * from {{ ref('stg_devices') }}

)

select * from devices
