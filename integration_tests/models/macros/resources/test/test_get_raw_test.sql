{%- set raw_test_relation -%}
  {{- var('dq_vault__raw_db', target.database) -}}.
  {{- var('dq_vault__raw_schema', target.schema) -}}.
  {{- 'raw_test' -}}
{%- endset %}

select  'default' as test_case,
        '{{ dq_vault.get_raw_test() }}' as actual,
        '{{ raw_test_relation }}' as expected, 1 as exact

union all
select  'create_sql=true' as test_case,
        '{{ dq_vault.get_raw_test(create_sql=true) }}' as actual,
        'create table if not exists {{ raw_test_relation }}' as expected, 0 as exact

union all
select  'create_sql=true, full_refresh=true' as test_case,
        '{{ dq_vault.get_raw_test(create_sql=true, full_refresh=true) }}' as actual,
        'create or replace table {{ raw_test_relation }}' as expected, 0 as exact