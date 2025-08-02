with transactions as (

    select * from {{ ref('stg_transactions') }}

)

select * from transactions
