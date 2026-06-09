-- Loss audit: total revenue in the mart must reconcile with staging to the cent.
-- If this returns rows, the transformation dropped or duplicated money somewhere.

with staging_total as (

    select round(sum(amount), 2) as revenue
    from {{ ref('stg_sales') }}

),

mart_total as (

    select round(sum(revenue), 2) as revenue
    from {{ ref('fct_sales_daily') }}

)

select
    s.revenue as staging_revenue,
    m.revenue as mart_revenue
from staging_total s
cross join mart_total m
where abs(coalesce(s.revenue, 0) - coalesce(m.revenue, 0)) > 0.01
