
/****** Object:  View [catalog].[dn_Accessories]    Script Date: 05/13/2014 09:06:31 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[catalog].[dn_Accessories]'))
DROP VIEW [catalog].[dn_Accessories]
GO



ALTER VIEW [catalog].[Inventory]
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




/****** Object:  View [catalog].[dn_Accessories]    Script Date: 05/13/2014 09:06:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/* carriers only*/
CREATE VIEW [catalog].[dn_Accessories]
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
            
                     (SELECT  Top 1   ISNULL(AvailableQty, 0) QtyOnHand FROM  catalog.Inventory
                      WHERE     ProductId = p.ProductId
                      ) as QtyOnHand
                              
                     , ROW_NUMBER() OVER (ORDER BY sr.EditorsChoiceRank, sr.EditorsChoiceAccessoriesRank, sr.LaunchDateRank, 
                      sr.Sales3WeeksRank) AS DefaultSortRank
FROM         catalog.Accessory a INNER JOIN
                      catalog.ProductGuid pg ON a.AccessoryGuid = pg.ProductGuid INNER JOIN
                      catalog.ProductType pt ON pg.ProductTypeId = pt.ProductTypeId INNER JOIN
                      catalog. Product p ON pg.ProductGuid = p.ProductGuid INNER JOIN
                      catalog.SortRanks sr ON pg.ProductGuid = sr.ProductGuid INNER JOIN
                      catalog.Company c ON a.ManufacturerGuid = c.CompanyGuid
WHERE     p.Active = 1





GO


