CREATE VIEW [report].[OrderDetailDump]
AS
SELECT     
	O.UserId
	, 'EC' + CONVERT(nvarchar(10)
	, CONVERT(binary(4), O.UserId), 2) AS CUST_CD
	, O.OrderDate, O.Status AS OrderStatus
	, O.OrderId
	, O.GERSRefNum
	, O.GERSStatus
	, C.CompanyName
	, A.FirstName
	, A.LastName
	, OD.OrderDetailId
	, OD.GersSku
	, OD.ProductTitle
	, WL.ActivationStatus AS LineActivationStatus
	, OD.Qty * OD.NetPrice AS Subtotal
	, OD.Taxes
	, WL.MonthlyFee MonthlyAccessFee
	, CASE 
		WHEN OD.OrderDetailType = 'd' THEN OD.ProductTitle 
		ELSE NULL 
	  END HandsetType
	, ISNULL(WL.NewMDN, WL.CurrentMDN) ActivatedPhoneNumber
	, WL.IMEI AS ESN_IMEI
FROM salesorder.[Order] AS O 
INNER JOIN salesorder.OrderDetail AS OD ON O.OrderId = OD.OrderId 
INNER JOIN catalog.Company AS C ON O.CarrierId = C.CarrierId 
INNER JOIN salesorder.Address AS A ON O.ShipAddressGuid = A.AddressGuid 
LEFT OUTER JOIN salesorder.WirelessLine AS WL ON OD.OrderDetailId = WL.OrderDetailId
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'report', @level1type = N'VIEW', @level1name = N'OrderDetailDump';


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
         Begin Table = "O"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 282
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OD"
            Begin Extent = 
               Top = 6
               Left = 320
               Bottom = 125
               Right = 488
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 6
               Left = 526
               Bottom = 125
               Right = 687
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 725
               Bottom = 125
               Right = 885
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "WL"
            Begin Extent = 
               Top = 126
               Left = 318
               Bottom = 245
               Right = 530
            End
            DisplayFlags = 280
            TopColumn = 0
         End
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
', @level0type = N'SCHEMA', @level0name = N'report', @level1type = N'VIEW', @level1name = N'OrderDetailDump';

