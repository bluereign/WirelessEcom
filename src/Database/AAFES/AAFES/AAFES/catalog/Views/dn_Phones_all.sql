

CREATE VIEW [catalog].[dn_Phones_all] 
AS
/******************************************************************************************
*
*  Object: dn_Phones_All
*  Schema: catalog
*
*  Example Call:

              SELECT * FROM [catalog].[dn_Phones_AllNew]
			  SELECT * FROM [catalog].[dn_Phones_All]

*  Purpose: Return phone detail information.

*
*  Date             User                Detail
*  ??/??/??         ??                  Initial coding.
*  3/25/2011		smuniyandi			After Modified this view, we had 25% of performance increased.
*  09/18/2014       scampbell           Refactor and reference to new table [catalog].[DeviceDetail]
*
*****************************************************************************************/


WITH upgradeRebateTotal( DeviceGuid, Price )
AS
(
  SELECT ProductGuid
       , CAST(RebateTotal AS money)
   FROM [catalog].vProductRebateTotal AS vprt WITH (nolock)
  WHERE RebateMode = 'U'
),
addALineRebateTotal( DeviceGuid, Price )
AS
(
   SELECT ProductGuid
        , CAST(RebateTotal AS money)
     FROM [catalog].vProductRebateTotal AS vprt WITH (nolock)
    WHERE (RebateMode = 'A')
)
SELECT device.DeviceGuid
     , device.DeviceGuid AS ProductGuid
	 , ISNULL(device.ProductId, 0) AS phoneId
	 , ISNULL(device.ProductId, 0) AS product_Id
	 , ISNULL(device.ProductId, 0) AS ProductID
	 , device.pageTitle
	 , device.summaryTitle
	 , device.detailTitle
	 , device.carrierId AS CarrierId
	 , device.carrierName
	 , null AS carrierLogoSmall
	 , null AS carrierLogoMedium
	 , null AS carrierLogoLarge 
	 , null AS manufacturerID
	 , null AS manufacturerName
	 , CONVERT(bit, ISNULL((SELECT 1
                              FROM [catalog].ProductTag
                              WHERE (Tag = 'warehouse') 
							    AND (ProductGuid = device.DeviceGuid)), 0)
			   ) AS bWarehouse
     , device.BFreeAccessory AS bFreeAccessory
	 , null AS smimage
     , 0 AS smimagewidth
	 , 0 AS smimageheight
	 , null AS stdimage
	 , 0 AS stdimagewidth
	 , 0 AS stdimageheight
	 , null AS lrgimage
	 , 0 AS lrgimagewidth
	 , 0 AS lrgimageheight
	 , device.SummaryDescription AS summaryDescription
	 , device.DetailDescription AS detailDescription
	 , null AS metaKeywords
	 , null AS metaDescription
	 , device.prepaid AS prepaid
	 , device.typeId AS typeID
	 , device.RetailPrice AS price_retail
	 , device.NewPrice AS price_new
	 , ISNULL((SELECT RebateTotal
                 FROM [catalog].vProductRebateTotal AS vprt WITH (nolock)
                WHERE (ProductGuid = device.DeviceGuid) 
				  AND (RebateMode = 'N')
			   ), CAST(0 AS money)) AS new_rebateTotal
     , device.UpgradePrice AS price_upgrade
	 , upgradeRebateTotal.Price AS upgrade_rebateTotal
	 , device.AddALinePrice AS price_addaline
	 , addALineRebateTotal.Price AS addaline_rebateTotal
	 , device.UPC
	 , ISNULL(inventory.AvailableQty, 0) AS QtyOnHand
	 , device.Active
	 , device.DefaultSortRank
  FROM [catalog].[DeviceDetail] AS device
       LEFT JOIN upgradeRebateTotal
	     ON device.DeviceGuid = upgradeRebateTotal.DeviceGuid
	   LEFT JOIN addALineRebateTotal
	     ON device.DeviceGuid = addALineRebateTotal.DeviceGuid
	   LEFT JOIN [catalog].[Inventory] inventory WITH (NOLOCK) 
         ON device.ProductId = inventory.ProductId
 WHERE device.TypeId = 1
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'VIEW', @level1name = N'dn_Phones_all';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'VIEW', @level1name = N'dn_Phones_all';

