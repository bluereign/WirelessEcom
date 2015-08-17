CREATE VIEW report.OrderDump
AS
SELECT     O.UserId, 'EC' + CONVERT(nvarchar(10), CONVERT(binary(4), O.UserId), 2) AS CUST_CD, O.OrderDate, O.Status AS OrderStatus, O.OrderId, 
                      O.GERSRefNum, C.CompanyName, A.FirstName, A.LastName, WA.ActivationStatus AS OrderActivationStatus, ISNULL(P.PaymentAmount, 0) 
                      AS PaymentAmount, P.PaymentDate, O.ParentOrderId, O.SortCode, O.ActivationType,
                          (SELECT     SUM(Qty * NetPrice) AS Expr1
                            FROM          salesorder.OrderDetail
                            WHERE      (OrderId = O.OrderId)) AS OrderItemSubtotal,
                          (SELECT     SUM(Qty * Taxes) AS Expr1
                            FROM          salesorder.OrderDetail AS OrderDetail_1
                            WHERE      (OrderId = O.OrderId)) AS OrderTaxes, O.ShipCost
FROM         salesorder.[Order] AS O INNER JOIN
                      catalog.Company AS C ON O.CarrierId = C.CarrierId INNER JOIN
                      salesorder.Address AS A ON O.ShipAddressGuid = A.AddressGuid INNER JOIN
                      salesorder.WirelessAccount AS WA ON O.OrderId = WA.OrderId LEFT OUTER JOIN
                      salesorder.Payment AS P ON O.OrderId = P.OrderId AND P.PaymentMethodId IS NOT NULL
WHERE     (P.PaymentDate IS NOT NULL)

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[19] 4[16] 2[3] 3) )"
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
         Begin Table = "C"
            Begin Extent = 
               Top = 6
               Left = 320
               Bottom = 125
               Right = 481
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 519
               Bottom = 125
               Right = 679
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "WA"
            Begin Extent = 
               Top = 6
               Left = 717
               Bottom = 125
               Right = 921
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "P"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 280
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
      Begin ColumnWidths = 18
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
         Width = 1665
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500', @level0type = N'SCHEMA', @level0name = N'report', @level1type = N'VIEW', @level1name = N'OrderDump';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'Width = 1500
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
End', @level0type = N'SCHEMA', @level0name = N'report', @level1type = N'VIEW', @level1name = N'OrderDump';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'report', @level1type = N'VIEW', @level1name = N'OrderDump';

