SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW  [logging].[catalogload_property] AS

SELECT DISTINCT
	lca.Type
	,lca.TableName AS 'Object'
	,ISNULL((SELECT cp.GersSku FROM catalog.product cp WHERE CONVERT(varchar(128),cp.productguid) = CONVERT(varchar(128),cpy.productguid)),'Inactive') AS 'GersSku'
	,ISNULL((SELECT cp.Active FROM catalog.product cp WHERE CONVERT(varchar(128),cp.productguid) = CONVERT(varchar(128),cpy.productguid)),'0') AS 'Active'
	,CASE
		WHEN lca2.OldValue IS NOT NULL OR lca2.NewValue IS NOT NULL
		AND (lca3.OldValue = lca3.NewValue AND lca7.OldValue = lca7.NewValue) THEN 'Name'
		WHEN lca3.OldValue IS NOT NULL OR lca3.NewValue IS NOT NULL
		AND (lca2.OldValue = lca2.NewValue AND lca7.OldValue = lca7.NewValue) THEN 'Value'
		WHEN lca7.OldValue IS NOT NULL OR lca7.NewValue IS NOT NULL
		AND (lca3.OldValue = lca3.NewValue AND lca2.OldValue = lca2.NewValue) THEN 'Status'
		ELSE '[MULTIPLE]' END AS 'ModifiedValue'
	,ISNULL(lca2.OldValue,'---') AS 'PreviousName'
	,ISNULL(lca2.NewValue,'---') AS 'NewName'
	,ISNULL(lca3.OldValue,'---') AS 'PreviousValue'
	,ISNULL(lca3.NewValue,'---') AS 'NewValue'
	,ISNULL(lca7.OldValue,'---') AS 'PreviousStatus'
	,ISNULL(lca7.NewValue,'---') AS 'NewStatus'
	,lca.PKCol AS 'PK'
FROM logging.CatalogAudit lca
LEFT OUTER JOIN catalog.Property cpy ON cpy.PropertyGuid = lca.PKCol
LEFT OUTER JOIN logging.CatalogAudit lca2 ON lca.PkCol = lca2.PkCol AND lca2.FieldName = 'Name'
LEFT OUTER JOIN logging.CatalogAudit lca3 ON lca.PkCol = lca3.PkCol AND lca3.FieldName = 'Value'
LEFT OUTER JOIN logging.CatalogAudit lca7 ON lca.PkCol = lca7.PkCol AND lca7.FieldName = 'Active'
WHERE lca.SchemaName + lca.TableName = 'catalogproperty'
AND lca.PKCol IS NOT NULL AND lca.FieldName NOT IN ('IsCustom', 'LastModifiedBy', 'LastModifiedDate')


GO
