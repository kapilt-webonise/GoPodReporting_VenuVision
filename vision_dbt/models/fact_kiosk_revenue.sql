{{ config(materialized='table') }}

with source_data as (

    SELECT 
	CAST(kr.RevenueDate AS date) as RevenueDate ,--  kr.Cash, kr.Credit, kr.Other, kr.Coupon, kr.Refunds,
        ifer.ExchangeRate,
		coalesce(kr.Cash, 0) * coalesce(ifer.ExchangeRate, 0) as cash,
		coalesce(kr.Credit, 0) * coalesce(ifer.ExchangeRate, 0) as credit,
		coalesce(kr.Other, 0) * coalesce(ifer.ExchangeRate, 0) as other,
		coalesce(kr.Coupon, 0) * coalesce(ifer.ExchangeRate, 0) Coupon,
		coalesce(kr.Refunds, 0) * coalesce(ifer.ExchangeRate, 0) as Refunds,
	    f.Id,
        f.FacilityName 

	FROM KioskRevenues kr 
	INNER JOIN Kiosks k ON kr.KioskId = k.Id 
	INNER JOIN Sites s on k.Site_Id = s.Id 
	INNER JOIN Facilities f ON s.FacilityId = f.Id
	INNER JOIN InternationalFacilities ifac ON ifac.FacilityId = s.FacilityId
	INNER JOIN InternationalFacilityExchangeRates ifer ON ifer.InternationalFacilityId = ifac.Id 
	 and ifer.Date = CAST(kr.RevenueDate AS date)
	WHERE --Convert(date, kr.RevenueDate) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) -1, 0)
	--AND Convert(date, kr.RevenueDate) < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND
	kr.Cash + kr.Credit + kr.Other + kr.Coupon + kr.Refunds > 0
    --and TO_VARCHAR(DATE_TRUNC('DAY', revenuedate), 'MON YYYY') = 'May 2025'


)
 
 SELECT RevenueDate , 
            SUM(Cash) AS Cash,
            SUM(Credit) AS Credit,
            SUM(Other) AS Other,
            SUM(Cash + Credit + Other) AS Total,
            SUM(Coupon) AS Coupon, 
            SUM(Refunds) AS Refunds, 
            FacilityName AS FacilityName
	 from source_data

	GROUP BY RevenueDate, FacilityName
	ORDER BY RevenueDate, FacilityName

