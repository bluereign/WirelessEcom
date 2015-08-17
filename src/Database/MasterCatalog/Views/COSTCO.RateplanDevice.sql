
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* Push Static Data to catalog.RateplanDevice */

CREATE VIEW [COSTCO].[RateplanDevice] AS

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

SELECT DISTINCT
	pr.ProductGuid AS 'RateplanGuid'
	,pd.ProductGuid AS 'DeviceGuid'
	,crd.IsDefaultRateplan
FROM
	catalog.RateplanDevice crd
INNER JOIN ParentGuid pr ON pr.ParentProductGuid = crd.RateplanGuid
INNER JOIN ParentGuid pd ON pd.ParentProductGuid = crd.DeviceGuid

UNION

SELECT DISTINCT
	pr.ProductGuid AS 'RateplanGuid'
	,pd.ProductGuid AS 'DeviceGuid'
	,crd.IsDefaultRateplan
FROM
	catalog.RateplanDevice crd
INNER JOIN ParentGuid pr ON pr.ProductGuid = crd.RateplanGuid
INNER JOIN ParentGuid pd ON pd.ParentProductGuid = crd.DeviceGuid



GO
