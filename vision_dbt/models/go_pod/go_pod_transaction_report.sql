with source_data as (

    select 
			ts.TransactionDateTime,
			f.facilityname, s.sitename, rol.option, k.id as KioskId, 
			CASE WHEN	pst.id < 4  THEN 'Locker' ELSE 'Ancillary' END as Product_Type,
			pst.ProductLongName, ptls.name as PaymentType, tsls.name as Status, 
			ts.amount, ts.salestaxamount,
			cp.value as CouponValue, rcl.ReasonCode as Coupon_Reason,
            f.id as facilityid,s.id as site_id,rol.id as rentaloptionlookupid
	from {{ source('public', 'TRANSACTIONSET') }} ts
		join {{ source('public', 'PURCHASESET') }} ps on ts.PurchaseId = ps.id
		inner join {{ source('public', 'TRANSACTIONSTATUSLOOKUPSET') }} tsls on tsls.id = ts.transactionstatuslookupid
		left join {{ source('public', 'PAYMENTSET') }} pays on pays.transactionid = ts.id
		left join {{ source('public', 'PAYMENTTYPELOOKUPSET') }} ptls on ptls.id = pays.paymenttypelookupid
		left join {{ source('public', 'PRODUCTSET') }} pst on pst.id = ts.ProductId
		left join {{ source('public', 'COUPONS') }} cp on cp.id = pays.Coupon_Id
		left join {{ source('public', 'REASONCODELOOKUPS') }} rcl on rcl.id = cp.ReasonCodeLookupId
		left join {{ source('public', 'LOCALCOUPONS') }} lcp on lcp.id = pays.LocalCoupon_Id
		left join {{ source('public', 'KIOSKS') }} k on k.id = ts.KioskId
		left join {{ source('public', 'SITES') }} s on s.id = k.Site_Id
		left join {{ source('public', 'RENTALOPTIONLOOKUPS') }} rol on rol.id = s.rentaloptionlookupid
		left join {{ source('public', 'FACILITIES') }} f on f.id = s.facilityId


)

select *
from source_data
