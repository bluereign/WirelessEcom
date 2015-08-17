
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [catalog].[dn_Plans]
WITH SCHEMABINDING 
AS

SELECT     r.RateplanGuid, p.ProductGuid, p.ProductId AS planId, p.ProductId, p.GersSku, r.CarrierBillCode, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = r.RateplanGuid)), r.Title) AS PlanName, 
                      CASE WHEN r.[Type] = 'IND' THEN 'individual' WHEN r.[Type] = 'FAM' THEN 'family' WHEN r.[Type] = 'DAT' THEN 'data' ELSE NULL END AS PlanType,
                      r.IsShared, 
                      ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_16
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = r.RateplanGuid)), r.Title) AS PageTitle, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_15
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = r.RateplanGuid)), r.Title) AS SummaryTitle, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_14
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = r.RateplanGuid)), r.Title) AS DetailTitle, 1 AS FamilyPlan, c.CompanyName, 
                      c.CompanyName AS CarrierName, c.CarrierId, c.CompanyGuid AS CarrierGuid, 'Do we need carrier small logo?' AS CarrierLogoSmall, 
                      'Do we need carrier medium logo?' AS CarrierLogoMedium, 'Do we need carrier large logo?' AS CarrierLogoLarge, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_13
                              WHERE     (Name = 'ShortDescription') AND (ProductGuid = r.RateplanGuid)), r.Title) AS SummaryDescription, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_12
                              WHERE     (Name = 'LongDescription') AND (ProductGuid = r.RateplanGuid)), r.Title) AS DetailDescription, catalog.GetRateplanMonthlyFee(p.ProductId, 1) 
                      AS PlanPrice, catalog.GetRateplanMonthlyFee(p.ProductId, 1) AS MonthlyFee, r.IncludedLines, r.MaxLines, r.AdditionalLineFee, ISNULL
                          ((SELECT     TOP (1) REPLACE(LTRIM(RTRIM(Value)),'FALSE','0') AS Expr1
                              FROM         catalog.Property AS Property_11
                              WHERE     (Name = 'ca0eebeb-a6cf-40b3-b9bc-b431e20fa356') AND (Value <> '') AND (ProductGuid = r.RateplanGuid)), 0) AS minutes_anytime, ISNULL
                          ((SELECT     TOP (1) LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_10
                              WHERE     (Name = '4cd4d055-9503-4b4a-904c-fc6a5cf50956') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS minutes_offpeak, 
                      ISNULL
                          ((SELECT     TOP (1) REPLACE(LTRIM(RTRIM(Value)),'FALSE','0') AS Expr1
                              FROM         catalog.Property AS Property_9
                              WHERE     (Name = '20ee37a2-f82a-4fd6-9164-e993ae3912ba') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS minutes_mobtomob, 
                      ISNULL
                          ((SELECT     TOP (1) LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_8
                              WHERE     (Name = 'c1bc81e0-242c-4d0a-a6de-7f7a82fccb79') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) 
                      AS minutes_friendsandfamily, CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_7
                              WHERE     (Name = 'f081eba4-b5c1-4ade-8a03-cd2a8aac8e3c') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS bit) 
                      AS unlimited_offpeak, CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_6
                              WHERE     (Name = '101f781e-7f66-4ef3-94ee-58759b526886') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS bit) 
                      AS unlimited_mobtomob, CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_5
                              WHERE     (Name = 'f84020d5-3dfd-4244-a125-4801a5b9c122') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS bit) 
                      AS unlimited_friendsandfamily, CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_4
                              WHERE     (Name = 'a56b0b8a-65b1-41e2-911f-145a5c1c720a') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS bit) AS unlimited_data, 
                      CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_3
                              WHERE     (Name = 'ce632bcb-adf0-4705-a229-4ede08e3c9bd') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS bit) 
                      AS unlimited_textmessaging, CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_2
                              WHERE     (Name = '1701ca57-852c-49bb-b8fd-a75d58e5dba0') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS bit) 
                      AS free_longdistance, CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_1
                              WHERE     (Name = '93345b9b-9866-4265-bce0-4a32d2ae165e') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS bit) AS free_roaming, 
                      CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_1
                              WHERE     (Name = '4497c077-da96-4ff7-b92f-dcffe2b0c464') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS VARCHAR(50)) 
                      AS data_limit, CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_1
                              WHERE     (Name = 'CE42C5DA-5473-4E82-AD76-DE4D1D0C47DC') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS VARCHAR(50)) 
                      AS additional_data_usage,
                      
                      
                       ISNULL((SELECT TOP 1 py.Value FROM catalog.Property py WHERE Name = 'MetaKeywords' AND py.ProductGuid = p.ProductGuid) + ', ' + STUFF(
             (SELECT ', ' + cptg.Tag
             FROM catalog.ProductTag cptg
             WHERE cptg.ProductGuid = p.ProductGuid
              FOR XML PATH (''))
             , 1, 1, ''),0) AS MetaKeywords,
                      
                       CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_1
                              WHERE     (Name = 'DataLimitGB') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS VARCHAR(50)) 
                      AS DataLimitGb,p.CreateDate
FROM         catalog.Rateplan AS r INNER JOIN
                      catalog.Company AS c ON r.CarrierGuid = c.CompanyGuid INNER JOIN
                      catalog.Product AS p ON r.RateplanGuid = p.ProductGuid
WHERE     (p.Active = 1)











GO



EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[24] 4[12] 2[46] 3) )"
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
         Begin Table = "r"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 10
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 121
               Right = 427
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 241
               Right = 190
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
      Begin ColumnWidths = 38
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
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
     ', 'SCHEMA', N'catalog', 'VIEW', N'dn_Plans', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N' End
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
', 'SCHEMA', N'catalog', 'VIEW', N'dn_Plans', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'catalog', 'VIEW', N'dn_Plans', NULL, NULL
GO
