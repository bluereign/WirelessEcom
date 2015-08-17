/****** Object:  View [catalog].[dn_Warranty]    Script Date: 07/22/2014 12:00:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [catalog].[dn_Warranty] WITH SCHEMABINDING AS

SELECT
	w.WarrantyGuid
	,w.WarrantyGuid AS ProductGuid
	,ISNULL(p.ProductId, 0) AS ProductId
	,ISNULL(p.ProductId, 0) AS product_id
	,p.GersSku
	,NULL AS category_id
	,NULL AS categoryName
	,NULL AS group_id
	,ISNULL(
			(SELECT ltrim(rtrim(p2.Value)) FROM catalog.Property p2
			 WHERE (p2.Name = 'Title') AND (p2.Value <> '') AND (p2.ProductGuid = w.WarrantyGuid))
	 ,w.Title) + ' (' + c.CompanyName + ')' AS pageTitle
	,ISNULL(
			(SELECT ltrim(rtrim(p2.Value)) FROM catalog.Property p2
			 WHERE (p2.Name = 'Title') AND (p2.Value <> '') AND (p2.ProductGuid = w.WarrantyGuid))
	 ,w.Title) AS summaryTitle
	,ISNULL(
			(SELECT ltrim(rtrim(p2.Value)) FROM catalog.Property p2
			 WHERE (p2.Name = 'Title') AND (p2.Value <> '') AND (p2.ProductGuid = w.WarrantyGuid))
	 ,w.Title) AS detailTitle
	,ISNULL(
			(SELECT ltrim(rtrim(p2.Value)) FROM catalog.Property p2
			 WHERE (p2.Name = 'ShortDescription') AND (p2.Value <> '') AND (p2.ProductGuid = w.WarrantyGuid))
	 ,w.Title) AS summaryDescription
	,ISNULL(
			(SELECT ltrim(rtrim(p2.Value)) FROM catalog.Property p2
			 WHERE (p2.Name = 'LongDescription') AND (p2.Value <> '') AND (p2.ProductGuid = w.WarrantyGuid))
	 ,w.Title) AS detailDescription
	,(SELECT TOP 1 py.Value FROM catalog.Property py WHERE Name = 'MetaKeywords' AND py.ProductGuid = pg.ProductGuid) + ', ' + STUFF(
             (SELECT ', ' + cptg.Tag
             FROM catalog.ProductTag cptg
             WHERE cptg.ProductGuid = pg.ProductGuid
              FOR XML PATH (''))
             , 1, 1, '') AS MetaKeywords
    ,CAST(w.Price AS money) AS price_retail
	,CAST(w.Price AS money) AS price
	 ,c.CompanyGuid
	 ,c.CompanyName AS ManufacturerName
	 ,w.UPC
	 ,w.Deductible
	 ,w.ContractTerm
	 ,'1' AS QtyOnHand
	 ,CASE WHEN w.CompanyGuid = '47A9293D-ED40-444A-BA35-C18C3A4EFC60' THEN '1'
	 WHEN c.CompanyName = 'Apple' THEN '1' ELSE '0' END AS 'IsApple'
	 ,ROW_NUMBER() OVER (ORDER BY sr.EditorsChoiceRank, sr.EditorsChoiceAccessoriesRank, sr.LaunchDateRank, sr.Sales3WeeksRank) AS DefaultSortRank
FROM         catalog.Warranty w INNER JOIN
                      catalog.ProductGuid pg ON w.WarrantyGuid = pg.ProductGuid INNER JOIN
                      catalog.ProductType pt ON pg.ProductTypeId = pt.ProductTypeId INNER JOIN
                      catalog. Product p ON pg.ProductGuid = p.ProductGuid INNER JOIN
                      catalog.SortRanks sr ON pg.ProductGuid = sr.ProductGuid INNER JOIN
                      catalog.Company c ON w.CompanyGuid = c.CompanyGuid
WHERE     p.Active = 1







GO





/*
If we need to roll back, please execute the following:

ALTER VIEW [catalog].[dn_Warranty] WITH SCHEMABINDING AS

SELECT
	w.WarrantyGuid
	,w.WarrantyGuid AS ProductGuid
	,ISNULL(p.ProductId, 0) AS ProductId
	,ISNULL(p.ProductId, 0) AS product_id
	,p.GersSku
	,NULL AS category_id
	,NULL AS categoryName
	,NULL AS group_id
	,ISNULL(
			(SELECT ltrim(rtrim(p2.Value)) FROM catalog.Property p2
			 WHERE (p2.Name = 'Title') AND (p2.Value <> '') AND (p2.ProductGuid = w.WarrantyGuid))
	 ,w.Title) + ' (' + c.CompanyName + ')' AS pageTitle
	,ISNULL(
			(SELECT ltrim(rtrim(p2.Value)) FROM catalog.Property p2
			 WHERE (p2.Name = 'Title') AND (p2.Value <> '') AND (p2.ProductGuid = w.WarrantyGuid))
	 ,w.Title) AS summaryTitle
	,ISNULL(
			(SELECT ltrim(rtrim(p2.Value)) FROM catalog.Property p2
			 WHERE (p2.Name = 'Title') AND (p2.Value <> '') AND (p2.ProductGuid = w.WarrantyGuid))
	 ,w.Title) AS detailTitle
	,ISNULL(
			(SELECT ltrim(rtrim(p2.Value)) FROM catalog.Property p2
			 WHERE (p2.Name = 'ShortDescription') AND (p2.Value <> '') AND (p2.ProductGuid = w.WarrantyGuid))
	 ,w.Title) AS summaryDescription
	,ISNULL(
			(SELECT ltrim(rtrim(p2.Value)) FROM catalog.Property p2
			 WHERE (p2.Name = 'LongDescription') AND (p2.Value <> '') AND (p2.ProductGuid = w.WarrantyGuid))
	 ,w.Title) AS detailDescription
	,(SELECT TOP 1 py.Value FROM catalog.Property py WHERE Name = 'MetaKeywords' AND py.ProductGuid = pg.ProductGuid) + ', ' + STUFF(
             (SELECT ', ' + cptg.Tag
             FROM catalog.ProductTag cptg
             WHERE cptg.ProductGuid = pg.ProductGuid
              FOR XML PATH (''))
             , 1, 1, '') AS MetaKeywords
    ,CAST(w.Price AS money) AS price_retail
	,CAST(w.Price AS money) AS price
	 ,c.CompanyGuid
	 ,c.CompanyName AS ManufacturerName
	 ,w.UPC
	 ,w.Deductible
	 ,w.ContractTerm
	 ,'1' AS QtyOnHand
	 ,ROW_NUMBER() OVER (ORDER BY sr.EditorsChoiceRank, sr.EditorsChoiceAccessoriesRank, sr.LaunchDateRank, sr.Sales3WeeksRank) AS DefaultSortRank
FROM         catalog.Warranty w INNER JOIN
                      catalog.ProductGuid pg ON w.WarrantyGuid = pg.ProductGuid INNER JOIN
                      catalog.ProductType pt ON pg.ProductTypeId = pt.ProductTypeId INNER JOIN
                      catalog. Product p ON pg.ProductGuid = p.ProductGuid INNER JOIN
                      catalog.SortRanks sr ON pg.ProductGuid = sr.ProductGuid INNER JOIN
                      catalog.Company c ON w.CompanyGuid = c.CompanyGuid
WHERE     p.Active = 1







GO





*/