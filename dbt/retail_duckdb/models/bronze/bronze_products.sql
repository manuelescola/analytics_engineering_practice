{{ config(materialized='incremental', unique_key='product_id') }}

select
  cast(product_id as integer) as product_id,
  product_name,
  category,
  cast(unit_price as double) as unit_price,
  '{{ var("batch_name") }}'::text as batch_name,
  current_timestamp as load_timestamp
from read_csv_auto('{{ var("load_path") }}/products.csv', HEADER=True)
