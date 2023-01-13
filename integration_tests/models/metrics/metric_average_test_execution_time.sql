select * 
from {{ metrics.calculate(
    metric('average_test_execution_time'),
    grain='day',
    dimensions=['test_id']
) }}