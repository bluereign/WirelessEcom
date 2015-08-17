SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [report].[new_rateplandevice]
AS
SELECT DISTINCT
 pg.UPC, nd.Name AS 'Device Name', STUFF(
             (SELECT ', ' + cptg.rateplancarrierbillcode
             FROM (SELECT * FROM catalogthisweek.RateplanDevice crdt WHERE NOT EXISTS
(SELECT * FROM cataloglastweek.rateplandevice crdl WHERE crdt.UPC = crdl.UPC AND crdt.RateplanCarrierBillCode = crdl.RateplanCarrierBillCode)) cptg
             WHERE cptg.upc = pg.upc
              FOR XML PATH (''))
             , 1, 1, '') AS 'RateplanBillCodes'
FROM (SELECT * FROM catalogthisweek.RateplanDevice crdt WHERE NOT EXISTS
(SELECT * FROM cataloglastweek.rateplandevice crdl WHERE crdt.UPC = crdl.UPC AND crdt.RateplanCarrierBillCode = crdl.RateplanCarrierBillCode)) pg
LEFT OUTER JOIN catalogthisweek.device nd ON nd.upc = pg.upc
GO
