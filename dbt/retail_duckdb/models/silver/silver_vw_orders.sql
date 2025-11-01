{{ config(materialized='view') }}

select
  order_id,
  customer_id,
  cast(order_date as date) as order_date,
  lower(status) as status,
  batch_name,
  load_timestamp
from {{ ref('bronze_orders') }}
