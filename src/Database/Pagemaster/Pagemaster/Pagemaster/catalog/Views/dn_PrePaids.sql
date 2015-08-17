


/* carriers only*/
CREATE VIEW [catalog].[dn_PrePaids] AS
SELECT     
	d.DeviceGuid
	, d.DeviceGuid AS ProductGuid
	, ISNULL(p.ProductId, 0) AS phoneID
	, ISNULL(p.ProductId, 0) AS product_id
	, ISNULL(p.ProductId, 0) AS ProductID
	, p.GersSku
	, d.UPC
	, ISNULL((	SELECT     ltrim(rtrim(Value))
				FROM         catalog.Property WITH (NOLOCK)
				WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), d .Name) + ' (' + c.CompanyName + ')' AS pageTitle
	, ISNULL((	SELECT     ltrim(rtrim(Value))
				FROM         catalog.Property WITH (NOLOCK)
				WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), d .Name) AS summaryTitle
	, ISNULL((	SELECT     ltrim(rtrim(Value))
				FROM         catalog.Property WITH (NOLOCK)
				WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), d .Name) AS detailTitle
	, c.CarrierId
	, c.CompanyName AS carrierName
	, mf.CompanyGuid AS manufacturerGuid
	, mf.CompanyName AS manufacturerName
	, CONVERT(bit, ISNULL((SELECT     1
		  FROM         catalog.ProductTag WITH (NOLOCK)
		  WHERE     (Tag = 'warehouse') AND (ProductGuid = d .DeviceGuid)), 0)) AS IsAvailableInWarehouse
	, CONVERT(bit, ISNULL((SELECT     1
		  FROM         catalog.ProductTag WITH (NOLOCK)
		  WHERE     (Tag = 'online') AND (ProductGuid = d .DeviceGuid)), 0)) AS IsAvailableOnline
	, CONVERT(bit, ISNULL
	  ((SELECT     COUNT(ProductGuid) AS Expr1
		  FROM         catalog.DeviceFreeAccessory dfa WITH (NOLOCK)
		  WHERE     (DeviceGuid = d .DeviceGuid) AND (GETDATE() >= StartDate) AND (GETDATE() <= EndDate)), 0)) AS bFreeAccessory
	, ISNULL((	SELECT ltrim(rtrim(Value))
				FROM catalog.Property WITH (NOLOCK)
				WHERE (Name = 'ShortDescription') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), NULL) AS summaryDescription
	, ISNULL((	SELECT ltrim(rtrim(Value))
				FROM catalog.Property WITH (NOLOCK)
				WHERE (Name = 'LongDescription') AND (Value <> '') AND (ProductGuid = d .DeviceGuid)), NULL) AS detailDescription
	,(SELECT TOP 1 p.Value FROM catalog.Property p WHERE Name = 'MetaKeywords' AND p.ProductGuid = d .DeviceGuid) + ', ' + STUFF(
		(SELECT ', ' + cptg.Tag
		FROM catalog.ProductTag cptg
		WHERE cptg.ProductGuid = pg.ProductGuid
		FOR XML PATH (''))
		, 1, 1, '') AS MetaKeywords
	, NULL AS metaDescription
	, 1 AS prepaid
	, pt.ProductTypeId AS typeID
	, (SELECT TOP 1 p.Value FROM catalog.Property p WHERE Name = 'ReleaseDate' AND p.ProductGuid = d .DeviceGuid) ReleaseDate
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
	, ISNULL((	SELECT ISNULL(AvailableQty, 0)
                FROM catalog.Inventory WITH (NOLOCK)
                WHERE ProductId = p.ProductId), 0) AS QtyOnHand
	, ROW_NUMBER() OVER (ORDER BY sr.EditorsChoiceRank, sr.LaunchDateRank, sr.Sales3WeeksRank) AS DefaultSortRank
FROM catalog.Device d WITH (NOLOCK)
INNER JOIN catalog.ProductGuid pg WITH (NOLOCK) ON d.DeviceGuid = pg.ProductGuid 
INNER JOIN catalog.ProductType pt WITH (NOLOCK) ON pg.ProductTypeId = pt.ProductTypeId 
LEFT OUTER JOIN catalog.Product p WITH (NOLOCK) ON pg.ProductGuid = p.ProductGuid 
INNER JOIN catalog.SortRanks sr WITH (NOLOCK) ON pg.ProductGuid = sr.ProductGuid 
INNER JOIN catalog.Company c WITH (NOLOCK) ON d.CarrierGuid = c.CompanyGuid AND c.IsCarrier = 1 
LEFT JOIN catalog.Company mf WITH (NOLOCK) ON d.ManufacturerGuid = mf.CompanyGuid 
INNER JOIN catalog.ProductTag ptag WITH (NOLOCK) ON p.ProductGuid = ptag.ProductGuid AND ptag.Tag = 'prepaid'
WHERE
	p.Active = 1