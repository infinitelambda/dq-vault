select * 
from {{ metrics.calculate(
    metric('no_of_test_of_each_run'),
    grain='day',
    dimensions=['run_id', 'run_est_executed_at', 'datavault_type', 'datavault_test_type'],
    where="no_of_test_of_each_run != 0"
) }}