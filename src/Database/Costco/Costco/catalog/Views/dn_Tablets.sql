


CREATE VIEW [catalog].[dn_Tablets]
AS
/******************************************************************************************
*
*  Object: dn_Tablet
*  Schema: catalog
*
*  Example Call:

              SELECT * FROM [catalog].[dn_Tablets] WHERE ProductId = 24514

*  Purpose: Return phone detail information.

*
*  Date             User                 Detail
*  ??/??/??          ??                   Initial coding.
*  09/18/2014        scampbell            Refactor and reference to new table [catalog].[DeviceDetail]
*  11/17/2014        rdelzer              get pricing from [catalog].[DevicePrice]
*
*****************************************************************************************/
WITH onlineAvail( ProductGUID, Cnt )
  AS
  (
    SELECT ProductGUID,
            COUNT(pto.Tag)
      FROM [catalog].ProductTag pto WITH (NOLOCK) 
     WHERE pto.Tag = 'online'
     GROUP BY ProductGuid
  ),
  warehouseAvail( ProductGUID, Cnt )
  AS
  (
    SELECT ProductGUID,
           COUNT(pt.Tag)
      FROM [catalog].ProductTag pt WITH (NOLOCK) 
     WHERE pt.Tag = 'warehouse'
     GROUP BY ProductGuid
  )
  SELECT detail.DeviceGuid
       , detail.DeviceGuid AS ProductGuid
       , ISNULL(detail.ProductId, 0) AS phoneID
       , ISNULL(detail.ProductId, 0) AS product_id
       , ISNULL(detail.ProductId, 0) AS ProductID
       , detail.GersSku
       , detail.PageTitle
       , detail.SummaryTitle
       , detail.DetailTitle
       , detail.CarrierId
       , detail.CarrierName
       , detail.ManufacturerGuid
       , detail.ManufacturerName
	   , CONVERT(bit, ISNULL(warehouseAvail.Cnt, 0)) AS IsAvailableInWarehouse
       , CONVERT(bit, ISNULL(onlineAvail.Cnt, 0)) AS IsAvailableOnline
       , detail.BFreeAccessory AS bFreeAccessory
       , detail.SummaryDescription AS summaryDescription
       , detail.DetailDescription AS detailDescription
       , detail.MetaKeywords
       , detail.MetaDescription
       , detail.ReleaseDate
       , detail.Prepaid
       , detail.typeID 
       , detail.UPC
       , detail.Buyurl AS buyurl
       , detail.ImageURL AS imageurl
       , ISNULL(inventory.AvailableQty, 0) AS QtyOnHand
       , ISNULL(price.RetailPrice, CAST(0 AS money)) AS price_retail
       , ISNULL(price.NewPrice, CAST(0 AS money)) AS price_new
       , ISNULL(price.UpgradePrice, CAST(0 AS money)) AS price_upgrade
       , ISNULL(price.AddALinePrice, CAST(0 AS money)) AS price_addaline
       , ISNULL(price.NoContractPrice, CAST(0 AS money)) AS price_nocontract                                   
       , ISNULL(price.NewPriceAfterRebate, CAST(0 AS money)) AS NewPriceAfterRebate
       , ISNULL(price.UpgradePriceAfterRebate, CAST(0 AS money)) AS UpgradePriceAfterRebate
       , ISNULL(price.AddALinePriceAfterRebate, CAST(0 AS money)) AS AddALinePriceAfterRebate
	   , ISNULL((SELECT TOP 1 gp.Price FROM catalog.GersPrice AS gp WHERE detail.GersSku = gp.GersSku AND gp.PriceGroupCode = 'NFR'),0) FinancedFullRetailPrice
	   , ISNULL((SELECT TOP 1 gp.Price FROM catalog.GersPrice AS gp WHERE detail.GersSku = gp.GersSku AND gp.PriceGroupCode = 'N12'),0) FinancedMonthlyPrice12
	   , ISNULL((SELECT TOP 1 gp.Price FROM catalog.GersPrice AS gp WHERE detail.GersSku = gp.GersSku AND gp.PriceGroupCode = 'N18'),0) FinancedMonthlyPrice18
	   , ISNULL((SELECT TOP 1 gp.Price FROM catalog.GersPrice AS gp WHERE detail.GersSku = gp.GersSku AND gp.PriceGroupCode = 'N24'),0) FinancedMonthlyPrice24         
       , detail.DefaultSortRank
    FROM [catalog].[DeviceDetail] AS detail
		INNER JOIN [catalog].[DevicePrice] as price
			ON detail.DeviceGuid = price.DeviceGuid
	     INNER JOIN [catalog].[Inventory] inventory
           ON detail.ProductId = inventory.ProductId
         LEFT JOIN onlineAvail
		   ON detail.DeviceGuid = onlineAvail.ProductGuid
		LEFT JOIN warehouseAvail
		   ON detail.DeviceGuid = warehouseAvail.ProductGuid
   WHERE detail.TypeId = 6  -- Tablets
     AND detail.Active = 1
	;