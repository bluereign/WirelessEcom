SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [logging].[catalogload_devicerateplan]
AS
WITH 		
	Skers AS
		(
		SELECT lca.PKCol, cp.GersSku, lca.NewValue, lca.OldValue, lca.Type, lca.TableName
		FROM  logging.CatalogAudit AS lca
		INNER JOIN catalog.Product AS cp ON CONVERT(VARCHAR(128), cp.ProductGuid) = CONVERT(varchar(128),(ISNULL(lca.OldValue,lca.NewValue)))
		WHERE lca.FieldName = 'DeviceGuid' AND (lca.SchemaName + lca.TableName = 'catalograteplandevice') AND (lca.PKCol IS NOT NULL)
		)
	,
	Rateplan AS 
		(
		SELECT	lca.PKCol, lca.NewValue, lca.OldValue, cs.CarrierBillCode, lca.Type, lca.TableName
		FROM  logging.CatalogAudit AS lca
		INNER JOIN catalog.Rateplan AS cs ON CONVERT(VARCHAR(128), cs.RateplanGuid) = CONVERT(varchar(128),(ISNULL(lca.OldValue,lca.NewValue))) 
		WHERE lca.FieldName = 'RateplanGuid' AND (lca.SchemaName + lca.TableName = 'catalograteplandevice') AND (lca.PKCol IS NOT NULL)
		)		

SELECT DISTINCT
               ISNULL(s.Type,r.Type) AS 'Type', ISNULL(s.TableName,r.TableName) AS Object, CASE WHEN s.OldValue IS NOT NULL OR
               s.NewValue IS NOT NULL AND (r.OldValue = r.NewValue) THEN 'DeviceGuid' WHEN r.OldValue IS NOT NULL OR
               r.NewValue IS NOT NULL AND (s.OldValue = s.NewValue) THEN 'RateplanGuid'
			   ELSE '[MULTPLE]' END AS [Modified Value], s.GersSku AS DeviceSku, 
               r.CarrierBillCode AS RateplanCarrierBillCode, ISNULL(s.OldValue, '---') AS OldDevice, ISNULL(s.NewValue, '---') AS NewDevice, ISNULL(r.OldValue, '---') 
               AS PreviousRateplan, ISNULL(r.NewValue, '---') AS NewRateplan
FROM  Skers s INNER JOIN Rateplan r ON r.PKCol = s.PKCol


GO
