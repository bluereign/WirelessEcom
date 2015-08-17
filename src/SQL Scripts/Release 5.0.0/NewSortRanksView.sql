USE [AAFES.DEV]
GO

/****** Object:  View [catalog].[SortRanks]    Script Date: 07/01/2013 12:17:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP VIEW [catalog].[dn_Accessories];

GO

ALTER VIEW [catalog].[SortRanks]

WITH SCHEMABINDING

AS

WITH SortProperties AS

(

                SELECT P.ProductGuid

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.EditorsChoice' AND ISNUMERIC(Value)=1) AS EditorsChoice
								
								, (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.EditorsChoiceAccessories' AND ISNUMERIC(Value)=1) AS EditorsChoiceAccessories

                                , (SELECT CONVERT(date,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='LaunchDate' AND ISDATE(Value)=1 AND CONVERT(date,Value) >= CONVERT(date,DATEADD(day,-21,GETDATE()))) AS LaunchDate

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales1Weeks' AND ISNUMERIC(Value)=1) AS Sales1Weeks

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales2Weeks' AND ISNUMERIC(Value)=1) AS Sales2Weeks

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales3Weeks' AND ISNUMERIC(Value)=1) AS Sales3Weeks

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales4Weeks' AND ISNUMERIC(Value)=1) AS Sales4Weeks

                FROM catalog.Product P

)

SELECT ProductGuid

                , COALESCE(EditorsChoice, 3.40E + 38) AS EditorsChoiceRank
			
				, COALESCE(EditorsChoiceAccessories, 3.40E + 38) AS EditorsChoiceAccessoriesRank

                , DENSE_RANK() OVER(ORDER BY LaunchDate DESC) AS LaunchDateRank

                , DENSE_RANK() OVER(ORDER BY Sales1Weeks DESC) AS Sales1WeeksRank

                , DENSE_RANK() OVER(ORDER BY Sales2Weeks DESC) AS Sales2WeeksRank

                , DENSE_RANK() OVER(ORDER BY Sales3Weeks DESC) AS Sales3WeeksRank

                , DENSE_RANK() OVER(ORDER BY Sales4Weeks DESC) AS Sales4WeeksRank

FROM SortProperties;

GO


/* carriers only*/
CREATE VIEW [catalog].[dn_Accessories]
WITH SCHEMABINDING 
AS

SELECT     a.AccessoryGuid, a.AccessoryGuid AS ProductGuid, ISNULL(p.ProductId, 0) AS ProductId, ISNULL(p.ProductId, 0) AS product_id, p.GersSku, NULL 
                      AS category_id, NULL AS categoryName, NULL AS group_id, ISNULL
                          ((SELECT     ltrim(rtrim(p2.Value))
                              FROM         catalog.Property p2
                              WHERE     (p2.Name = 'Title') AND (p2.Value <> '') AND (p2.ProductGuid = a.AccessoryGuid)), a.Name) + ' (' + c.CompanyName + ')' AS pageTitle, 
                      ISNULL
                          ((SELECT     ltrim(rtrim(p2.Value))
                              FROM         catalog.Property p2
                              WHERE     (p2.Name = 'Title') AND (p2.Value <> '') AND (p2.ProductGuid = a.AccessoryGuid)), a.Name) AS summaryTitle, ISNULL
                          ((SELECT     ltrim(rtrim(p2.Value))
                              FROM         catalog.Property p2
                              WHERE     (p2.Name = 'Title') AND (p2.Value <> '') AND (p2.ProductGuid = a.AccessoryGuid)), a.Name) AS detailTitle, ISNULL
                          ((SELECT     ltrim(rtrim(p2.Value))
                              FROM         catalog.Property p2
                              WHERE     (p2.Name = 'ShortDescription') AND (p2.Value <> '') AND (p2.ProductGuid = a.AccessoryGuid)), a.Name) AS summaryDescription, 
                      ISNULL
                          ((SELECT     ltrim(rtrim(p2.Value))
                              FROM         catalog.Property p2
                              WHERE     (p2.Name = 'LongDescription') AND (p2.Value <> '') AND (p2.ProductGuid = a.AccessoryGuid)), a.Name) 
                      AS detailDescription/* *** TRV: For now, setting both price_retail and price to the GERS ECP (retail price) - may need to revisit this later *** */ ,
                                             (SELECT TOP 1 py.Value FROM catalog.Property py WHERE Name = 'MetaKeywords' AND py.ProductGuid = pg.ProductGuid) + ', ' + STUFF(
             (SELECT ', ' + cptg.Tag
             FROM catalog.ProductTag cptg
             WHERE cptg.ProductGuid = pg.ProductGuid
              FOR XML PATH (''))
             , 1, 1, '') AS MetaKeywords, 
                      ISNULL
                          ((SELECT     TOP 1 CAST(gp.Price AS money)
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECP' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND GETDATE() <= gp.EndDate), CAST(0 AS money)) AS price_retail, 
                      ISNULL
                          ((SELECT     TOP 1 CAST(gp.Price AS money)
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECP' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND GETDATE() <= gp.EndDate), CAST(0 AS money)) AS price, c.CompanyGuid, 
                      c.CompanyName AS ManufacturerName, a.UPC ,
            
                     (SELECT  Top 1   ISNULL(AvailableQty, 0) QtyOnHand FROM  catalog.Inventory
                      WHERE     ProductId = p.ProductId
                      ) as QtyOnHand
                              
                     , ROW_NUMBER() OVER (ORDER BY sr.EditorsChoiceRank, sr.LaunchDateRank, 
                      sr.Sales3WeeksRank) AS DefaultSortRank
FROM         catalog.Accessory a INNER JOIN
                      catalog.ProductGuid pg ON a.AccessoryGuid = pg.ProductGuid INNER JOIN
                      catalog.ProductType pt ON pg.ProductTypeId = pt.ProductTypeId INNER JOIN
                      catalog. Product p ON pg.ProductGuid = p.ProductGuid INNER JOIN
                      catalog.SortRanks sr ON pg.ProductGuid = sr.ProductGuid INNER JOIN
                      catalog.Company c ON a.ManufacturerGuid = c.CompanyGuid
WHERE     p.Active = 1



GO

