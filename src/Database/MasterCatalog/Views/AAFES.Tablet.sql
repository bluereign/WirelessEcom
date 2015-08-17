SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








/* Push Static Data to catalog.Device */

CREATE VIEW [AAFES].[Tablet] AS

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
	pp.ProductGuid AS 'TabletGuid'
	,d.CarrierGuid
	,d.ManufacturerGuid
	,CASE WHEN
	d.UPC = '' THEN (SELECT UPC FROM catalog.Device WHERE DeviceGuid = pp.ProductGuid)
	WHEN d.UPC IS NULL  THEN (SELECT UPC FROM catalog.Device WHERE DeviceGuid = pp.ProductGuid)
	WHEN LEN(d.UPC) <> (SELECT LEN(UPC) FROM catalog.Device WHERE DeviceGuid = pp.ProductGuid) THEN (SELECT UPC FROM catalog.Device WHERE DeviceGuid = pp.ProductGuid) ELSE d.UPC END AS 'UPC'
	,ISNULL((SELECT Value FROM catalog.property WHERE Name = 'title' AND ProductGuid = pp.ProductGuid),(SELECT Value FROM catalog.property WHERE Name = 'title' AND ProductGuid = d.TabletGuid)) AS 'Name'
FROM
	catalog.Tablet d
INNER JOIN ParentGuid pp ON pp.ParentProductGuid = d.TabletGuid
WHERE pp.ChannelId = '3'









GO
