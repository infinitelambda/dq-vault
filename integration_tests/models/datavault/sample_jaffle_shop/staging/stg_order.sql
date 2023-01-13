{%- set yaml_metadata -%}

source_model: 'raw_orders'
hashed_columns:
  HKEY:
    - ID
  CUSTOMER_HKEY:
    - USER_ID
  HASHDIFF:
    is_hashdiff: true
    columns:
      - USER_ID
      - ORDER_DATE
      - STATUS

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}
{% set source_model = metadata_dict['source_model'] %}
{% set derived_columns = metadata_dict['derived_columns'] %}
{% set hashed_columns = metadata_dict['hashed_columns'] %}

with stage as (
{{ dbtvault.stage(include_source_columns=true,
                  source_model=source_model,
                  hashed_columns=hashed_columns,
                  derived_columns=derived_columns) }}
)

select  *
        ,{{ dbt_utils.current_timestamp() }} as load_datetime
        ,'jaffle_shop' as record_source
from    stage