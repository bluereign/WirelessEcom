SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [report].[old_deviceservice]
AS
SELECT DISTINCT
 pg.UPC, nd.Name AS 'Device Name', STUFF(
             (SELECT ', ' + cptg.carrierserviceid
             FROM (SELECT * FROM cataloglastweek.DeviceService cdsl WHERE NOT EXISTS
(SELECT * FROM catalogthisweek.DeviceService cdst WHERE cdsl.UPC = cdst.UPC AND cdsl.CarrierServiceId = cdst.CarrierServiceId)) cptg
             WHERE cptg.upc = pg.upc
              FOR XML PATH (''))
             , 1, 1, '') AS 'ServiceBillCodes'
FROM (SELECT * FROM cataloglastweek.DeviceService cdsl WHERE NOT EXISTS
(SELECT * FROM catalogthisweek.DeviceService cdst WHERE cdsl.UPC = cdst.UPC AND cdsl.CarrierServiceId = cdst.CarrierServiceId)) pg
LEFT OUTER JOIN cataloglastweek.device nd ON nd.upc = pg.upc

GO
