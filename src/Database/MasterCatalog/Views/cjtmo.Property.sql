SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW cjtmo.Property AS
WITH ParentGuid (ProductId, ProductGuid, ParentProductGuid, GersSku, Active, ChannelId) AS (
SELECT DISTINCT
	p.ProductId
	,p.ProductGuid
	,ppc.ParentProductGuid
	,p.GersSku
	,p.Active
	,p.ChannelID
FROM
	catalog.Product p
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = p.ProductGuid
WHERE p.ChannelID = '3'
AND p.GersSku IN (SELECT GersSku FROM cjtmo.Product))


SELECT
	PropertyGuid
	--,cpp.ProductGuid
	,pg.ProductGuid AS 'ProductGuid'
	,IsCustom
	,LastModifiedDate
	,LastModifiedBy
	,Name
	,Value
	,cpp.Active
FROM catalog.Property cpp
INNER JOIN ParentGuid pg ON pg.ParentProductGuid = cpp.ProductGuid
WHERE cpp.ProductGuid IN (SELECT ProductGuid FROM catalog.product WHERE ProductId IN (SELECT ProductId FROM cjtmo.product WHERE ProductGuid IS NOT NULL)
AND ChannelID = '1')
GO
