
CREATE VIEW [salesorder].[CurrentInventory] AS
SELECT	gso.GersSku, 
(
	SELECT		COUNT(1)
	FROM		catalog.GersStock AS gs WITH (NOLOCK)
	INNER JOIN	catalog.Product AS p WITH (NOLOCK) ON p.GersSku = gs.GersSku AND p.Active = 1
	WHERE		gs.GersSku = gso.GersSku
) AS TotalStock,
(
	SELECT		COUNT(1)
	FROM		catalog.GersStock AS gs WITH (NOLOCK)
	INNER JOIN	catalog.Product AS p WITH (NOLOCK) ON p.GersSku = gs.GersSku AND p.Active = 1
	WHERE		gs.OutletCode <> 'FAK'
		AND		gs.GersSku = gso.GersSku
) AS TotalRealStock,
(
	SELECT		COUNT(1)
	FROM		catalog.GersStock AS gs WITH (NOLOCK)
	INNER JOIN	catalog.Product AS p WITH (NOLOCK) ON p.GersSku = gs.GersSku AND p.Active = 1
	WHERE		gs.OrderDetailId IS NOT NULL AND gs.OutletCode <> 'FAK'
		AND		gs.GersSku = gso.GersSku
) AS TotalRealStockOrders,
(
	SELECT		COUNT(1)
	FROM		catalog.GersStock AS gs WITH (NOLOCK)
	INNER JOIN	catalog.Product AS p WITH (NOLOCK) ON p.GersSku = gs.GersSku AND p.Active = 1
	WHERE		gs.OutletCode = 'FAK'
		AND		gs.GersSku = gso.GersSku
) AS TotalVirtualStock,
(
	SELECT		COUNT(1)
	FROM		catalog.GersStock AS gs WITH (NOLOCK)
	INNER JOIN	catalog.Product AS p WITH (NOLOCK) ON p.GersSku = gs.GersSku AND p.Active = 1
	WHERE		gs.OrderDetailId IS NOT NULL AND gs.OutletCode = 'FAK'
		AND		gs.GersSku = gso.GersSku
) AS TotalVirtualOrders
FROM		catalog.GersStock AS gso WITH (NOLOCK)
INNER JOIN	catalog.Product AS p WITH (NOLOCK) ON p.GersSku = gso.GersSku
GROUP BY	gso.GersSku
