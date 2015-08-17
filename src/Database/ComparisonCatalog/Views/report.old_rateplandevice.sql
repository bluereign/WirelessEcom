SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [report].[old_rateplandevice]
AS
SELECT DISTINCT
 pg.UPC, nd.Name AS 'Device Name', STUFF(
             (SELECT ', ' + cptg.rateplancarrierbillcode
             FROM (SELECT * FROM cataloglastweek.RateplanDevice crdl WHERE NOT EXISTS
(SELECT * FROM catalogthisweek.rateplandevice crdt WHERE crdl.UPC = crdt.UPC AND crdl.RateplanCarrierBillCode = crdt.RateplanCarrierBillCode)) cptg
             WHERE cptg.upc = pg.upc
              FOR XML PATH (''))
             , 1, 1, '') AS 'RateplanBillCodes'
FROM (SELECT * FROM cataloglastweek.RateplanDevice crdl WHERE NOT EXISTS
(SELECT * FROM catalogthisweek.rateplandevice crdt WHERE crdl.UPC = crdt.UPC AND crdl.RateplanCarrierBillCode = crdt.RateplanCarrierBillCode)) pg
INNER JOIN cataloglastweek.device nd ON nd.upc = pg.upc
WHERE pg.RateplanCarrierBillCode IS NOT NULL
GO
