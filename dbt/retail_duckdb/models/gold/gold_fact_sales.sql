{{ config(
    materialized='incremental',
    unique_key='order_id,product_id',
    on_schema_change='sync_all_columns'
) }}

with src as (
  select
    oi.order_id,
    o.order_date,
    o.customer_id,
    oi.product_id,
    cast(oi.quantity as int)      as quantity,
    cast(oi.unit_price as double) as unit_price,
    (cast(oi.quantity as int) * cast(oi.unit_price as double)) as line_amount,
    greatest(oi.load_timestamp, o.load_timestamp) as _src_loaded_at
  from {{ ref('silver_vw_order_items') }} oi
  join {{ ref('silver_vw_orders') }} o using (order_id)
  where lower(o.status) = 'completed'
),

cust_lkp as (
  select
    dbt_scd_id as customer_sk,
    customer_id,
    dbt_valid_from,
    coalesce(dbt_valid_to, timestamp '9999-12-31') as dbt_valid_to
  from {{ ref('dim_customers_scd2') }}
),

prod_lkp as (
  select
    dbt_scd_id as product_sk,
    product_id,
    dbt_valid_from,
    coalesce(dbt_valid_to, timestamp '9999-12-31') as dbt_valid_to
  from {{ ref('dim_products_scd2') }}
)

select
  s.order_id,
  s.order_date,
  s.customer_id,
  c.customer_sk,   -- FK to dim_customers (specific SCD2 version)
  s.product_id,
  p.product_sk,    -- FK to dim_products (specific SCD2 version)
  s.quantity,
  s.unit_price,
  s.line_amount,
  s._src_loaded_at
from src s
left join cust_lkp c
  on s.customer_id = c.customer_id
 and s.order_date  >= c.dbt_valid_from
 and s.order_date  <  c.dbt_valid_to
left join prod_lkp p
  on s.product_id  = p.product_id
 and s.order_date  >= p.dbt_valid_from
 and s.order_date  <  p.dbt_valid_to

{% if is_incremental() %}
where s._src_loaded_at >
      (select coalesce(max(_src_loaded_at), timestamp '1900-01-01') from {{ this }})
{% endif %}
