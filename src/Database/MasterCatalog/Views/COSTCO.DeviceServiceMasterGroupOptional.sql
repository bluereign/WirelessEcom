
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* Push Static Data to catalog.DeviceServiceMasterGroupOptional */

CREATE VIEW [COSTCO].[DeviceServiceMasterGroupOptional] AS


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
WHERE p.ChannelID = '2')

SELECT
	pd.ProductGuid AS 'DeviceGuid'
FROM
	catalog.DeviceServiceMasterGroupOptional cds
INNER JOIN ParentGuid pd ON pd.ParentProductGuid = cds.DeviceGuid
GO
