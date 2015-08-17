
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO












CREATE VIEW [catalog].[dn_Phones] AS

WITH
Title (DeviceGuid, pageTitle, summaryTitle, detailTitle, sd, ld, mk, md, bWarehouse, bfreebit) AS 
		(
		SELECT DISTINCT
		d.deviceguid,
		LTRIM(RTRIM(p.Value)) AS Expr1,
		LTRIM(RTRIM(p.Value)) AS Expr2,
		LTRIM(RTRIM(p.Value)) AS Expr3,
		LTRIM(RTRIM(p2.Value)) AS sd,
		LTRIM(RTRIM(p3.Value)) AS ld,
		LTRIM(RTRIM(p4.Value)) AS mk,
		LTRIM(RTRIM(p5.Value)) AS md,
		CONVERT(bit, ISNULL(COUNT(pt.Tag), 0)) AS bWarehouse,
		ISNULL(COUNT(dfa.ProductGuid), 0) AS bfreebit
		FROM   catalog.device AS d
		INNER JOIN catalog.property AS p ON p.ProductGuid = d.DeviceGuid AND p.Name = 'Title'
		INNER JOIN catalog.property AS p2 ON p2.ProductGuid = d.DeviceGuid AND p2.Name = 'ShortDescription'
		AND p2.ProductGuid = p.ProductGuid
		INNER JOIN catalog.property AS p3 ON p3.ProductGuid = d.DeviceGuid AND p3.Name = 'LongDescription'
		AND p3.ProductGuid = p.ProductGuid AND p3.ProductGuid = p2.ProductGuid
		INNER JOIN catalog.property AS p4 ON p4.ProductGuid = d.DeviceGuid AND p4.Name = 'MetaKeywords'
		AND p4.ProductGuid = p.ProductGuid AND p4.ProductGuid = p2.ProductGuid AND p4.ProductGuid = p3.ProductGuid
		INNER JOIN catalog.property AS p5 ON p5.ProductGuid = d.DeviceGuid AND p5.Name = 'MetaDescription'
		AND p5.ProductGuid = p.ProductGuid AND p5.ProductGuid = p2.ProductGuid AND p5.ProductGuid = p3.ProductGuid AND p5.ProductGuid = p4.ProductGuid
		LEFT OUTER JOIN catalog.ProductTag pt ON pt.ProductGuid = d.DeviceGuid AND pt.Tag = 'warehouse'
		LEFT OUTER JOIN catalog.DeviceFreeAccessory AS dfa ON dfa.DeviceGuid = d.DeviceGuid AND (GETDATE() >= StartDate) AND (GETDATE() <= EndDate)
		WHERE (p.Value <> '' OR p2.Value <> '' OR p3.value <> '')
		AND d.DeviceGuid NOT IN (SELECT ProductGuid FROM catalog.ProductTag WHERE Tag = 'prepaidphone')
		GROUP BY d.DeviceGuid, p.Value, p2.Value, p3.Value, p4.Value, p5.Value, pt.tag, dfa.ProductGuid
		)

SELECT
	d.DeviceGuid,
	d.DeviceGuid AS ProductGuid,
	ISNULL(p.ProductId, 0) AS phoneID,
	ISNULL(p.ProductId, 0) AS product_id,
	ISNULL(p.ProductId, 0) AS ProductID,
	p.GersSku,
	ISNULL (t.pageTitle, d .Name) + ' (' + c.CompanyName + ')' AS pageTitle,
    ISNULL (t.summaryTitle, d .Name) AS summaryTitle,
	ISNULL (t.detailTitle, d .Name)	AS detailTitle,
	c.CarrierId,
	c.CompanyName AS carrierName,
	NULL AS carrierLogoSmall,
	NULL AS carrierLogoMedium,
	NULL AS carrierLogoLarge,
	mf.CompanyGuid AS manufacturerGuid,
	mf.CompanyName AS manufacturerName,
	t.bWarehouse AS bWarehouse,
	t.bfreebit AS bFreeAccessory,
	NULL AS smimage,
	0 AS smimagewidth,
	0 AS smimageheight,
	NULL AS stdimage,
	0 AS stdimagewidth,
	0 AS stdimageheight,
	NULL AS lrgimage,
	0 AS lrgimagewidth,
	0 AS lrgimageheight,
	ISNULL (t.sd, NULL)	AS summaryDescription,
	ISNULL (t.ld, NULL)	AS detailDescription,
	t.mk  + ', ' + STUFF(
             (SELECT ', ' + cptg.Tag
             FROM catalog.ProductTag cptg
             WHERE cptg.ProductGuid = pg.ProductGuid
              FOR XML PATH (''))
             , 1, 1, '') AS MetaKeywords,
	t.md AS MetaDescription,
	(SELECT TOP 1 p.Value
                    FROM   catalog.Property p
                    WHERE Name = 'ReleaseDate' AND p.ProductGuid = d .DeviceGuid) ReleaseDate,
	0 AS prepaid,
	pt.ProductTypeId AS typeID
	,
	 ISNULL
                          ((SELECT     MAX(gp.Price)
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECP' AND gp.GersSku = p.GersSku AND 
                                                    GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_retail,
	ISNULL((SELECT     MAX(gp.Price)
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECN' AND gp.GersSku = p.GersSku AND 
                                                    GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_new
	,CAST(0 AS money) AS new_rebateTotal, ISNULL
                          ((SELECT     MAX(gp.Price)
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECU' AND gp.GersSku = p.GersSku AND 
                                                    GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_upgrade,
                                                     CAST(0 AS money) AS upgrade_rebateTotal, ISNULL
                          ((SELECT     MAX(gp.Price)
                              FROM         catalog.GersPrice AS gp INNER JOIN
                                                    catalog.GersPriceGroup AS gpg ON gp.PriceGroupCode = gpg.PriceGroupCode AND gpg.PriceGroupCode = 'ECA' AND gp.GersSku = p.GersSku AND 
                                                    GETDATE() >= gp.StartDate AND CONVERT(date, GETDATE()) <= gp.EndDate), CAST(0 AS money)) AS price_addaline,
                                                    CAST(0 AS money) AS addaline_rebateTotal,
	d .UPC,
	p.CreateDate,
	ISNULL(i.AvailableQty, 0) AS QtyOnHand,
	ROW_NUMBER() OVER (ORDER BY sr.EditorsChoiceRank, sr.Sales2WeeksRank, sr.LaunchDateRank) AS DefaultSortRank

FROM
	catalog.Device AS d

INNER JOIN
	catalog.ProductGuid AS pg ON d .DeviceGuid = pg.ProductGuid

INNER JOIN
	catalog.ProductType AS pt ON pg.ProductTypeId = pt.ProductTypeId

LEFT OUTER JOIN
	catalog.Product AS p ON pg.ProductGuid = p.ProductGuid AND p.Active = '1'

INNER JOIN
	catalog.SortRanks sr ON pg.ProductGuid = sr.ProductGuid

INNER JOIN
	catalog.Company AS c ON d .CarrierGuid = c.CompanyGuid AND c.IsCarrier = 1

LEFT OUTER JOIN
	catalog.Company AS mf ON d .ManufacturerGuid = mf.CompanyGuid

INNER JOIN
	Title AS t ON t.DeviceGuid = d.DeviceGuid

INNER JOIN
	catalog.Inventory i ON i.ProductId = p.ProductId 





GO
