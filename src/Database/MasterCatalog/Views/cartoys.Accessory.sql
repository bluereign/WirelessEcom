SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [cartoys].[Accessory] AS

----- Accessory Information
SELECT
	a.UPC
	,cp.ProductGuid
	,cpy.Value AS 'CleanName'
	,cc2.CompanyName AS 'Manufacturer'
	,CASE cpy2.Value
	WHEN ''
	THEN
	(SELECT cpyy.Value FROM catalog.Property cpyy INNER JOIN catalog.Product cpp ON cpp.ProductGuid = cpyy.ProductGuid AND cpp.ChannelID = '3'
	WHERE cpyy.ProductGuid = a.AccessoryGuid AND cpyy.Name = 'shortdescription')
	ELSE cpy2.Value END AS 'ShortDescription'
	,cpy3.Value AS 'LongDescription'
	,cpy5.Value AS 'MetaKeywords'
	,(SELECT TOP 1 ci.binImage FROM catalog.Image ci WHERE ci.ReferenceGuid = a.AccessoryGuid AND IsPrimaryImage = '1') AS 'Image'
FROM catalog.accessory a
INNER JOIN catalog.Product cp ON cp.ProductGuid = a.AccessoryGuid AND cp.ChannelID = '1'
INNER JOIN catalog.Property cpy ON cpy.ProductGuid = a.AccessoryGuid AND cpy.Name = 'title'
INNER JOIN catalog.Company cc2 ON cc2.CompanyGuid = a.ManufacturerGuid
INNER JOIN catalog.Property cpy2 ON cpy2.ProductGuid = a.AccessoryGuid AND cpy2.Name = 'shortdescription'
INNER JOIN catalog.Property cpy3 ON cpy3.ProductGuid = a.AccessoryGuid AND cpy3.Name = 'longdescription'
LEFT JOIN catalog.Property cpy5 ON cpy5.ProductGuid = a.AccessoryGuid AND cpy5.Name = 'metakeywords'
WHERE a.AccessoryGuid NOT IN (SELECT ProductGuid FROM catalog.ProductTag WHERE Tag = 'freeaccessory')

GO
