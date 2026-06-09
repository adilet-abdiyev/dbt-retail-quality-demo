-- Product dimension built from the SCD-2 snapshot.
-- Every price or category change in raw_products becomes a new versioned row.

select
    product_id,
    product_name,
    category,
    unit_price,
    dbt_valid_from              as valid_from,
    dbt_valid_to                as valid_to,
    dbt_valid_to is null        as is_current
from {{ ref('products_snapshot') }}
