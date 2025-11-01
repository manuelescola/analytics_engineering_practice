{{ config(
    materialized='incremental',
    unique_key='dbt_scd_id',
    on_schema_change='sync_all_columns'
) }}

-- Bring the entire SCD2 history from the snapshot
-- MERGE (via unique_key) updates previously-open rows that get "closed" and inserts new versions
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
from {{ ref('dim_customers_scd2') }}

-- No is_incremental() filter on purpose:
-- If we filtered only "new" rows, we might miss updates to dbt_valid_to on existing rows.
-- In a fact table, we use incremental to check for new rows (with load date) and those new rows can be either
-- update (i.e., correct) an old row (that you already had in your fact table) or insert a new row.
