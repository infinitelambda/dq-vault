select 
    project_name,
    invocation_id as run_id,
    status as test_status,
    {# timing__compile__started_at, #}
    {# timing__compile__completed_at, #}
    timing__execute__started_at as test_executed_at,
    timing__execute__completed_at as test_completed_at,
    {# thread_id, #}
    execution_time as test_execution_time,
    {# adapter_response, #}
    message as test_message,
    failures as failures_count,
    {# node__raw_sql, #}
    {# node__test_metadata__name, #}
    {# node__test_metadata__kwargs, #}
    {# node__test_metadata__namespace, #}
    {# node__compiled, #}
    node__database as test_database,
    node__schema as test_schema,
    {# node__fqn, #}
    node__unique_id as test_id,
    {# node__package_name, #}
    {# node__root_path, #}
    {# node__path, #}
    {# node__original_file_path, #}
    node__name as test_name,
    {# node__resource_type, #}
    {# node__config__enabled, #}
    {# node__config__alias, #}
    {# node__config__schema, #}
    {# node__config__database, #}
    node__config__tags as test_config_tags,
    {# node__config__meta, #}
    {# node__config__materialized, #}
    node__config__severity as test_severity,
    {# node__config__store_failures, #}
    {# node__config__where, #}
    {# node__config__limit, #}
    {# node__config__fail_calc, #}
    {# node__config__warn_if, #}
    {# node__config__error_if, #}
    node__tags as test_tags,
    node__refs as test_ref_models,
    node__sources as test_sources,
    node__metrics as test_metrics,
    {# node__depends_on__macros, #}
    {# node__depends_on__nodes, #}
    node__description as test_description,
    {# node__columns, #}
    node__meta as test_meta,
    {# node__docs__show, #}
    {# node__patch_path, #}
    {# node__compiled_path, #}
    {# node__build_path, #}
    {# node__deferred, #}
    {# node__unrendered_config, #}
    {# node__created_at as test_created_at, #}
    {# node__config_call_dict, #}
    {# node__extra_ctes_injected, #}
    {# node__extra_ctes, #}
    {# node__relation_name, #}
    node__column_name as test_column_name,
    {# node__file_key_name, #}
    {# created_timestamp, #}
    seq,
    datavault_test_type,
    datavault_type
from {{ ref('stg_test') }}
where {{ where_select_dv_models() }}