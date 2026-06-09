{% snapshot products_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='product_id',
      strategy='check',
      check_cols=['product_name', 'category', 'unit_price'],
    )
}}

select * from {{ ref('raw_products') }}

{% endsnapshot %}
