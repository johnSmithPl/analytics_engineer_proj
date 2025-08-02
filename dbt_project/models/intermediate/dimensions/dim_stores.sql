
{{ config(tags=["intermediate"]) }}

with stores as (

    select * from {{ ref('stg_stores') }}

)

select * from stores
