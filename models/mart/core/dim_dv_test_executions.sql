select distinct
    -- PKs
    run_id,
    test_id,
    --
    test_status,
    test_message,
    failures_count,
    test_executed_at,
    test_completed_at,
    test_execution_time
from {{ ref('stg_test_dv') }}