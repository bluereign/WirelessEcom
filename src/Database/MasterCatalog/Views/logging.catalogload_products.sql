SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW  [logging].[catalogload_products] AS

SELECT DISTINCT
	lca.Type
	,lca.TableName AS 'Object'
	,(SELECT cpt.ProductType
	FROM catalog.ProductGuid cpg
	INNER JOIN catalog.Product cp ON CONVERT(varchar(128),cp.productguid) = CONVERT(varchar(128),cpg.ProductGuid)
	INNER JOIN catalog.ProductType cpt ON cpg.ProductTypeId = cpt.ProductTypeId
	WHERE CONVERT(varchar(128),cp.productid) = CONVERT(varchar(128),lca.PKCol)
	) AS 'Product'
	,ISNULL((SELECT cp.GersSku FROM catalog.product cp WHERE CONVERT(varchar(128),cp.productid) = CONVERT(varchar(128),lca.PKCol)),'Inactive') AS 'ProductSKU'
	,ISNULL((SELECT cp.Active FROM catalog.product cp WHERE CONVERT(varchar(128),cp.productid) = CONVERT(varchar(128),lca.PKCol)),'0') AS 'Active'
	,CASE
		WHEN lca1.OldValue IS NOT NULL OR lca1.NewValue IS NOT NULL AND (lca2.OldValue = lca2.NewValue) THEN 'GersSku'
		WHEN lca2.OldValue IS NOT NULL OR lca2.NewValue IS NOT NULL AND (lca1.OldValue = lca1.NewValue) THEN 'Active'
		ELSE '[MULTPLE]' END AS 'ModifiedValue'
	,ISNULL(lca1.OldValue,'---') AS 'PreviousGersSku'
	,ISNULL(lca1.NewValue,'---') AS 'NewGersSku'
	,ISNULL(lca2.OldValue,'---') AS 'PreviousStatus'
	,ISNULL(lca2.NewValue,'---') AS 'NewStatus'
	,lca.PKCol AS 'PK'
FROM logging.CatalogAudit lca
LEFT OUTER JOIN logging.CatalogAudit lca1 ON lca.PKCol = lca1.PkCol AND lca1.FieldName = 'GersSku'
LEFT OUTER JOIN logging.CatalogAudit lca2 ON lca.PKCol = lca2.PkCol AND lca2.FieldName = 'Active'
WHERE lca.SchemaName + lca.TableName = 'catalogproduct'
AND lca.PKCol IS NOT NULL

GO
