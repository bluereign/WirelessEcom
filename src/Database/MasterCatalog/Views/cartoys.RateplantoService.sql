
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [cartoys].[RateplantoService] AS

--WITH ParentGuid (ProductId, ProductGuid, ParentProductGuid, GersSku, Active, ChannelId) AS (
--SELECT
--	p.ProductId
--	,p.ProductGuid
--	,ppc.ParentProductGuid
--	,p.GersSku
--	,p.Active
--	,p.ChannelID
--FROM
--	catalog.Product p
--INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = p.ProductGuid
--WHERE p.ChannelID = '4')

------- Device Information
--SELECT DISTINCT
--	cc.CompanyName AS 'Carrier'
--	,d.CarrierBillCode AS 'RateplanBillCode'
--	,(SELECT cs.CarrierBillCode FROM catalog.Service cs WHERE cs.ServiceGuid = cds.ServiceGuid) AS 'ServiceBillCode'
--       , CONVERT(tinyint, cdS.IsIncluded) AS IsIncluded --fix SSIS conversion warning **
--       , CONVERT(tinyint, cdS.IsRequired) AS IsRequired --fix SSIS conversion warning **
--       , CONVERT(tinyint, cdS.IsDefault) AS IsDefault --fix SSIS conversion warning **
--FROM catalog.rateplan d
--INNER JOIN catalog.Product cp ON cp.ProductGuid = d.rateplanguid AND cp.ChannelID = '4'
--INNER JOIN catalog.RateplanService cds ON cds.RateplanGuid= d.RateplanGuid
--INNER JOIN catalog.Company cc ON cc.CompanyGuid = d.CarrierGuid
--WHERE d.CarrierGuid = '83D7A62E-E62F-4E37-A421-3D5711182FB0'
--AND cp.active = '1'

--UNION 

--SELECT DISTINCT
--	cc.CompanyName AS 'Carrier'
--	,d.CarrierBillCode AS 'RateplanBillCode'
--	,(SELECT cs.CarrierBillCode FROM catalog.Service cs WHERE cs.ServiceGuid = cds.ServiceGuid) AS 'ServiceBillCode'
--	       , CONVERT(tinyint, cdS.IsIncluded) AS IsIncluded --fix SSIS conversion warning **
--       , CONVERT(tinyint, cdS.IsRequired) AS IsRequired --fix SSIS conversion warning **
--       , CONVERT(tinyint, cdS.IsDefault) AS IsDefault --fix SSIS conversion warning **
--FROM catalog.rateplan d
--INNER JOIN catalog.Product cp ON cp.ProductGuid = d.rateplanguid AND cp.ChannelID = '1'
--INNER JOIN catalog.RateplanService cds ON cds.RateplanGuid= d.RateplanGuid
--INNER JOIN catalog.Company cc ON cc.CompanyGuid = d.CarrierGuid
--WHERE d.CarrierGuid = '83D7A62E-E62F-4E37-A421-3D5711182FB0'
--AND cp.active = '1'


SELECT DISTINCT
	C.CompanyName AS Carrier
	, R.CarrierBillCode AS RateplanBillCode
	, S.CarrierBillCode AS ServiceBillCode
	, CONVERT(tinyint, RS.IsIncluded) AS IsIncluded
	, CONVERT(tinyint, RS.IsRequired) AS IsRequired
	, CONVERT(tinyint, RS.IsDefault) AS IsDefault
FROM catalog.Rateplan R
	INNER JOIN catalog.Company C on R.CarrierGuid = C.CompanyGuid AND C.IsCarrier = 1
	INNER JOIN catalog.RateplanService RS ON R.RateplanGuid = RS.RateplanGuid
	INNER JOIN catalog.[Service] S ON RS.ServiceGuid = S.ServiceGuid
WHERE EXISTS (SELECT * FROM cartoys.Rateplan WHERE Carrier = C.CompanyName AND CarrierBillCode = R.CarrierBillCode)
	AND EXISTS (SELECT * FROM cartoys.[Service] WHERE Carrier = C.CompanyName AND CarrierBillCode = S.CarrierBillCode)


GO
