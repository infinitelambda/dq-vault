select
    f.*,
    f2.value::string as test_ref_model
from {{ ref('fact_dv_tests') }} f,
lateral flatten(input => f.test_ref_models) f1,
lateral flatten(input => f1.value) f2 -- unnesting ref models array
