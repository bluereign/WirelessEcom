
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










CREATE VIEW [cartoys].[Device] AS

WITH ParentGuid (ProductId, ProductGuid, ParentProductGuid, GersSku, Active, ChannelId) AS (
SELECT
	p.ProductId
	,p.ProductGuid
	,ppc.ParentProductGuid
	,p.GersSku
	,p.Active
	,p.ChannelID
FROM
	catalog.Product p
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = p.ProductGuid
WHERE p.ChannelID = '4')

----- Device Information
SELECT DISTINCT d.DeviceGuid
	,cp.GersSku AS 'UPC'
	,CASE 
	WHEN LEN(cpy.Value) <> LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'title')) AND LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'title')) <> '0'
	THEN (SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'title') ELSE cpy.Value END AS 'CleanName'
	,cc1.CompanyName AS 'Carrier'
	,cc2.CompanyName AS 'Manufacturer'
	,CASE WHEN cpy2.Value = ''
	THEN
	(SELECT cpyy.Value FROM catalog.Property cpyy INNER JOIN catalog.Product cpp ON cpp.ProductGuid = cpyy.ProductGuid
	WHERE cpyy.ProductGuid = d.DeviceGuid AND cpyy.Name = 'shortdescription')
	WHEN LEN(cpy2.Value) <> LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'ShortDescription')) AND LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'ShortDescription')) <> '0'
	THEN (SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'ShortDescription')
	ELSE cpy2.Value END AS 'ShortDescription'
	,CASE  
	WHEN LEN(cpy3.Value) <> LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'LongDescription')) AND LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'LongDescription')) <> '0'
	THEN (SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'LongDescription') ELSE cpy3.Value END AS 'LongDescription'
	,cpy4.Value AS 'MetaDescription'
	,cpy5.Value AS 'MetaKeywords'
	,CASE  
	WHEN LEN(cpy6.Value) <> LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'C9043E7D-784B-41CC-B47C-7A482FED1C34')) AND LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'C9043E7D-784B-41CC-B47C-7A482FED1C34')) <> '0'
	THEN (SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'C9043E7D-784B-41CC-B47C-7A482FED1C34') ELSE cpy6.Value END AS 'DeviceType'
	,NULL AS 'Image' --(SELECT TOP 1 ci.binImage FROM catalog.Image ci WHERE ci.ReferenceGuid = d.DeviceGuid AND IsPrimaryImage = '1') AS 'Image'
FROM ParentGuid pg
INNER JOIN catalog.Device d ON d.DeviceGuid = pg.ProductGuid
INNER JOIN catalog.Product cp ON cp.ProductGuid = pg.ProductGuid
LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = pg.ParentProductGuid AND cpy.Name = 'title'
INNER JOIN catalog.Company cc1 ON cc1.CompanyGuid = d.CarrierGuid AND IsCarrier = '1'
INNER JOIN catalog.Company cc2 ON cc2.CompanyGuid = d.ManufacturerGuid
LEFT JOIN catalog.Property cpy2 ON cpy2.ProductGuid = pg.ParentProductGuid AND cpy2.Name = 'shortdescription'
LEFT JOIN catalog.Property cpy3 ON cpy3.ProductGuid = pg.ParentProductGuid AND cpy3.Name = 'longdescription'
LEFT JOIN catalog.Property cpy4 ON cpy4.ProductGuid = pg.ParentProductGuid AND cpy4.Name = 'metadescription'
LEFT JOIN catalog.Property cpy5 ON cpy5.ProductGuid = pg.ParentProductGuid AND cpy5.Name = 'metakeywords'
LEFT JOIN catalog.Property cpy6 ON cpy6.ProductGuid = pg.ParentProductGuid AND cpy6.Name = 'C9043E7D-784B-41CC-B47C-7A482FED1C34'
WHERE cp.Active = '1'









GO
