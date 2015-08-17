
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [PAGEMASTER].[Property] AS

WITH ParentGuid (ProductId, ProductGuid, ParentProductGuid, GersSku, Active, ChannelId) AS (
SELECT DISTINCT
	p.ProductId
	,p.ProductGuid
	,ppc.ParentProductGuid
	,p.GersSku
	,p.Active
	,p.ChannelID
FROM
	catalog.Product p
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = p.ProductGuid
WHERE p.ChannelID = '5')
,MasterProperties (PropertyGuid, ProductGuid, IsCustom, LastModifiedDate, LastModifiedBy, Name, Value, Active) AS (
SELECT DISTINCT
	p.PropertyGuid
	,pp.ProductGuid
	--,ppc.ParentProductGuid
	,p.IsCustom
	,p.LastModifiedDate
	,p.LastModifiedBy
	,p.Name
	,CASE WHEN p.Name = 'Inventory.HoldBackQty' THEN (SELECT Value FROM catalog.Property INNER JOIN ParentGuid ON ParentGuid.ProductGuid = catalog.Property.ProductGuid WHERE catalog.Property.ProductGuid = pp.ProductGuid AND catalog.property.Name = 'Inventory.HoldBackQty')
	ELSE p.Value END AS 'Value'
	,p.Active
FROM
	catalog.Property p
INNER JOIN ParentGuid pp ON pp.ParentProductGuid = p.ProductGuid
WHERE pp.ChannelId = '5')


SELECT DISTINCT
	mp.PropertyGuid
	,mp.ProductGuid
	--,ppc.ParentProductGuid
	,mp.IsCustom
	,mp.LastModifiedDate
	,mp.LastModifiedBy
	,mp.Name
	,CASE WHEN cpy.Name = 'shortdescription' AND LEN(cpy.Value) <> LEN(mp.Value) AND cpy.Value <> '' THEN cpy.Value
	WHEN cpy.Name = 'longdescription' AND LEN(cpy.Value) <> LEN(mp.Value) AND cpy.Value <> '' THEN cpy.Value
	WHEN cpy.Name = 'title' AND cpy.Value <> mp.Value AND cpy.Value <> '' THEN cpy.Value
	WHEN cpy.Name = 'title' AND cpy.Value <> '' AND cpy.Value <> (SELECT Name FROM catalog.Device WHERE DeviceGuid = cpy.ProductGuid) THEN cpy.Value
	ELSE mp.Value END AS 'Value'
	,mp.Active
FROM
	MasterProperties mp
LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = mp.ProductGuid AND cpy.Name = mp.Name
WHERE mp.Name NOT IN ('sort.EditorsChoiceAccessories','sort.EditorsChoice','C780F29A-904B-4357-990B-EA9E440992C4')

UNION 

SELECT DISTINCT
	cpy.PropertyGuid
	,cpy.ProductGuid
	--,ppc.ParentProductGuid
	,cpy.IsCustom
	,cpy.LastModifiedDate
	,cpy.LastModifiedBy
	,cpy.Name
	,cpy.Value
	,cpy.Active
FROM
	catalog.Property cpy
WHERE ProductGuid IN (SELECT ProductGuid FROM catalog.Product WHERE ChannelID = '5')
AND cpy.Name NOT IN (SELECT mp.Name FROM MasterProperties mp WHERE cpy.ProductGuid = mp.ProductGuid)














GO
