select  'default' as test_case,
        '{{ dq_vault.get_datavault_type() | escape }}' as actual,
        '{{  
          "case
            when 
              /* type: hub */
              (
                lower(node__refs) like concat('%','hub','%')
              )
              then 'hub'
            when 
              /* type: sat */
              (
                lower(node__refs) like concat('%','sat','%') or
                lower(node__refs) like concat('%','satellite','%')
              )
              then 'sat'
            when 
              /* type: link */
              (
                lower(node__refs) like concat('%','link','%') or
                lower(node__refs) like concat('%','tlink','%')or
                lower(node__refs) like concat('%','t_link','%')or
                lower(node__refs) like concat('%','lnk','%')or
                lower(node__refs) like concat('%','tlnk','%')or
                lower(node__refs) like concat('%','t_lnk','%')
              )
              then 'link'
            when 
              /* type: pit */
              (
                lower(node__refs) like concat('%','pit','%')
              )
              then 'pit'
            when 
              /* type: bridge */
              (
                lower(node__refs) like concat('%','bridge','%')
              )
              then 'bridge'
            when 
              /* type: xts */
              (
                lower(node__refs) like concat('%','xts','%')
              )
              then 'xts'
            else 'unknown'
          end" | escape }}' as expected

union all
select  'key_column="my_column"' as test_case,
        '{{ dq_vault.get_datavault_type(key_column="my_column") | escape }}' as actual,
        '{{  
          "case
            when 
              /* type: hub */
              (
                lower(my_column) like concat('%','hub','%')
              )
              then 'hub'
            when 
              /* type: sat */
              (
                lower(my_column) like concat('%','sat','%') or
                lower(my_column) like concat('%','satellite','%')
              )
              then 'sat'
            when 
              /* type: link */
              (
                lower(my_column) like concat('%','link','%') or
                lower(my_column) like concat('%','tlink','%')or
                lower(my_column) like concat('%','t_link','%')or
                lower(my_column) like concat('%','lnk','%')or
                lower(my_column) like concat('%','tlnk','%')or
                lower(my_column) like concat('%','t_lnk','%')
              )
              then 'link'
            when 
              /* type: pit */
              (
                lower(my_column) like concat('%','pit','%')
              )
              then 'pit'
            when 
              /* type: bridge */
              (
                lower(my_column) like concat('%','bridge','%')
              )
              then 'bridge'
            when 
              /* type: xts */
              (
                lower(my_column) like concat('%','xts','%')
              )
              then 'xts'
            else 'unknown'
          end" | escape }}' as expected