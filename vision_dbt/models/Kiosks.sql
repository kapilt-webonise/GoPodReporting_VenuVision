{{ config(materialized='table') }}

with source_data as (

    select  * from
    kiosks

)

select * from source_data
