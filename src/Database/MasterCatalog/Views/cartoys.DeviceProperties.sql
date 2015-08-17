
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [cartoys].[DeviceProperties] AS

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
WHERE p.ChannelID = '4')


----- Device Information
SELECT DISTINCT
	cp.GersSku AS 'UPC'
	,
      CASE WHEN LEN(cpy.Name) = '36' THEN cpm.label
      ELSE cpy.name END AS Name
	,cpy.Value
FROM ParentGuid pg
INNER JOIN catalog.Device d ON d.DeviceGuid = pg.ProductGuid
INNER JOIN catalog.Product cp ON cp.ProductGuid = d.DeviceGuid
INNER JOIN catalog.Property cpy ON cpy.ProductGuid = pg.ParentProductGuid
LEFT OUTER JOIN catalog.propertymaster cpm ON CAST(cpm.propertymasterguid AS NVARCHAR(36)) = cpy.name
WHERE cpy.Name in (
SELECT CAST(cpm.propertymasterguid AS NVARCHAR(36)) FROM catalog.PropertyMaster)









GO
