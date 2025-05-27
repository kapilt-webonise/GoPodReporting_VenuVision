{{ config(materialized='table') }}

with source_data as (

select *  from rentaloptionlookups

)

select * from source_data
