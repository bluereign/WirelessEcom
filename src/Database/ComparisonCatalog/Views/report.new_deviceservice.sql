SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [report].[new_deviceservice]
AS
SELECT DISTINCT
 pg.UPC, nd.Name AS 'Device Name', STUFF(
             (SELECT ', ' + cptg.carrierserviceid
             FROM (SELECT * FROM catalogthisweek.DeviceService cdst WHERE NOT EXISTS
(SELECT * FROM cataloglastweek.DeviceService cdsl WHERE cdst.UPC = cdsl.UPC AND cdst.CarrierServiceId = cdsl.CarrierServiceId)) cptg
             WHERE cptg.upc = pg.upc
              FOR XML PATH (''))
             , 1, 1, '') AS 'ServiceBillCodes'
FROM (SELECT * FROM catalogthisweek.DeviceService cdst WHERE NOT EXISTS
(SELECT * FROM cataloglastweek.DeviceService cdsl WHERE cdst.UPC = cdsl.UPC AND cdst.CarrierServiceId = cdsl.CarrierServiceId)) pg
LEFT OUTER JOIN catalogthisweek.device nd ON nd.upc = pg.upc

GO
