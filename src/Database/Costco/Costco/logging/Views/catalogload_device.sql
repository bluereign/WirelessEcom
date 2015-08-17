



CREATE VIEW  [logging].[catalogload_device] AS

SELECT DISTINCT
	lca.Type
	,lca.TableName AS 'Object'
	,ISNULL((SELECT cp.GersSku FROM catalog.product cp WHERE CONVERT(varchar(128),cp.productguid) = CONVERT(varchar(128),lca.PKCol)),'Inactive') AS 'DeviceSKU'
	,ISNULL((SELECT cp.Active FROM catalog.product cp WHERE CONVERT(varchar(128),cp.productguid) = CONVERT(varchar(128),lca.PKCol)),'0') AS 'Active'
	,CASE
		WHEN lca1.OldValue IS NOT NULL OR lca1.NewValue IS NOT NULL AND (lca2.OldValue = lca2.NewValue) THEN 'UPC'
		WHEN lca2.OldValue IS NOT NULL OR lca2.NewValue IS NOT NULL AND (lca1.OldValue = lca1.NewValue) THEN 'Name'
		ELSE '[MULTPLE]' END AS 'ModifiedValue'
	,ISNULL(lca2.OldValue,'---') AS 'PreviousName'
	,ISNULL(lca2.NewValue,'---') AS 'NewName'
	,ISNULL(lca1.OldValue,'---') AS 'PreviousUPC'
	,ISNULL(lca1.NewValue,'---') AS 'NewUPC'
	,lca.PKCol AS 'PK'
FROM logging.CatalogAudit lca
LEFT OUTER JOIN logging.CatalogAudit lca1 ON lca.PkCol = lca1.PkCol AND lca1.FieldName = 'UPC'
LEFT OUTER JOIN logging.CatalogAudit lca2 ON lca.PkCol = lca2.PkCol AND lca2.FieldName = 'Name'
WHERE lca.SchemaName + lca.TableName = 'catalogdevice'
AND lca.PKCol IS NOT NULL