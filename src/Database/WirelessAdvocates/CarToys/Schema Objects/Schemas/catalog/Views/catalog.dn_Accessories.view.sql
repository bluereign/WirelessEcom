


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


