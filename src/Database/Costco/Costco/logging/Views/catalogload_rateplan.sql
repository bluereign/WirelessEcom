



CREATE VIEW  [logging].[catalogload_rateplan] AS

SELECT DISTINCT
	lca.Type
	,lca.TableName AS 'Object'
	,ISNULL((SELECT cr.CarrierBillCode FROM catalog.rateplan cr WHERE CONVERT(varchar(128),cr.rateplanguid) = CONVERT(varchar(128),lca.PKCol)),'Inactive') AS 'RateplanCode'
	,ISNULL((SELECT cp.Active FROM catalog.product cp WHERE CONVERT(varchar(128),cp.productguid) = CONVERT(varchar(128),lca.PKCol)),'0') AS 'Active'
	,CASE
		WHEN lca2.OldValue IS NOT NULL OR lca2.NewValue IS NOT NULL
		AND (lca3.OldValue = lca3.NewValue AND lca4.OldValue = lca4.NewValue AND lca5.OldValue = lca5.NewValue
		AND lca6.OldValue = lca6.NewValue AND lca7.OldValue = lca7.NewValue AND lca8.OldValue = lca8.NewValue
		AND lca9.OldValue = lca9.NewValue AND lca10.OldValue = lca10.NewValue AND lca11.OldValue = lca11.NewValue) THEN 'Name'
		WHEN lca3.OldValue IS NOT NULL OR lca3.NewValue IS NOT NULL
		AND (lca2.OldValue = lca2.NewValue AND lca4.OldValue = lca4.NewValue AND lca5.OldValue = lca5.NewValue
		AND lca6.OldValue = lca6.NewValue AND lca7.OldValue = lca7.NewValue AND lca8.OldValue = lca8.NewValue
		AND lca9.OldValue = lca9.NewValue AND lca10.OldValue = lca10.NewValue AND lca11.OldValue = lca11.NewValue) THEN 'Type'
		WHEN lca4.OldValue IS NOT NULL OR lca4.NewValue IS NOT NULL
		AND (lca2.OldValue = lca2.NewValue AND lca3.OldValue = lca3.NewValue AND lca5.OldValue = lca5.NewValue
		AND lca6.OldValue = lca6.NewValue AND lca7.OldValue = lca7.NewValue AND lca8.OldValue = lca8.NewValue
		AND lca9.OldValue = lca9.NewValue AND lca10.OldValue = lca10.NewValue AND lca11.OldValue = lca11.NewValue) THEN 'ContractTerm'
		WHEN lca5.OldValue IS NOT NULL OR lca5.NewValue IS NOT NULL
		AND (lca2.OldValue = lca2.NewValue AND lca3.OldValue = lca3.NewValue AND lca4.OldValue = lca4.NewValue
		AND lca6.OldValue = lca6.NewValue AND lca7.OldValue = lca7.NewValue AND lca8.OldValue = lca8.NewValue
		AND lca9.OldValue = lca9.NewValue AND lca10.OldValue = lca10.NewValue AND lca11.OldValue = lca11.NewValue) THEN 'IncludedLines'
		WHEN lca6.OldValue IS NOT NULL OR lca6.NewValue IS NOT NULL
		AND (lca2.OldValue = lca2.NewValue AND lca3.OldValue = lca3.NewValue AND lca4.OldValue = lca4.NewValue
		AND lca5.OldValue = lca5.NewValue AND lca7.OldValue = lca7.NewValue AND lca8.OldValue = lca8.NewValue
		AND lca9.OldValue = lca9.NewValue AND lca10.OldValue = lca10.NewValue AND lca11.OldValue = lca11.NewValue) THEN 'MaxLines'
		WHEN lca7.OldValue IS NOT NULL OR lca7.NewValue IS NOT NULL
		AND (lca3.OldValue = lca3.NewValue AND lca4.OldValue = lca4.NewValue AND lca5.OldValue = lca5.NewValue
		AND lca6.OldValue = lca6.NewValue AND lca2.OldValue = lca2.NewValue AND lca8.OldValue = lca8.NewValue
		AND lca9.OldValue = lca9.NewValue AND lca10.OldValue = lca10.NewValue AND lca11.OldValue = lca11.NewValue) THEN 'MonthlyFee'
		WHEN lca8.OldValue IS NOT NULL OR lca8.NewValue IS NOT NULL
		AND (lca3.OldValue = lca3.NewValue AND lca4.OldValue = lca4.NewValue AND lca2.OldValue = lca2.NewValue
		AND lca5.OldValue = lca5.NewValue AND lca6.OldValue = lca6.NewValue AND lca7.OldValue = lca7.NewValue
		AND lca9.OldValue = lca9.NewValue AND lca10.OldValue = lca10.NewValue AND lca11.OldValue = lca11.NewValue) THEN 'AdditionalLineFee'
		WHEN lca9.OldValue IS NOT NULL OR lca9.NewValue IS NOT NULL
		AND (lca2.OldValue = lca2.NewValue AND lca3.OldValue = lca3.NewValue AND lca4.OldValue = lca4.NewValue
		AND lca5.OldValue = lca5.NewValue AND lca7.OldValue = lca7.NewValue AND lca8.OldValue = lca8.NewValue
		AND lca6.OldValue = lca6.NewValue AND lca10.OldValue = lca10.NewValue AND lca11.OldValue = lca11.NewValue) THEN 'PrimaryActivationFee'
		WHEN lca10.OldValue IS NOT NULL OR lca10.NewValue IS NOT NULL
		AND (lca2.OldValue = lca2.NewValue AND lca3.OldValue = lca3.NewValue AND lca4.OldValue = lca4.NewValue
		AND lca5.OldValue = lca5.NewValue AND lca6.OldValue = lca6.NewValue AND lca7.OldValue = lca7.NewValue
		AND lca8.OldValue = lca8.NewValue AND lca9.OldValue = lca9.NewValue AND lca11.OldValue = lca11.NewValue) THEN 'SecondaryActivationFee'
		WHEN lca11.OldValue IS NOT NULL OR lca11.NewValue IS NOT NULL
		AND (lca2.OldValue = lca2.NewValue AND lca3.OldValue = lca3.NewValue AND lca4.OldValue = lca4.NewValue
		AND lca5.OldValue = lca5.NewValue AND lca6.OldValue = lca6.NewValue AND lca7.OldValue = lca7.NewValue
		AND lca8.OldValue = lca8.NewValue AND lca9.OldValue = lca9.NewValue AND lca10.OldValue = lca10.NewValue) THEN 'IsShared'
		ELSE '[MULTIPLE]' END AS 'ModifiedValue'
	,ISNULL(lca3.OldValue,'---') AS 'PreviousType'
	,ISNULL(lca3.NewValue,'---') AS 'NewType'
	,ISNULL(lca6.OldValue,'---') AS 'PreviousMaxLines'
	,ISNULL(lca6.NewValue,'---') AS 'NewMaxLines'
	,ISNULL(lca7.OldValue,'---') AS 'PreviousMonthlyFee'
	,ISNULL(lca7.NewValue,'---') AS 'NewMonthlyFee'
	,ISNULL(lca8.OldValue,'---') AS 'PreviousAdditionalLineFee'
	,ISNULL(lca8.NewValue,'---') AS 'NewAdditionalLineFee'
	,ISNULL(lca9.OldValue,'---') AS 'PreviousPrimaryActivationFee'
	,ISNULL(lca9.NewValue,'---') AS 'NewPrimaryActivationFee'
	,ISNULL(lca10.OldValue,'---') AS 'PreviousSecondaryActivationFee'
	,ISNULL(lca10.NewValue,'---') AS 'NewSecondaryActivationFee'
	,ISNULL(lca4.OldValue,'---') AS 'PreviousContractTerm'
	,ISNULL(lca4.NewValue,'---') AS 'NewContractTerm'
	,ISNULL(lca5.OldValue,'---') AS 'PreviousIncludedLines'
	,ISNULL(lca5.NewValue,'---') AS 'NewIncludedLines'
	,ISNULL(lca11.OldValue,'---') AS 'PreviousIsShared'
	,ISNULL(lca11.NewValue,'---') AS 'NewIsShared'
	,ISNULL(lca2.OldValue,'---') AS 'PreviousName'
	,ISNULL(lca2.NewValue,'---') AS 'NewName'
	,lca.PKCol AS 'PK'
FROM logging.CatalogAudit lca
LEFT OUTER JOIN logging.CatalogAudit lca2 ON lca.PkCol = lca2.PkCol AND lca2.FieldName = 'Title'
LEFT OUTER JOIN logging.CatalogAudit lca3 ON lca.PkCol = lca3.PkCol AND lca3.FieldName = 'Type'
LEFT OUTER JOIN logging.CatalogAudit lca4 ON lca.PkCol = lca4.PkCol AND lca4.FieldName = 'ContractTerm'
LEFT OUTER JOIN logging.CatalogAudit lca5 ON lca.PkCol = lca5.PkCol AND lca5.FieldName = 'IncludedLines'
LEFT OUTER JOIN logging.CatalogAudit lca6 ON lca.PkCol = lca6.PkCol AND lca6.FieldName = 'MaxLines'
LEFT OUTER JOIN logging.CatalogAudit lca7 ON lca.PkCol = lca7.PkCol AND lca7.FieldName = 'MonthlyFee'
LEFT OUTER JOIN logging.CatalogAudit lca8 ON lca.PkCol = lca8.PkCol AND lca8.FieldName = 'AdditionalLineFee'
LEFT OUTER JOIN logging.CatalogAudit lca9 ON lca.PkCol = lca9.PkCol AND lca9.FieldName = 'PrimaryActivationFee'
LEFT OUTER JOIN logging.CatalogAudit lca10 ON lca.PkCol = lca10.PkCol AND lca10.FieldName = 'SecondaryActivationFee'
LEFT OUTER JOIN logging.CatalogAudit lca11 ON lca.PkCol = lca11.PkCol AND lca11.FieldName = 'IsShared'
WHERE lca.SchemaName + lca.TableName = 'catalograteplan'
AND lca.PKCol IS NOT NULL