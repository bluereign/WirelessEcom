
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* Push Static Data to catalog.ProductTag */

CREATE VIEW [AAFES].[ProductTag] AS

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

SELECT pg.ProductGuid, cpt.Tag FROM catalog.ProductTag cpt
INNER JOIN ParentGuid pg ON pg.ParentProductGuid = cpt.ProductGuid

UNION 

SELECT pg.ProductGuid, cpt.Tag FROM catalog.ProductTag cpt
INNER JOIN ParentGuid pg ON pg.ProductGuid = cpt.ProductGuid

GO
