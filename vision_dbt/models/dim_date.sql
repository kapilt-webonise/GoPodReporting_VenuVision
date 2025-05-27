{{ config(materialized='table') }}

with source_data as (
    select 
        row_number() over (order by seq8())-1 as rn
        ,dateadd('day', rn, '2022-01-01'::date) as d
    from table(generator(rowcount=>1800))
)

SELECT 
    
    CAST(TO_VARCHAR(DATE_TRUNC('DAY', d), 'YYYYMMDD') AS INTEGER) AS D_DATEKEY
    ,DATE_TRUNC('DAY', d) AS D_DATE
    ,TO_VARCHAR(DATE_TRUNC('DAY', d), 'DD') AS D_DAYOFWEEK
    ,TO_VARCHAR(DATE_TRUNC('DAY', d), 'MON') AS D_MONTH
    ,DATE_PART('YEAR', d) AS D_YEAR
    ,DATE_PART('Month', d) AS D_Mon
    ,DATE_PART('YEAR', d) * 100 + DATE_PART('MONTH', d) AS D_YEARMONTHNUM
    ,TO_VARCHAR(DATE_TRUNC('DAY', d), 'MON YYYY') AS D_YEARMONTH
 from source_data
