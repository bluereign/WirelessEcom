



CREATE VIEW  [logging].[catalogload_service] AS

SELECT DISTINCT
	lca.Type
	,lca.TableName AS 'Object'
	,ISNULL((SELECT cs.CarrierBillCode FROM catalog.service cs WHERE CONVERT(varchar(128),cs.serviceguid) = CONVERT(varchar(128),lca.PKCol)),'Inactive') AS 'ServiceCarrierBillCode'
	,ISNULL((SELECT cp.Active FROM catalog.product cp WHERE CONVERT(varchar(128),cp.productguid) = CONVERT(varchar(128),lca.PKCol)),'0') AS 'Active'
	,CASE
		WHEN lca2.OldValue IS NOT NULL OR lca2.NewValue IS NOT NULL
		AND (lca3.OldValue = lca3.NewValue AND lca7.OldValue = lca7.NewValue AND lca11.OldValue = lca11.NewValue) THEN 'Name'
		WHEN lca3.OldValue IS NOT NULL OR lca3.NewValue IS NOT NULL
		AND (lca2.OldValue = lca2.NewValue AND lca7.OldValue = lca7.NewValue AND lca11.OldValue = lca11.NewValue) THEN 'CarrierBillCode'
		WHEN lca7.OldValue IS NOT NULL OR lca7.NewValue IS NOT NULL
		AND (lca3.OldValue = lca3.NewValue AND lca2.OldValue = lca2.NewValue AND lca11.OldValue = lca11.NewValue) THEN 'MonthlyFee'
		WHEN lca11.OldValue IS NOT NULL OR lca11.NewValue IS NOT NULL
		AND (lca2.OldValue = lca2.NewValue AND lca3.OldValue = lca3.NewValue AND lca7.OldValue = lca7.NewValue) THEN 'CartTypeId'
		ELSE '[MULTIPLE]' END AS 'ModifiedValue'
	,ISNULL(lca2.OldValue,'---') AS 'PreviousName'
	,ISNULL(lca2.NewValue,'---') AS 'NewName'
	,ISNULL(lca3.OldValue,'---') AS 'PreviousCarrierBillCode'
	,ISNULL(lca3.NewValue,'---') AS 'NewCarrierBillCode'
	,ISNULL(lca7.OldValue,'---') AS 'PreviousMonthlyFee'
	,ISNULL(lca7.NewValue,'---') AS 'NewMonthlyFee'
	,ISNULL(lca11.OldValue,'---') AS 'PreviousCartTypeId'
	,ISNULL(lca11.NewValue,'---') AS 'NewCartTypeId'
	,lca.PKCol AS 'PK'
FROM logging.CatalogAudit lca
LEFT OUTER JOIN logging.CatalogAudit lca2 ON lca.PkCol = lca2.PkCol AND lca2.FieldName = 'Title'
LEFT OUTER JOIN logging.CatalogAudit lca3 ON lca.PkCol = lca3.PkCol AND lca3.FieldName = 'CarrierBillCode'
LEFT OUTER JOIN logging.CatalogAudit lca7 ON lca.PkCol = lca7.PkCol AND lca7.FieldName = 'MonthlyFee'
LEFT OUTER JOIN logging.CatalogAudit lca11 ON lca.PkCol = lca11.PkCol AND lca11.FieldName = 'CartTypeId'
WHERE lca.SchemaName + lca.TableName = 'catalogservice'
AND lca.PKCol IS NOT NULL