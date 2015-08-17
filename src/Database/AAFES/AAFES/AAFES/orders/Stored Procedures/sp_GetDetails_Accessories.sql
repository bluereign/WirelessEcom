CREATE PROCedure [orders].[sp_GetDetails_Accessories]
	@GersSku varchar(9)

as

SELECT ap.GersSku, 
 (SELECT COUNT(*) from catalog.GersStock WHERE GersSku = ap.GersSku
  AND OrderDetailID IS NULL
 ) AS Qty
FROM catalog.Device d 
INNER JOIN catalog.Product dp ON dp.ProductGuid = d.DeviceGuid
INNER JOIN catalog.DeviceFreeAccessory da ON da.DeviceGuid = d.DeviceGuid
INNER JOIN catalog.Accessory a ON a.AccessoryGuid = da.ProductGuid
INNER JOIN catalog.Product ap ON ap.ProductGuid = a.AccessoryGuid
INNER JOIN catalog.ProductTag pt on pt.ProductGuid = ap.ProductGuid
WHERE dp.GersSku = @GersSku and Tag = 'freeaccessory'
ORDER BY ap.ProductID asc, ap.GersSku asc