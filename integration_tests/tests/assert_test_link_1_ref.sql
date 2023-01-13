with 
    sample_data as (
        select 2 as a from {{ ref('it_sample_sat') }}
    )

select a from sample_data 
where false