CREATE PROCedure [orders].sp_GetAccessoryDevice
	@GersSku varchar(10)

as
SELECT TOP 1 dp.GersSku
FROM catalog.Device d 
INNER JOIN catalog.Product dp ON dp.ProductGuid = d.DeviceGuid
INNER JOIN catalog.DeviceFreeAccessory da ON da.DeviceGuid = d.DeviceGuid
INNER JOIN catalog.Accessory a ON a.AccessoryGuid = da.ProductGuid
INNER JOIN catalog.Product ap ON ap.ProductGuid = a.AccessoryGuid
INNER JOIN catalog.ProductTag pt on pt.ProductGuid = ap.ProductGuid
WHERE pt.Tag = 'freeaccessory' and ap.gerssku = @GersSku
ORDER BY ap.ProductID asc, ap.GersSku asc