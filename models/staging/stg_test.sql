with source as (

  select  *
          ,parse_json(content_json) as content
  
  from    {{ source('run_result_log', 'raw_test') }}

),

casting as (

  select   cast(content:project_name as {{ type_string() }}) as project_name
          ,cast(content:invocation_id as {{ type_string() }}) as invocation_id
          ,cast(content:status as {{ type_string() }}) as status
          ,cast(content:timing__compile__started_at as {{ type_timestamp() }}) as timing__compile__started_at
          ,cast(content:timing__compile__completed_at as {{ type_timestamp() }}) as timing__compile__completed_at
          ,cast(content:timing__execute__started_at as {{ type_timestamp() }}) as timing__execute__started_at
          ,cast(content:timing__execute__completed_at as {{ type_timestamp() }}) as timing__execute__completed_at
          ,cast(content:thread_id as {{ type_string() }}) as thread_id
          ,cast(content:execution_time as {{ type_numeric() }}) as execution_time
          ,cast(content:adapter_response as {{ type_string() }}) as adapter_response
          ,cast(content:message as {{ type_string() }}) as message
          ,cast(content:failures as {{ type_int() }}) as failures
          ,cast(content:node__raw_sql as {{ type_string() }}) as node__raw_sql
          ,cast(content:node__test_metadata__name as {{ type_string() }}) as node__test_metadata__name
          ,cast(content:node__test_metadata__kwargs as {{ type_string() }}) as node__test_metadata__kwargs
          ,cast(content:node__test_metadata__namespace as {{ type_string() }}) as node__test_metadata__namespace
          ,cast(content:node__compiled as {{ type_string() }}) as node__compiled
          ,cast(content:node__database as {{ type_string() }}) as node__database
          ,cast(content:node__schema as {{ type_string() }}) as node__schema
          ,cast(content:node__fqn as {{ type_string() }}) as node__fqn
          ,cast(content:node__unique_id as {{ type_string() }}) as node__unique_id
          ,cast(content:node__package_name as {{ type_string() }}) as node__package_name
          ,cast(content:node__root_path as {{ type_string() }}) as node__root_path
          ,cast(content:node__path as {{ type_string() }}) as node__path
          ,cast(content:node__original_file_path as {{ type_string() }}) as node__original_file_path
          ,cast(content:node__name as {{ type_string() }}) as node__name
          ,cast(content:node__resource_type as {{ type_string() }}) as node__resource_type
          ,cast(content:node__config__enabled as {{ type_string() }}) as node__config__enabled
          ,cast(content:node__config__alias as {{ type_string() }}) as node__config__alias
          ,cast(content:node__config__schema as {{ type_string() }}) as node__config__schema
          ,cast(content:node__config__database as {{ type_string() }}) as node__config__database
          ,cast(content:node__config__tags as {{ type_string() }}) as node__config__tags
          ,cast(content:node__config__meta as {{ type_string() }}) as node__config__meta
          ,cast(content:node__config__materialized as {{ type_string() }}) as node__config__materialized
          ,upper(cast(content:node__config__severity as {{ type_string() }})) as node__config__severity
          ,cast(content:node__config__store_failures as {{ type_string() }}) as node__config__store_failures
          ,cast(content:node__config__where as {{ type_string() }}) as node__config__where
          ,cast(content:node__config__limit as {{ type_string() }}) as node__config__limit
          ,cast(content:node__config__fail_calc as {{ type_string() }}) as node__config__fail_calc
          ,cast(content:node__config__warn_if as {{ type_string() }}) as node__config__warn_if
          ,cast(content:node__config__error_if as {{ type_string() }}) as node__config__error_if
          ,cast(content:node__tags as {{ type_string() }}) as node__tags
          -- ,cast(content:node__refs as {{ type_string() }}) as node__refs
          ,content:node__refs as node__refs  --  2 level array contain ref models
          ,cast(content:node__sources as {{ type_string() }}) as node__sources
          ,cast(content:node__metrics as {{ type_string() }}) as node__metrics
          ,cast(content:node__depends_on__macros as {{ type_string() }}) as node__depends_on__macros
          ,cast(content:node__depends_on__nodes as {{ type_string() }}) as node__depends_on__nodes
          ,cast(content:node__description as {{ type_string() }}) as node__description
          ,cast(content:node__columns as {{ type_string() }}) as node__columns
          ,cast(content:node__meta as {{ type_string() }}) as node__meta
          ,cast(content:node__docs__show as {{ type_string() }}) as node__docs__show
          ,cast(content:node__patch_path as {{ type_string() }}) as node__patch_path
          ,cast(content:node__compiled_path as {{ type_string() }}) as node__compiled_path
          ,cast(content:node__build_path as {{ type_string() }}) as node__build_path
          ,cast(content:node__deferred as {{ type_string() }}) as node__deferred
          ,cast(content:node__unrendered_config as {{ type_string() }}) as node__unrendered_config
          ,cast(content:node__created_at as {{ type_timestamp() }}) as node__created_at
          ,cast(content:node__config_call_dict as {{ type_string() }}) as node__config_call_dict
          ,cast(content:node__extra_ctes_injected as {{ type_string() }}) as node__extra_ctes_injected
          ,cast(content:node__extra_ctes as {{ type_string() }}) as node__extra_ctes
          ,cast(content:node__relation_name as {{ type_string() }}) as node__relation_name
          ,cast(content:node__column_name as {{ type_string() }}) as node__column_name
          ,cast(content:node__file_key_name as {{ type_string() }}) as node__file_key_name
          ,created_timestamp
  
  from    source

),

final as (

  select  *
          ,row_number() over (
            partition by  node__unique_id, {{ date_trunc("day", "created_timestamp") }}
            order by      created_timestamp desc
          ) as seq
          ,{{ dq_vault.get_test_type() }} as datavault_test_type
          ,{{ dq_vault.get_datavault_type() }} as datavault_type

  from    casting

)

select  * 
from    final