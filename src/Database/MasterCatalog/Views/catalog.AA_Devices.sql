SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [catalog].[AA_Devices] AS

SELECT DISTINCT
	cp.ProductId
	,cp.GersSku
	,cpp.ProductGuid
	,cpp.ParentProductGuid AS 'MasterGuid'	
	,CASE WHEN (SELECT cpt.Tag FROM catalog.ProductTag cpt	WHERE cpt.ProductGuid = cpp.ParentProductGuid AND Tag = 'smartphone') = 'smartphone' THEN '1' ELSE '0' END AS 'Smartphone'
	,CASE WHEN cc.CompanyName = 'Apple' THEN '1' ELSE '0' END AS 'Apple'
	,CASE WHEN cc.CompanyName = 'Samsung' THEN '1' ELSE '0' END AS 'Android'
	,CASE WHEN (SELECT cpt.Tag FROM catalog.ProductTag cpt	WHERE cpt.ProductGuid = cpp.ParentProductGuid AND Tag = 'hotspot') = 'hotspot' THEN '1' ELSE '0' END AS 'MBB'
	,'0' AS 'Tablet'
FROM catalog.Device cd
INNER JOIN catalog.ProducttoParentChannel cpp ON cpp.ParentProductGuid = cd.DeviceGuid
INNER JOIN catalog.Product cp ON cp.ProductGuid = cpp.ProductGuid
INNER JOIN catalog.Company cc ON cc.CompanyGuid = cd.ManufacturerGuid
WHERE cp.Active = '1' AND cp.ChannelID <> '1'

UNION

SELECT DISTINCT
	cp.ProductId
	,cp.GersSku
	,cpp.ProductGuid
	,cpp.ParentProductGuid AS 'MasterGuid'
	,'0' AS 'Smartphone'
	,CASE WHEN cc.CompanyName = 'Apple' THEN '1' ELSE '0' END AS 'Apple'
	,CASE WHEN cc.CompanyName = 'Samsung' THEN '1' ELSE '0' END AS 'Android'
	,CASE WHEN (SELECT cpt.Tag FROM catalog.ProductTag cpt	WHERE cpt.ProductGuid = cpp.ParentProductGuid AND Tag = 'hotspot') = 'hotspot' THEN '1' ELSE '0' END AS 'MBB'
	,'1' AS 'Tablet'
FROM catalog.Tablet cd
INNER JOIN catalog.ProducttoParentChannel cpp ON cpp.ParentProductGuid = cd.TabletGuid
INNER JOIN catalog.Product cp ON cp.ProductGuid = cpp.ProductGuid
INNER JOIN catalog.Company cc ON cc.CompanyGuid = cd.ManufacturerGuid
WHERE cp.Active = '1' AND cp.ChannelID <> '1'


GO
