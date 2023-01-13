{% macro create_resources() %}
  {{ return(adapter.dispatch('create_resources', 'dq_vault')()) }}
{% endmacro %}

{% macro default__create_resources() %}

  {{ dq_vault.get_raw_test(create_sql=true) }}
  
{% endmacro %}