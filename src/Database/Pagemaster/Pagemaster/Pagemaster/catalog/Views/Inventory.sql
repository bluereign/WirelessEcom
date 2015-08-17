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