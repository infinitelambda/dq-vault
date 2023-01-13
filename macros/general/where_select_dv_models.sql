{% macro where_select_dv_models(key_column='node__refs') %}
  {{ return(adapter.dispatch('where_select_dv_models', 'dq_vault')(key_column)) }}
{% endmacro %}

{%- macro default__where_select_dv_models(key_column='node__refs') %}

  {%- set rules = var('dq_vault__selected_model_rules',{}) %}
  {%- if rules %}
    (
    {%- for rule in rules %}
      
      {%- set rule_key, rule_values = rule.items() | first %}
      /* type: {{ rule_key }} */
      (
        {%- for rule_value in rule_values %}
          lower({{ key_column }}) like concat('%','{{ rule_value | lower }}','%') {% if not loop.last %} or {% endif %}
        {%- endfor %}
      )
      {% if not loop.last -%} or {% endif %}
      
    {%- endfor %}
    )

  {%- endif %}
  
{%- endmacro %}