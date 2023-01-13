{% macro store_test_results_json(results, batch=100) %}
  {{ return(adapter.dispatch('store_test_results_json', 'dq_vault')(results, batch)) }}
{% endmacro %}

{% macro default__store_test_results_json(results, batch=100) -%}

  {%- set enable_store_test = var('dq_vault__enable_store_test', false) -%}
  {%- if not enable_store_test or not execute %}
    {{ return('') }}
  {% endif -%}

  {%- set test_results = [] %}
  {%- for result in results if result.node.resource_type == 'test' %}
    {%- set test_results = test_results.append(dq_vault.result_to_dict(result)) -%}
  {% endfor -%}

  {%- if (test_results | length) == 0 %}
    {{ log("Found no test results to process.", true) if execute }}
    {{ return('') -}}
  {% endif -%}

  {%- set log_tbl %} {{ dq_vault.get_raw_test() }} {% endset -%}
  {{ log("Centralizing " ~ test_results|length ~ " test results in " + log_tbl, true) if execute -}}
  {{ dq_vault.create_resources() }}

  {% for i in range(0, (test_results | length), batch) -%}

    {% set chunk = test_results[i:i+batch] %}
    insert into {{ log_tbl }} (created_timestamp, content_json)

    with logs as (
      {% for result in chunk -%}
        
        {% set content_json = tojson(result) | replace("'","''") %}
        select  '{{ modules.datetime.datetime.now(modules.pytz.utc).strftime("%Y-%m-%d %H:%M:%S.%f")[:-3] }}' as created_timestamp,
                '{{ content_json }}' as content_json
        {{ "union all" if not loop.last }}

      {%- endfor %}

    )
    select    created_timestamp, content_json
    from      logs;

  {% endfor -%}

{%- endmacro %}