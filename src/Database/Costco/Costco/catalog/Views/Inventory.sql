


CREATE VIEW [catalog].[Inventory]
WITH SCHEMABINDING AS
--- Create "temp tables" from queries

WITH
	ProductList AS
		(
		SELECT	P.ProductId
				,P.ProductGuid
				,P.GersSku
				,P.Active
				,PT.ProductType
		FROM   catalog.Product AS P
		INNER JOIN catalog.ProductGuid AS PG ON P.ProductGuid = PG.ProductGuid AND P.GersSku IS NOT NULL AND PG.ProductTypeId IN (1, 4,6)
		INNER JOIN catalog.ProductType AS PT ON PG.ProductTypeId = PT.ProductTypeId
		)
		,
	EndOfLife AS
		(
		SELECT	ProductGuid
				,CONVERT(bit, Value) AS EndOfLife
		FROM   catalog.Property AS Prp
		WHERE (Name = 'Inventory.EndOfLife')
		)
		,
	PhysicalStock AS
		(
		SELECT	GersSku
				,COUNT(*) AS OnHandQty
		FROM   catalog.GersStock AS GS
		WHERE (OrderDetailId IS NULL)
		GROUP BY GersSku
		)
		,
	HoldBackProperty AS
		(
		SELECT	ProductGuid
				,CONVERT(int, Value) AS HoldBackQty
		FROM   catalog.Property AS Prp
		WHERE (Name = 'Inventory.HoldBackQty')
		),
	HoldBack AS
		(
		SELECT	PG.ProductGuid
		,ISNULL(H.HoldBackQty, CASE PG.ProductTypeId WHEN 1 THEN 3 ELSE 0 END) AS HoldBackQty
		FROM   catalog.ProductGuid AS PG
		LEFT OUTER JOIN HoldBackProperty AS H ON PG.ProductGuid = H.ProductGuid
		)
		,
	Reservations AS
		(
		SELECT ProductId
		,SUM(Qty) AS ReservedQty
		FROM   catalog.SessionStockReservation AS SSR
		GROUP BY ProductId
		)

--- Now actual query

SELECT
	ISNULL(P.ProductId, 0) AS ProductId
	,ISNULL(P.GersSku, S.GersSku) AS GersSku
	,ISNULL(P.ProductType, 'Unknown') AS ProductType
	,ISNULL(P.Active, 0) AS Active
	,ISNULL(E.EndOfLife, 0) AS EndOfLife
	,ISNULL(S.OnHandQty, 0) AS OnHandQty
	,H.HoldBackQty
	,CASE
		WHEN R.ReservedQty < 0
		THEN 0
		ELSE ISNULL(R.ReservedQty, 0) END AS ReservedQty
	,CASE
		WHEN ISNULL(H.HoldBackQty, 0) + ISNULL(R.ReservedQty, 0) > ISNULL(S.OnHandQty, 0)
		THEN ISNULL(S.OnHandQty, 0)
		ELSE ISNULL(S.OnHandQty, 0) - H.HoldBackQty - ISNULL(R.ReservedQty, 0) END AS AvailableQty
    
    FROM  ProductList AS P
    LEFT OUTER JOIN EndOfLife AS E ON P.ProductGuid = E.ProductGuid
    FULL OUTER JOIN PhysicalStock AS S ON P.GersSku = S.GersSku
    LEFT OUTER JOIN HoldBack AS H ON P.ProductGuid = H.ProductGuid
    LEFT OUTER JOIN Reservations AS R ON P.ProductId = R.ProductId;
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'VIEW', @level1name = N'Inventory';


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
         Begin Table = "PGS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 110
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PSR"
            Begin Extent = 
               Top = 6
               Left = 252
               Bottom = 110
               Right = 428
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
      Begin ColumnWidths = 9
         Width = 284
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
', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'VIEW', @level1name = N'Inventory';

