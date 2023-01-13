with 
    tests_metadata as (
        select
            -- PKs
            test_executed_at,
            test_id,
            -- 
            test_name,
            datavault_type,
            datavault_test_type,
            project_name,
            test_database,
            test_schema,
            test_column_name,
            test_severity,
            test_config_tags,
            test_tags,
            test_ref_models,  -- arrays of ref models
            test_sources,
            test_metrics,
            test_description,
            test_meta,
            cast(md5_binary(concat_ws('||',
                ifnull(nullif(upper(trim(cast(test_id as varchar))), ''), '^^'),
                ifnull(nullif(upper(trim(cast(test_name as varchar))), ''), '^^'),
                ifnull(nullif(upper(trim(cast(datavault_type as varchar))), ''), '^^'),
                ifnull(nullif(upper(trim(cast(datavault_test_type as varchar))), ''), '^^'),
                ifnull(nullif(upper(trim(cast(project_name as varchar))), ''), '^^'),
                ifnull(nullif(upper(trim(cast(test_database as varchar))), ''), '^^'),
                ifnull(nullif(upper(trim(cast(test_schema as varchar))), ''), '^^'),
                ifnull(nullif(upper(trim(cast(test_column_name as varchar))), ''), '^^'),
                ifnull(nullif(upper(trim(cast(test_severity as varchar))), ''), '^^'),
                ifnull(nullif(upper(trim(cast(test_config_tags as varchar))), ''), '^^'),
                ifnull(nullif(upper(trim(cast(test_tags as varchar))), ''), '^^'),
                ifnull(nullif(upper(trim(cast(test_ref_models as varchar))), ''), '^^'),
                ifnull(nullif(upper(trim(cast(test_sources as varchar))), ''), '^^'),
                ifnull(nullif(upper(trim(cast(test_metrics as varchar))), ''), '^^'),
                ifnull(nullif(upper(trim(cast(test_description as varchar))), ''), '^^'),
                ifnull(nullif(upper(trim(cast(test_meta as varchar))), ''), '^^')
            )) as binary(16)) as test_hashdiff
        from {{ ref('stg_test_dv') }}
    ),
    
    calculate_preceeding_test_run_time as (
        select 
            *,
            lag(test_hashdiff) ignore nulls over (
                partition by test_id order by test_executed_at) as preceeding_test_hashdiff
        from tests_metadata
    ),
    
    calculate_starting_timestamp_for_each_test_hashdiff as (
        select 
            *
        from calculate_preceeding_test_run_time
        where true 
        -- get the starting test_executed_at for each period of preceeding_test_hashdiff of a test_id
        and (test_hashdiff != preceeding_test_hashdiff or preceeding_test_hashdiff is null)
    ),

    source as (
        select
            * exclude (test_executed_at),
            test_executed_at as valid_from,
            coalesce (lead (test_executed_at) over (partition by test_id order by test_executed_at), to_timestamp('9999-12-31')) as valid_to
        from calculate_starting_timestamp_for_each_test_hashdiff
    )

select
    *,
    case when valid_to = to_timestamp('9999-12-31') then 'Y'  else 'N' end as valid_flag
from source