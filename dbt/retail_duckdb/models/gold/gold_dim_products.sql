{{ config(
    materialized='incremental',
    unique_key='dbt_scd_id',
    on_schema_change='sync_all_columns'
) }}

select
  dbt_scd_id,
  product_id,
  product_name,
  category,
  unit_price,
  dbt_valid_from,
  dbt_valid_to
from {{ ref('dim_products_scd2') }}
-- No incremental filter: need MERGE to update closing rows and insert new versions
