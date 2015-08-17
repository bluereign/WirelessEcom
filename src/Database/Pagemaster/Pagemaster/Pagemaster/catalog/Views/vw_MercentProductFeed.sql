
CREATE view  [catalog].[vw_MercentProductFeed] as

select distinct
	   gs.GersSku as SKU,
       gi.VendorStockNumber as UPC,
	   d.UPC as MfrPartNumber,
	   (SELECT Value FROM catalog.[Property] WHERE ProductGUID = d.DeviceGUID AND Name = 'title' AND Active = 1) as Title,
	   (SELECT Value FROM catalog.[Property] WHERE ProductGUID = d.DeviceGUID AND Name = 'longDescription' AND Active = 1) as Description,
	   (SELECT Value FROM catalog.[Property] WHERE ProductGUID = d.DeviceGUID AND Name = 'shortDescription' AND Active = 1) as Feature,
	   'New' as Condition,
	   c2.CompanyName as Brand,
	   'http://membershipwireless.com/index.cfm/go/shop/do/PhoneDetails/productId/' + cast(p.ProductID as varchar) as ProductURL,
	   'http://membershipwireless.com/images/Catalog/cached/' + lower(cast(i.ImageGUID as varchar(40)) + '_600_0.jpg') as MainImageURL,	 
	   (SELECT TOP 1 Price FROM catalog.[GersPrice] WHERE GersSku = gs.GersSku and PriceGroupCode = 'ECN'
		 ORDER BY StartDate DESC) as StandardPrice,
	   'Wireless' as MerchantCategory,
	   'InStock' as AvailabilityCode,	  	   
	   0 as ShippingStandard,
	   c1.CompanyName as Custom_Carrier
from catalog.[GersStock] gs 
INNER JOIN catalog.[GersItm] gi on gi.GersSku = gs.GersSku
INNER JOIN catalog.[Product] p ON p.GersSku = gs.GersSku
INNER JOIN catalog.[Device] d on d.DeviceGuid = p.ProductGuid
INNER JOIN catalog.[Company] c1 on d.CarrierGuid = c1.CompanyGUID 
INNER JOIN catalog.[Company] c2 on d.ManufacturerGuid = c2.CompanyGUID
INNER JOIN catalog.[Image] i on i.ReferenceGUID = d.DeviceGUID

where gs.OrderDetailID IS NOT NULL AND p.Active = 1 
AND i.IsPrimaryImage = 1 
--AND C1.CompanyName = 'AT&T' and gs.GErsSku = 'AGALXYS3W'