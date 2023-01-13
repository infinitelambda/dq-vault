{% test test_generate_random_test_result_base_on_current_time(model, column_name) %}

select
    {{ column_name }}
from {{ model }}
where second(current_timestamp()) %2 = 0  -- generate random pass/fail result

{% endtest %}