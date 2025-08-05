{{ config(tags=["intermediate"]) }}

with devices as (
    select
        device_id,
        device_type,
        store_id
    from {{ ref('stg_devices') }}
)

select
    device_id,
    device_type,
    store_id
from devices
