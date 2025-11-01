{% snapshot dim_customers_scd2 %}
{{
  config(
    unique_key='customer_id',
    strategy='check',
    check_cols=['full_name','email','city','country','loyalty_status']
  )
}}

-- Track clean attributes from silver (staging)
select
  customer_id,
  full_name,
  email,
  city,
  country,
  loyalty_status
from {{ ref('silver_vw_customers') }}

{% endsnapshot %}
