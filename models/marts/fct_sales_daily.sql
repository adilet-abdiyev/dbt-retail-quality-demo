-- Daily sales fact, one row per (sale_date, store, product).
-- Incremental delete+insert keyed on the grain: late-arriving rows for a day
-- replace that day's slice instead of duplicating it.

{{ config(
    materialized='incremental',
    incremental_strategy='delete+insert',
    unique_key=['sale_date', 'store_id', 'product_id']
) }}

with sales as (

    select * from {{ ref('stg_sales') }}

    {% if is_incremental() %}
    where sale_date >= (select coalesce(max(sale_date), date '1900-01-01') from {{ this }})
    {% endif %}

)

select
    sale_date,
    store_id,
    product_id,
    sum(quantity)          as units,
    round(sum(amount), 2)  as revenue
from sales
group by 1, 2, 3
