CREATE PROCedure [orders].[sp_GetDetails_SKU]
	@GersSku varchar(9)

as

SELECT d.Name, dp.GersSku,
 (SELECT COUNT(*) from catalog.GersStock WHERE GersSku = dp.GersSku
  AND OrderDetailID IS NULL
 ) AS Qty
FROM catalog.Device d 
INNER JOIN catalog.Product dp ON dp.ProductGuid = d.DeviceGuid
where  dp.gerssku = @GersSku
UNION
SELECT d.Name, dp.GersSku,
 (SELECT COUNT(*) from catalog.GersStock WHERE GersSku = dp.GersSku
  AND OrderDetailID IS NULL
 ) AS Qty
FROM catalog.Accessory d 
INNER JOIN catalog.Product dp ON dp.ProductGuid = d.AccessoryGuid
where  dp.gerssku = @GersSku