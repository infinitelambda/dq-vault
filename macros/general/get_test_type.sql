{% macro get_test_type() %}
  {{ return(adapter.dispatch('get_test_type', 'dq_vault')()) }}
{% endmacro %}

{%- macro default__get_test_type() %}

  lower(coalesce(
    cast(try_parse_json(node__test_metadata__kwargs):test_type as {{ dbt_utils.type_string() }}),
    cast(try_parse_json(node__config__meta):test_type as {{ dbt_utils.type_string() }}),
    {{ dq_vault.get_test_type_by_name() }},
    'unknown'
  ))
  
{%- endmacro %}


{% macro get_test_type_by_name() -%}

  case 
    when node__test_metadata__kwargs is not null /*generic*/ and (node__unique_id like '%unique%')
      then 'duplication'
    when node__test_metadata__kwargs is not null /*generic*/ and (node__unique_id like '%relationship%')
      then 'reference'
    when node__test_metadata__kwargs is not null /*generic*/ and (node__unique_id like '%equal%' or node__unique_id like '%equality%')
      then 'reconciliation'
    when node__test_metadata__kwargs is null and node__name is not null /*singular*/
      then 'reconciliation'
    else null
  end
  
{%- endmacro %}