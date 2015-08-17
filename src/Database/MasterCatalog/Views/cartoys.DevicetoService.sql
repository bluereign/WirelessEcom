
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [cartoys].[DevicetoService] AS

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
--	CONVERT(nvarchar(30),'AT&T') AS Carrier
--	,cp.GersSku AS 'UPC'
--	,(SELECT cs.CarrierBillCode FROM catalog.Service cs WHERE cs.ServiceGuid = cds.ServiceGuid) AS 'ServiceBillCode'
--FROM ParentGuid pg
--INNER JOIN catalog.Device d ON d.DeviceGuid = pg.ProductGuid
--INNER JOIN catalog.Product cp ON cp.ProductGuid = d.DeviceGuid AND cp.ChannelID = '4'
--INNER JOIN catalog.DeviceService cds ON cds.DeviceGuid = pg.ParentProductGuid
--WHERE cds.ServiceGuid IN (SELECT ServiceGuid FROM catalog.Service WHERE CarrierGuid = '83D7A62E-E62F-4E37-A421-3D5711182FB0')
--AND cp.Active = '1'

SELECT DISTINCT
	C.CompanyName AS Carrier
	, P.GersSku AS UPC
	, S.CarrierBillCode AS ServiceBillCode
FROM [catalog].Device D
	INNER JOIN [catalog].Product P ON D.DeviceGuid = P.ProductGuid
	INNER JOIN [catalog].Company C ON D.CarrierGuid = C.CompanyGuid AND C.IsCarrier = 1
	INNER JOIN [catalog].DeviceService DS ON D.DeviceGuid = DS.DeviceGuid
	INNER JOIN [catalog].[Service] S ON DS.ServiceGuid = S.ServiceGuid
WHERE P.GersSku IS NOT NULL
	AND EXISTS (SELECT * FROM cartoys.Device WHERE Carrier = C.CompanyName AND UPC = P.GersSku)
	AND EXISTS (SELECT * FROM cartoys.[Service] WHERE Carrier = C.CompanyName AND CarrierBillCode = S.CarrierBillCode)

GO
