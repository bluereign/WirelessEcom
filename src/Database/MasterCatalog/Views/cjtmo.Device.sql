SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW cjtmo.Device AS
SELECT DeviceGuid,CarrierGuid,ManufacturerGuid,UPC,Name
FROM catalog.Device WHERE DeviceGuid IN (SELECT ProductGuid FROM cjtmo.product WHERE ProductGuid IS NOT NULL)
GO
