SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* Push Static Data to catalog.AccessoryForDevice */

CREATE VIEW [AAFES].[AccessoryForDeviceStage] AS
/*
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
WHERE p.ChannelID = '3')

SELECT DISTINCT
	pd.ProductGuid AS 'DeviceGuid'
	,ps.ProductGuid AS 'AccessoryGuid'
	,cafd.Ordinal
FROM
	catalog.AccessoryForDevice cafd
INNER JOIN ParentGuid ps ON ps.ProductGuid = cafd.AccessoryGuid
INNER JOIN ParentGuid pd ON pd.ProductGuid = cafd.DeviceGuid
*/

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
WHERE p.ChannelID = '3')

SELECT
	(SELECT TOP 1 pg.ProductGuid FROM ParentGuid pg
	WHERE pg.ParentProductGuid = afd.DeviceGuid AND afd.DeviceGuid IS NOT NULL AND afd.AccessoryGuid IS NOT NULL) AS 'DeviceGuid'
	,(SELECT TOP 1 pg.ProductGuid FROM ParentGuid pg
	WHERE pg.ParentProductGuid = afd.AccessoryGuid AND afd.AccessoryGuid IS NOT NULL AND afd.DeviceGuid IS NOT NULL) AS 'AccessoryGuid'
	,afd.Ordinal
	,afd.CreateDate
FROM catalog.AccessoryForDevice afd
WHERE DeviceGuid IS NOT NULL AND AccessoryGuid IS NOT NULL

UNION 

SELECT DISTINCT
	pd.ProductGuid AS 'DeviceGuid'
	,ps.ProductGuid AS 'AccessoryGuid'
	,cafd.Ordinal
	,cafd.CreateDate
FROM
	catalog.AccessoryForDevice cafd
INNER JOIN ParentGuid ps ON ps.ProductGuid = cafd.AccessoryGuid AND ps.ProductGuid IS NOT NULL
INNER JOIN ParentGuid pd ON pd.ProductGuid = cafd.DeviceGuid AND pd.ProductGuid IS NOT NULL
WHERE DeviceGuid IS NOT NULL AND AccessoryGuid IS NOT NULL





GO
