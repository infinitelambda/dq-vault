{% macro result_to_dict(node) %}
  {{ return(adapter.dispatch('result_to_dict', 'dq_vault')(node)) }}
{% endmacro %}

{% macro default__result_to_dict(node) %}

  {% if node.node.resource_type is defined and node.node.resource_type == 'test' %}
    
    {# test node metadata #}
    {% set result = 
      {
        'status':                             node.status | default(none),
        'timing__compile__started_at':        node.timing[0].started_at.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3] | default(none),
        'timing__compile__completed_at':      node.timing[0].completed_at.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3] | default(none),
        'timing__execute__started_at':        node.timing[1].started_at.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3] | default(none),
        'timing__execute__completed_at':      node.timing[1].completed_at.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3] | default(none),
        'thread_id':                          node.thread_id | default(none),
        'execution_time':                     node.execution_time | default(none),
        'adapter_response':                   node.adapter_response | default({}),
        'message':                            node.message | default(none),
        'failures':                           node.failures | default(0),
        'node__raw_sql':                      node.node.raw_sql | replace('"',"(qot)") | replace('\n','(eol)') | default(none),
        'node__test_metadata__name':          node.node.test_metadata.name if node.node.test_metadata is defined else none | default(none),
        'node__test_metadata__kwargs':        node.node.test_metadata.kwargs if node.node.test_metadata is defined else none | default({}),
        'node__test_metadata__namespace':     node.node.test_metadata.namespace if node.node.test_metadata is defined else none | default(none),
        'node__compiled':                     node.node.compiled | default(false),
        'node__database':                     node.node.database | default(none),
        'node__schema':                       node.node.schema | default(none),
        'node__fqn':                          node.node.fqn | default([]),
        'node__unique_id':                    node.node.unique_id | default(none),
        'node__package_name':                 node.node.package_name | default(none),
        'node__root_path':                    node.node.root_path | default(none),
        'node__path':                         node.node.path | default(none),
        'node__original_file_path':           node.node.original_file_path | default(none),
        'node__name':                         node.node.name | default(none),
        'node__resource_type':                node.node.resource_type | default(none),
        'node__config__enabled':              node.node.config.enabled | default(true),
        'node__config__alias':                node.node.config.alias | default(none),
        'node__config__schema':               node.node.config.schema | default(none),
        'node__config__database':             node.node.config.databas | default(none),
        'node__config__tags':                 node.node.config.tags | default([]),
        'node__config__meta':                 node.node.config.meta | default({}),
        'node__config__materialized':         node.node.config.materialized | default(none),
        'node__config__severity':             node.node.config.severity | default(none),
        'node__config__store_failures':       node.node.config.store_failures | default(false),
        'node__config__where':                node.node.config.where | default(none),
        'node__config__limit':                node.node.config.limit | default(none),
        'node__config__fail_calc':            node.node.config.fail_calc | default(none),
        'node__config__warn_if':              node.node.config.warn_if | default(none),
        'node__config__error_if':             node.node.config.error_if | default(none),
        'node__tags':                         node.node.tags | default([]),
        'node__refs':                         node.node.refs | default([]),
        'node__sources':                      node.node.sources | default([]),
        'node__metrics':                      node.node.metrics | default([]),
        'node__depends_on__macros':           node.node.depends_on.macros | default([]),
        'node__depends_on__nodes':            node.node.depends_on.nodes | default([]),
        'node__description':                  node.node.description | default(none),
        'node__columns':                      node.node.columns | default({}),
        'node__meta':                         node.node.meta | default({}),
        'node__docs__show':                   node.node.docs.show | default(true),
        'node__patch_path':                   node.node.patch_path | default(none),
        'node__compiled_path':                node.node.compiled_path | default(none),
        'node__build_path':                   node.node.build_path | default(none),
        'node__deferred':                     node.node.deferred | default(false),
        'node__unrendered_config':            node.node.unrendered_config | default({}),
        'node__created_at':                   node.node.created_at | default(0),
        'node__config_call_dict':             node.node.config_call_dict | default({}),
        'node__extra_ctes_injected':          node.node.extra_ctes_injected | default(true),
        'node__extra_ctes':                   node.node.extra_ctes | default([]),
        'node__relation_name':                node.node.relation_name | default(none),
        'node__column_name':                  node.node.column_name | default(none),
        'node__file_key_name':                node.node.file_key_name | default(none),
      }

    %}

  {% endif %}

  {# project metadata #}
  {% do result.update({
    'project_name': project_name,
    'invocation_id': invocation_id
  }) %}

  {{ return(result) }}
  
{% endmacro %}