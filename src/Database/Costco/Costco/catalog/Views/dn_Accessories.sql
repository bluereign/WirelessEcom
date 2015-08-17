








/* carriers only*/
CREATE VIEW [catalog].[dn_Accessories] WITH SCHEMABINDING  AS

WITH SORTY (ProductGuid, GersSku, Sort) AS (
SELECT cp.ProductGuid, cp.GersSku, 
CASE
WHEN cgi.MinorCode = 'BNDL' THEN 1
WHEN cgi.MinorCode = 'CASE' THEN 2
WHEN cgi.MinorCode = 'SCRN' THEN 3
WHEN cgi.MinorCode = 'BAT' THEN 4
WHEN cgi.MinorCode = 'CHGR' THEN 5
WHEN cgi.MinorCode = 'DATA' THEN 6
WHEN cgi.MinorCode = 'BTD' THEN 7
WHEN cgi.MinorCode = 'SPKR' THEN 8
WHEN cgi.MinorCode = 'DOCK' THEN 9
WHEN cgi.MinorCode = 'ARM' THEN 10
WHEN cgi.MinorCode = 'WHD' THEN 11
ELSE 99 END AS 'Sort' FROM catalog.gersitm cgi
INNER JOIN catalog.product cp ON cp.gerssku = cgi.gerssku)

SELECT a.AccessoryGuid, a.AccessoryGuid AS ProductGuid, ISNULL(p.ProductId, 0) AS ProductId, ISNULL(p.ProductId, 0) AS product_id, p.GersSku, sr.Sort 
                      AS category_id, sr.Sort AS categoryName, NULL AS group_id, ISNULL
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
                                             ISNULL((SELECT TOP 1 py.Value FROM catalog.Property py WHERE Name = 'MetaKeywords' AND py.ProductGuid = pg.ProductGuid) + ', ' + STUFF(
             (SELECT ', ' + cptg.Tag
             FROM catalog.ProductTag cptg
             WHERE cptg.ProductGuid = pg.ProductGuid
              FOR XML PATH (''))
             , 1, 1, ''),'accessory') AS MetaKeywords, 
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
                              
                     , ROW_NUMBER() OVER (ORDER BY sr.Sort, c.CompanyName  ASC) AS DefaultSortRank
FROM         catalog.Accessory a INNER JOIN
                      catalog.ProductGuid pg ON a.AccessoryGuid = pg.ProductGuid INNER JOIN
                      catalog.ProductType pt ON pg.ProductTypeId = pt.ProductTypeId INNER JOIN
                      catalog. Product p ON pg.ProductGuid = p.ProductGuid 
					  INNER JOIN sorty sr ON sr.gerssku = p.gerssku
					  INNER JOIN
                      catalog.Company c ON a.ManufacturerGuid = c.CompanyGuid
WHERE     p.Active = 1