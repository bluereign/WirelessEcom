
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/* Push Static Data to catalog.DeviceService */

CREATE VIEW [AAFES].[DeviceService] AS

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
	,ps.ProductGuid AS 'ServiceGuid'
	,cds.IsDefault
FROM
	catalog.DeviceService cds
INNER JOIN ParentGuid pd ON pd.ParentProductGuid = cds.DeviceGuid
INNER JOIN ParentGuid ps ON ps.ParentProductGuid = cds.ServiceGuid

UNION

SELECT DISTINCT
	cds.DeviceGuid AS 'DeviceGuid'
	,cds.ServiceGuid  AS 'ServiceGuid'
	,cds.IsDefault
FROM
	catalog.DeviceService cds
INNER JOIN ParentGuid pd ON pd.ProductGuid = cds.DeviceGuid
INNER JOIN ParentGuid ps ON ps.ProductGuid = cds.ServiceGuid



GO
