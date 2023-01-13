{%- set yaml_metadata -%}
source_model: stg_order
src_pk: HKEY
src_fk: CUSTOMER_HKEY
src_ldts: LOAD_DATETIME
src_source: RECORD_SOURCE
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.link(src_pk=metadata_dict["src_pk"],
                 src_fk=metadata_dict["src_fk"],
                 src_ldts=metadata_dict["src_ldts"],
                 src_source=metadata_dict["src_source"],
                 source_model=metadata_dict["source_model"]) }}
