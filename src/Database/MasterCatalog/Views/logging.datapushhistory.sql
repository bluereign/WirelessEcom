SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW logging.datapushhistory AS

WITH StuffChanged (Channel, ProductType, GersSKU, ProductName, ProductGuid) AS (
SELECT
	CASE cp.ChannelID
	WHEN 1 THEN 'Master Entry'
	WHEN 2 THEN 'Costco'
	WHEN 3 THEN 'AAFES'
	WHEN 4 THEN 'CarToys'
	ELSE 'Unassigned' END AS 'Channel'
	,CASE cpg.ProductTypeId
	WHEN 1 THEN 'Device'
	WHEN 2 THEN 'Rateplan'
	WHEN 3 THEN 'Service'
	WHEN 4 THEN 'Accessory'
	ELSE 'Unassigned' END AS 'Product Type'
	,ISNULL(cp.GersSku,'N/A') AS 'GersSKU'
	,CASE cpg.ProductTypeId
	WHEN 1 THEN ISNULL((SELECT Name FROM catalog.Device WHERE DeviceGuid = cp.ProductGuid),'N/A')
	WHEN 2 THEN ISNULL((SELECT Title FROM catalog.Rateplan WHERE RateplanGuid = cp.ProductGuid),'N/A')
	WHEN 3 THEN ISNULL((SELECT Title FROM catalog.Service WHERE ServiceGuid = cp.ProductGuid),'N/A')
	WHEN 4 THEN ISNULL((SELECT Name FROM catalog.Accessory WHERE AccessoryGuid = cp.ProductGuid),'N/A')
	ELSE 'Unknown' END AS 'Product Name'
	,cp.ProductGuid
FROM catalog.Product cp
INNER JOIN catalog.ProductGuid cpg ON cpg.ProductGuid = cp.ProductGuid
WHERE cp.ProductGuid IN (
SELECT ProductGuid FROM catalog.Property WHERE PropertyGuid IN 
(SELECT CONVERT(UNIQUEIDENTIFIER,PKCol) FROM logging.CatalogAudit lca
WHERE UserName = 'cfdbo'
AND FieldName NOT IN ('LastModifiedBy','LastModifiedDate','IsCustom','InsertDate','ProductTypeId')
AND FieldName NOT LIKE '%GUID%'
AND PKCol IS NOT NULL AND LEN(PKCol) > '35'
)
)
OR cp.ProductGuid IN (
SELECT CONVERT(UNIQUEIDENTIFIER,PKCol) FROM logging.CatalogAudit lca
WHERE UserName = 'cfdbo'
AND FieldName NOT IN ('LastModifiedBy','LastModifiedDate','IsCustom','InsertDate','ProductTypeId')
AND FieldName NOT LIKE '%GUID%'
AND PKCol IS NOT NULL AND LEN(PKCol) > '35'))
,NewProduct (Channel, ProductType, GersSKU, ProductName, ProductGuid) AS
(SELECT
	CASE cp.ChannelID
	WHEN 1 THEN 'Master Entry'
	WHEN 2 THEN 'Costco'
	WHEN 3 THEN 'AAFES'
	WHEN 4 THEN 'CarToys'
	ELSE 'Unassigned' END AS 'Channel'
	,CASE cpg.ProductTypeId
	WHEN 1 THEN 'Device'
	WHEN 2 THEN 'Rateplan'
	WHEN 3 THEN 'Service'
	WHEN 4 THEN 'Accessory'
	ELSE 'Unassigned' END AS 'Product Type'
	,ISNULL(cp.GersSku,'N/A') AS 'GersSKU'
	,CASE cpg.ProductTypeId
	WHEN 1 THEN ISNULL((SELECT Name FROM catalog.Device WHERE DeviceGuid = cp.ProductGuid),'N/A')
	WHEN 2 THEN ISNULL((SELECT Title FROM catalog.Rateplan WHERE RateplanGuid = cp.ProductGuid),'N/A')
	WHEN 3 THEN ISNULL((SELECT Title FROM catalog.Service WHERE ServiceGuid = cp.ProductGuid),'N/A')
	WHEN 4 THEN ISNULL((SELECT Name FROM catalog.Accessory WHERE AccessoryGuid = cp.ProductGuid),'N/A')
	ELSE 'Unknown' END AS 'Product Name'
	,cp.ProductGuid
FROM catalog.Product cp
INNER JOIN catalog.ProductGuid cpg ON cpg.ProductGuid = cp.ProductGuid)
,NewTags (Channel, ProductType, GersSKU, ProductName, ProductGuid) AS (
SELECT
	CASE cp.ChannelID
	WHEN 1 THEN 'Master Entry'
	WHEN 2 THEN 'Costco'
	WHEN 3 THEN 'AAFES'
	WHEN 4 THEN 'CarToys'
	ELSE 'Unassigned' END AS 'Channel'
	,CASE cpg.ProductTypeId
	WHEN 1 THEN 'Device'
	WHEN 2 THEN 'Rateplan'
	WHEN 3 THEN 'Service'
	WHEN 4 THEN 'Accessory'
	ELSE 'Unassigned' END AS 'Product Type'
	,ISNULL(cp.GersSku,'N/A') AS 'GersSKU'
	,CASE cpg.ProductTypeId
	WHEN 1 THEN ISNULL((SELECT Name FROM catalog.Device WHERE DeviceGuid = cp.ProductGuid),'N/A')
	WHEN 2 THEN ISNULL((SELECT Title FROM catalog.Rateplan WHERE RateplanGuid = cp.ProductGuid),'N/A')
	WHEN 3 THEN ISNULL((SELECT Title FROM catalog.Service WHERE ServiceGuid = cp.ProductGuid),'N/A')
	WHEN 4 THEN ISNULL((SELECT Name FROM catalog.Accessory WHERE AccessoryGuid = cp.ProductGuid),'N/A')
	ELSE 'Unknown' END AS 'Product Name'
	,cp.ProductGuid
FROM catalog.Product cp
INNER JOIN catalog.ProductGuid cpg ON cpg.ProductGuid = cp.ProductGuid
WHERE cp.ProductGuid IN (
(SELECT ProductGuid FROM logging.ProductTag
)))



SELECT DISTINCT
sc.Channel, sc.ProductType, sc.GersSKU, sc.ProductName,
CASE lca.Type WHEN 'U' THEN 'Update' WHEN 'I' THEN 'New' WHEN 'D' THEN 'Removed' ELSE '' END AS 'Change Type'
,lca.FieldName AS 'Attribute'
,CASE lca.Type
WHEN 'U' THEN 'Old: ' + lca.OldValue + ', New: ' + lca.NewValue
WHEN 'I' THEN lca.NewValue
WHEN 'D' THEN lca.OldValue ELSE '' END AS 'Updated Value'
,CONVERT(VARCHAR(10),lca.UpdateDate,101) AS 'Change Date'
FROM StuffChanged sc
INNER JOIN logging.CatalogAudit lca ON lca.PKCol = sc.ProductGuid
WHERE LEN(lca.PKCol) > '35'
AND lca.FieldName NOT LIKE '%GUID%'
AND lca.FieldName NOT IN ('ProductTypeId')

UNION

SELECT DISTINCT
sc.Channel, sc.ProductType, sc.GersSKU, sc.ProductName,
CASE lca.Type WHEN 'U' THEN 'Update' WHEN 'I' THEN 'New' WHEN 'D' THEN 'Removed' ELSE '' END AS 'Change Type'
,lca.FieldName AS 'Attribute'
,CASE lca.Type
WHEN 'U' THEN 'Old: ' + lca.OldValue + ', New: ' + lca.NewValue
WHEN 'I' THEN lca.NewValue
WHEN 'D' THEN lca.OldValue ELSE '' END AS 'Updated Value'
,CONVERT(VARCHAR(10),lca.UpdateDate,101) AS 'Change Date'
FROM NewProduct sc
INNER JOIN logging.CatalogAudit lca ON lca.PKCol = sc.ProductGuid
WHERE LEN(lca.PKCol) > '35'
AND lca.FieldName NOT LIKE '%GUID%'
AND lca.FieldName NOT IN ('ProductTypeId')

UNION

SELECT DISTINCT
sc.Channel, sc.ProductType, sc.GersSKU, sc.ProductName,
CASE cpt.Type WHEN 'U' THEN 'Update' WHEN 'I' THEN 'New' WHEN 'D' THEN 'Removed' ELSE '' END AS 'Change Type'
,'Tag' AS 'Attribute'
,cpt.Tag AS 'Updated Value'
,CONVERT(VARCHAR(10),cpt.TimeStamp,101) AS 'Change Date'
FROM NewTags sc
INNER JOIN logging.ProductTag cpt ON cpt.ProductGuid = sc.ProductGuid
GO
