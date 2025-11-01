{{ config(
    materialized='incremental',
    unique_key='date',
    on_schema_change='sync_all_columns'
) }}

-- Build a date dimension from the min/max of your orders,
-- with a 1-year lookahead to cover future dates.
with bounds as (
  select
    coalesce(min(order_date), date '2020-01-01') as start_date,
    coalesce(max(order_date), current_date)      as end_date
  from {{ ref('silver_vw_orders') }}
),
series as (
  select
    d::date as date
  from bounds,
       generate_series(start_date, end_date + interval 365 day, interval 1 day) as gs(d)
)

select
  date                                        as date,
  cast(strftime(date, '%Y%m%d') as int)       as date_key,

  extract(year    from date)                  as year,
  extract(quarter from date)                  as quarter,
  extract(month   from date)                  as month,
  strftime(date, '%B')                        as month_name,
  extract(day     from date)                  as day_of_month,

  cast(strftime(date, '%u') as int)           as iso_day_of_week,  -- 1=Mon..7=Sun
  strftime(date, '%A')                         as day_name,
  case when cast(strftime(date, '%u') as int) in (6,7) then true else false end as is_weekend,

  cast(strftime(date, '%V') as int)           as iso_week_of_year,
  cast(strftime(date, '%G') as int)           as iso_year,

  date_trunc('week',  date)::date             as week_start_date,
  date_trunc('month', date)::date             as month_start_date,
  (date_trunc('month', date) + interval 1 month - interval 1 day)::date as month_end_date,
  date_trunc('quarter', date)::date           as quarter_start_date,
  (date_trunc('quarter', date) + interval 3 month - interval 1 day)::date as quarter_end_date,
  date_trunc('year', date)::date              as year_start_date,
  (date_trunc('year', date) + interval 1 year - interval 1 day)::date as year_end_date

from series

{% if is_incremental() %}
-- Only append dates newer than what's already in the table
where date >
  (select coalesce(max(date), date '1900-01-01') from {{ this }})
{% endif %}
