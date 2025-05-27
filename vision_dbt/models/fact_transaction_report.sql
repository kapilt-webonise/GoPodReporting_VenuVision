
{{ config(materialized='table') }}

with source_data as (

    select 
			ts.TransactionDateTime,
			f.facilityname, s.sitename, rol.option, k.id as KioskId, 
			CASE WHEN	pst.id < 4  THEN 'Locker' ELSE 'Ancillary' END as Product_Type,
			pst.ProductLongName, ptls.name as PaymentType, tsls.name as Status, 
			ts.amount, ts.salestaxamount,
			cp.value as CouponValue, rcl.ReasonCode as Coupon_Reason,
            f.id as facilityid,s.id as site_id,rol.id as rentaloptionlookupid
	from purchaseset ps
		join transactionset ts on ts.PurchaseId = ps.id
		inner join transactionstatuslookupset tsls on tsls.id = ts.transactionstatuslookupid
		left join paymentset pays on pays.transactionid = ts.id
		left join paymenttypelookupset ptls on ptls.id = pays.paymenttypelookupid
		left join productset pst on pst.id = ts.ProductId
		left join coupons cp on cp.id = pays.Coupon_Id
		left join ReasonCodeLookups rcl on rcl.id = cp.ReasonCodeLookupId
		left join LocalCoupons lcp on lcp.id = pays.LocalCoupon_Id
		left join kiosks k on k.id = ts.KioskId
		left join sites s on s.id = k.Site_Id
		left join RentalOptionLookups rol on rol.id = s.rentaloptionlookupid
		left join facilities f on f.id = s.facilityId


)

select *
from source_data
