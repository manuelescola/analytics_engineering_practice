{{ config(materialized='view') }}

select
  customer_id,
  trim(full_name) as full_name,
  lower(email) as email,
  trim(city) as city,
  trim(country) as country,
  lower(loyalty_status) as loyalty_status,
  batch_name,
  load_timestamp
from {{ ref('bronze_customers') }}
