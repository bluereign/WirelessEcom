SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [report].[new_rateplanservice]
AS
SELECT DISTINCT
 pg.RateplanCarrierBillCode, nd.Title 'Rateplan Name', STUFF(
             (SELECT ', ' + cptg.ServiceCarrierBillCode
             FROM (SELECT * FROM catalogthisweek.RateplanService crst WHERE NOT EXISTS
(SELECT * FROM cataloglastweek.RateplanService crsl WHERE crst.RateplanCarrierBillCode = crsl.RateplanCarrierBillCode
AND crst.ServiceCarrierBillCode = crsl.ServiceCarrierBillCode)) cptg
             WHERE cptg.RateplanCarrierBillCode = pg.RateplanCarrierBillCode
              FOR XML PATH (''))
             , 1, 1, '') AS 'ServiceBillCodes'
FROM (SELECT * FROM catalogthisweek.RateplanService crst WHERE NOT EXISTS
(SELECT * FROM cataloglastweek.RateplanService crsl WHERE crst.RateplanCarrierBillCode = crsl.RateplanCarrierBillCode
AND crst.ServiceCarrierBillCode = crsl.ServiceCarrierBillCode)) pg
INNER JOIN catalogthisweek.rateplan nd ON nd.CarrierBillCode = pg.RateplanCarrierBillCode
GO
