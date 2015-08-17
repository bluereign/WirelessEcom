
CREATE VIEW [catalog].[dn_Phones]
AS
/*
This view Modified By Sekar Muniyandi
Modified Date : 8/21/2011
After Modified this view, we had 66% of performance increased
Removed LOOP Keyword from the INNER JOIN 
*/ SELECT
                       d.DeviceGuid, d.DeviceGuid AS ProductGuid, ISNULL(p.ProductId, 0) AS phoneID, ISNULL(p.ProductId, 0) AS product_id, ISNULL(p.ProductId, 0) AS ProductID, 
                      p.GersSku, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property WITH (NOLOCK)
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), d .Name) + ' (' + c.CompanyName + ')' AS pageTitle, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_4 WITH (NOLOCK)
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), d .Name) AS summaryTitle, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_3 WITH (NOLOCK)
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), d .Name) AS detailTitle, c.CarrierId, c.CompanyName AS carrierName, NULL 
                      AS carrierLogoSmall, NULL AS carrierLogoMedium, NULL AS carrierLogoLarge, mf.CompanyGuid AS manufacturerGuid, mf.CompanyName AS manufacturerName, 
                      CONVERT(bit, ISNULL
                          ((SELECT     1 AS Expr1
                              FROM         catalog.ProductTag WITH (NOLOCK)
                              WHERE     (Tag = 'warehouse') AND (ProductGuid = d .DeviceGuid)), 0)) AS bWarehouse, CONVERT(bit, ISNULL
                          ((SELECT     COUNT(ProductGuid) AS Expr1
                              FROM         catalog.DeviceFreeAccessory AS dfa WITH (NOLOCK)
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
                              FROM         catalog.GersPrice AS gp WITH (NOLOCK) INNER  JOIN
                                                    catalog.GersPriceGroup AS gpg WITH (NOLOCK) ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECP' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_retail, 
                      ISNULL
                          ((SELECT     gp.Price
                              FROM         catalog.GersPrice AS gp WITH (NOLOCK) INNER  JOIN
                                                    catalog.GersPriceGroup AS gpg WITH (NOLOCK) ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECN' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_new, 
                      ISNULL
                          ((SELECT     RebateTotal
                              FROM         catalog.vProductRebateTotal AS vprt WITH (NOLOCK)
                              WHERE     (ProductGuid = p.ProductGuid) AND (RebateMode = 'N')), CAST(0 AS money)) AS new_rebateTotal, ISNULL
                          ((SELECT     gp.Price
                              FROM         catalog.GersPrice AS gp WITH (NOLOCK) INNER  JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECU' AND gp.GersSku = p.GersSku AND 
                                                    GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_upgrade, ISNULL
                          ((SELECT     RebateTotal
                              FROM         catalog.vProductRebateTotal AS vprt WITH (NOLOCK)
                              WHERE     (ProductGuid = p.ProductGuid) AND (RebateMode = 'U')), CAST(0 AS money)) AS upgrade_rebateTotal, ISNULL
                          ((SELECT     gp.Price
                              FROM         catalog.GersPrice AS gp WITH (NOLOCK) INNER  JOIN
                                                    catalog.GersPriceGroup AS gpg WITH (NOLOCK) ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECA' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_addaline, 
                      ISNULL
                          ((SELECT     RebateTotal
                              FROM         catalog.vProductRebateTotal AS vprt WITH (NOLOCK)
                              WHERE     (ProductGuid = p.ProductGuid) AND (RebateMode = 'A')), CAST(0 AS money)) AS addaline_rebateTotal, d .UPC, ISNULL
                          ((SELECT     ISNULL(AvailableQty, 0) AS Expr1
                              FROM         catalog.Inventory WITH (NOLOCK)
                              WHERE     (ProductId = p.ProductId)), 0) AS QtyOnHand, ROW_NUMBER() OVER (ORDER BY sr.EditorsChoiceRank, sr.Sales2WeeksRank, sr.LaunchDateRank) 
AS DefaultSortRank
FROM         catalog.Device AS d INNER  JOIN
                      catalog.ProductGuid AS pg WITH (NOLOCK) ON d .DeviceGuid = pg.ProductGuid INNER  JOIN
                      catalog.ProductType AS pt WITH (NOLOCK) ON pg.ProductTypeId = pt.ProductTypeId LEFT OUTER JOIN
                      catalog. Product AS p WITH (NOLOCK) ON pg.ProductGuid = p.ProductGuid INNER  JOIN
                      catalog.SortRanks sr WITH (NOLOCK) ON pg.ProductGuid = sr.ProductGuid INNER  JOIN
                      catalog.Company AS c WITH (NOLOCK) ON d .CarrierGuid = c.CompanyGuid AND c.IsCarrier = 1 LEFT OUTER JOIN
                      catalog.Company AS mf WITH (NOLOCK) ON d .ManufacturerGuid = mf.CompanyGuid
WHERE     (p.Active = 1) AND (p.GersSku NOT IN
                          (SELECT     GersSku
                            FROM          catalog.dn_PrePaids))

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[10] 4[28] 2[43] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'VIEW', @level1name = N'dn_Phones';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'VIEW', @level1name = N'dn_Phones';

