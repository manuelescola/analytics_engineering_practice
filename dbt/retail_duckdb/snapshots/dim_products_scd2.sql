{% snapshot dim_products_scd2 %}
{{
  config(
    unique_key='product_id',
    strategy='check',
    check_cols=['product_name','category','unit_price']
  )
}}

select
  product_id,
  product_name,
  category,
  unit_price
from {{ ref('silver_vw_products') }}

{% endsnapshot %}
