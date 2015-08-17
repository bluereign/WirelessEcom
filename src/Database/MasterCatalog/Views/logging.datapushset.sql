
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [logging].[datapushset] AS 
WITH Prop (ProductGuidYo) AS (
SELECT DISTINCT ProductGuid FROM catalog.Property WHERE PropertyGuid IN 
(SELECT DISTINCT CONVERT(UNIQUEIDENTIFIER,PKCol) FROM logging.CatalogAudit lca
WHERE UserName = 'cfdbo'
AND FieldName NOT IN ('LastModifiedBy','LastModifiedDate','IsCustom','InsertDate','ProductTypeId')
AND FieldName NOT LIKE '%GUID%'
AND PKCol IS NOT NULL AND LEN(PKCol) > '35'
AND UpdateDate > (SELECT MAX(Timestamp) FROM logging.DataPush))
)
,StuffChanged (Channel, ProductType, GersSKU, ProductName, ProductGuid) AS (
SELECT DISTINCT
	cc.Channel
	,cpt.ProductType AS 'Product Type'
	,ISNULL(cp.GersSku,'N/A') AS 'GersSKU'
	,ISNULL(cpy.Value,cp.GersSku) AS 'Product Name'
	,cp.ProductGuid
FROM Prop p
INNER JOIN catalog.Product cp ON cp.ProductGuid = p.ProductGuidYo
INNER JOIN catalog.Channel cc ON cc.channelid = cp.channelid
INNER JOIN catalog.ProductGuid cpg ON cpg.ProductGuid = cp.ProductGuid
INNER JOIN catalog.ProductType cpt ON cpt.ProductTypeId = cpg.ProductTypeId
LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = cp.ProductGuid AND cpy.Name = 'title'
)
,NewProduct (Channel, ProductType, GersSKU, ProductName, ProductGuid) AS(
SELECT DISTINCT
	cc.Channel
	,cpt.ProductType AS 'Product Type'
	,ISNULL(cp.GersSku,'N/A') AS 'GersSKU'
	,ISNULL(cpy.Value,cp.GersSku) AS 'Product Name'
	,cp.ProductGuid
FROM catalog.Product cp
INNER JOIN catalog.Channel cc ON cc.channelid = cp.channelid
INNER JOIN catalog.ProductGuid cpg ON cpg.ProductGuid = cp.ProductGuid
INNER JOIN catalog.ProductType cpt ON cpt.ProductTypeId = cpg.ProductTypeId
LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = cp.ProductGuid AND cpy.Name = 'title'
WHERE CreateDate > (SELECT MAX(Timestamp) FROM logging.DataPush)
)
,NewTags (Channel, ProductType, GersSKU, ProductName, ProductGuid) AS (
SELECT DISTINCT
	cc.Channel
	,cpt.ProductType AS 'Product Type'
	,ISNULL(cp.GersSku,'N/A') AS 'GersSKU'
	,ISNULL(cpy.Value,cp.GersSku) AS 'Product Name'
	,cp.ProductGuid
FROM logging.ProductTag lpt
INNER JOIN catalog.Product cp ON cp.productguid = lpt.productguid
INNER JOIN catalog.Channel cc ON cc.channelid = cp.channelid
INNER JOIN catalog.ProductGuid cpg ON cpg.ProductGuid = cp.ProductGuid
INNER JOIN catalog.ProductType cpt ON cpt.ProductTypeId = cpg.ProductTypeId
LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = cp.ProductGuid AND cpy.Name = 'title'
WHERE lpt.Timestamp > (SELECT MAX(Timestamp) FROM logging.DataPush)
)

SELECT DISTINCT
sc.Channel, sc.ProductType, sc.GersSKU, sc.ProductName,
CASE lca.Type WHEN 'U' THEN 'Update' WHEN 'I' THEN 'New' WHEN 'D' THEN 'Removed' ELSE '' END AS 'Change Type'
,lca.FieldName AS 'Attribute'
,CASE lca.Type
WHEN 'U' THEN 'Old: ' + lca.OldValue + ', New: ' + lca.NewValue
WHEN 'I' THEN lca.NewValue
WHEN 'D' THEN lca.OldValue ELSE '' END AS 'Updated Value'
,CONVERT(VARCHAR(10),lca.UpdateDate,101) AS 'Change Date'
FROM (SELECT DISTINCT Channel, ProductType, GersSKU, ProductName, ProductGuid FROM NewProduct UNION SELECT DISTINCT Channel, ProductType, GersSKU, ProductName, ProductGuid FROM StuffChanged UNION SELECT DISTINCT Channel, ProductType, GersSKU, ProductName, ProductGuid FROM NewTags) sc
INNER JOIN logging.CatalogAudit lca ON lca.PKCol = sc.ProductGuid AND LEN(lca.PKCol) > '35'
WHERE lca.FieldName NOT LIKE '%GUID%' AND lca.FieldName NOT IN ('ProductTypeId')


GO
