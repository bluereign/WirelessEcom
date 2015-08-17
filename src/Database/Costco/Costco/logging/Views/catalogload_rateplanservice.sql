







CREATE VIEW  [logging].[catalogload_rateplanservice] AS

WITH 		
	Skers AS
		(
		SELECT lca.PKCol, cp.CarrierBillCode, lca.NewValue, lca.OldValue, lca.Type, lca.TableName
		FROM  logging.CatalogAudit AS lca
		INNER JOIN catalog.Service AS cp ON CONVERT(VARCHAR(128), cp.ServiceGuid) = CONVERT(varchar(128),(ISNULL(lca.OldValue,lca.NewValue)))
		WHERE lca.FieldName = 'ServiceGuid' AND (lca.SchemaName + lca.TableName = 'catalograteplanservice') AND (lca.PKCol IS NOT NULL)
		)
	,
	Rateplan AS 
		(
		SELECT	lca.PKCol, lca.NewValue, lca.OldValue, cs.CarrierBillCode, lca.Type, lca.TableName
		FROM  logging.CatalogAudit AS lca
		INNER JOIN catalog.Rateplan AS cs ON CONVERT(VARCHAR(128), cs.RateplanGuid) = CONVERT(varchar(128),(ISNULL(lca.OldValue,lca.NewValue))) 
		WHERE lca.FieldName = 'RateplanGuid' AND (lca.SchemaName + lca.TableName = 'catalograteplanservice') AND (lca.PKCol IS NOT NULL)
		)		

SELECT DISTINCT
               ISNULL(s.Type,r.Type) AS 'Type'
               ,ISNULL(s.TableName,r.TableName) AS Object
               ,CASE WHEN s.OldValue IS NOT NULL OR
               s.NewValue IS NOT NULL AND (r.OldValue = r.NewValue) THEN 'ServiceGuid' WHEN r.OldValue IS NOT NULL OR
               r.NewValue IS NOT NULL AND (s.OldValue = s.NewValue) THEN 'RateplanGuid'
			   ELSE '[MULTPLE]' END AS 'ModifiedValue'
	,r.CarrierBillCode AS 'RateplanCode'
	,s.CarrierBillCode AS 'ServiceCarrierBillCode'
	,ISNULL(r.OldValue,'---') AS 'PreviousRateplan'
	,ISNULL(r.NewValue,'---') AS 'NewRateplan'
	,ISNULL(s.OldValue,'---') AS 'PreviousService'
	,ISNULL(s.NewValue,'---') AS 'NewService'
	,'---' AS 'PreviousIsIncluded'
	,'---' AS 'NewIsIncluded'
	,'---' AS 'PreviousIsRequired'
	,'---' AS 'NewIsRequired'
	,'---' AS 'PreviousIsDefault'
	,'---' AS 'NewIsDefault'
	,r.PKCol AS 'PK'
FROM  Skers s INNER JOIN Rateplan r ON r.PKCol = s.PKCol