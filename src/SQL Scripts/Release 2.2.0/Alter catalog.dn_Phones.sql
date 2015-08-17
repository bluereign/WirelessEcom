/****** Object:  View [catalog].[dn_Phones]    Script Date: 08/25/2011 12:21:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [catalog].[dn_Phones]
AS
SELECT     d .DeviceGuid, d .DeviceGuid AS ProductGuid, ISNULL(p.ProductId, 0) AS phoneID, ISNULL(p.ProductId, 0) AS product_id, ISNULL(p.ProductId, 0) AS ProductID, 
                      p.GersSku, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), d .Name) + ' (' + c.CompanyName + ')' AS pageTitle, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_4
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), d .Name) AS summaryTitle, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_3
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), d .Name) AS detailTitle, c.CarrierId, c.CompanyName AS carrierName, NULL 
                      AS carrierLogoSmall, NULL AS carrierLogoMedium, NULL AS carrierLogoLarge, mf.CompanyGuid AS manufacturerGuid, mf.CompanyName AS manufacturerName, 
                      CONVERT(bit, ISNULL
                          ((SELECT     1 AS Expr1
                              FROM         catalog.ProductTag
                              WHERE     (Tag = 'warehouse') AND (ProductGuid = d .DeviceGuid)), 0)) AS bWarehouse, CONVERT(bit, ISNULL
                          ((SELECT     COUNT(ProductGuid) AS Expr1
                              FROM         catalog.DeviceFreeAccessory AS dfa
                              WHERE     (DeviceGuid = d .DeviceGuid) AND (GETDATE() >= StartDate) AND (GETDATE() <= EndDate)), 0)) AS bFreeAccessory, NULL AS smimage, 
                      0 AS smimagewidth, 0 AS smimageheight, NULL AS stdimage, 0 AS stdimagewidth, 0 AS stdimageheight, NULL AS lrgimage, 0 AS lrgimagewidth, 0 AS lrgimageheight, 
                      ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_2
                              WHERE     (Name = 'ShortDescription') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), NULL) AS summaryDescription, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_1
                              WHERE     (Name = 'LongDescription') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), NULL) AS detailDescription, NULL AS metaKeywords, NULL 
                      AS metaDescription, 0 AS prepaid, pt.ProductTypeId AS typeID, ISNULL
                          ((SELECT     gp.Price
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECP' AND gp.GersSku = p.GersSku AND 
                                                    GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_retail, ISNULL
                          ((SELECT     gp.Price
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECN' AND gp.GersSku = p.GersSku AND 
                                                    GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_new, ISNULL
                          ((SELECT     RebateTotal
                              FROM         catalog.vProductRebateTotal AS vprt
                              WHERE     (ProductGuid = p.ProductGuid) AND (RebateMode = 'N')), CAST(0 AS money)) AS new_rebateTotal, ISNULL
                          ((SELECT     gp.Price
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECU' AND gp.GersSku = p.GersSku AND 
                                                    GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_upgrade, ISNULL
                          ((SELECT     RebateTotal
                              FROM         catalog.vProductRebateTotal AS vprt
                              WHERE     (ProductGuid = p.ProductGuid) AND (RebateMode = 'U')), CAST(0 AS money)) AS upgrade_rebateTotal, ISNULL
                          ((SELECT     gp.Price
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECA' AND gp.GersSku = p.GersSku AND 
                                                    GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_addaline, ISNULL
                          ((SELECT     RebateTotal
                              FROM         catalog.vProductRebateTotal AS vprt
                              WHERE     (ProductGuid = p.ProductGuid) AND (RebateMode = 'A')), CAST(0 AS money)) AS addaline_rebateTotal, d .UPC, ISNULL
                          ((SELECT     ISNULL(AvailableQty, 0) AS Expr1
                              FROM         catalog.Inventory
                              WHERE     (ProductId = p.ProductId)), 0) AS QtyOnHand, ROW_NUMBER() OVER (ORDER BY sr.EditorsChoiceRank, sr.Sales2WeeksRank, sr.LaunchDateRank) 
AS DefaultSortRank
FROM         catalog.Device AS d INNER JOIN
                      catalog.ProductGuid AS pg ON d .DeviceGuid = pg.ProductGuid INNER JOIN
                      catalog.ProductType AS pt ON pg.ProductTypeId = pt.ProductTypeId LEFT OUTER JOIN
                      catalog. Product AS p ON pg.ProductGuid = p.ProductGuid INNER JOIN
                      catalog.SortRanks sr ON pg.ProductGuid = sr.ProductGuid INNER JOIN
                      catalog.Company AS c ON d .CarrierGuid = c.CompanyGuid AND c.IsCarrier = 1 LEFT OUTER JOIN
                      catalog.Company AS mf ON d .ManufacturerGuid = mf.CompanyGuid
WHERE     (p.Active = 1) AND (p.GersSku NOT IN
                          (SELECT     GersSku
                            FROM          catalog.dn_PrePaids))

GO


