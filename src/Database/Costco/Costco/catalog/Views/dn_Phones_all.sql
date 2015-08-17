

CREATE VIEW [catalog].[dn_Phones_all] AS
	SELECT
                       d .DeviceGuid, d .DeviceGuid AS ProductGuid, ISNULL(p.ProductId, 0) AS phoneID, ISNULL(p.ProductId, 0) AS product_id, ISNULL(p.ProductId, 0) AS ProductID, 
                      ISNULL
                          ((SELECT     ltrim(rtrim(Value))
                              FROM         [catalog].Property
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), d .Name) + ' (' + c.CompanyName + ')' AS pageTitle, ISNULL
                          ((SELECT     ltrim(rtrim(Value))
                              FROM         [catalog].Property
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), d .Name) AS summaryTitle, ISNULL
                          ((SELECT     ltrim(rtrim(Value))
                              FROM         [catalog].Property
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), d .Name) AS detailTitle, c.CarrierId, c.CompanyName AS carrierName, NULL 
                      AS carrierLogoSmall, NULL AS carrierLogoMedium, NULL AS carrierLogoLarge, NULL AS manufacturerID, NULL AS manufacturerName, CONVERT(bit, ISNULL
                          ((SELECT     1
                              FROM         [catalog].ProductTag
                              WHERE     (Tag = 'warehouse') AND (ProductGuid = d .DeviceGuid)), 0)) AS bWarehouse, CONVERT(bit, ISNULL
                          ((SELECT     COUNT(ProductGuid) AS Expr1
                              FROM         [catalog].DeviceFreeAccessory AS dfa
                              WHERE     (DeviceGuid = d .DeviceGuid) AND (GETDATE() >= StartDate) AND (GETDATE() <= EndDate)), 0)) AS bFreeAccessory, NULL AS smimage, 
                      0 AS smimagewidth, 0 AS smimageheight, NULL AS stdimage, 0 AS stdimagewidth, 0 AS stdimageheight, NULL AS lrgimage, 0 AS lrgimagewidth, 0 AS lrgimageheight, 
                      	ISNULL
                          ((SELECT     ltrim(rtrim(Value))
                              FROM         [catalog].Property
                              WHERE     (Name = 'ShortDescription') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), NULL) AS summaryDescription,
                        ISNULL
                          ((SELECT     ltrim(rtrim(Value))
                              FROM         [catalog].Property
                              WHERE     (Name = 'LongDescription') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), NULL) AS detailDescription, NULL AS metaKeywords, NULL 
                      AS metaDescription, 0 AS prepaid, pt.ProductTypeId AS typeID, ISNULL
                          ((SELECT     gp.Price
                              FROM         [catalog].GersPrice AS gp WITH (nolock) INNER LOOP JOIN
                                                    [catalog].GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECP' AND gp.GersSku = p.GersSku AND 
                                                    GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_retail, ISNULL
                          ((SELECT     gp.Price
                              FROM         [catalog].GersPrice AS gp WITH (nolock) INNER LOOP JOIN
                                                    [catalog].GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECN' AND gp.GersSku = p.GersSku AND 
                                                    GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_new, ISNULL
                          ((SELECT     RebateTotal
                              FROM         [catalog].vProductRebateTotal AS vprt WITH (nolock)
                              WHERE     (ProductGuid = p.ProductGuid) AND (RebateMode = 'N')), CAST(0 AS money)) AS new_rebateTotal, ISNULL
                          ((SELECT     gp.Price
                              FROM         [catalog].GersPrice AS gp INNER LOOP JOIN
                                                    [catalog].GersPriceGroup AS gpg WITH (nolock) ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECU' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_upgrade, 
                      ISNULL
                          ((SELECT     RebateTotal
                              FROM         [catalog].vProductRebateTotal AS vprt WITH (nolock)
                              WHERE     (ProductGuid = p.ProductGuid) AND (RebateMode = 'U')), CAST(0 AS money)) AS upgrade_rebateTotal, ISNULL
                          ((SELECT     gp.Price
                              FROM         [catalog].GersPrice AS gp INNER LOOP JOIN
                                                    [catalog].GersPriceGroup AS gpg WITH (nolock) ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECA' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_addaline, 
                      ISNULL
                          ((SELECT     RebateTotal
                              FROM         [catalog].vProductRebateTotal AS vprt WITH (nolock)
                              WHERE     (ProductGuid = p.ProductGuid) AND (RebateMode = 'A')), CAST(0 AS money)) AS addaline_rebateTotal, d .UPC, ISNULL
                          ((SELECT     ISNULL(AvailableQty, 0)
                              FROM         [catalog].Inventory
                              WHERE     ProductId = p.ProductId), 0) AS QtyOnHand, p.Active, ROW_NUMBER() OVER (ORDER BY sr.EditorsChoiceRank, sr.Sales2WeeksRank, 
                      sr.LaunchDateRank) AS DefaultSortRank
FROM         [catalog].Device AS d INNER LOOP JOIN
                      [catalog].ProductGuid AS pg WITH (nolock) ON d .DeviceGuid = pg.ProductGuid INNER LOOP JOIN
                      [catalog].ProductType AS pt WITH (nolock) ON pg.ProductTypeId = pt.ProductTypeId LEFT JOIN
                      [catalog]. Product AS p WITH (nolock) ON pg.ProductGuid = p.ProductGuid INNER LOOP JOIN
                      [catalog].SortRanks sr WITH (nolock) ON p.ProductGuid = sr.ProductGuid INNER LOOP JOIN
                      [catalog].Company AS c WITH (nolock) ON d .CarrierGuid = c.CompanyGuid AND c.IsCarrier = 1
;