
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [cartoys].[DevicetoRateplan] AS

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
--WHERE p.ChannelID = '4' AND p.Active = '1')

------- Device Information
--SELECT DISTINCT C.CompanyName AS CarrierName
--	,cp.GersSku AS 'UPC'
--	,(SELECT cs.CarrierBillCode FROM catalog.Rateplan cs
--	WHERE cs.RateplanGuid = r.RateplanGuid AND cs.CarrierBillCode not in ('MSDGI20GB','MSDGJ30GB','MSDGK40GB','MSDGL50GB')
--	AND cs.CarrierBillCode IS NOT NULL) AS 'RateplanBillCode'
--FROM ParentGuid pg 
--INNER JOIN catalog.Device d ON d.DeviceGuid = pg.ProductGuid
--INNER JOIN catalog.Product cp ON cp.ProductGuid = d.DeviceGuid AND cp.ChannelID = '4'
--INNER JOIN catalog.RateplanDevice cds ON cds.DeviceGuid = pg.ParentProductGuid
--	INNER JOIN catalog.Rateplan R ON cds.RateplanGuid = R.RateplanGuid
--	--cds.RateplanGuid
--	INNER JOIN catalog.Company C ON R.CarrierGuid = C.CompanyGuid
--WHERE cp.Active = '1' AND r.RateplanGuid IN (SELECT ProductGuid FROM catalog.Product where Active = '1')



--UNION

--SELECT DISTINCT C.CompanyName AS CarrierName
--	,cp.GersSku AS 'UPC'
--	,(SELECT cs.CarrierBillCode FROM catalog.Rateplan cs WHERE cs.RateplanGuid = r.RateplanGuid) AS 'RateplanBillCode'
--FROM catalog.product cp
--INNER JOIN catalog.rateplan r ON r.RateplanGuid = cp.ProductGuid AND cp.ChannelID = '4' AND cp.Active = '1'
--INNER JOIN catalog.RateplanDevice cds ON cds.RateplanGuid = cp.ProductGuid
--	INNER JOIN catalog.device d ON cds.DeviceGuid = d.deviceguid
--	INNER JOIN catalog.Company C ON R.CarrierGuid = C.CompanyGuid
--WHERE cp.Active = '1' AND
--r.RateplanGuid IN (SELECT ProductGuid FROM catalog.Product where Active = '1' and ChannelID = '4')

SELECT DISTINCT
	C.CompanyName AS CarrierName
	, P.GersSku AS UPC
	, R.CarrierBillCode AS RateplanBillCode
FROM [catalog].Device D
	INNER JOIN [catalog].Product P ON D.DeviceGuid = P.ProductGuid
	INNER JOIN [catalog].Company C ON D.CarrierGuid = C.CompanyGuid AND C.IsCarrier = 1
	INNER JOIN [catalog].RateplanDevice RD ON D.DeviceGuid = RD.DeviceGuid
	INNER JOIN [catalog].Rateplan R ON RD.RateplanGuid = R.RateplanGuid
WHERE P.GersSku IS NOT NULL
	AND EXISTS (SELECT * FROM cartoys.Device WHERE Carrier = C.CompanyName AND UPC = P.GersSku)
	AND EXISTS (SELECT * FROM cartoys.Rateplan WHERE Carrier = C.CompanyName AND CarrierBillCode = R.CarrierBillCode)



GO
