with tables as (

  select  *
  from    information_schema.tables
  where   table_catalog = '{{ var("dq_vault__raw_db", target.database) | upper }}'
    and   table_schema = '{{ var("dq_vault__raw_schema", target.schema) | upper }}'
    and   table_name = '{{ "raw_test" | upper }}'

)

select  1
where   not exists (select 1 from tables limit 1)