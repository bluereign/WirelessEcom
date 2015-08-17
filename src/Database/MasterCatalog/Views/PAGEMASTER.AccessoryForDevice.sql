
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/* Push Static Data to catalog.AccessoryForDevice */

CREATE VIEW [PAGEMASTER].[AccessoryForDevice] AS

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
WHERE p.ChannelID = '5')

SELECT DISTINCT
	pd.ProductGuid AS 'DeviceGuid'
	,ps.ProductGuid AS 'AccessoryGuid'
	,cafd.Ordinal
FROM
	catalog.AccessoryForDevice cafd
INNER JOIN ParentGuid ps ON ps.ProductGuid = cafd.AccessoryGuid
INNER JOIN ParentGuid pd ON pd.ProductGuid = cafd.DeviceGuid

UNION

SELECT DISTINCT
	pd.ProductGuid AS 'DeviceGuid'
	,ps.ProductGuid AS 'AccessoryGuid'
	,cafd.Ordinal
FROM
	catalog.AccessoryForDevice cafd
INNER JOIN ParentGuid ps ON ps.ParentProductGuid = cafd.AccessoryGuid
INNER JOIN ParentGuid pd ON pd.ParentProductGuid = cafd.DeviceGuid

GO
