
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [cartoys].[RateplanProperties] AS

WITH ParentGuid (ProductId, ProductGuid, ParentProductGuid, GersSku, Active, ChannelId) AS (
SELECT
	p.ProductId
	,p.ProductGuid
	,ppc.ParentProductGuid
	,p.GersSku
	,p.Active
	,p.ChannelID
FROM
	catalog.Product p
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = p.ProductGuid
WHERE p.ChannelID = '4'  AND p.Active = '1'
)

----- Device Information
SELECT
	d.CarrierBillCode
	,
      CASE WHEN LEN(cpy.Name) = '36' THEN cpm.label
      ELSE cpy.name END AS Name
	,cpy.Value
FROM ParentGuid pg
INNER JOIN catalog.rateplan d ON d.RateplanGuid = pg.ParentProductGuid
INNER JOIN catalog.Property cpy ON cpy.ProductGuid = d.RateplanGuid
LEFT OUTER JOIN catalog.propertymaster cpm ON CAST(cpm.propertymasterguid AS NVARCHAR(36)) = cpy.name
WHERE cpy.Name in (
SELECT CAST(cpm.propertymasterguid AS NVARCHAR(36)) FROM catalog.PropertyMaster)
AND D.CarrierGuid = '83D7A62E-E62F-4E37-A421-3D5711182FB0'

UNION

SELECT
	d.CarrierBillCode
	,
      CASE WHEN LEN(cpy.Name) = '36' THEN cpm.label
      ELSE cpy.name END AS Name
	,cpy.Value
FROM catalog.product pg
INNER JOIN catalog.rateplan d ON d.RateplanGuid = pg.ProductGuid AND ChannelID = '4' AND pg.ProductGuid NOT IN (SELECT ProductGuid FROM ParentGuid)
INNER JOIN catalog.Property cpy ON cpy.ProductGuid = d.RateplanGuid
LEFT OUTER JOIN catalog.propertymaster cpm ON CAST(cpm.propertymasterguid AS NVARCHAR(36)) = cpy.name
WHERE cpy.Name in (
SELECT CAST(cpm.propertymasterguid AS NVARCHAR(36)) FROM catalog.PropertyMaster)
AND D.CarrierGuid = '83D7A62E-E62F-4E37-A421-3D5711182FB0'



GO
