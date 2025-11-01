{{ config(materialized='incremental', unique_key='order_id') }}

select
  cast(order_id as integer) as order_id,
  cast(customer_id as integer) as customer_id,
  cast(order_date as date) as order_date,
  status,
  '{{ var("batch_name") }}'::text as batch_name,
  current_timestamp as load_timestamp
from read_csv_auto('{{ var("load_path") }}/orders.csv', HEADER=True)
