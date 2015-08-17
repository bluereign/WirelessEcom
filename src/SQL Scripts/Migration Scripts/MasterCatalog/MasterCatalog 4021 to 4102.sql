/*
This is the migration script to update the database with the set of uncommitted changes you selected.

You can customize the script, and your edits will be used in deployment.
The following objects will be affected:
  catalog.Channel, catalog.FilterChannel, catalog.Product,
  service.IncomingGersPrice, service.IncomingGersPriceGroup, AAFES,
  orders.dn_AllPlans, catalog.vProductRebates, catalog.vProductRebateTotal,
  catalog.dn_Plans
*/

SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Creating schemata'
GO
CREATE SCHEMA [AAFES]
AUTHORIZATION [dbo]
GO
PRINT N'Removing schema binding from [catalog].[dn_Plans]'
GO







ALTER VIEW [catalog].[dn_Plans] AS
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
                          ((SELECT     TOP (1) LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_11
                              WHERE     (Name = 'ca0eebeb-a6cf-40b3-b9bc-b431e20fa356') AND (Value <> '') AND (ProductGuid = r.RateplanGuid)), 0) AS minutes_anytime, ISNULL
                          ((SELECT     TOP (1) LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_10
                              WHERE     (Name = '4cd4d055-9503-4b4a-904c-fc6a5cf50956') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS minutes_offpeak, 
                      ISNULL
                          ((SELECT     TOP (1) LTRIM(RTRIM(Value)) AS Expr1
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
                      AS DataLimitGb
FROM         catalog.Rateplan AS r INNER JOIN
                      catalog.Company AS c ON r.CarrierGuid = c.CompanyGuid INNER JOIN
                      catalog.Product AS p ON r.RateplanGuid = p.ProductGuid
WHERE     (p.Active = 1)
AND catalog.GetRateplanMonthlyFee(p.ProductId, 1) > '0'









GO
PRINT N'Removing schema binding from [catalog].[dn_Accessories]'
GO









/* carriers only*/
ALTER VIEW [catalog].[dn_Accessories]
AS

SELECT     a.AccessoryGuid, a.AccessoryGuid AS ProductGuid, ISNULL(p.ProductId, 0) AS ProductId, ISNULL(p.ProductId, 0) AS product_id, p.GersSku, NULL 
                      AS category_id, NULL AS categoryName, NULL AS group_id, ISNULL
                          ((SELECT     ltrim(rtrim(p2.Value))
                              FROM         catalog.Property p2
                              WHERE     (p2.Name = 'Title') AND (p2.Value <> '') AND (p2.ProductGuid = a.AccessoryGuid)), a.Name) + ' (' + c.CompanyName + ')' AS pageTitle, 
                      ISNULL
                          ((SELECT     ltrim(rtrim(p2.Value))
                              FROM         catalog.Property p2
                              WHERE     (p2.Name = 'Title') AND (p2.Value <> '') AND (p2.ProductGuid = a.AccessoryGuid)), a.Name) AS summaryTitle, ISNULL
                          ((SELECT     ltrim(rtrim(p2.Value))
                              FROM         catalog.Property p2
                              WHERE     (p2.Name = 'Title') AND (p2.Value <> '') AND (p2.ProductGuid = a.AccessoryGuid)), a.Name) AS detailTitle, ISNULL
                          ((SELECT     ltrim(rtrim(p2.Value))
                              FROM         catalog.Property p2
                              WHERE     (p2.Name = 'ShortDescription') AND (p2.Value <> '') AND (p2.ProductGuid = a.AccessoryGuid)), a.Name) AS summaryDescription, 
                      ISNULL
                          ((SELECT     ltrim(rtrim(p2.Value))
                              FROM         catalog.Property p2
                              WHERE     (p2.Name = 'LongDescription') AND (p2.Value <> '') AND (p2.ProductGuid = a.AccessoryGuid)), a.Name) 
                      AS detailDescription/* *** TRV: For now, setting both price_retail and price to the GERS ECP (retail price) - may need to revisit this later *** */ ,
                                             (SELECT TOP 1 py.Value FROM catalog.Property py WHERE Name = 'MetaKeywords' AND py.ProductGuid = pg.ProductGuid) + ', ' + STUFF(
             (SELECT ', ' + cptg.Tag
             FROM catalog.ProductTag cptg
             WHERE cptg.ProductGuid = pg.ProductGuid
              FOR XML PATH (''))
             , 1, 1, '') AS MetaKeywords, 
                      ISNULL
                          ((SELECT     TOP 1 CAST(gp.Price AS money)
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECP' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND GETDATE() <= gp.EndDate), CAST(0 AS money)) AS price_retail, 
                      ISNULL
                          ((SELECT     TOP 1 CAST(gp.Price AS money)
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECP' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND GETDATE() <= gp.EndDate), CAST(0 AS money)) AS price, c.CompanyGuid, 
                      c.CompanyName AS ManufacturerName, a.UPC ,
            
                     ISNULL(AvailableQty, 0) as QtyOnHand
                              
                     , ROW_NUMBER() OVER (ORDER BY sr.EditorsChoiceRank, sr.LaunchDateRank, 
                      sr.Sales3WeeksRank) AS DefaultSortRank
FROM         catalog.Accessory a INNER JOIN
                      catalog.ProductGuid pg ON a.AccessoryGuid = pg.ProductGuid INNER JOIN
                      catalog.ProductType pt ON pg.ProductTypeId = pt.ProductTypeId INNER JOIN
                      catalog. Product p ON pg.ProductGuid = p.ProductGuid INNER JOIN
                      catalog.SortRanks sr ON pg.ProductGuid = sr.ProductGuid INNER JOIN
                      catalog.Company c ON a.ManufacturerGuid = c.CompanyGuid
                      INNER JOIN catalog.Inventory i ON i.ProductId = p.ProductId AND i.AvailableQty > '0'
WHERE     p.Active = 1

AND 
ISNULL
                          ((SELECT     TOP 1 CAST(gp.Price AS money)
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECP' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND GETDATE() <= gp.EndDate), CAST(0 AS money)) > '0'






GO
PRINT N'Removing schema binding from [catalog].[SortRanks]'
GO
ALTER VIEW [catalog].[SortRanks]

AS

WITH SortProperties AS

(

                SELECT P.ProductGuid

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.EditorsChoice' AND ISNUMERIC(Value)=1) AS EditorsChoice

                                , (SELECT CONVERT(date,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='LaunchDate' AND ISDATE(Value)=1 AND CONVERT(date,Value) >= CONVERT(date,DATEADD(day,-21,GETDATE()))) AS LaunchDate

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales1Weeks' AND ISNUMERIC(Value)=1) AS Sales1Weeks

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales2Weeks' AND ISNUMERIC(Value)=1) AS Sales2Weeks

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales3Weeks' AND ISNUMERIC(Value)=1) AS Sales3Weeks

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales4Weeks' AND ISNUMERIC(Value)=1) AS Sales4Weeks

                FROM catalog.Product P

)

SELECT ProductGuid

                , COALESCE(EditorsChoice, 3.40E + 38) AS EditorsChoiceRank

                , DENSE_RANK() OVER(ORDER BY LaunchDate DESC) AS LaunchDateRank

                , DENSE_RANK() OVER(ORDER BY Sales1Weeks DESC) AS Sales1WeeksRank

                , DENSE_RANK() OVER(ORDER BY Sales2Weeks DESC) AS Sales2WeeksRank

                , DENSE_RANK() OVER(ORDER BY Sales3Weeks DESC) AS Sales3WeeksRank

                , DENSE_RANK() OVER(ORDER BY Sales4Weeks DESC) AS Sales4WeeksRank

FROM SortProperties

GO
PRINT N'Removing schema binding from [catalog].[Inventory]'
GO














ALTER VIEW [catalog].[Inventory]
AS
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
		INNER JOIN catalog.ProductGuid AS PG ON P.ProductGuid = PG.ProductGuid AND P.GersSku IS NOT NULL AND PG.ProductTypeId IN (1, 4)
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
PRINT N'Dropping extended properties'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'catalog', 'TABLE', N'Product', NULL, NULL
GO
EXEC sp_dropextendedproperty N'CreateDate', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'Active'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'Active'
GO
EXEC sp_dropextendedproperty N'Owner', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'Active'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'GersSku'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'ProductGuid'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'ProductId'
GO
PRINT N'Dropping foreign keys from [catalog].[Product]'
GO
ALTER TABLE [catalog].[Product] DROP CONSTRAINT [FK_Product_ProductGuid]
ALTER TABLE [catalog].[Product] DROP CONSTRAINT [FK_Product_GersItm]
GO
PRINT N'Dropping constraints from [catalog].[Product]'
GO
ALTER TABLE [catalog].[Product] DROP CONSTRAINT [PK_Product]
GO
PRINT N'Dropping constraints from [catalog].[Product]'
GO
ALTER TABLE [catalog].[Product] DROP CONSTRAINT [DF_Product_Active]
GO
PRINT N'Dropping index [IX_ProductGuid_Active_ProductId_GersSku] from [catalog].[Product]'
GO
DROP INDEX [IX_ProductGuid_Active_ProductId_GersSku] ON [catalog].[Product]
GO
PRINT N'Rebuilding [catalog].[Product]'
GO
CREATE TABLE [catalog].[tmp_rg_xx_Product]
(
[ProductId] [int] NOT NULL,
[ProductGuid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ProductGuidUni] DEFAULT (newid()),
[GersSku] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Product_Active] DEFAULT ((0)),
[ChannelID] [int] NOT NULL CONSTRAINT [DF__Product__Channel__7A0EC0D3] DEFAULT ((0))
) ON [PRIMARY]
GO
INSERT INTO [catalog].[tmp_rg_xx_Product]([ProductId], [ProductGuid], [GersSku], [Active]) SELECT [ProductId], ISNULL([ProductGuid], (newid())), [GersSku], [Active] FROM [catalog].[Product]
GO
DROP TABLE [catalog].[Product]
GO
EXEC sp_rename N'[catalog].[tmp_rg_xx_Product]', N'Product'
GO
PRINT N'Creating primary key [PK__Product__D8BC025F763E2FEF] on [catalog].[Product]'
GO
ALTER TABLE [catalog].[Product] ADD CONSTRAINT [PK__Product__D8BC025F763E2FEF] PRIMARY KEY CLUSTERED  ([ProductGuid]) ON [PRIMARY]
GO
PRINT N'Altering [catalog].[Inventory]'
GO















ALTER VIEW [catalog].[Inventory]
WITH SCHEMABINDING
AS
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
		INNER JOIN catalog.ProductGuid AS PG ON P.ProductGuid = PG.ProductGuid AND P.GersSku IS NOT NULL AND PG.ProductTypeId IN (1, 4)
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
PRINT N'Altering [catalog].[dn_Plans]'
GO







ALTER VIEW [catalog].[dn_Plans]
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
                          ((SELECT     TOP (1) LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_11
                              WHERE     (Name = 'ca0eebeb-a6cf-40b3-b9bc-b431e20fa356') AND (Value <> '') AND (ProductGuid = r.RateplanGuid)), 0) AS minutes_anytime, ISNULL
                          ((SELECT     TOP (1) LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_10
                              WHERE     (Name = '4cd4d055-9503-4b4a-904c-fc6a5cf50956') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS minutes_offpeak, 
                      ISNULL
                          ((SELECT     TOP (1) LTRIM(RTRIM(Value)) AS Expr1
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
                      AS DataLimitGb
FROM         catalog.Rateplan AS r INNER JOIN
                      catalog.Company AS c ON r.CarrierGuid = c.CompanyGuid INNER JOIN
                      catalog.Product AS p ON r.RateplanGuid = p.ProductGuid
WHERE     (p.Active = 1)









GO
PRINT N'Altering [catalog].[SortRanks]'
GO

ALTER VIEW [catalog].[SortRanks]

WITH SCHEMABINDING

AS

WITH SortProperties AS

(

                SELECT P.ProductGuid

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.EditorsChoice' AND ISNUMERIC(Value)=1) AS EditorsChoice

                                , (SELECT CONVERT(date,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='LaunchDate' AND ISDATE(Value)=1 AND CONVERT(date,Value) >= CONVERT(date,DATEADD(day,-21,GETDATE()))) AS LaunchDate

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales1Weeks' AND ISNUMERIC(Value)=1) AS Sales1Weeks

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales2Weeks' AND ISNUMERIC(Value)=1) AS Sales2Weeks

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales3Weeks' AND ISNUMERIC(Value)=1) AS Sales3Weeks

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales4Weeks' AND ISNUMERIC(Value)=1) AS Sales4Weeks

                FROM catalog.Product P

)

SELECT ProductGuid

                , COALESCE(EditorsChoice, 3.40E + 38) AS EditorsChoiceRank

                , DENSE_RANK() OVER(ORDER BY LaunchDate DESC) AS LaunchDateRank

                , DENSE_RANK() OVER(ORDER BY Sales1Weeks DESC) AS Sales1WeeksRank

                , DENSE_RANK() OVER(ORDER BY Sales2Weeks DESC) AS Sales2WeeksRank

                , DENSE_RANK() OVER(ORDER BY Sales3Weeks DESC) AS Sales3WeeksRank

                , DENSE_RANK() OVER(ORDER BY Sales4Weeks DESC) AS Sales4WeeksRank

FROM SortProperties


GO
PRINT N'Altering [catalog].[dn_Accessories]'
GO










/* carriers only*/
ALTER VIEW [catalog].[dn_Accessories]
WITH SCHEMABINDING 
AS

SELECT     a.AccessoryGuid, a.AccessoryGuid AS ProductGuid, ISNULL(p.ProductId, 0) AS ProductId, ISNULL(p.ProductId, 0) AS product_id, p.GersSku, NULL 
                      AS category_id, NULL AS categoryName, NULL AS group_id, ISNULL
                          ((SELECT     ltrim(rtrim(p2.Value))
                              FROM         catalog.Property p2
                              WHERE     (p2.Name = 'Title') AND (p2.Value <> '') AND (p2.ProductGuid = a.AccessoryGuid)), a.Name) + ' (' + c.CompanyName + ')' AS pageTitle, 
                      ISNULL
                          ((SELECT     ltrim(rtrim(p2.Value))
                              FROM         catalog.Property p2
                              WHERE     (p2.Name = 'Title') AND (p2.Value <> '') AND (p2.ProductGuid = a.AccessoryGuid)), a.Name) AS summaryTitle, ISNULL
                          ((SELECT     ltrim(rtrim(p2.Value))
                              FROM         catalog.Property p2
                              WHERE     (p2.Name = 'Title') AND (p2.Value <> '') AND (p2.ProductGuid = a.AccessoryGuid)), a.Name) AS detailTitle, ISNULL
                          ((SELECT     ltrim(rtrim(p2.Value))
                              FROM         catalog.Property p2
                              WHERE     (p2.Name = 'ShortDescription') AND (p2.Value <> '') AND (p2.ProductGuid = a.AccessoryGuid)), a.Name) AS summaryDescription, 
                      ISNULL
                          ((SELECT     ltrim(rtrim(p2.Value))
                              FROM         catalog.Property p2
                              WHERE     (p2.Name = 'LongDescription') AND (p2.Value <> '') AND (p2.ProductGuid = a.AccessoryGuid)), a.Name) 
                      AS detailDescription/* *** TRV: For now, setting both price_retail and price to the GERS ECP (retail price) - may need to revisit this later *** */ ,
                                             (SELECT TOP 1 py.Value FROM catalog.Property py WHERE Name = 'MetaKeywords' AND py.ProductGuid = pg.ProductGuid) + ', ' + STUFF(
             (SELECT ', ' + cptg.Tag
             FROM catalog.ProductTag cptg
             WHERE cptg.ProductGuid = pg.ProductGuid
              FOR XML PATH (''))
             , 1, 1, '') AS MetaKeywords, 
                      ISNULL
                          ((SELECT     TOP 1 CAST(gp.Price AS money)
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECP' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND GETDATE() <= gp.EndDate), CAST(0 AS money)) AS price_retail, 
                      ISNULL
                          ((SELECT     TOP 1 CAST(gp.Price AS money)
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECP' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND GETDATE() <= gp.EndDate), CAST(0 AS money)) AS price, c.CompanyGuid, 
                      c.CompanyName AS ManufacturerName, a.UPC ,
            
                     ISNULL(AvailableQty, 0) as QtyOnHand
                              
                     , ROW_NUMBER() OVER (ORDER BY sr.EditorsChoiceRank, sr.LaunchDateRank, 
                      sr.Sales3WeeksRank) AS DefaultSortRank
FROM         catalog.Accessory a INNER JOIN
                      catalog.ProductGuid pg ON a.AccessoryGuid = pg.ProductGuid INNER JOIN
                      catalog.ProductType pt ON pg.ProductTypeId = pt.ProductTypeId INNER JOIN
                      catalog. Product p ON pg.ProductGuid = p.ProductGuid INNER JOIN
                      catalog.SortRanks sr ON pg.ProductGuid = sr.ProductGuid INNER JOIN
                      catalog.Company c ON a.ManufacturerGuid = c.CompanyGuid
                      INNER JOIN catalog.Inventory i ON i.ProductId = p.ProductId AND i.AvailableQty > '0'
WHERE     p.Active = 1

AND 
ISNULL
                          ((SELECT     TOP 1 CAST(gp.Price AS money)
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECP' AND 
                                                    gp.GersSku = p.GersSku AND GETDATE() >= gp.StartDate AND GETDATE() <= gp.EndDate), CAST(0 AS money)) > '0'







GO
PRINT N'Creating [orders].[dn_AllPlans]'
GO


CREATE VIEW [orders].[dn_AllPlans]
WITH SCHEMABINDING 
AS
SELECT  DISTINCT    p.ProductId, p.GersSku, ISNULL
	((SELECT     LTRIM(RTRIM(Value)) AS Expr1
    FROM         catalog.Property
    WHERE     (Name = 'catalogProductName') AND (Value <> '') AND (ProductGuid = r.RateplanGuid)), r.Title) AS PlanName, c.CompanyName as CarrierName, 
                    catalog.GetRateplanMonthlyFee(p.ProductId, 1) AS MonthlyFeex, 'Voice' as PlanType, CarrierBillCode, cast( p.ProductGUID as varchar(40)) as ProductGUID
FROM         catalog.Rateplan AS r INNER JOIN
                      catalog.Company AS c ON r.CarrierGuid = c.CompanyGuid LEFT JOIN
                      catalog.Product AS p ON r.RateplanGuid = p.ProductGuid
WHERE (p.Active = 1) and p.GersSku is not null                     
UNION
SELECT  DISTINCT    p.ProductId, p.GersSku, ISNULL
	((SELECT     LTRIM(RTRIM(Value)) AS Expr1
    FROM         catalog.Property
    WHERE     (Name = 'catalogProductName') AND (Value <> '') AND (ProductGuid = r.ServiceGuid)), r.Title) AS PlanName,
     c.CompanyName as CarrierName,  r.MonthlyFee AS MonthlyFeex, 'Data' as PlanType, CarrierBillCode, cast( p.ProductGUID as varchar(40)) as ProductGUID
FROM         catalog.Service AS r INNER JOIN
                      catalog.Company AS c ON r.CarrierGuid = c.CompanyGuid LEFT JOIN
                      catalog.Product AS p ON r.ServiceGuid = p.ProductGuid
WHERE (p.Active = 1) and p.GersSku is not null                     

GO
PRINT N'Refreshing [logging].[catalogload_products]'
GO
EXEC sp_refreshview N'[logging].[catalogload_products]'
GO
PRINT N'Refreshing [logging].[catalogload_rateplan]'
GO
EXEC sp_refreshview N'[logging].[catalogload_rateplan]'
GO
PRINT N'Refreshing [logging].[catalogload_service]'
GO
EXEC sp_refreshview N'[logging].[catalogload_service]'
GO
PRINT N'Refreshing [logging].[catalogload_device]'
GO
EXEC sp_refreshview N'[logging].[catalogload_device]'
GO
PRINT N'Refreshing [logging].[catalogload_property]'
GO
EXEC sp_refreshview N'[logging].[catalogload_property]'
GO
PRINT N'Refreshing [logging].[catalogload_deviceservice]'
GO
EXEC sp_refreshview N'[logging].[catalogload_deviceservice]'
GO
PRINT N'Refreshing [logging].[catalogload_devicerateplan]'
GO
EXEC sp_refreshview N'[logging].[catalogload_devicerateplan]'
GO
PRINT N'Creating [catalog].[vProductRebateTotal]'
GO



CREATE VIEW [catalog].[vProductRebateTotal] WITH SCHEMABINDING AS
select
	p.ProductGuid,
	p.ProductId,
	rtp.RebateMode,
	ISNULL(SUM(r.Amount),0) as RebateTotal
from catalog.Product p
	INNER JOIN catalog.RebateToProduct rtp
		ON p.ProductGuid = rtp.ProductGuid
		AND GETDATE() >= rtp.StartDate
		AND GETDATE() <= rtp.EndDate
	INNER JOIN catalog.Rebate r
		ON rtp.RebateGuid = r.RebateGuid
		AND r.Active = 1
group by
	p.ProductGuid,
	p.ProductId,
	rtp.RebateMode


GO
PRINT N'Refreshing [catalog].[dn_Phones_all]'
GO
EXEC sp_refreshview N'[catalog].[dn_Phones_all]'
GO
PRINT N'Refreshing [catalog].[dn_PrePaids]'
GO
EXEC sp_refreshview N'[catalog].[dn_PrePaids]'
GO
PRINT N'Refreshing [catalog].[dn_Phones]'
GO
EXEC sp_refreshview N'[catalog].[dn_Phones]'
GO
PRINT N'Creating [catalog].[vProductRebates]'
GO



CREATE VIEW [catalog].[vProductRebates] WITH SCHEMABINDING AS
select
	p.ProductId,
	rtp.ProductGuid,
	rtp.RebateGuid,
	rtp.RebateMode,
	rtp.StartDate,
	rtp.EndDate,
	r.Title,
	r.Amount,
	r.Active,
	r.URL
from catalog.Product p
	INNER JOIN catalog.RebateToProduct rtp
		ON p.ProductGuid = rtp.ProductGuid
		AND GETDATE() >= rtp.StartDate
		AND GETDATE() <= rtp.EndDate
	INNER JOIN catalog.Rebate r
		ON rtp.RebateGuid = r.RebateGuid
		AND r.Active = 1

GO
PRINT N'Creating [catalog].[Channel]'
GO
CREATE TABLE [catalog].[Channel]
(
[ChannelGuid] [uniqueidentifier] NULL CONSTRAINT [DF_ChannelizeID] DEFAULT (newid()),
[ChannelId] [int] NOT NULL,
[Channel] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__Channel__38C3E8145E66A65E] on [catalog].[Channel]'
GO
ALTER TABLE [catalog].[Channel] ADD CONSTRAINT [PK__Channel__38C3E8145E66A65E] PRIMARY KEY CLUSTERED  ([ChannelId]) ON [PRIMARY]
GO
PRINT N'Creating [catalog].[FilterChannel]'
GO
CREATE TABLE [catalog].[FilterChannel]
(
[FilterChannelGuid] [uniqueidentifier] NULL CONSTRAINT [DF_FilterChannelizeID] DEFAULT (newsequentialid()),
[ChannelId] [int] NOT NULL,
[FilterOptionId] [int] NOT NULL,
[FilterGroupId] [int] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating [service].[IncomingGersPrice]'
GO
CREATE TABLE [service].[IncomingGersPrice]
(
[GersSku] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PriceGroupCode] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Price] [money] NOT NULL,
[StartDate] [date] NOT NULL,
[EndDate] [date] NOT NULL,
[Comment] [nvarchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_IncomingGersPrice] on [service].[IncomingGersPrice]'
GO
ALTER TABLE [service].[IncomingGersPrice] ADD CONSTRAINT [PK_IncomingGersPrice] PRIMARY KEY CLUSTERED  ([GersSku], [PriceGroupCode], [StartDate]) ON [PRIMARY]
GO
PRINT N'Creating [service].[IncomingGersPriceGroup]'
GO
CREATE TABLE [service].[IncomingGersPriceGroup]
(
[PriceGroupCode] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PriceGroupDescription] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK__Incoming__C1DF1DF33EEDFB05] on [service].[IncomingGersPriceGroup]'
GO
ALTER TABLE [service].[IncomingGersPriceGroup] ADD CONSTRAINT [PK__Incoming__C1DF1DF33EEDFB05] PRIMARY KEY CLUSTERED  ([PriceGroupCode]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [catalog].[Product]'
GO
ALTER TABLE [catalog].[Product] ADD CONSTRAINT [IX_ChanneledProductCopy] UNIQUE NONCLUSTERED  ([ProductId], [GersSku], [ChannelID]) ON [PRIMARY]
GO
PRINT N'Adding foreign keys to [catalog].[Product]'
GO
ALTER TABLE [catalog].[Product] WITH NOCHECK  ADD CONSTRAINT [FK_Product_GersItm] FOREIGN KEY ([GersSku]) REFERENCES [catalog].[GersItm] ([GersSku])
GO
PRINT N'Adding foreign keys to [catalog].[FilterChannel]'
GO
ALTER TABLE [catalog].[FilterChannel] ADD CONSTRAINT [FK__FilterCha__Chann__71797AD2] FOREIGN KEY ([ChannelId]) REFERENCES [catalog].[Channel] ([ChannelId])
ALTER TABLE [catalog].[FilterChannel] ADD CONSTRAINT [FK__FilterCha__Filte__726D9F0B] FOREIGN KEY ([FilterOptionId]) REFERENCES [catalog].[FilterOption] ([FilterOptionId])
ALTER TABLE [catalog].[FilterChannel] ADD CONSTRAINT [FK__FilterCha__Filte__7361C344] FOREIGN KEY ([FilterGroupId]) REFERENCES [catalog].[FilterGroup] ([FilterGroupId])
GO
PRINT N'Creating extended properties'
GO
EXEC sp_addextendedproperty N'MS_Description', N'List of all products, regardless of it being device, accessory, tablet, etc. with its GERS Sku. Also includes if the product should be actively available on the site or not.', 'SCHEMA', N'catalog', 'TABLE', N'Product', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'25-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Whether or not the product is actively listed on the site. (1) Active and (0) Inactive.', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'Owner', N'Naomi Hall', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to GersItm table', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'GersSku'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to ProductGuid table', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'ProductGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'ProductId'
GO
