SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [report].[old_rateplanservice]
AS
SELECT DISTINCT
 pg.RateplanCarrierBillCode, nd.Title 'Rateplan Name', STUFF(
             (SELECT ', ' + cptg.ServiceCarrierBillCode
             FROM (SELECT * FROM cataloglastweek.RateplanService crsl WHERE NOT EXISTS
(SELECT * FROM catalogthisweek.RateplanService crst WHERE crsl.RateplanCarrierBillCode = crst.RateplanCarrierBillCode
AND crsl.ServiceCarrierBillCode = crst.ServiceCarrierBillCode)) cptg
             WHERE cptg.RateplanCarrierBillCode = pg.RateplanCarrierBillCode
              FOR XML PATH (''))
             , 1, 1, '') AS 'ServiceBillCodes'
FROM (SELECT * FROM cataloglastweek.RateplanService crsl WHERE NOT EXISTS
(SELECT * FROM catalogthisweek.RateplanService crst WHERE crsl.RateplanCarrierBillCode = crst.RateplanCarrierBillCode
AND crsl.ServiceCarrierBillCode = crst.ServiceCarrierBillCode)) pg
INNER JOIN catalogthisweek.rateplan nd ON nd.CarrierBillCode = pg.RateplanCarrierBillCode
GO
