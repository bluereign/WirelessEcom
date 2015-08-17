SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [catalog].[AA_Accessories] AS

SELECT DISTINCT
	cp.ProductId
	,cp.GersSku
	,cpp.ProductGuid
	,cpp.ParentProductGuid AS 'MasterGuid'
	,CASE WHEN (SELECT MinorCode FROM catalog.GersItm cgi WHERE cgi.GersSku = cp.GersSku AND cgi.MinorCode = 'ARM') = 'arm' THEN '1' ELSE '0' END AS 'Armband'
	,CASE WHEN (SELECT MinorCode FROM catalog.GersItm cgi WHERE cgi.GersSku = cp.GersSku AND cgi.MinorCode = 'BAT') = 'bat' THEN '1' ELSE '0' END AS 'Battery'
	,CASE WHEN (SELECT MinorCode FROM catalog.GersItm cgi WHERE cgi.GersSku = cp.GersSku AND cgi.MinorCode = 'BTD') = 'btd' THEN '1' ELSE '0' END AS 'Bluetooth'
	,CASE WHEN (SELECT MinorCode FROM catalog.GersItm cgi WHERE cgi.GersSku = cp.GersSku AND cgi.MinorCode = 'CASE') = 'case' THEN '1' ELSE '0' END AS 'Case'
	,CASE WHEN (SELECT MinorCode FROM catalog.GersItm cgi WHERE cgi.GersSku = cp.GersSku AND cgi.MinorCode = 'DOCK') = 'dock' THEN '1' ELSE '0' END AS 'Dock'
	,CASE WHEN (SELECT MinorCode FROM catalog.GersItm cgi WHERE cgi.GersSku = cp.GersSku AND cgi.MinorCode = 'CHGR') = 'chgr' THEN '1' ELSE '0' END AS 'Charger'
	,CASE WHEN (SELECT MinorCode FROM catalog.GersItm cgi WHERE cgi.GersSku = cp.GersSku AND cgi.MinorCode = 'SCRN') = 'scrn' THEN '1' ELSE '0' END AS 'ScreenProtector'
	,CASE WHEN (SELECT MinorCode FROM catalog.GersItm cgi WHERE cgi.GersSku = cp.GersSku AND cgi.MinorCode = 'STYL') = 'styl' THEN '1' ELSE '0' END AS 'Stylus'
	,CASE WHEN (SELECT MinorCode FROM catalog.GersItm cgi WHERE cgi.GersSku = cp.GersSku AND cgi.MinorCode = 'WHD') = 'WHD' THEN '1' ELSE '0' END AS 'Wireless Headset'
	,CASE WHEN (SELECT cpt.Tag FROM catalog.ProductTag cpt	WHERE cpt.ProductGuid = cpp.ParentProductGuid AND Tag = 'lightning') = 'lightning' THEN '1' ELSE '0' END AS 'Lightning'
	,CASE WHEN (SELECT cpt.Tag FROM catalog.ProductTag cpt	WHERE cpt.ProductGuid = cpp.ParentProductGuid AND Tag = 'usb2') = 'usb2' THEN '1' ELSE '0' END AS 'USB 2.0'
	,CASE WHEN (SELECT cpt.Tag FROM catalog.ProductTag cpt	WHERE cpt.ProductGuid = cpp.ParentProductGuid AND Tag = 'usb3') = 'usb3' THEN '1' ELSE '0' END AS 'USB 3.0'
FROM catalog.accessory cd
INNER JOIN catalog.ProducttoParentChannel cpp ON cpp.ParentProductGuid = cd.accessoryGuid
INNER JOIN catalog.Product cp ON cp.ProductGuid = cpp.ProductGuid
INNER JOIN catalog.Company cc ON cc.CompanyGuid = cd.ManufacturerGuid
WHERE cp.Active = '1' AND cp.ChannelID <> '1'
AND cp.GersSku NOT IN (SELECT GersSku FROM catalog.gersitm WHERE MinorCode IN ('KIT','SIM','SIMV'))
GO
