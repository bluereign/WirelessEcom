











CREATE VIEW [catalog].[dn_Phones] AS

WITH
Title (DeviceGuid, pageTitle, summaryTitle, detailTitle, sd, ld, mk, md, IsAvailableInWarehouse, IsAvailableOnline, bfreebit,buyurl,imageurl) AS 
		(
		SELECT DISTINCT
			d.deviceguid
			, LTRIM(RTRIM(p.Value)) AS Expr1
			, LTRIM(RTRIM(p.Value)) AS Expr2
			, LTRIM(RTRIM(p.Value)) AS Expr3
			, LTRIM(RTRIM(p2.Value)) AS sd
			, LTRIM(RTRIM(p3.Value)) AS ld
			, LTRIM(RTRIM(p4.Value)) AS mk
			, LTRIM(RTRIM(p5.Value)) AS md
			, CONVERT(bit, ISNULL(COUNT(pt.Tag), 0)) AS IsAvailableInWarehouse
			, CONVERT(bit, ISNULL(COUNT(pto.Tag), 0)) AS IsAvailableOnline
			, ISNULL(COUNT(dfa.ProductGuid), 0) AS bfreebit
			, LTRIM(RTRIM(p007.Value)) AS buyurl
			, LTRIM(RTRIM(p008.Value)) AS imageurl
		FROM catalog.device AS d WITH (NOLOCK) 
		INNER JOIN catalog.property AS p WITH (NOLOCK) ON p.ProductGuid = d.DeviceGuid 
			AND p.Name = 'Title'
		INNER JOIN catalog.property AS p2 WITH (NOLOCK) ON p2.ProductGuid = d.DeviceGuid 
			AND p2.Name = 'ShortDescription'
			AND p2.ProductGuid = p.ProductGuid
		INNER JOIN catalog.property AS p3 WITH (NOLOCK) ON p3.ProductGuid = d.DeviceGuid AND p3.Name = 'LongDescription'
			AND p3.ProductGuid = p.ProductGuid 
			AND p3.ProductGuid = p2.ProductGuid
		LEFT JOIN catalog.property AS p4 WITH (NOLOCK) ON p4.ProductGuid = d.DeviceGuid AND p4.Name = 'MetaKeywords'
			AND p4.ProductGuid = p.ProductGuid 
			AND p4.ProductGuid = p2.ProductGuid AND p4.ProductGuid = p3.ProductGuid
		LEFT JOIN catalog.property AS p5 WITH (NOLOCK) ON p5.ProductGuid = d.DeviceGuid 
			AND p5.Name = 'MetaDescription'
			AND p5.ProductGuid = p.ProductGuid 
			AND p5.ProductGuid = p2.ProductGuid AND p5.ProductGuid = p3.ProductGuid AND p5.ProductGuid = p4.ProductGuid
		LEFT JOIN catalog.property AS p007 WITH (NOLOCK) ON p007.ProductGuid = d.DeviceGuid 
			AND p007.Name = 'CJ-BuyURL'
		LEFT JOIN catalog.property AS p008 WITH (NOLOCK) ON p008.ProductGuid = d.DeviceGuid 
			AND p008.Name = 'CJ-ImageURL'		
		LEFT OUTER JOIN catalog.ProductTag pt WITH (NOLOCK) ON pt.ProductGuid = d.DeviceGuid 
			AND pt.Tag = 'warehouse'
		LEFT OUTER JOIN catalog.ProductTag pto WITH (NOLOCK) ON pto.ProductGuid = d.DeviceGuid 
			AND pto.Tag = 'online'			
		LEFT OUTER JOIN catalog.DeviceFreeAccessory dfa WITH (NOLOCK) ON dfa.DeviceGuid = d.DeviceGuid 
			AND (GETDATE() >= StartDate) AND (GETDATE() <= EndDate)
		WHERE (p.Value <> '' OR p2.Value <> '' OR p3.value <> '')
			AND d.DeviceGuid NOT IN (SELECT ProductGuid FROM catalog.ProductTag WITH (NOLOCK) WHERE Tag = 'prepaidphone')
		GROUP BY d.DeviceGuid, p.Value, p2.Value, p3.Value, p4.Value, p5.Value, pt.tag, dfa.ProductGuid,p007.Value
		,p008.value
		)

SELECT DISTINCT
	d.DeviceGuid
	, d.DeviceGuid AS ProductGuid
	, ISNULL(p.ProductId, 0) AS phoneID
	, ISNULL(p.ProductId, 0) AS product_id
	, ISNULL(p.ProductId, 0) AS ProductID
	, p.GersSku
	, ISNULL (t.pageTitle, d .Name) + ' (' + c.CompanyName + ')' AS PageTitle
    , ISNULL (t.summaryTitle, d .Name) AS SummaryTitle
	, ISNULL (t.detailTitle, d .Name) AS DetailTitle
	, c.CarrierId
	, c.CompanyName AS CarrierName
	, mf.CompanyGuid AS ManufacturerGuid
	, mf.CompanyName AS ManufacturerName
	, t.IsAvailableInWarehouse
	, t.IsAvailableOnline
	, t.bfreebit AS bFreeAccessory
	, ISNULL (t.sd, NULL)	AS summaryDescription
	, ISNULL (t.ld, NULL)	AS detailDescription
	, t.mk  + ', ' + STUFF(
             (SELECT ', ' + cptg.Tag
             FROM catalog.ProductTag cptg WITH (NOLOCK)
             WHERE cptg.ProductGuid = pg.ProductGuid
              FOR XML PATH (''))
             , 1, 1, '') AS MetaKeywords
	, t.md AS MetaDescription
	, (SELECT TOP 1 p.Value FROM catalog.Property p WITH (NOLOCK) WHERE Name = 'ReleaseDate' AND p.ProductGuid = d .DeviceGuid) ReleaseDate
	, 0 AS Prepaid
	, pt.ProductTypeId AS typeID
	, d.UPC
	, t.buyurl
	, t.imageurl
	, ISNULL(i.AvailableQty, 0) AS QtyOnHand
	, ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ECP' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_retail
	, ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ECN' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_new
	, ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ECU' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_upgrade
    , ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ECA' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_addaline
	, ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ECP' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_nocontract						
    , ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ERN' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS NewPriceAfterRebate
    , ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ERU' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS UpgradePriceAfterRebate
    , ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ERA' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS AddALinePriceAfterRebate
	, ROW_NUMBER() OVER (ORDER BY sr.EditorsChoiceRank, sr.Sales2WeeksRank, sr.LaunchDateRank) AS DefaultSortRank
FROM catalog.Device d WITH (NOLOCK)
INNER JOIN catalog.ProductGuid pg WITH (NOLOCK) ON d.DeviceGuid = pg.ProductGuid
INNER JOIN catalog.ProductType pt WITH (NOLOCK) ON pg.ProductTypeId = pt.ProductTypeId
LEFT OUTER JOIN catalog.Product p WITH (NOLOCK) ON pg.ProductGuid = p.ProductGuid AND p.Active = '1'
INNER JOIN catalog.SortRanks sr WITH (NOLOCK) ON pg.ProductGuid = sr.ProductGuid
INNER JOIN catalog.Company c WITH (NOLOCK) ON d .CarrierGuid = c.CompanyGuid AND c.IsCarrier = 1
LEFT OUTER JOIN catalog.Company mf WITH (NOLOCK) ON d.ManufacturerGuid = mf.CompanyGuid
INNER JOIN Title t WITH (NOLOCK) ON t.DeviceGuid = d.DeviceGuid
INNER JOIN catalog.Inventory i WITH (NOLOCK) ON i.ProductId = p.ProductId
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'VIEW', @level1name = N'dn_Phones';


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
End
', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'VIEW', @level1name = N'dn_Phones';

