{{ config(materialized='view') }}

select
  dbt_scd_id,
  customer_id,
  full_name,
  email,
  city,
  country,
  loyalty_status,
  dbt_valid_from,
  dbt_valid_to
from {{ ref('gold_dim_customers') }}
where dbt_valid_to is null
