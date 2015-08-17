


CREATE VIEW [logging].[catalogload_deviceservice]
AS
WITH 		
	Skers AS
		(
		SELECT DISTINCT lca.PKCol, cp.GersSku, lca.NewValue, lca.OldValue, lca.Type, lca.TableName
		FROM  logging.CatalogAudit AS lca
		INNER JOIN catalog.Product AS cp ON CONVERT(VARCHAR(128), cp.ProductGuid) = CONVERT(varchar(128),(ISNULL(lca.OldValue,lca.NewValue)))
		WHERE lca.FieldName = 'DeviceGuid' AND (lca.SchemaName + lca.TableName = 'catalogdeviceservice') AND (lca.PKCol IS NOT NULL) AND (cp.GersSku IS NOT NULL)
		)
	,
	Service AS 
		(
		SELECT DISTINCT lca.PKCol, lca.NewValue, lca.OldValue, cs.CarrierBillCode, lca.Type, lca.TableName
		FROM  logging.CatalogAudit AS lca
		INNER JOIN catalog.Service AS cs ON CONVERT(VARCHAR(128), cs.ServiceGuid) = CONVERT(varchar(128),(ISNULL(lca.OldValue,lca.NewValue))) 
		WHERE lca.FieldName = 'ServiceGuid' AND (lca.SchemaName + lca.TableName = 'catalogdeviceservice') AND (lca.PKCol IS NOT NULL)
		)		

SELECT DISTINCT
               ISNULL(s.Type,r.Type) AS 'Type', ISNULL(s.TableName,r.TableName) AS Object, CASE WHEN s.OldValue IS NOT NULL OR
               s.NewValue IS NOT NULL AND (r.OldValue = r.NewValue) THEN 'DeviceGuid' WHEN r.OldValue IS NOT NULL OR
               r.NewValue IS NOT NULL AND (s.OldValue = s.NewValue) THEN 'ServiceGuid'
			   ELSE '[MULTPLE]' END AS [Modified Value], s.GersSku AS DeviceSku, 
               r.CarrierBillCode AS ServiceCarrierBillCode, ISNULL(s.OldValue, '---') AS OldDevice, ISNULL(s.NewValue, '---') AS NewDevice, ISNULL(r.OldValue, '---') 
               AS PreviousService, ISNULL(r.NewValue, '---') AS NewService
FROM  Skers s INNER JOIN Service r ON r.PKCol = s.PKCol
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'logging', @level1type = N'VIEW', @level1name = N'catalogload_deviceservice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N' 1170
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
', @level0type = N'SCHEMA', @level0name = N'logging', @level1type = N'VIEW', @level1name = N'catalogload_deviceservice';


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
         Begin Table = "lca"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 148
               Right = 232
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lca1"
            Begin Extent = 
               Top = 7
               Left = 280
               Bottom = 148
               Right = 464
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cp"
            Begin Extent = 
               Top = 154
               Left = 48
               Bottom = 295
               Right = 232
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lca2"
            Begin Extent = 
               Top = 154
               Left = 280
               Bottom = 295
               Right = 464
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cs"
            Begin Extent = 
               Top = 301
               Left = 48
               Bottom = 442
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lca3"
            Begin Extent = 
               Top = 301
               Left = 284
               Bottom = 442
               Right = 468
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
         Table =', @level0type = N'SCHEMA', @level0name = N'logging', @level1type = N'VIEW', @level1name = N'catalogload_deviceservice';

