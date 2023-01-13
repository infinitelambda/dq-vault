with 
    sample_data as (
        select 2 as a from {{ ref('it_sample_sat') }} union all
        select 1 as a from {{ ref('it_sample_hub') }}
    )

select a from sample_data 
where true