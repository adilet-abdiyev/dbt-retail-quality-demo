-- Clean the raw sales feed:
--   1. dedupe by sale_id (the seed contains a duplicated row on purpose)
--   2. drop impossible rows (negative quantities)
--   3. cast types and compute the line amount

with source as (

    select * from {{ ref('raw_sales') }}

),

deduped as (

    select
        *,
        row_number() over (partition by sale_id order by sale_date) as rn
    from source

)

select
    sale_id,
    cast(sale_date as date)            as sale_date,
    store_id,
    product_id,
    quantity,
    unit_price,
    round(quantity * unit_price, 2)    as amount
from deduped
where rn = 1
  and quantity > 0
