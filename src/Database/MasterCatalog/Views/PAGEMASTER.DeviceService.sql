
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* Push Static Data to catalog.DeviceService */

CREATE VIEW [PAGEMASTER].[DeviceService] AS

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

SELECT
	pd.ProductGuid AS 'DeviceGuid'
	,ps.ProductGuid AS 'ServiceGuid'
	,cds.IsDefault
FROM
	catalog.DeviceService cds
INNER JOIN ParentGuid pd ON pd.ParentProductGuid = cds.DeviceGuid
INNER JOIN ParentGuid ps ON ps.ParentProductGuid = cds.ServiceGuid



GO
