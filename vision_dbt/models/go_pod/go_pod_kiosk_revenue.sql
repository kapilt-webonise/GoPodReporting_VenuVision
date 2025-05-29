with source_data as (

    select 
        cast(kr.RevenueDate as date) as revenue_date,
        ifer.ExchangeRate as exchange_rate,
        coalesce(kr.Cash, 0) * coalesce(ifer.ExchangeRate, 0) as cash,
        coalesce(kr.Credit, 0) * coalesce(ifer.ExchangeRate, 0) as credit,
        coalesce(kr.Other, 0) * coalesce(ifer.ExchangeRate, 0) as other,
        coalesce(kr.Coupon, 0) * coalesce(ifer.ExchangeRate, 0) as coupon,
        coalesce(kr.Refunds, 0) * coalesce(ifer.ExchangeRate, 0) as refunds,
        f.FacilityName as facility_name,
        k.KIOSKNAME as kiosk_name,
        s.SITENAME as site_name
    from {{ source('public', 'KioskRevenues') }} kr
    inner join {{ source('public', 'KIOSKS') }} k on kr.KioskId = k.Id
    inner join {{ source('public', 'SITES') }} s on k.Site_Id = s.Id
    inner join {{ source('public', 'FACILITIES') }} f on s.FacilityId = f.Id
    inner join {{ source('public', 'INTERNATIONALFACILITIES') }} ifac on ifac.FacilityId = s.FacilityId
    inner join {{ source('public', 'INTERNATIONALFACILITYEXCHANGERATES') }} ifer 
        on ifer.InternationalFacilityId = ifac.Id 
        and ifer.Date = cast(kr.RevenueDate as date)

    where kr.Cash + kr.Credit + kr.Other + kr.Coupon + kr.Refunds > 0

)

select 
    revenue_date,
    facility_name,
    site_name,
    kiosk_name,
    sum(cash) as cash,
    sum(credit) as credit,
    sum(other) as other,
    sum(cash + credit + other) as total,
    sum(coupon) as coupon,
    sum(refunds) as refunds

from source_data
group by revenue_date, facility_name, site_name, kiosk_name
order by revenue_date, facility_name, site_name, kiosk_name
