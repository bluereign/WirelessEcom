
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/* Push Static Data to catalog.RateplanMarket */

CREATE VIEW [AAFES].[RateplanMarket] AS

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
	pp.ProductGuid AS 'RateplanGuid'
	,r.MarketGuid
	,r.CarrierPlanReference
FROM
	catalog.RateplanMarket r
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = r.RateplanGuid
INNER JOIN ParentGuid pp ON pp.ProductGuid = ppc.ProductGuid
WHERE pp.ChannelId = '3'

UNION 

SELECT DISTINCT
	pp.ProductGuid AS 'RateplanGuid'
	,r.MarketGuid
	,r.CarrierPlanReference
FROM
	catalog.RateplanMarket r
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ParentProductGuid = r.RateplanGuid
INNER JOIN ParentGuid pp ON pp.ProductGuid = ppc.ProductGuid
WHERE pp.ChannelId = '3'







GO
