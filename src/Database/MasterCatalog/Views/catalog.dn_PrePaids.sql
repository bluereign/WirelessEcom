
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/* carriers only*/
CREATE VIEW [catalog].[dn_PrePaids] AS

SELECT     d .DeviceGuid, d .DeviceGuid AS ProductGuid, ISNULL(p.ProductId, 0) AS phoneID, ISNULL(p.ProductId, 0) AS product_id, ISNULL(p.ProductId, 0) 
                      AS ProductID, p.GersSku, ISNULL
                          ((SELECT     ltrim(rtrim(Value))
                              FROM         catalog.Property
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), d .Name) + ' (' + c.CompanyName + ')' AS pageTitle, 
                      ISNULL
                          ((SELECT     ltrim(rtrim(Value))
                              FROM         catalog.Property
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), d .Name) AS summaryTitle, ISNULL
                          ((SELECT     ltrim(rtrim(Value))
                              FROM         catalog.Property
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), d .Name) AS detailTitle, c.CarrierId, 
                      c.CompanyName AS carrierName, NULL AS carrierLogoSmall, NULL AS carrierLogoMedium, NULL AS carrierLogoLarge, 
                      mf.CompanyGuid AS manufacturerGuid, mf.CompanyName AS manufacturerName, CONVERT(bit, ISNULL
                          ((SELECT     1
                              FROM         catalog.ProductTag
                              WHERE     (Tag = 'warehouse') AND (ProductGuid = d .DeviceGuid)), 0)) AS bWarehouse, CONVERT(bit, ISNULL
                          ((SELECT     COUNT(ProductGuid) AS Expr1
                              FROM         catalog.DeviceFreeAccessory AS dfa
                              WHERE     (DeviceGuid = d .DeviceGuid) AND (GETDATE() >= StartDate) AND (GETDATE() <= EndDate)), 0)) AS bFreeAccessory, NULL AS smimage, 
                      0 AS smimagewidth, 0 AS smimageheight, NULL AS stdimage, 0 AS stdimagewidth, 0 AS stdimageheight, NULL AS lrgimage, 0 AS lrgimagewidth, 
                      0 AS lrgimageheight, ISNULL
                          ((SELECT     ltrim(rtrim(Value))
                              FROM         catalog.Property
                              WHERE     (Name = 'ShortDescription') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), NULL) AS summaryDescription, ISNULL
                          ((SELECT     ltrim(rtrim(Value))
                              FROM         catalog.Property
                              WHERE     (Name = 'LongDescription') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), NULL) AS detailDescription
                      ,(SELECT TOP 1 p.Value FROM catalog.Property p WHERE Name = 'MetaKeywords' AND p.ProductGuid = d .DeviceGuid) + ', ' + STUFF(
             (SELECT ', ' + cptg.Tag
             FROM catalog.ProductTag cptg
             WHERE cptg.ProductGuid = pg.ProductGuid
              FOR XML PATH (''))
             , 1, 1, '') AS MetaKeywords
                      , NULL AS metaDescription, 1 AS prepaid, pt.ProductTypeId AS typeID
                      , (SELECT TOP 1 p.Value FROM catalog.Property p WHERE Name = 'ReleaseDate' AND p.ProductGuid = d .DeviceGuid) ReleaseDate
                      , ISNULL
                          ((SELECT     gp.Price
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECP' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND GETDATE() <= gp.EndDate), CAST(0 AS money)) AS price_retail, 
                      ISNULL
                          ((SELECT     gp.Price
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECN' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND GETDATE() <= gp.EndDate), CAST(0 AS money)) AS price_new, 
                      CAST(0 AS money) AS new_rebateTotal, ISNULL
                          ((SELECT     gp.Price
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECU' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND GETDATE() <= gp.EndDate), CAST(0 AS money)) AS price_upgrade, 
                      CAST(0 AS money) AS upgrade_rebateTotal, ISNULL
                          ((SELECT     gp.Price
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECA' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND GETDATE() <= gp.EndDate), CAST(0 AS money)) AS price_addaline, 
                      CAST(0 AS money) AS addaline_rebateTotal, d .UPC, ISNULL
                          ((SELECT     ISNULL(AvailableQty, 0)
                              FROM         catalog.Inventory
                              WHERE     ProductId = p.ProductId), 0) AS QtyOnHand, ROW_NUMBER() OVER (ORDER BY sr.EditorsChoiceRank, sr.LaunchDateRank, 
                      sr.Sales3WeeksRank) AS DefaultSortRank,p.CreateDate
FROM         catalog.Device AS d INNER JOIN
                      catalog.ProductGuid AS pg ON d .DeviceGuid = pg.ProductGuid INNER JOIN
                      catalog.ProductType AS pt ON pg.ProductTypeId = pt.ProductTypeId LEFT OUTER JOIN
                      catalog. Product AS p ON pg.ProductGuid = p.ProductGuid INNER JOIN
                      catalog.SortRanks sr ON pg.ProductGuid = sr.ProductGuid INNER JOIN
                      catalog.Company AS c ON d .CarrierGuid = c.CompanyGuid AND c.IsCarrier = 1 LEFT JOIN
                      catalog.Company mf ON d .ManufacturerGuid = mf.CompanyGuid INNER JOIN
                      catalog.ProductTag ptag ON p.ProductGuid = ptag.ProductGuid AND ptag.Tag = 'prepaidphone'
WHERE     p.Active = 1
AND (SELECT  AvailableQty   FROM         catalog.Inventory  WHERE     ProductId = p.ProductId) > '0'
AND (SELECT Price FROM catalog.GersPrice WHERE GersSku = p.GersSku
AND PriceGroupCode = 'ECN'
AND GETDATE() >= StartDate AND CONVERT(date, GETDATE()) <= EndDate
) > '0'
AND (SELECT Price FROM catalog.GersPrice WHERE GersSku = p.GersSku
AND PriceGroupCode = 'COG'
AND GETDATE() >= StartDate AND CONVERT(date, GETDATE()) <= EndDate
) > '0'




GO
