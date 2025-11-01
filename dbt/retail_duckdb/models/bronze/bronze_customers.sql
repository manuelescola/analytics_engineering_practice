{{ config(materialized='incremental', unique_key='customer_id') }}

select
  cast(customer_id as integer) as customer_id,
  full_name,
  email,
  city,
  country,
  loyalty_status,
  '{{ var("batch_name") }}'::text as batch_name,
  current_timestamp as load_timestamp
from read_csv_auto('{{ var("load_path") }}/customers.csv', HEADER=True)
