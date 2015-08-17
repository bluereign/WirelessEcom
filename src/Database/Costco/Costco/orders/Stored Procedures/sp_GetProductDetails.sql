CREATE procedure [orders].[sp_GetProductDetails]
  @GersSKU varchar(30)
as


select ProductID, name as ProductTitle --, 0 as RetailPrice, 0 as Tax
 from catalog.Product p inner join catalog.Accessory a
 on a.AccessoryGuid = p.ProductGuid
where p.GersSku = @GersSKU
UNION
select ProductID, name as ProductTitle --, 0 as RetailPrice, 0 as Tax
 from catalog.Product p inner join catalog.Device a
 on a.DeviceGuid = p.ProductGuid
where p.GersSku = @GersSKU