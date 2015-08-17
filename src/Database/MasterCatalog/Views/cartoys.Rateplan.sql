
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [cartoys].[Rateplan] AS



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
WHERE p.ChannelID = '4' AND p.Active = '1'
)

----- Rateplan Information
SELECT r.RateplanGuid
	,r.CarrierBillCode
	,CASE 
	WHEN LEN(cpy.Value) <> LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'title')) AND LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'title')) <> '0'
	THEN (SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'title') ELSE cpy.Value END AS 'CleanName'
	,cc1.CompanyName AS 'Carrier'
	,r.ContractTerm
	,r.IncludedLines
	,r.MaxLines
	,r.MonthlyFee
	,r.PrimaryActivationFee
	,r.SecondaryActivationFee
	,r.AdditionalLineBillCode
	,r.AdditionalLineFee
	,CASE WHEN cpy6.Value IS NULL THEN '0.0000' ELSE cpy6.Value END AS 'BasicFee'
	,CASE WHEN cpy7.Value IS NULL THEN '0.0000' ELSE cpy7.Value END AS 'SmartphoneFee'
	,CASE WHEN cpy8.Value IS NULL THEN '0.0000' ELSE cpy8.Value END AS 'MifiFee'
	,CASE WHEN cpy2.Value = ''
	THEN
	(SELECT cpyy.Value FROM catalog.Property cpyy INNER JOIN catalog.Product cpp ON cpp.ProductGuid = cpyy.ProductGuid
	WHERE cpyy.ProductGuid = r.RateplanGuid AND cpyy.Name = 'shortdescription')
	WHEN LEN(cpy2.Value) <> LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'ShortDescription')) AND LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'ShortDescription')) <> '0'
	THEN (SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'ShortDescription')
	ELSE cpy2.Value END AS 'ShortDescription'
	,CASE  
	WHEN LEN(cpy3.Value) <> LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'LongDescription')) AND LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'LongDescription')) <> '0'
	THEN (SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'LongDescription') ELSE cpy3.Value END AS 'LongDescription'
	,cpy4.Value AS 'MetaDescription'
	,cpy5.Value AS 'MetaKeywords'
FROM ParentGuid pg
INNER JOIN catalog.Rateplan r ON r.RateplanGuid = pg.ParentProductGuid
INNER JOIN catalog.Property cpy ON cpy.ProductGuid = r.RateplanGuid AND cpy.Name = 'title'
INNER JOIN catalog.Company cc1 ON cc1.CompanyGuid = r.CarrierGuid AND IsCarrier = '1'
INNER JOIN catalog.Property cpy2 ON cpy2.ProductGuid = r.RateplanGuid AND cpy2.Name = 'shortdescription'
INNER JOIN catalog.Property cpy3 ON cpy3.ProductGuid = r.RateplanGuid AND cpy3.Name = 'longdescription'
LEFT JOIN catalog.Property cpy4 ON cpy4.ProductGuid = r.RateplanGuid AND cpy4.Name = 'metadescription'
LEFT JOIN catalog.Property cpy5 ON cpy5.ProductGuid = r.RateplanGuid AND cpy5.Name = 'metakeywords'
LEFT JOIN catalog.Property cpy6 ON cpy6.ProductGuid = pg.ProductGuid AND cpy6.Name = 'BasicFee'
LEFT JOIN catalog.Property cpy7 ON cpy7.ProductGuid = pg.ProductGuid AND cpy7.Name = 'SmartphoneFee'
LEFT JOIN catalog.Property cpy8 ON cpy8.ProductGuid = pg.ProductGuid AND cpy8.Name = 'MifiFee'

UNION

SELECT r.RateplanGuid
	,r.CarrierBillCode
	,CASE 
	WHEN LEN(cpy.Value) <> LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'title')) AND LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'title')) <> '0'
	THEN (SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'title') ELSE cpy.Value END AS 'CleanName'
	,cc1.CompanyName AS 'Carrier'
	,r.ContractTerm
	,r.IncludedLines
	,r.MaxLines
	,r.MonthlyFee
	,r.PrimaryActivationFee
	,r.SecondaryActivationFee
	,r.AdditionalLineBillCode
	,r.AdditionalLineFee
	,'0.00' AS 'BasicFee'
	,'0.00' AS 'SmartphoneFee'
	,'0.00' AS 'MifiFee'
	,CASE WHEN cpy2.Value = ''
	THEN
	(SELECT cpyy.Value FROM catalog.Property cpyy INNER JOIN catalog.Product cpp ON cpp.ProductGuid = cpyy.ProductGuid
	WHERE cpyy.ProductGuid = r.RateplanGuid AND cpyy.Name = 'shortdescription')
	WHEN LEN(cpy2.Value) <> LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'ShortDescription')) AND LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'ShortDescription')) <> '0'
	THEN (SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'ShortDescription')
	ELSE cpy2.Value END AS 'ShortDescription'
	,CASE  
	WHEN LEN(cpy3.Value) <> LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'LongDescription')) AND LEN((SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'LongDescription')) <> '0'
	THEN (SELECT TOP 1 Value FROM catalog.property WHERE ProductGuid = pg.ProductGuid AND Name = 'LongDescription') ELSE cpy3.Value END AS 'LongDescription'
	,cpy4.Value AS 'MetaDescription'
	,cpy5.Value AS 'MetaKeywords'
FROM catalog.Rateplan r
INNER JOIN catalog.product pg ON r.RateplanGuid = pg.ProductGuid AND ChannelID = '4' AND pg.ProductGuid NOT IN (SELECT ProductGuid FROM ParentGuid)
INNER JOIN catalog.Property cpy ON cpy.ProductGuid = r.RateplanGuid AND cpy.Name = 'title'
INNER JOIN catalog.Company cc1 ON cc1.CompanyGuid = r.CarrierGuid AND IsCarrier = '1'
INNER JOIN catalog.Property cpy2 ON cpy2.ProductGuid = r.RateplanGuid AND cpy2.Name = 'shortdescription'
INNER JOIN catalog.Property cpy3 ON cpy3.ProductGuid = r.RateplanGuid AND cpy3.Name = 'longdescription'
LEFT JOIN catalog.Property cpy4 ON cpy4.ProductGuid = r.RateplanGuid AND cpy4.Name = 'metadescription'
LEFT JOIN catalog.Property cpy5 ON cpy5.ProductGuid = r.RateplanGuid AND cpy5.Name = 'metakeywords'
WHERE pg.Active = '1'


GO
