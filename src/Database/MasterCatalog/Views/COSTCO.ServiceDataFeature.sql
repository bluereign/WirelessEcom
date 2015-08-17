
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* Push Static Data to catalog.ServiceDataFeature */

CREATE VIEW [COSTCO].[ServiceDataFeature] AS
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
	crd.ServiceDataFeatureId
	,pr.ProductGuid AS 'ServiceGuid'
	,pd.ProductGuid AS 'ServiceDataGroupGuid'
	,crd.DeviceType
FROM
	catalog.ServiceDataFeature crd
INNER JOIN ParentGuid pr ON pr.ParentProductGuid = crd.ServiceGuid
INNER JOIN ParentGuid pd ON pd.ParentProductGuid = crd.ServiceDataGroupGuid

GO
