


CREATE VIEW [logging].[catalogload_deviceservice]
AS
WITH 		
	Skers AS
		(
		SELECT DISTINCT lca.PKCol, cp.GersSku, lca.NewValue, lca.OldValue, lca.Type, lca.TableName
		FROM  logging.CatalogAudit AS lca
		INNER JOIN catalog.Product AS cp ON CONVERT(VARCHAR(128), cp.ProductGuid) = CONVERT(varchar(128),(ISNULL(lca.OldValue,lca.NewValue)))
		WHERE lca.FieldName = 'DeviceGuid' AND (lca.SchemaName + lca.TableName = 'catalogdeviceservice') AND (lca.PKCol IS NOT NULL) AND (cp.GersSku IS NOT NULL)
		)
	,
	Service AS 
		(
		SELECT DISTINCT lca.PKCol, lca.NewValue, lca.OldValue, cs.CarrierBillCode, lca.Type, lca.TableName
		FROM  logging.CatalogAudit AS lca
		INNER JOIN catalog.Service AS cs ON CONVERT(VARCHAR(128), cs.ServiceGuid) = CONVERT(varchar(128),(ISNULL(lca.OldValue,lca.NewValue))) 
		WHERE lca.FieldName = 'ServiceGuid' AND (lca.SchemaName + lca.TableName = 'catalogdeviceservice') AND (lca.PKCol IS NOT NULL)
		)		

SELECT DISTINCT
               ISNULL(s.Type,r.Type) AS 'Type', ISNULL(s.TableName,r.TableName) AS Object, CASE WHEN s.OldValue IS NOT NULL OR
               s.NewValue IS NOT NULL AND (r.OldValue = r.NewValue) THEN 'DeviceGuid' WHEN r.OldValue IS NOT NULL OR
               r.NewValue IS NOT NULL AND (s.OldValue = s.NewValue) THEN 'ServiceGuid'
			   ELSE '[MULTPLE]' END AS [Modified Value], s.GersSku AS DeviceSku, 
               r.CarrierBillCode AS ServiceCarrierBillCode, ISNULL(s.OldValue, '---') AS OldDevice, ISNULL(s.NewValue, '---') AS NewDevice, ISNULL(r.OldValue, '---') 
               AS PreviousService, ISNULL(r.NewValue, '---') AS NewService
FROM  Skers s INNER JOIN Service r ON r.PKCol = s.PKCol