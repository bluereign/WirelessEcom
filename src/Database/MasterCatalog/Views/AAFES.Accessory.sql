
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* Push Static Data to catalog.Accessory */


CREATE VIEW [AAFES].[Accessory] AS 

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
	cp.ProductGuid AS 'AccessoryGuid'
	,ca.ManufacturerGuid
	,ca.UPC
	,ca.Name
FROM
	catalog.Accessory ca
INNER JOIN catalog.Product cp ON cp.ProductGuid = ca.AccessoryGuid
WHERE cp.ChannelId = '3'

GO
