
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/* Push Static Data to catalog.RateplanService */

CREATE VIEW [PAGEMASTER].[RateplanService] AS

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
	pd.ProductGuid AS 'ServiceGuid'
	,ps.ProductGuid AS 'RateplanGuid'
	,crs.IsDefault
	,crs.IsIncluded
	,crs.IsRequired
FROM
	catalog.RateplanService crs
INNER JOIN ParentGuid ps ON ps.ParentProductGuid = crs.RateplanGuid
INNER JOIN ParentGuid pd ON pd.ParentProductGuid = crs.ServiceGuid





GO
