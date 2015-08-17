



CREATE VIEW [catalog].[dn_Tablets] AS

WITH
Title (DeviceGuid, pageTitle, summaryTitle, detailTitle, sd, ld, mk, md, IsAvailableInWarehouse, IsAvailableOnline, bfreebit) AS 
		(
		SELECT DISTINCT
			d.tabletguid
			, LTRIM(RTRIM(p.Value)) AS Expr1
			, LTRIM(RTRIM(p.Value)) AS Expr2
			, LTRIM(RTRIM(p.Value)) AS Expr3
			, LTRIM(RTRIM(p2.Value)) AS sd
			, LTRIM(RTRIM(p3.Value)) AS ld
			, LTRIM(RTRIM(p4.Value)) AS mk
			, LTRIM(RTRIM(p5.Value)) AS md
			, CONVERT(bit, ISNULL(COUNT(pt.Tag), 0)) AS IsAvailableInWarehouse
			, CONVERT(bit, ISNULL(COUNT(pto.Tag), 0)) AS IsAvailableOnline
			, ISNULL(COUNT(dfa.ProductGuid), 0) AS bfreebit
		FROM catalog.tablet AS d WITH (NOLOCK) 
		INNER JOIN catalog.property AS p WITH (NOLOCK) ON p.ProductGuid = d.TabletGuid 
			AND p.Name = 'Title'
		INNER JOIN catalog.property AS p2 WITH (NOLOCK) ON p2.ProductGuid = d.TabletGuid 
			AND p2.Name = 'ShortDescription'
			AND p2.ProductGuid = p.ProductGuid
		INNER JOIN catalog.property AS p3 WITH (NOLOCK) ON p3.ProductGuid = d.TabletGuid AND p3.Name = 'LongDescription'
			AND p3.ProductGuid = p.ProductGuid 
			AND p3.ProductGuid = p2.ProductGuid
		LEFT JOIN catalog.property AS p4 WITH (NOLOCK) ON p4.ProductGuid = d.TabletGuid AND p4.Name = 'MetaKeywords'
			AND p4.ProductGuid = p.ProductGuid 
			AND p4.ProductGuid = p2.ProductGuid AND p4.ProductGuid = p3.ProductGuid
		LEFT JOIN catalog.property AS p5 WITH (NOLOCK) ON p5.ProductGuid = d.TabletGuid 
			AND p5.Name = 'MetaDescription'
			AND p5.ProductGuid = p.ProductGuid 
			AND p5.ProductGuid = p2.ProductGuid AND p5.ProductGuid = p3.ProductGuid AND p5.ProductGuid = p4.ProductGuid
		LEFT OUTER JOIN catalog.ProductTag pt WITH (NOLOCK) ON pt.ProductGuid = d.TabletGuid 
			AND pt.Tag = 'warehouse'
		LEFT OUTER JOIN catalog.ProductTag pto WITH (NOLOCK) ON pto.ProductGuid = d.TabletGuid 
			AND pto.Tag = 'online'			
		LEFT OUTER JOIN catalog.DeviceFreeAccessory dfa WITH (NOLOCK) ON dfa.DeviceGuid = d.TabletGuid 
			AND (GETDATE() >= StartDate) AND (GETDATE() <= EndDate)
		WHERE (p.Value <> '' OR p2.Value <> '' OR p3.value <> '')
			AND d.TabletGuid NOT IN (SELECT ProductGuid FROM catalog.ProductTag WITH (NOLOCK) WHERE Tag = 'prepaidphone')
		GROUP BY d.TabletGuid, p.Value, p2.Value, p3.Value, p4.Value, p5.Value, pt.tag, dfa.ProductGuid
		)

SELECT
	d.TabletGuid AS 'DeviceGuid'
	, d.TabletGuid AS ProductGuid
	, ISNULL(p.ProductId, 0) AS phoneID
	, ISNULL(p.ProductId, 0) AS product_id
	, ISNULL(p.ProductId, 0) AS ProductID
	, p.GersSku
	, ISNULL (t.pageTitle, d .Name) + ' (' + c.CompanyName + ')' AS PageTitle
    , ISNULL (t.summaryTitle, d .Name) AS SummaryTitle
	, ISNULL (t.detailTitle, d .Name) AS DetailTitle
	, c.CarrierId
	, c.CompanyName AS CarrierName
	, mf.CompanyGuid AS ManufacturerGuid
	, mf.CompanyName AS ManufacturerName
	, t.IsAvailableInWarehouse
	, t.IsAvailableOnline
	, t.bfreebit AS bFreeAccessory
	, ISNULL (t.sd, NULL)	AS summaryDescription
	, ISNULL (t.ld, NULL)	AS detailDescription
	, t.mk  + ', ' + STUFF(
             (SELECT ', ' + cptg.Tag
             FROM catalog.ProductTag cptg WITH (NOLOCK)
             WHERE cptg.ProductGuid = pg.ProductGuid
              FOR XML PATH (''))
             , 1, 1, '') AS MetaKeywords
	, t.md AS MetaDescription
	, (SELECT TOP 1 p.Value FROM catalog.Property p WITH (NOLOCK) WHERE Name = 'ReleaseDate' AND p.ProductGuid = d .TabletGuid) ReleaseDate
	, 0 AS Prepaid
	, pt.ProductTypeId AS typeID
	, d.UPC
	, ISNULL(i.AvailableQty, 0) AS QtyOnHand
	, ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ECP' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_retail
	, ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ECN' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_new
	, ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ECU' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_upgrade
    , ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ECA' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_addaline
	, ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ECP' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_nocontract						
    , ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ERN' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS NewPriceAfterRebate
    , ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ERU' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS UpgradePriceAfterRebate
    , ISNULL((	SELECT MAX(gp.Price)
				FROM catalog.GersPrice gp WITH (NOLOCK)
				WHERE 
					gp.PriceGroupCode = 'ERA' 
					AND gp.GersSku = p.GersSku 
					AND GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS AddALinePriceAfterRebate
	, ROW_NUMBER() OVER (ORDER BY sr.EditorsChoiceRank, sr.Sales2WeeksRank, sr.LaunchDateRank) AS DefaultSortRank
FROM catalog.tablet d WITH (NOLOCK)
INNER JOIN catalog.ProductGuid pg WITH (NOLOCK) ON d.TabletGuid = pg.ProductGuid
INNER JOIN catalog.ProductType pt WITH (NOLOCK) ON pg.ProductTypeId = pt.ProductTypeId
LEFT OUTER JOIN catalog.Product p WITH (NOLOCK) ON pg.ProductGuid = p.ProductGuid AND p.Active = '1'
INNER JOIN catalog.SortRanks sr WITH (NOLOCK) ON pg.ProductGuid = sr.ProductGuid
INNER JOIN catalog.Company c WITH (NOLOCK) ON d .CarrierGuid = c.CompanyGuid AND c.IsCarrier = 1
LEFT OUTER JOIN catalog.Company mf WITH (NOLOCK) ON d.ManufacturerGuid = mf.CompanyGuid
INNER JOIN Title t WITH (NOLOCK) ON t.DeviceGuid = d.TabletGuid
LEFT JOIN catalog.Inventory i WITH (NOLOCK) ON i.ProductId = p.ProductId