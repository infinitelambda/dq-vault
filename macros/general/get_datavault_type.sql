{% macro get_datavault_type(key_column='node__refs') %}
  {{ return(adapter.dispatch('get_datavault_type', 'dq_vault')(key_column)) }}
{% endmacro %}

{%- macro default__get_datavault_type(key_column='node__refs') %}

  {%- set rules = var('dq_vault__selected_model_rules',{}) %}
  {%- if rules %}

    case

    {%- for rule in rules %}
      when
        {%- set rule_key, rule_values = rule.items() | first %}
        /* type: {{ rule_key }} */
        (
          {%- for rule_value in rule_values %}
            lower({{ key_column }}) like concat('%','{{ rule_value | lower }}','%') {% if not loop.last %} or {% endif %}
          {%- endfor %}
        )
        then '{{ rule_key | lower }}'
      
    {%- endfor %}
      else 'unknown'
    end

  {%- endif %}
  
{%- endmacro %}