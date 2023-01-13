{% macro get_raw_test(create_sql=false, full_refresh=false) %}
  {{ return(adapter.dispatch('get_raw_test', 'dq_vault')(create_sql, full_refresh)) }}
{% endmacro %}

{% macro default__get_raw_test(create_sql=false, full_refresh=false) -%}

  {%- set raw_test_schema -%}
    {{- var('dq_vault__raw_db', target.database) -}}.
    {{- var('dq_vault__raw_schema', target.schema) -}}
  {%- endset %}

  {%- set raw_test_relation -%}
    {{- raw_test_schema -}}.{{- 'raw_test' -}}
  {%- endset %}

  {%- if not create_sql -%}
    {{ raw_test_relation }}
  {%- else %}

    create {% if full_refresh %}or replace {% endif %}schema {% if not full_refresh %}if not exists {% endif %}{{ raw_test_schema }};
    create {% if full_refresh %}or replace {% endif %}table {% if not full_refresh %}if not exists {% endif %}{{ raw_test_relation }}
      (created_timestamp {{ type_timestamp() }}, content_json {{ type_string() }});
    
  {%- endif %}
  
{%- endmacro %}