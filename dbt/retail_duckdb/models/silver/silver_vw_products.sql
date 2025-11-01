{{ config(materialized='view') }}

select
  product_id,
  trim(product_name) as product_name,
  trim(category) as category,
  cast(unit_price as double) as unit_price,
  batch_name,
  load_timestamp
from {{ ref('bronze_products') }}
