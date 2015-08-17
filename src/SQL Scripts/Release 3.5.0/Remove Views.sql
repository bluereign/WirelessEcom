
BEGIN TRY
    BEGIN TRANSACTION

---- START VIEW REMOVAL ----

USE CarToys

-- Object:  View [dbo].[v_KT_OrderItems]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_KT_OrderItems]'))
DROP VIEW [dbo].[v_KT_OrderItems]


-- Object:  View [dbo].[v_KT_Orders]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_KT_Orders]'))
DROP VIEW [dbo].[v_KT_Orders]


-- Object:  View [dbo].[vAllAttributesWithProductsAndGroups]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vAllAttributesWithProductsAndGroups]'))
DROP VIEW [dbo].[vAllAttributesWithProductsAndGroups]


-- Object:  View [dbo].[vAllAttributesWithProductsAndGroups2]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vAllAttributesWithProductsAndGroups2]'))
DROP VIEW [dbo].[vAllAttributesWithProductsAndGroups2]


-- Object:  View [dbo].[vAmazonProducts]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vAmazonProducts]'))
DROP VIEW [dbo].[vAmazonProducts]


-- Object:  View [dbo].[vAmazonProducts_old]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vAmazonProducts_old]'))
DROP VIEW [dbo].[vAmazonProducts_old]


-- Object:  View [dbo].[vAOL]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vAOL]'))
DROP VIEW [dbo].[vAOL]


-- Object:  View [dbo].[vBasketTotal]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vBasketTotal]'))
DROP VIEW [dbo].[vBasketTotal]


-- Object:  View [dbo].[vBizRate]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vBizRate]'))
DROP VIEW [dbo].[vBizRate]


-- Object:  View [dbo].[vBrands]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vBrands]'))
DROP VIEW [dbo].[vBrands]


-- Object:  View [dbo].[vBrands_with_Active_Products]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vBrands_with_Active_Products]'))
DROP VIEW [dbo].[vBrands_with_Active_Products]


-- Object:  View [dbo].[vCarModels]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vCarModels]'))
DROP VIEW [dbo].[vCarModels]


-- Object:  View [dbo].[vCatTree]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vCatTree]'))
DROP VIEW [dbo].[vCatTree]


-- Object:  View [dbo].[vEEStock]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vEEStock]'))
DROP VIEW [dbo].[vEEStock]


-- Object:  View [dbo].[VExport]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VExport]'))
DROP VIEW [dbo].[VExport]


-- Object:  View [dbo].[vExport_AR_TRN_IFACE]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vExport_AR_TRN_IFACE]'))
DROP VIEW [dbo].[vExport_AR_TRN_IFACE]


-- Object:  View [dbo].[vExport_AR_TRN_IFACE_2003_12_16]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vExport_AR_TRN_IFACE_2003_12_16]'))
DROP VIEW [dbo].[vExport_AR_TRN_IFACE_2003_12_16]


-- Object:  View [dbo].[vExport_CUST_IFACE]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vExport_CUST_IFACE]'))
DROP VIEW [dbo].[vExport_CUST_IFACE]


-- Object:  View [dbo].[vExport_CUST_IFACE_2003_12_16]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vExport_CUST_IFACE_2003_12_16]'))
DROP VIEW [dbo].[vExport_CUST_IFACE_2003_12_16]


-- Object:  View [dbo].[vExport_SO_CMNT_IFACE]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vExport_SO_CMNT_IFACE]'))
DROP VIEW [dbo].[vExport_SO_CMNT_IFACE]


-- Object:  View [dbo].[vExport_SO_CMNT_IFACE_2003_12_16]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vExport_SO_CMNT_IFACE_2003_12_16]'))
DROP VIEW [dbo].[vExport_SO_CMNT_IFACE_2003_12_16]


-- Object:  View [dbo].[vExport_SO_IFACE]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vExport_SO_IFACE]'))
DROP VIEW [dbo].[vExport_SO_IFACE]


-- Object:  View [dbo].[vExport_SO_IFACE_2003_12_16]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vExport_SO_IFACE_2003_12_16]'))
DROP VIEW [dbo].[vExport_SO_IFACE_2003_12_16]


-- Object:  View [dbo].[vExport_SO_LN_IFACE]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vExport_SO_LN_IFACE]'))
DROP VIEW [dbo].[vExport_SO_LN_IFACE]


-- Object:  View [dbo].[vExport_SO_LN_IFACE_2003_12_16]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vExport_SO_LN_IFACE_2003_12_16]'))
DROP VIEW [dbo].[vExport_SO_LN_IFACE_2003_12_16]


-- Object:  View [dbo].[vExport_SO_LN_IFACE_2004_04_01]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vExport_SO_LN_IFACE_2004_04_01]'))
DROP VIEW [dbo].[vExport_SO_LN_IFACE_2004_04_01]


-- Object:  View [dbo].[vExport_SO_LN_IFACE_2007_01_08]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vExport_SO_LN_IFACE_2007_01_08]'))
DROP VIEW [dbo].[vExport_SO_LN_IFACE_2007_01_08]


-- Object:  View [dbo].[vExport_SO_LN_IFACE_test]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vExport_SO_LN_IFACE_test]'))
DROP VIEW [dbo].[vExport_SO_LN_IFACE_test]


-- Object:  View [dbo].[vExport_TRN_IFace]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vExport_TRN_IFace]'))
DROP VIEW [dbo].[vExport_TRN_IFace]


-- Object:  View [dbo].[vExport_TRN_IFace_2003_12_16]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vExport_TRN_IFace_2003_12_16]'))
DROP VIEW [dbo].[vExport_TRN_IFace_2003_12_16]


-- Object:  View [dbo].[vFBAOrderDetailsToLoad]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vFBAOrderDetailsToLoad]'))
DROP VIEW [dbo].[vFBAOrderDetailsToLoad]


-- Object:  View [dbo].[vFBAOrdersToLoad]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vFBAOrdersToLoad]'))
DROP VIEW [dbo].[vFBAOrdersToLoad]


-- Object:  View [dbo].[vFroogle]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vFroogle]'))
DROP VIEW [dbo].[vFroogle]


-- Object:  View [dbo].[vGroupAttributes]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vGroupAttributes]'))
DROP VIEW [dbo].[vGroupAttributes]


-- Object:  View [dbo].[vGroupBrands]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vGroupBrands]'))
DROP VIEW [dbo].[vGroupBrands]


-- Object:  View [dbo].[vGroupFilters]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vGroupFilters]'))
DROP VIEW [dbo].[vGroupFilters]


-- Object:  View [dbo].[vMSN]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vMSN]'))
DROP VIEW [dbo].[vMSN]


-- Object:  View [dbo].[vMySimon]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vMySimon]'))
DROP VIEW [dbo].[vMySimon]


-- Object:  View [dbo].[vNextag]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vNextag]'))
DROP VIEW [dbo].[vNextag]


-- Object:  View [dbo].[vNonWirelessAccessories]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vNonWirelessAccessories]'))
DROP VIEW [dbo].[vNonWirelessAccessories]


-- Object:  View [dbo].[vOrders]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vOrders]'))
DROP VIEW [dbo].[vOrders]


-- Object:  View [dbo].[vOrders_2003_12_16]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vOrders_2003_12_16]'))
DROP VIEW [dbo].[vOrders_2003_12_16]


-- Object:  View [dbo].[vOrdersForUserByTopCat]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vOrdersForUserByTopCat]'))
DROP VIEW [dbo].[vOrdersForUserByTopCat]


-- Object:  View [dbo].[vOrdersFromAWtoGers]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vOrdersFromAWtoGers]'))
DROP VIEW [dbo].[vOrdersFromAWtoGers]


-- Object:  View [dbo].[vOrdersToAW]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vOrdersToAW]'))
DROP VIEW [dbo].[vOrdersToAW]


-- Object:  View [dbo].[vOrdersToGERS]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vOrdersToGERS]'))
DROP VIEW [dbo].[vOrdersToGERS]


-- Object:  View [dbo].[vOrdersToGERS_2003_12_16]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vOrdersToGERS_2003_12_16]'))
DROP VIEW [dbo].[vOrdersToGERS_2003_12_16]


-- Object:  View [dbo].[vOrdersToGERS_Change2004-2-17]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vOrdersToGERS_Change2004-2-17]'))
DROP VIEW [dbo].[vOrdersToGERS_Change2004-2-17]


-- Object:  View [dbo].[vOrdersToGERS_DirectShipOnly]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vOrdersToGERS_DirectShipOnly]'))
DROP VIEW [dbo].[vOrdersToGERS_DirectShipOnly]


-- Object:  View [dbo].[vOrdersToGERSAmazonTest]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vOrdersToGERSAmazonTest]'))
DROP VIEW [dbo].[vOrdersToGERSAmazonTest]


-- Object:  View [dbo].[vOrdersToGERSTest]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vOrdersToGERSTest]'))
DROP VIEW [dbo].[vOrdersToGERSTest]


-- Object:  View [dbo].[vPhones]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vPhones]'))
DROP VIEW [dbo].[vPhones]


-- Object:  View [dbo].[vPlans]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vPlans]'))
DROP VIEW [dbo].[vPlans]


-- Object:  View [dbo].[vPriceGrabber]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vPriceGrabber]'))
DROP VIEW [dbo].[vPriceGrabber]


-- Object:  View [dbo].[vProductAttributes]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vProductAttributes]'))
DROP VIEW [dbo].[vProductAttributes]


-- Object:  View [dbo].[vProductAttributesExtended]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vProductAttributesExtended]'))
DROP VIEW [dbo].[vProductAttributesExtended]


-- Object:  View [dbo].[vProductCar]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vProductCar]'))
DROP VIEW [dbo].[vProductCar]


-- Object:  View [dbo].[vProductPrices]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vProductPrices]'))
DROP VIEW [dbo].[vProductPrices]


-- Object:  View [dbo].[vProductPrices_12_29_2003]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vProductPrices_12_29_2003]'))
DROP VIEW [dbo].[vProductPrices_12_29_2003]


-- Object:  View [dbo].[vProductPrices_2003_12_26]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vProductPrices_2003_12_26]'))
DROP VIEW [dbo].[vProductPrices_2003_12_26]


-- Object:  View [dbo].[vProductPrices_2003_12_26_New_Column]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vProductPrices_2003_12_26_New_Column]'))
DROP VIEW [dbo].[vProductPrices_2003_12_26_New_Column]


-- Object:  View [dbo].[vProductPrices_all]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vProductPrices_all]'))
DROP VIEW [dbo].[vProductPrices_all]


-- Object:  View [dbo].[vProductPricesTEST]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vProductPricesTEST]'))
DROP VIEW [dbo].[vProductPricesTEST]


-- Object:  View [dbo].[vProductsForPortals]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vProductsForPortals]'))
DROP VIEW [dbo].[vProductsForPortals]


-- Object:  View [dbo].[vProductWireless]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vProductWireless]'))
DROP VIEW [dbo].[vProductWireless]


-- Object:  View [dbo].[vRebate]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vRebate]'))
DROP VIEW [dbo].[vRebate]


-- Object:  View [dbo].[vShoppingDotCom]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vShoppingDotCom]'))
DROP VIEW [dbo].[vShoppingDotCom]


-- Object:  View [dbo].[vSiteStability]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vSiteStability]'))
DROP VIEW [dbo].[vSiteStability]


-- Object:  View [dbo].[vStates_with_Stores]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vStates_with_Stores]'))
DROP VIEW [dbo].[vStates_with_Stores]


-- Object:  View [dbo].[vStoreInventoryTotalByPartnumber]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vStoreInventoryTotalByPartnumber]'))
DROP VIEW [dbo].[vStoreInventoryTotalByPartnumber]


-- Object:  View [dbo].[vStores]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vStores]'))
DROP VIEW [dbo].[vStores]


-- Object:  View [dbo].[vStoreStock]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vStoreStock]'))
DROP VIEW [dbo].[vStoreStock]


-- Object:  View [dbo].[vTopCatGroups]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vTopCatGroups]'))
DROP VIEW [dbo].[vTopCatGroups]


-- Object:  View [dbo].[vTopCatProducts]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vTopCatProducts]'))
DROP VIEW [dbo].[vTopCatProducts]


-- Object:  View [dbo].[vTotalStock]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vTotalStock]'))
DROP VIEW [dbo].[vTotalStock]


-- Object:  View [dbo].[vTrafficLeaderFeed-not used]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vTrafficLeaderFeed-not used]'))
DROP VIEW [dbo].[vTrafficLeaderFeed-not used]


-- Object:  View [dbo].[vTWInventoryByPartnumber]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vTWInventoryByPartnumber]'))
DROP VIEW [dbo].[vTWInventoryByPartnumber]


-- Object:  View [dbo].[vTWStock]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vTWStock]'))
DROP VIEW [dbo].[vTWStock]


-- Object:  View [dbo].[vwExpProdOrd]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vwExpProdOrd]'))
DROP VIEW [dbo].[vwExpProdOrd]


-- Object:  View [dbo].[vYahoo]    
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vYahoo]'))
DROP VIEW [dbo].[vYahoo]


COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
END CATCH
