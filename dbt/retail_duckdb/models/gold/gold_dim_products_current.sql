{{ config(materialized='view') }}

select
  dbt_scd_id,
  product_id,
  product_name,
  category,
  unit_price,
  dbt_valid_from,
  dbt_valid_to
from {{ ref('gold_dim_products') }}
where dbt_valid_to is null
