{%- set yaml_metadata -%}
source_model: stg_customer
src_pk: HKEY
src_hashdiff: HASHDIFF
src_payload:
  - ID
  - FIRST_NAME
  - LAST_NAME

src_ldts: LOAD_DATETIME
src_source: RECORD_SOURCE
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.sat(src_pk=metadata_dict["src_pk"],
                src_hashdiff=metadata_dict["src_hashdiff"],
                src_payload=metadata_dict["src_payload"],
                src_ldts=metadata_dict["src_ldts"],
                src_source=metadata_dict["src_source"],
                source_model=metadata_dict["source_model"]) }}
