{% macro refresh_resouces() %}
  {{ return(adapter.dispatch('refresh_resouces', 'dq_vault')()) }}
{% endmacro %}

{% macro default__refresh_resouces() %}

  {{ dq_vault.get_raw_test(create_sql=true, full_refresh=true) }}
  
{% endmacro %}