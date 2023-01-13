select
    dim_dv_tests.* exclude(valid_from, valid_to, valid_flag),
    dim_dv_test_executions.* exclude(test_id),
    min(test_executed_at) over (partition by run_id) as run_est_executed_at
from {{ ref('dim_dv_tests') }}
inner join {{ ref('dim_dv_test_executions') }}
on dim_dv_tests.test_id = dim_dv_test_executions.test_id
and dim_dv_test_executions.test_executed_at >= dim_dv_tests.valid_from 
and dim_dv_test_executions.test_executed_at < dim_dv_tests.valid_to