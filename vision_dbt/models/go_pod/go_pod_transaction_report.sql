with source_data as (
    select 
        ts.TransactionDateTime as transaction_datetime,
        ts.TransactionIdentifier as transaction_identifier,
        f.facilityname as facility_name,
        s.sitename as site_name,
        rol.option as rental_option,
        k.kioskname as kiosk_name,
        case 
            when pst.id < 4 then 'Locker' 
            else 'Ancillary' 
        end as product_type,
        pst.ProductLongName as product_name,
        ptls.name as payment_type,
        tsls.name as status,
        ts.amount,
        ts.salestaxamount,
        cp.value as coupon_value,
        rcl.ReasonCode as coupon_reason
    from {{ source('public', 'TRANSACTIONSET') }} ts
    -- Primary joins
    join {{ source('public', 'PURCHASESET') }} ps 
        on ts.PurchaseId = ps.id
    inner join {{ source('public', 'TRANSACTIONSTATUSLOOKUPSET') }} tsls 
        on tsls.id = ts.transactionstatuslookupid
    -- Payment and coupon details
    left join {{ source('public', 'PAYMENTSET') }} pays 
        on pays.transactionid = ts.id
    left join {{ source('public', 'PAYMENTTYPELOOKUPSET') }} ptls 
        on ptls.id = pays.paymenttypelookupid
    left join {{ source('public', 'PRODUCTSET') }} pst 
        on pst.id = ts.ProductId
    left join {{ source('public', 'COUPONS') }} cp 
        on cp.id = pays.Coupon_Id
    left join {{ source('public', 'REASONCODELOOKUPS') }} rcl 
        on rcl.id = cp.ReasonCodeLookupId
    left join {{ source('public', 'LOCALCOUPONS') }} lcp 
        on lcp.id = pays.LocalCoupon_Id
    -- Kiosk and site mapping
    left join {{ source('public', 'KIOSKS') }} k 
        on k.id = ts.KioskId
    left join {{ source('public', 'SITES') }} s 
        on s.id = k.Site_Id
    left join {{ source('public', 'RENTALOPTIONLOOKUPS') }} rol 
        on rol.id = s.rentaloptionlookupid
    left join {{ source('public', 'FACILITIES') }} f 
        on f.id = s.facilityId

)

select *
from source_data