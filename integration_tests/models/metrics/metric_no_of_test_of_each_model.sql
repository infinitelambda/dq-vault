select * 
from {{ metrics.calculate(
    metric('no_of_test_of_each_model'),
    grain='day',
    dimensions=['test_ref_model', 'datavault_type']
) }}