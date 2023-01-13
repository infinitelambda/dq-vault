select * 
from {{ metrics.calculate(
    metric('test_status_of_each_run'),
    grain='day',
    dimensions=['run_id', 'run_est_executed_at', 'datavault_type', 'datavault_test_type', 'test_status'],
    where="test_status_of_each_run != 0"
) }}