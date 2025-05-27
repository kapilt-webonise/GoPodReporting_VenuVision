{{ config(materialized='table') }}

with source_data as (

    select  facilityname ,Id from
    facilities

)

select * from source_data
