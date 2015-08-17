


CREATE VIEW [catalog].[dn_Phones_all_NEW] 
AS
/******************************************************************************************
*
*  Object: dn_Phones_All
*  Schema: catalog
*
*  Example Call:

			  SELECT * FROM [catalog].[dn_Phones_All]

*  Purpose: Return phone detail information.

*
*  Date             User                Detail
*  ??/??/??         ??                  Initial coding.
*  3/25/2011		smuniyandi			After Modified this view, we had 25% of performance increased.
*  09/18/2014       scampbell           Refactor and reference to new table [catalog].[DeviceDetail]
*
*****************************************************************************************/


WITH upgradeRebateTotal( DeviceGuid, Price )
AS
(
  SELECT ProductGuid
       , CAST(RebateTotal AS money)
   FROM [catalog].vProductRebateTotal AS vprt WITH (nolock)
  WHERE RebateMode = 'U'
),
addALineRebateTotal( DeviceGuid, Price )
AS
(
   SELECT ProductGuid
        , CAST(RebateTotal AS money)
     FROM [catalog].vProductRebateTotal AS vprt WITH (nolock)
    WHERE (RebateMode = 'A')
)
SELECT device.DeviceGuid
     , device.DeviceGuid AS ProductGuid
	 , ISNULL(device.ProductId, 0) AS phoneId
	 , ISNULL(device.ProductId, 0) AS product_Id
	 , ISNULL(device.ProductId, 0) AS ProductID
	 , device.pageTitle
	 , device.summaryTitle
	 , device.detailTitle
	 , device.carrierId AS CarrierId
	 , device.carrierName
	 , null AS carrierLogoSmall
	 , null AS carrierLogoMedium
	 , null AS carrierLogoLarge 
	 , null AS manufacturerID
	 , null AS manufacturerName
	 , CONVERT(bit, ISNULL((SELECT 1
                              FROM [catalog].ProductTag
                              WHERE (Tag = 'warehouse') 
							    AND (ProductGuid = device.DeviceGuid)), 0)
			   ) AS bWarehouse
     , device.BFreeAccessory AS bFreeAccessory
	 , null AS smimage
     , 0 AS smimagewidth
	 , 0 AS smimageheight
	 , null AS stdimage
	 , 0 AS stdimagewidth
	 , 0 AS stdimageheight
	 , null AS lrgimage
	 , 0 AS lrgimagewidth
	 , 0 AS lrgimageheight
	 , '<span class="rebate-callout">%CarrierRebate1% %CarrierSkuRebate1%</span>' + device.SummaryDescription AS summaryDescription
	 , '<span class="rebate-callout">%CarrierRebate1% %CarrierRebate2% %CarrierSkuRebate1% %CarrierSkuRebate2%</span>' + device.DetailDescription AS detailDescription
	 , null AS metaKeywords
	 , null AS metaDescription
	 , device.prepaid AS prepaid
	 , device.typeId AS typeID
	 , price.RetailPrice AS price_retail
	 , price.NewPrice AS price_new
	 , ISNULL((SELECT RebateTotal
                 FROM [catalog].vProductRebateTotal AS vprt WITH (nolock)
                WHERE (ProductGuid = device.DeviceGuid) 
				  AND (RebateMode = 'N')
			   ), CAST(0 AS money)) AS new_rebateTotal
     , price.UpgradePrice AS price_upgrade
	 , upgradeRebateTotal.Price AS upgrade_rebateTotal
	 , price.AddALinePrice AS price_addaline
	 , addALineRebateTotal.Price AS addaline_rebateTotal
	 , device.UPC
	 , ISNULL(inventory.AvailableQty, 0) AS QtyOnHand
	 , device.Active
	 , device.DefaultSortRank
  FROM [catalog].[DeviceDetail] AS device
	   LEFT JOIN [catalog].[DevicePrice] as price
		ON device.DeviceGuid = price.DeviceGuid
       LEFT JOIN upgradeRebateTotal
	     ON device.DeviceGuid = upgradeRebateTotal.DeviceGuid
	   LEFT JOIN addALineRebateTotal
	     ON device.DeviceGuid = addALineRebateTotal.DeviceGuid
	   LEFT JOIN [catalog].[Inventory] inventory WITH (NOLOCK) 
         ON device.ProductId = inventory.ProductId
 WHERE device.TypeId = 1
;