SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW cjtmo.ProductTag AS
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
WHERE p.ChannelID = '3' AND p.GersSku IN (SELECT GersSku FROM cjtmo.Product))

SELECT pg.ProductGuid, cpt.Tag FROM catalog.ProductTag cpt
INNER JOIN ParentGuid pg ON pg.ParentProductGuid = cpt.ProductGuid

UNION 

SELECT cp.ProductGuid, cpt.Tag FROM catalog.ProductTag cpt
INNER JOIN catalog.Product cp ON cp.ProductGuid = cpt.ProductGuid AND cp.ChannelID = '3'

GO
