{{ config(materialized='view') }}

select
  order_id,
  product_id,
  cast(quantity as integer)    as quantity,
  cast(unit_price as double)   as unit_price,
  (cast(quantity as integer) * cast(unit_price as double)) as line_amount,
  batch_name,
  load_timestamp
from {{ ref('bronze_order_items') }}
