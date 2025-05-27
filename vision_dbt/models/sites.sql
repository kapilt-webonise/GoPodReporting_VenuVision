{{ config(materialized='table') }}

with source_data as (

        select        id,
        sitename,

       facilityid,    
       
       rentaloptionlookupid 
       
       from sites

)

select * from source_data
