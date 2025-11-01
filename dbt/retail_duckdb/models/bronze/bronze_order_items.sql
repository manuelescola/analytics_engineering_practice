{{ config(materialized='incremental', unique_key='order_id,product_id') }}

select
  cast(order_id as integer) as order_id,
  cast(product_id as integer) as product_id,
  cast(quantity as integer) as quantity,
  cast(unit_price as double) as unit_price,
  '{{ var("batch_name") }}'::text as batch_name,
  current_timestamp as load_timestamp
from read_csv_auto('{{ var("load_path") }}/order_items.csv', HEADER=True)
