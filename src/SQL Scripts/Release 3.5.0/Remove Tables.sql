BEGIN TRY
    BEGIN TRANSACTION

USE [CarToys]

---- START CONSTRAINT REMOVAL ----

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TestSIMS_Used]') AND type = 'D')
ALTER TABLE [service].[TestSIMS] DROP CONSTRAINT [DF_TestSIMS_Used]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__productre__produ__611D28B2]') AND parent_object_id = OBJECT_ID(N'[dbo].[productreview_DeleteLater]'))
ALTER TABLE [dbo].[productreview_DeleteLater] DROP CONSTRAINT [FK__productre__produ__611D28B2]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductKeywords_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductKeywords_DeleteLater]'))
ALTER TABLE [dbo].[ProductKeywords_DeleteLater] DROP CONSTRAINT [FK_ProductKeywords_Products]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrdTOPrds_PrdToPrdsTypes]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrdTOPrds _DeleteLater]'))
ALTER TABLE [dbo].[PrdTOPrds _DeleteLater] DROP CONSTRAINT [FK_PrdTOPrds_PrdToPrdsTypes]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrdTOPrds_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrdTOPrds _DeleteLater]'))
ALTER TABLE [dbo].[PrdTOPrds _DeleteLater] DROP CONSTRAINT [FK_PrdTOPrds_Products]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrdTOPrds_Products1]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrdTOPrds _DeleteLater]'))
ALTER TABLE [dbo].[PrdTOPrds _DeleteLater] DROP CONSTRAINT [FK_PrdTOPrds_Products1]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__PrdTOPrds__Prima__33F4B129]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PrdTOPrds _DeleteLater] DROP CONSTRAINT [DF__PrdTOPrds__Prima__33F4B129]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__PrdTOPrds__Secon__34E8D562]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PrdTOPrds _DeleteLater] DROP CONSTRAINT [DF__PrdTOPrds__Secon__34E8D562]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__PrdTOPrds__Type__36D11DD4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PrdTOPrds _DeleteLater] DROP CONSTRAINT [DF__PrdTOPrds__Type__36D11DD4]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PriceMatch_PriceMatchStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[PriceMatch _DeleteLater]'))
ALTER TABLE [dbo].[PriceMatch _DeleteLater] DROP CONSTRAINT [FK_PriceMatch_PriceMatchStatus]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PriceProducts_PriceGroups]') AND parent_object_id = OBJECT_ID(N'[dbo].[PriceProducts _DeleteLater]'))
ALTER TABLE [dbo].[PriceProducts _DeleteLater] DROP CONSTRAINT [FK_PriceProducts_PriceGroups]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PriceProducts_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[PriceProducts _DeleteLater]'))
ALTER TABLE [dbo].[PriceProducts _DeleteLater] DROP CONSTRAINT [FK_PriceProducts_Products]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProdToRebate_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProdToRebate _DeleteLater]'))
ALTER TABLE [dbo].[ProdToRebate _DeleteLater] DROP CONSTRAINT [FK_ProdToRebate_Products]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProdToRebate_Rebates]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProdToRebate _DeleteLater]'))
ALTER TABLE [dbo].[ProdToRebate _DeleteLater] DROP CONSTRAINT [FK_ProdToRebate_Rebates]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttributes_attributes]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttributes _DeleteLater]'))
ALTER TABLE [dbo].[ProductAttributes _DeleteLater] DROP CONSTRAINT [FK_ProductAttributes_attributes]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttributes_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttributes _DeleteLater]'))
ALTER TABLE [dbo].[ProductAttributes _DeleteLater] DROP CONSTRAINT [FK_ProductAttributes_Products]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductFeatures_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductFeatures_DeleteLater]'))
ALTER TABLE [dbo].[ProductFeatures_DeleteLater] DROP CONSTRAINT [FK_ProductFeatures_Products]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_productimages_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductImages_DeleteLater]'))
ALTER TABLE [dbo].[ProductImages_DeleteLater] DROP CONSTRAINT [FK_productimages_Products]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductOptions_Options]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductOptions_DeleteLater]'))
ALTER TABLE [dbo].[ProductOptions_DeleteLater] DROP CONSTRAINT [FK_ProductOptions_Options]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductOptions_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductOptions_DeleteLater]'))
ALTER TABLE [dbo].[ProductOptions_DeleteLater] DROP CONSTRAINT [FK_ProductOptions_Products]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__ProductOp__Opt_I__442B18F2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ProductOptions_DeleteLater] DROP CONSTRAINT [DF__ProductOp__Opt_I__442B18F2]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Products_Brands1]') AND parent_object_id = OBJECT_ID(N'[dbo].[Products_DeleteLater]'))
ALTER TABLE [dbo].[Products_DeleteLater] DROP CONSTRAINT [FK_Products_Brands1]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Products_carfitbox_values]') AND parent_object_id = OBJECT_ID(N'[dbo].[Products_DeleteLater]'))
ALTER TABLE [dbo].[Products_DeleteLater] DROP CONSTRAINT [FK_Products_carfitbox_values]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Products_ProductTypes]') AND parent_object_id = OBJECT_ID(N'[dbo].[Products_DeleteLater]'))
ALTER TABLE [dbo].[Products_DeleteLater] DROP CONSTRAINT [FK_Products_ProductTypes]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Products_Shippable_Types]') AND parent_object_id = OBJECT_ID(N'[dbo].[Products_DeleteLater]'))
ALTER TABLE [dbo].[Products_DeleteLater] DROP CONSTRAINT [FK_Products_Shippable_Types]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Products_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Products_DeleteLater] DROP CONSTRAINT [DF_Products_Active]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Products_Search]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Products_DeleteLater] DROP CONSTRAINT [DF_Products_Search]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Products_ignore_inventory]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Products_DeleteLater] DROP CONSTRAINT [DF_Products_ignore_inventory]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Products_promo_id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Products_DeleteLater] DROP CONSTRAINT [DF_Products_promo_id]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Products_BrandID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Products_DeleteLater] DROP CONSTRAINT [DF_Products_BrandID]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Products_ProductTypeID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Products_DeleteLater] DROP CONSTRAINT [DF_Products_ProductTypeID]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Products_StepUp_Product_id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Products_DeleteLater] DROP CONSTRAINT [DF_Products_StepUp_Product_id]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__products__new__11DF9047]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Products_DeleteLater] DROP CONSTRAINT [DF__products__new__11DF9047]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__products__shippa__2AAB3E11]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Products_DeleteLater] DROP CONSTRAINT [DF__products__shippa__2AAB3E11]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Products_CTGuy]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Products_DeleteLater] DROP CONSTRAINT [DF_Products_CTGuy]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Products_CTGuy1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Products_DeleteLater] DROP CONSTRAINT [DF_Products_CTGuy1]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductSpecials_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductSpecials_DeleteLater]'))
ALTER TABLE [dbo].[ProductSpecials_DeleteLater] DROP CONSTRAINT [FK_ProductSpecials_Products]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__ProductSp__Speci__1D114BD1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ProductSpecials_DeleteLater] DROP CONSTRAINT [DF__ProductSp__Speci__1D114BD1]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ProductSpecials_DoNotUpdate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ProductSpecials_DeleteLater] DROP CONSTRAINT [DF_ProductSpecials_DoNotUpdate]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductStock_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductStock_DeleteLater]'))
ALTER TABLE [dbo].[ProductStock_DeleteLater] DROP CONSTRAINT [FK_ProductStock_Products]


-- Object:  Table [dbo].[ProductStock_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductStock_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ProductStock_DeleteLater]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductToGroup_ObjectGroups]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductToGroup_DeleteLater]'))
ALTER TABLE [dbo].[ProductToGroup_DeleteLater] DROP CONSTRAINT [FK_ProductToGroup_ObjectGroups]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductToGroup_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductToGroup_DeleteLater]'))
ALTER TABLE [dbo].[ProductToGroup_DeleteLater] DROP CONSTRAINT [FK_ProductToGroup_Products]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderStatus_Orders]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderStatus _DeleteLater]'))
ALTER TABLE [dbo].[OrderStatus _DeleteLater] DROP CONSTRAINT [FK_OrderStatus_Orders]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderStatus_OrderStatusCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderStatus _DeleteLater]'))
ALTER TABLE [dbo].[OrderStatus _DeleteLater] DROP CONSTRAINT [FK_OrderStatus_OrderStatusCode]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__orderstat__activ__59E61B3E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OrderStatusCode _DeleteLater] DROP CONSTRAINT [DF__orderstat__activ__59E61B3E]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__orderstat__displ__5ADA3F77]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OrderStatusCode _DeleteLater] DROP CONSTRAINT [DF__orderstat__displ__5ADA3F77]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderWireless_DepositType]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderWireless _DeleteLater]'))
ALTER TABLE [dbo].[OrderWireless _DeleteLater] DROP CONSTRAINT [FK_OrderWireless_DepositType]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OrderWireless_FamilyPlan]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OrderWireless _DeleteLater] DROP CONSTRAINT [DF_OrderWireless_FamilyPlan]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OrderWireless_OW_Date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OrderWireless _DeleteLater] DROP CONSTRAINT [DF_OrderWireless_OW_Date]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderWirelessDetails_OrderWireless]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderWirelessDetails _DeleteLater]'))
ALTER TABLE [dbo].[OrderWirelessDetails _DeleteLater] DROP CONSTRAINT [FK_OrderWirelessDetails_OrderWireless]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OrderWirelessDetails_Removable]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OrderWirelessDetails _DeleteLater] DROP CONSTRAINT [DF_OrderWirelessDetails_Removable]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__PaymentMet__Sort__51851410]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMethods _DeleteLater] DROP CONSTRAINT [DF__PaymentMet__Sort__51851410]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__PaymentMe__Payme__52793849]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMethods _DeleteLater] DROP CONSTRAINT [DF__PaymentMe__Payme__52793849]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Payments_Orders]') AND parent_object_id = OBJECT_ID(N'[dbo].[Payments _DeleteLater]'))
ALTER TABLE [dbo].[Payments _DeleteLater] DROP CONSTRAINT [FK_Payments_Orders]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Payments_PaymentMethods]') AND parent_object_id = OBJECT_ID(N'[dbo].[Payments _DeleteLater]'))
ALTER TABLE [dbo].[Payments _DeleteLater] DROP CONSTRAINT [FK_Payments_PaymentMethods]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Permission_PermissionType_Permission]') AND parent_object_id = OBJECT_ID(N'[dbo].[Permission_PermissionType _DeleteLater]'))
ALTER TABLE [dbo].[Permission_PermissionType _DeleteLater] DROP CONSTRAINT [FK_Permission_PermissionType_Permission]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Permission_PermissionType_PermissionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[Permission_PermissionType _DeleteLater]'))
ALTER TABLE [dbo].[Permission_PermissionType _DeleteLater] DROP CONSTRAINT [FK_Permission_PermissionType_PermissionType]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PhoneOffers_NW_PhoneOffersTitle_NW]') AND parent_object_id = OBJECT_ID(N'[dbo].[PhoneOffers_NW _DeleteLater]'))
ALTER TABLE [dbo].[PhoneOffers_NW _DeleteLater] DROP CONSTRAINT [FK_PhoneOffers_NW_PhoneOffersTitle_NW]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PhoneOffers_NW_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[PhoneOffers_NW _DeleteLater]'))
ALTER TABLE [dbo].[PhoneOffers_NW _DeleteLater] DROP CONSTRAINT [FK_PhoneOffers_NW_Products]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PhoneOffersTitle_NW_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[PhoneOffersTitle_NW _DeleteLater]'))
ALTER TABLE [dbo].[PhoneOffersTitle_NW _DeleteLater] DROP CONSTRAINT [FK_PhoneOffersTitle_NW_Products]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PhoneOffersTitle_NW_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PhoneOffersTitle_NW _DeleteLater] DROP CONSTRAINT [DF_PhoneOffersTitle_NW_Active]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__showcase___showc__50E6C0E9]') AND parent_object_id = OBJECT_ID(N'[dbo].[showcase_comments_DeleteLater]'))
ALTER TABLE [dbo].[showcase_comments_DeleteLater] DROP CONSTRAINT [FK__showcase___showc__50E6C0E9]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__shiprate__shipme__4E3F5E68]') AND parent_object_id = OBJECT_ID(N'[dbo].[shiprate_DeleteLater]'))
ALTER TABLE [dbo].[shiprate_DeleteLater] DROP CONSTRAINT [FK__shiprate__shipme__4E3F5E68]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_shiprate_shipclassbracket]') AND parent_object_id = OBJECT_ID(N'[dbo].[shiprate_DeleteLater]'))
ALTER TABLE [dbo].[shiprate_DeleteLater] DROP CONSTRAINT [FK_shiprate_shipclassbracket]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_shipclass_universal]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[shipclass_DeleteLater] DROP CONSTRAINT [DF_shipclass_universal]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__shipclass__shipc__4B62F1BD]') AND parent_object_id = OBJECT_ID(N'[dbo].[shipclassbracket_DeleteLater]'))
ALTER TABLE [dbo].[shipclassbracket_DeleteLater] DROP CONSTRAINT [FK__shipclass__shipc__4B62F1BD]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Shipopts__Compan__5555A4F4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Shipopts_DeleteLater] DROP CONSTRAINT [DF__Shipopts__Compan__5555A4F4]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Shipopts__shipme__5649C92D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Shipopts_DeleteLater] DROP CONSTRAINT [DF__Shipopts__shipme__5649C92D]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Shipopts__flatfe__573DED66]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Shipopts_DeleteLater] DROP CONSTRAINT [DF__Shipopts__flatfe__573DED66]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Shipopts__ozfee__5832119F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Shipopts_DeleteLater] DROP CONSTRAINT [DF__Shipopts__ozfee__5832119F]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Shipopts__Matrix__592635D8]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Shipopts_DeleteLater] DROP CONSTRAINT [DF__Shipopts__Matrix__592635D8]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Shipopts__Countr__5A1A5A11]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Shipopts_DeleteLater] DROP CONSTRAINT [DF__Shipopts__Countr__5A1A5A11]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__shipclass__objec__48868512]') AND parent_object_id = OBJECT_ID(N'[dbo].[shipclass_criterion_DeleteLater]'))
ALTER TABLE [dbo].[shipclass_criterion_DeleteLater] DROP CONSTRAINT [FK__shipclass__objec__48868512]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__shipclass__produ__479260D9]') AND parent_object_id = OBJECT_ID(N'[dbo].[shipclass_criterion_DeleteLater]'))
ALTER TABLE [dbo].[shipclass_criterion_DeleteLater] DROP CONSTRAINT [FK__shipclass__produ__479260D9]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__shipclass__shipc__469E3CA0]') AND parent_object_id = OBJECT_ID(N'[dbo].[shipclass_criterion_DeleteLater]'))
ALTER TABLE [dbo].[shipclass_criterion_DeleteLater] DROP CONSTRAINT [FK__shipclass__shipc__469E3CA0]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SearchTerms_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SearchTerms_DeleteLater] DROP CONSTRAINT [DF_SearchTerms_CreateDate]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SaleItem_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[SaleItem_DeleteLater]'))
ALTER TABLE [dbo].[SaleItem_DeleteLater] DROP CONSTRAINT [FK_SaleItem_Products]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SaleItem_Sale]') AND parent_object_id = OBJECT_ID(N'[dbo].[SaleItem_DeleteLater]'))
ALTER TABLE [dbo].[SaleItem_DeleteLater] DROP CONSTRAINT [FK_SaleItem_Sale]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SaleItem_Actv]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SaleItem_DeleteLater] DROP CONSTRAINT [DF_SaleItem_Actv]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SaleItem_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SaleItem_DeleteLater] DROP CONSTRAINT [DF_SaleItem_CreateDate]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SaleItem_CreateBy]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SaleItem_DeleteLater] DROP CONSTRAINT [DF_SaleItem_CreateBy]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_userstores_Stores]') AND parent_object_id = OBJECT_ID(N'[dbo].[userstores_DeleteLater]'))
ALTER TABLE [dbo].[userstores_DeleteLater] DROP CONSTRAINT [FK_userstores_Stores]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_userstores_defaultstore]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[userstores_DeleteLater] DROP CONSTRAINT [DF_userstores_defaultstore]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_usercars_default]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[usercars_DeleteLater] DROP CONSTRAINT [DF_usercars_default]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tmpOrderWirelessDetails_Removable]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tmpOrderWirelessDetails_DeleteLater] DROP CONSTRAINT [DF_tmpOrderWirelessDetails_Removable]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tmpOrderDetails_Order_ID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tmpOrderDetails_DeleteLater] DROP CONSTRAINT [DF_tmpOrderDetails_Order_ID]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tmpOrderDetails_Taxable]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tmpOrderDetails_DeleteLater] DROP CONSTRAINT [DF_tmpOrderDetails_Taxable]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tmpOrderDetails_ExtPrice]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tmpOrderDetails_DeleteLater] DROP CONSTRAINT [DF_tmpOrderDetails_ExtPrice]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tmpOrderDetails_TotalWeight]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tmpOrderDetails_DeleteLater] DROP CONSTRAINT [DF_tmpOrderDetails_TotalWeight]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tmpOrderDetails_ow_type]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tmpOrderDetails_DeleteLater] DROP CONSTRAINT [DF_tmpOrderDetails_ow_type]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tmpOrderDetails_UpdatedInAmazon]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tmpOrderDetails_DeleteLater] DROP CONSTRAINT [DF_tmpOrderDetails_UpdatedInAmazon]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TemplateWizards_Protect]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TemplateWizards_DeleteLater] DROP CONSTRAINT [DF_TemplateWizards_Protect]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Store_Inventory_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Store_Inventory_DeleteLater] DROP CONSTRAINT [DF_Store_Inventory_CreateDate]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Special_Discounts_required_type_flag_values]') AND parent_object_id = OBJECT_ID(N'[dbo].[Special_Discounts_DeleteLater]'))
ALTER TABLE [dbo].[Special_Discounts_DeleteLater] DROP CONSTRAINT [FK_Special_Discounts_required_type_flag_values]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShowcaseProducts_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShowcaseProducts_DeleteLater]'))
ALTER TABLE [dbo].[ShowcaseProducts_DeleteLater] DROP CONSTRAINT [FK_ShowcaseProducts_Products]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShowcaseProducts_Showcase]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShowcaseProducts_DeleteLater]'))
ALTER TABLE [dbo].[ShowcaseProducts_DeleteLater] DROP CONSTRAINT [FK_ShowcaseProducts_Showcase]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ShowcaseProducts_Pos]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShowcaseProducts_DeleteLater] DROP CONSTRAINT [DF_ShowcaseProducts_Pos]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__showcase__showca__3DD3EC75]') AND parent_object_id = OBJECT_ID(N'[dbo].[Showcase_DeleteLater]'))
ALTER TABLE [dbo].[Showcase_DeleteLater] DROP CONSTRAINT [FK__showcase__showca__3DD3EC75]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Showcase_Stores]') AND parent_object_id = OBJECT_ID(N'[dbo].[Showcase_DeleteLater]'))
ALTER TABLE [dbo].[Showcase_DeleteLater] DROP CONSTRAINT [FK_Showcase_Stores]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Showcase_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Showcase_DeleteLater] DROP CONSTRAINT [DF_Showcase_Active]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Showcase_Active1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Showcase_DeleteLater] DROP CONSTRAINT [DF_Showcase_Active1]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Showcase_MakeI]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Showcase_DeleteLater] DROP CONSTRAINT [DF_Showcase_MakeI]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ObjectGroups_Categories]') AND parent_object_id = OBJECT_ID(N'[dbo].[ObjectGroups _DeleteLater]'))
ALTER TABLE [dbo].[ObjectGroups _DeleteLater] DROP CONSTRAINT [FK_ObjectGroups_Categories]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ObjectGroups_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ObjectGroups _DeleteLater] DROP CONSTRAINT [DF_ObjectGroups_Active]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ObjectGroups_GroupPageOptions]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ObjectGroups _DeleteLater] DROP CONSTRAINT [DF_ObjectGroups_GroupPageOptions]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_objectgroups_to_amazon_producttypes_ObjectGroups]') AND parent_object_id = OBJECT_ID(N'[dbo].[Objectgroups_to_Amazon_Producttypes _DeleteLater]'))
ALTER TABLE [dbo].[Objectgroups_to_Amazon_Producttypes _DeleteLater] DROP CONSTRAINT [FK_objectgroups_to_amazon_producttypes_ObjectGroups]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__order_ter__order__172433A8]') AND parent_object_id = OBJECT_ID(N'[dbo].[order_term _DeleteLater]'))
ALTER TABLE [dbo].[order_term _DeleteLater] DROP CONSTRAINT [FK__order_ter__order__172433A8]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__order_ter__term___181857E1]') AND parent_object_id = OBJECT_ID(N'[dbo].[order_term _DeleteLater]'))
ALTER TABLE [dbo].[order_term _DeleteLater] DROP CONSTRAINT [FK__order_ter__term___181857E1]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__order_vie__order__58BCECDB]') AND parent_object_id = OBJECT_ID(N'[dbo].[order_view _DeleteLater]'))
ALTER TABLE [dbo].[order_view _DeleteLater] DROP CONSTRAINT [FK__order_vie__order__58BCECDB]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderAttributes_Orders]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderAttributes _DeleteLater]'))
ALTER TABLE [dbo].[OrderAttributes _DeleteLater] DROP CONSTRAINT [FK_OrderAttributes_Orders]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrdersToRebates_Orders]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrdersToRebates _DeleteLater]'))
ALTER TABLE [dbo].[OrdersToRebates _DeleteLater] DROP CONSTRAINT [FK_OrdersToRebates_Orders]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrdersToRebates_Rebates]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrdersToRebates _DeleteLater]'))
ALTER TABLE [dbo].[OrdersToRebates _DeleteLater] DROP CONSTRAINT [FK_OrdersToRebates_Rebates]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrdersToSessions_Orders]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrdersToSessions _DeleteLater]'))
ALTER TABLE [dbo].[OrdersToSessions _DeleteLater] DROP CONSTRAINT [FK_OrdersToSessions_Orders]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Orders_OrderStatusCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[Orders _DeleteLater]'))
ALTER TABLE [dbo].[Orders _DeleteLater] DROP CONSTRAINT [FK_Orders_OrderStatusCode]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Orders_ship_types]') AND parent_object_id = OBJECT_ID(N'[dbo].[Orders _DeleteLater]'))
ALTER TABLE [dbo].[Orders _DeleteLater] DROP CONSTRAINT [FK_Orders_ship_types]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Orders_ShipMethods]') AND parent_object_id = OBJECT_ID(N'[dbo].[Orders _DeleteLater]'))
ALTER TABLE [dbo].[Orders _DeleteLater] DROP CONSTRAINT [FK_Orders_ShipMethods]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Orders_Stores]') AND parent_object_id = OBJECT_ID(N'[dbo].[Orders _DeleteLater]'))
ALTER TABLE [dbo].[Orders _DeleteLater] DROP CONSTRAINT [FK_Orders_Stores]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Orders__Company___4AD81681]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Orders _DeleteLater] DROP CONSTRAINT [DF__Orders__Company___4AD81681]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Orders__SameAsUs__4CC05EF3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Orders _DeleteLater] DROP CONSTRAINT [DF__Orders__SameAsUs__4CC05EF3]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Orders__Processe__4DB4832C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Orders _DeleteLater] DROP CONSTRAINT [DF__Orders__Processe__4DB4832C]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Orders__Status__4EA8A765]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Orders _DeleteLater] DROP CONSTRAINT [DF__Orders__Status__4EA8A765]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Orders_exported]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Orders _DeleteLater] DROP CONSTRAINT [DF_Orders_exported]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Orders_Split_Order_Id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Orders _DeleteLater] DROP CONSTRAINT [DF_Orders_Split_Order_Id]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Orders_OrderType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Orders _DeleteLater] DROP CONSTRAINT [DF_Orders_OrderType]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__orders__STORE_ID__29CC2871]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Orders _DeleteLater] DROP CONSTRAINT [DF__orders__STORE_ID__29CC2871]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Orders_ship_type]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Orders _DeleteLater] DROP CONSTRAINT [DF_Orders_ship_type]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Orders_costatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Orders _DeleteLater] DROP CONSTRAINT [DF_Orders_costatus]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Orders_SentToGERS]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Orders _DeleteLater] DROP CONSTRAINT [DF_Orders_SentToGERS]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderDetails_Orders]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderDetails _DeleteLater]'))
ALTER TABLE [dbo].[OrderDetails _DeleteLater] DROP CONSTRAINT [FK_OrderDetails_Orders]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderDetails_OrderStatusCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderDetails _DeleteLater]'))
ALTER TABLE [dbo].[OrderDetails _DeleteLater] DROP CONSTRAINT [FK_OrderDetails_OrderStatusCode]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderDetails_OrderWireless]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderDetails _DeleteLater]'))
ALTER TABLE [dbo].[OrderDetails _DeleteLater] DROP CONSTRAINT [FK_OrderDetails_OrderWireless]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderDetails_ow_types]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderDetails _DeleteLater]'))
ALTER TABLE [dbo].[OrderDetails _DeleteLater] DROP CONSTRAINT [FK_OrderDetails_ow_types]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__OrderDeta__Order__5CF6C6BC]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OrderDetails _DeleteLater] DROP CONSTRAINT [DF__OrderDeta__Order__5CF6C6BC]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OrderDetails_Taxable]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OrderDetails _DeleteLater] DROP CONSTRAINT [DF_OrderDetails_Taxable]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__OrderDeta__ExtPr__6497E884]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OrderDetails _DeleteLater] DROP CONSTRAINT [DF__OrderDeta__ExtPr__6497E884]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__OrderDeta__Total__658C0CBD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OrderDetails _DeleteLater] DROP CONSTRAINT [DF__OrderDeta__Total__658C0CBD]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__orderdeta__ow_ty__2062B9C8]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OrderDetails _DeleteLater] DROP CONSTRAINT [DF__orderdeta__ow_ty__2062B9C8]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OrderDetails_UpdatedInAmazon]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OrderDetails _DeleteLater] DROP CONSTRAINT [DF_OrderDetails_UpdatedInAmazon]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderDetailStatus_OrderDetails]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderDetailStatus _DeleteLater]'))
ALTER TABLE [dbo].[OrderDetailStatus _DeleteLater] DROP CONSTRAINT [FK_OrderDetailStatus_OrderDetails]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OrderDetailStatus_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OrderDetailStatus _DeleteLater] DROP CONSTRAINT [DF_OrderDetailStatus_DateCreated]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__orderdeta__order__2260DC2A]') AND parent_object_id = OBJECT_ID(N'[dbo].[orderdetail_vehicle _DeleteLater]'))
ALTER TABLE [dbo].[orderdetail_vehicle _DeleteLater] DROP CONSTRAINT [FK__orderdeta__order__2260DC2A]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_orderdetail_vehicle_OrderDetails]') AND parent_object_id = OBJECT_ID(N'[dbo].[orderdetail_vehicle _DeleteLater]'))
ALTER TABLE [dbo].[orderdetail_vehicle _DeleteLater] DROP CONSTRAINT [FK_orderdetail_vehicle_OrderDetails]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__orderbund__order__49E4BD9F]') AND parent_object_id = OBJECT_ID(N'[dbo].[orderbundle _DeleteLater]'))
ALTER TABLE [dbo].[orderbundle _DeleteLater] DROP CONSTRAINT [FK__orderbund__order__49E4BD9F]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__orderbund__relat__4BCD0611]') AND parent_object_id = OBJECT_ID(N'[dbo].[orderbundle _DeleteLater]'))
ALTER TABLE [dbo].[orderbundle _DeleteLater] DROP CONSTRAINT [FK__orderbund__relat__4BCD0611]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_orderbundle_OrderDetails]') AND parent_object_id = OBJECT_ID(N'[dbo].[orderbundle _DeleteLater]'))
ALTER TABLE [dbo].[orderbundle _DeleteLater] DROP CONSTRAINT [FK_orderbundle_OrderDetails]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_orderbundle_roleinbundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[orderbundle _DeleteLater]'))
ALTER TABLE [dbo].[orderbundle _DeleteLater] DROP CONSTRAINT [FK_orderbundle_roleinbundle]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderComments_Orders]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderComments _DeleteLater]'))
ALTER TABLE [dbo].[OrderComments _DeleteLater] DROP CONSTRAINT [FK_OrderComments_Orders]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MarketplaceProductPriceSale_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[MarketplaceProductPriceSale _DeleteLater]'))
ALTER TABLE [dbo].[MarketplaceProductPriceSale _DeleteLater] DROP CONSTRAINT [FK_MarketplaceProductPriceSale_Products]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MarketplaceProductShippingOverride_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[MarketplaceProductShippingOverride _DeleteLater]'))
ALTER TABLE [dbo].[MarketplaceProductShippingOverride _DeleteLater] DROP CONSTRAINT [FK_MarketplaceProductShippingOverride_Products]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Mercent_O__Ackno__5911F296]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Mercent_OrderDetails _DeleteLater] DROP CONSTRAINT [DF__Mercent_O__Ackno__5911F296]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Mercent_O__Updat__5A0616CF]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Mercent_OrderDetails _DeleteLater] DROP CONSTRAINT [DF__Mercent_O__Updat__5A0616CF]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Mercent_O__Ackno__563585EB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Mercent_Orders _DeleteLater] DROP CONSTRAINT [DF__Mercent_O__Ackno__563585EB]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Mercent_O__Updat__5729AA24]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Mercent_Orders _DeleteLater] DROP CONSTRAINT [DF__Mercent_O__Updat__5729AA24]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__ObjectGro__objec__6DB809C1]') AND parent_object_id = OBJECT_ID(N'[dbo].[ObjectGroup_Accessory _DeleteLater]'))
ALTER TABLE [dbo].[ObjectGroup_Accessory _DeleteLater] DROP CONSTRAINT [FK__ObjectGro__objec__6DB809C1]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__ObjectGro__produ__6EAC2DFA]') AND parent_object_id = OBJECT_ID(N'[dbo].[ObjectGroup_Accessory _DeleteLater]'))
ALTER TABLE [dbo].[ObjectGroup_Accessory _DeleteLater] DROP CONSTRAINT [FK__ObjectGro__produ__6EAC2DFA]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_FTPConfig_DeleteFiles]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[FTPConfig _DeleteLater] DROP CONSTRAINT [DF_FTPConfig_DeleteFiles]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Group_Permissions_Groups]') AND parent_object_id = OBJECT_ID(N'[dbo].[Group_Permission _DeleteLater]'))
ALTER TABLE [dbo].[Group_Permission _DeleteLater] DROP CONSTRAINT [FK_Group_Permissions_Groups]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Group_Permissions_Permissions]') AND parent_object_id = OBJECT_ID(N'[dbo].[Group_Permission _DeleteLater]'))
ALTER TABLE [dbo].[Group_Permission _DeleteLater] DROP CONSTRAINT [FK_Group_Permissions_Permissions]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GroupFilter_Values_GroupFilters1]') AND parent_object_id = OBJECT_ID(N'[dbo].[GroupFilter_Values _DeleteLater]'))
ALTER TABLE [dbo].[GroupFilter_Values _DeleteLater] DROP CONSTRAINT [FK_GroupFilter_Values_GroupFilters1]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Host_IP_Addr_Exclude]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Host_IP_Addr _DeleteLater] DROP CONSTRAINT [DF_Host_IP_Addr_Exclude]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MarketplaceProductPrice_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[MarketplaceProductPrice _DeleteLater]'))
ALTER TABLE [dbo].[MarketplaceProductPrice _DeleteLater] DROP CONSTRAINT [FK_MarketplaceProductPrice_Products]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MarketplaceProductPrice_BizRatePromotionalDesignation]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MarketplaceProductPrice _DeleteLater] DROP CONSTRAINT [DF_MarketplaceProductPrice_BizRatePromotionalDesignation]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__esn__product_id__7CFA4D51]') AND parent_object_id = OBJECT_ID(N'[dbo].[esp _DeleteLater]'))
ALTER TABLE [dbo].[esp _DeleteLater] DROP CONSTRAINT [FK__esn__product_id__7CFA4D51]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__esp__esp_class_c__058F9352]') AND parent_object_id = OBJECT_ID(N'[dbo].[esp _DeleteLater]'))
ALTER TABLE [dbo].[esp _DeleteLater] DROP CONSTRAINT [FK__esp__esp_class_c__058F9352]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__FeaturedP__brand__037FEF18]') AND parent_object_id = OBJECT_ID(N'[dbo].[FeaturedProducts _DeleteLater]'))
ALTER TABLE [dbo].[FeaturedProducts _DeleteLater] DROP CONSTRAINT [FK__FeaturedP__brand__037FEF18]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__FeaturedP__brand__0B6B29A3]') AND parent_object_id = OBJECT_ID(N'[dbo].[FeaturedProducts _DeleteLater]'))
ALTER TABLE [dbo].[FeaturedProducts _DeleteLater] DROP CONSTRAINT [FK__FeaturedP__brand__0B6B29A3]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__FeaturedP__brand__1356642E]') AND parent_object_id = OBJECT_ID(N'[dbo].[FeaturedProducts _DeleteLater]'))
ALTER TABLE [dbo].[FeaturedProducts _DeleteLater] DROP CONSTRAINT [FK__FeaturedP__brand__1356642E]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__FeaturedP__brand__1C35C2F2]') AND parent_object_id = OBJECT_ID(N'[dbo].[FeaturedProducts _DeleteLater]'))
ALTER TABLE [dbo].[FeaturedProducts _DeleteLater] DROP CONSTRAINT [FK__FeaturedP__brand__1C35C2F2]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__FeaturedP__brand__27F18E61]') AND parent_object_id = OBJECT_ID(N'[dbo].[FeaturedProducts _DeleteLater]'))
ALTER TABLE [dbo].[FeaturedProducts _DeleteLater] DROP CONSTRAINT [FK__FeaturedP__brand__27F18E61]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__featuredp__brand__7212AA8A]') AND parent_object_id = OBJECT_ID(N'[dbo].[FeaturedProducts _DeleteLater]'))
ALTER TABLE [dbo].[FeaturedProducts _DeleteLater] DROP CONSTRAINT [FK__featuredp__brand__7212AA8A]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__FeaturedP__brand__7B94B48D]') AND parent_object_id = OBJECT_ID(N'[dbo].[FeaturedProducts _DeleteLater]'))
ALTER TABLE [dbo].[FeaturedProducts _DeleteLater] DROP CONSTRAINT [FK__FeaturedP__brand__7B94B48D]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_FeaturedProducts_Categories]') AND parent_object_id = OBJECT_ID(N'[dbo].[FeaturedProducts _DeleteLater]'))
ALTER TABLE [dbo].[FeaturedProducts _DeleteLater] DROP CONSTRAINT [FK_FeaturedProducts_Categories]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_FeaturedProducts_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[FeaturedProducts _DeleteLater]'))
ALTER TABLE [dbo].[FeaturedProducts _DeleteLater] DROP CONSTRAINT [FK_FeaturedProducts_Products]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_FeaturedProducts_FeatureType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[FeaturedProducts _DeleteLater] DROP CONSTRAINT [DF_FeaturedProducts_FeatureType]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_FeaturedProducts_Topcat_ID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[FeaturedProducts _DeleteLater] DROP CONSTRAINT [DF_FeaturedProducts_Topcat_ID]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_FeaturedProducts_Category_ID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[FeaturedProducts _DeleteLater] DROP CONSTRAINT [DF_FeaturedProducts_Category_ID]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_FeaturedProducts_ObjectGroup_ID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[FeaturedProducts _DeleteLater] DROP CONSTRAINT [DF_FeaturedProducts_ObjectGroup_ID]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_FeaturedProducts_WebPage_IDs]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[FeaturedProducts _DeleteLater] DROP CONSTRAINT [DF_FeaturedProducts_WebPage_IDs]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Categories_TopCategories]') AND parent_object_id = OBJECT_ID(N'[dbo].[Categories _DeleteLater]'))
ALTER TABLE [dbo].[Categories _DeleteLater] DROP CONSTRAINT [FK_Categories_TopCategories]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__CPS_Stati__activ__1446FBA6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CPS_Static _DeleteLater] DROP CONSTRAINT [DF__CPS_Stati__activ__1446FBA6]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_detailedaddress_Orders]') AND parent_object_id = OBJECT_ID(N'[dbo].[detailedaddress _DeleteLater]'))
ALTER TABLE [dbo].[detailedaddress _DeleteLater] DROP CONSTRAINT [FK_detailedaddress_Orders]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_email_history_Email_body]') AND parent_object_id = OBJECT_ID(N'[dbo].[email_history _DeleteLater]'))
ALTER TABLE [dbo].[email_history _DeleteLater] DROP CONSTRAINT [FK_email_history_Email_body]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_email_history_Orders]') AND parent_object_id = OBJECT_ID(N'[dbo].[email_history _DeleteLater]'))
ALTER TABLE [dbo].[email_history _DeleteLater] DROP CONSTRAINT [FK_email_history_Orders]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_email_queue_Email_body]') AND parent_object_id = OBJECT_ID(N'[dbo].[email_queue _DeleteLater]'))
ALTER TABLE [dbo].[email_queue _DeleteLater] DROP CONSTRAINT [FK_email_queue_Email_body]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_EmailSubscription_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmailSubscription _DeleteLater] DROP CONSTRAINT [DF_EmailSubscription_Active]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_EmailSubscription_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmailSubscription _DeleteLater] DROP CONSTRAINT [DF_EmailSubscription_CreateDate]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_EmailSubscription_GPS]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmailSubscription _DeleteLater] DROP CONSTRAINT [DF_EmailSubscription_GPS]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_EmailSubscription_Audio]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmailSubscription _DeleteLater] DROP CONSTRAINT [DF_EmailSubscription_Audio]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_EmailSubscription_DVD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmailSubscription _DeleteLater] DROP CONSTRAINT [DF_EmailSubscription_DVD]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_EmailSubscription_Security]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmailSubscription _DeleteLater] DROP CONSTRAINT [DF_EmailSubscription_Security]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_EmailSubscription_Satellite]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmailSubscription _DeleteLater] DROP CONSTRAINT [DF_EmailSubscription_Satellite]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_EmailSubscription_Radar]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmailSubscription _DeleteLater] DROP CONSTRAINT [DF_EmailSubscription_Radar]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_EmailSubscription_Other]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmailSubscription _DeleteLater] DROP CONSTRAINT [DF_EmailSubscription_Other]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_EmailSubscription_Wireless]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmailSubscription _DeleteLater] DROP CONSTRAINT [DF_EmailSubscription_Wireless]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_EmailSubscription_Verizon]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmailSubscription _DeleteLater] DROP CONSTRAINT [DF_EmailSubscription_Verizon]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_EmailSubscription_Cingular]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmailSubscription _DeleteLater] DROP CONSTRAINT [DF_EmailSubscription_Cingular]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_EmailSubscription_TMobile]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmailSubscription _DeleteLater] DROP CONSTRAINT [DF_EmailSubscription_TMobile]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserGroups_Groups]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserGroups]'))
ALTER TABLE [dbo].[UserGroups] DROP CONSTRAINT [FK_UserGroups_Groups]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserPromotion_PromotionCodes]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserPromotion]'))
ALTER TABLE [dbo].[UserPromotion] DROP CONSTRAINT [FK_UserPromotion_PromotionCodes]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WirelessActivation_OrderDetails]') AND parent_object_id = OBJECT_ID(N'[dbo].[WirelessActivation]'))
ALTER TABLE [dbo].[WirelessActivation] DROP CONSTRAINT [FK_WirelessActivation_OrderDetails]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Category__Active__6D36E434]') AND type = 'D')
BEGIN
ALTER TABLE [admin].[Category] DROP CONSTRAINT [DF__Category__Active__6D36E434]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_attributes_Attribute_Type]') AND parent_object_id = OBJECT_ID(N'[dbo].[attributes _DeleteLater]'))
ALTER TABLE [dbo].[attributes _DeleteLater] DROP CONSTRAINT [FK_attributes_Attribute_Type]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__attributes__type__0FC23DAB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[attributes _DeleteLater] DROP CONSTRAINT [DF__attributes__type__0FC23DAB]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_StdOut_CreateTime]') AND type = 'D')
BEGIN
ALTER TABLE [test].[StdOut_DeleteLater] DROP CONSTRAINT [DF_StdOut_CreateTime]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__weblink_b__order__1A35AA7D]') AND parent_object_id = OBJECT_ID(N'[dbo].[weblink_batch_contents_DeleteLater]'))
ALTER TABLE [dbo].[weblink_batch_contents_DeleteLater] DROP CONSTRAINT [FK__weblink_b__order__1A35AA7D]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__weblink_b__webli__19418644]') AND parent_object_id = OBJECT_ID(N'[dbo].[weblink_batch_contents_DeleteLater]'))
ALTER TABLE [dbo].[weblink_batch_contents_DeleteLater] DROP CONSTRAINT [FK__weblink_b__webli__19418644]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__weblink_b__webli__525D94D0]') AND parent_object_id = OBJECT_ID(N'[dbo].[weblink_batch_contents_DeleteLater]'))
ALTER TABLE [dbo].[weblink_batch_contents_DeleteLater] DROP CONSTRAINT [FK__weblink_b__webli__525D94D0]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__weblink_b__webli__5A48CF5B]') AND parent_object_id = OBJECT_ID(N'[dbo].[weblink_batch_contents_DeleteLater]'))
ALTER TABLE [dbo].[weblink_batch_contents_DeleteLater] DROP CONSTRAINT [FK__weblink_b__webli__5A48CF5B]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__weblink_b__webli__623409E6]') AND parent_object_id = OBJECT_ID(N'[dbo].[weblink_batch_contents_DeleteLater]'))
ALTER TABLE [dbo].[weblink_batch_contents_DeleteLater] DROP CONSTRAINT [FK__weblink_b__webli__623409E6]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__weblink_b__webli__6A1F4471]') AND parent_object_id = OBJECT_ID(N'[dbo].[weblink_batch_contents_DeleteLater]'))
ALTER TABLE [dbo].[weblink_batch_contents_DeleteLater] DROP CONSTRAINT [FK__weblink_b__webli__6A1F4471]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__weblink_b__webli__72FEA335]') AND parent_object_id = OBJECT_ID(N'[dbo].[weblink_batch_contents_DeleteLater]'))
ALTER TABLE [dbo].[weblink_batch_contents_DeleteLater] DROP CONSTRAINT [FK__weblink_b__webli__72FEA335]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__weblink_b__webli__7EBA6EA4]') AND parent_object_id = OBJECT_ID(N'[dbo].[weblink_batch_contents_DeleteLater]'))
ALTER TABLE [dbo].[weblink_batch_contents_DeleteLater] DROP CONSTRAINT [FK__weblink_b__webli__7EBA6EA4]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cpPhoneToProd_cpPhones]') AND parent_object_id = OBJECT_ID(N'[dbo].[cpPhoneToProd _DeleteLater]'))
ALTER TABLE [dbo].[cpPhoneToProd _DeleteLater] DROP CONSTRAINT [FK_cpPhoneToProd_cpPhones]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cpPhoneToProd_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[cpPhoneToProd _DeleteLater]'))
ALTER TABLE [dbo].[cpPhoneToProd _DeleteLater] DROP CONSTRAINT [FK_cpPhoneToProd_Products]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cpPhoneToUser_cpPhones]') AND parent_object_id = OBJECT_ID(N'[dbo].[cpPhoneToUser _DeleteLater]'))
ALTER TABLE [dbo].[cpPhoneToUser _DeleteLater] DROP CONSTRAINT [FK_cpPhoneToUser_cpPhones]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__CPS_ARTIC__CPS_A__116A8EFB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CPS_ARTICLES _DeleteLater] DROP CONSTRAINT [DF__CPS_ARTIC__CPS_A__116A8EFB]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__CPS_PAGES__CPS_P__0CA5D9DE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CPS_PAGES _DeleteLater] DROP CONSTRAINT [DF__CPS_PAGES__CPS_P__0CA5D9DE]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Amazon_OrderFulfillmentItem_Amazon_OrderFulfillment]') AND parent_object_id = OBJECT_ID(N'[dbo].[Amazon_OrderFulfillmentItem _DeleteLater]'))
ALTER TABLE [dbo].[Amazon_OrderFulfillmentItem _DeleteLater] DROP CONSTRAINT [FK_Amazon_OrderFulfillmentItem_Amazon_OrderFulfillment]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_amazon_products_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[amazon_products _DeleteLater]'))
ALTER TABLE [dbo].[amazon_products _DeleteLater] DROP CONSTRAINT [FK_amazon_products_Products]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Attribute_Category_attributes]') AND parent_object_id = OBJECT_ID(N'[dbo].[Attribute_Category _DeleteLater]'))
ALTER TABLE [dbo].[Attribute_Category _DeleteLater] DROP CONSTRAINT [FK_Attribute_Category_attributes]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Attribute_Category_Categories]') AND parent_object_id = OBJECT_ID(N'[dbo].[Attribute_Category _DeleteLater]'))
ALTER TABLE [dbo].[Attribute_Category _DeleteLater] DROP CONSTRAINT [FK_Attribute_Category_Categories]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Attribute_ObjectGroup_attributes]') AND parent_object_id = OBJECT_ID(N'[dbo].[Attribute_ObjectGroup _DeleteLater]'))
ALTER TABLE [dbo].[Attribute_ObjectGroup _DeleteLater] DROP CONSTRAINT [FK_Attribute_ObjectGroup_attributes]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Attribute_ObjectGroup_ObjectGroups]') AND parent_object_id = OBJECT_ID(N'[dbo].[Attribute_ObjectGroup _DeleteLater]'))
ALTER TABLE [dbo].[Attribute_ObjectGroup _DeleteLater] DROP CONSTRAINT [FK_Attribute_ObjectGroup_ObjectGroups]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BrandImages_Brands]') AND parent_object_id = OBJECT_ID(N'[dbo].[BrandImages _DeleteLater]'))
ALTER TABLE [dbo].[BrandImages _DeleteLater] DROP CONSTRAINT [FK_BrandImages_Brands]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BrandImages_Height]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BrandImages _DeleteLater] DROP CONSTRAINT [DF_BrandImages_Height]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BrandImages_DateEntered]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BrandImages _DeleteLater] DROP CONSTRAINT [DF_BrandImages_DateEntered]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Companies_Special_Discounts]') AND parent_object_id = OBJECT_ID(N'[dbo].[Companies _DeleteLater]'))
ALTER TABLE [dbo].[Companies _DeleteLater] DROP CONSTRAINT [FK_Companies_Special_Discounts]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyCorrespondence_Orders]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyCorrespondence _DeleteLater]'))
ALTER TABLE [dbo].[CompanyCorrespondence _DeleteLater] DROP CONSTRAINT [FK_CompanyCorrespondence_Orders]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_cpPhones_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[cpPhones _DeleteLater] DROP CONSTRAINT [DF_cpPhones_Active]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AllowedStatusChange_OrderStatusCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[AllowedStatusChange_ DeleteLater]'))
ALTER TABLE [dbo].[AllowedStatusChange_ DeleteLater] DROP CONSTRAINT [FK_AllowedStatusChange_OrderStatusCode]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AllowedStatusChange_OrderStatusCode1]') AND parent_object_id = OBJECT_ID(N'[dbo].[AllowedStatusChange_ DeleteLater]'))
ALTER TABLE [dbo].[AllowedStatusChange_ DeleteLater] DROP CONSTRAINT [FK_AllowedStatusChange_OrderStatusCode1]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AllowedStatusChange_OnlyIfNotProcessed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AllowedStatusChange_ DeleteLater] DROP CONSTRAINT [DF_AllowedStatusChange_OnlyIfNotProcessed]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Banner_ActiveDateTime]') AND type = 'D')
BEGIN
ALTER TABLE [content].[Banner] DROP CONSTRAINT [DF_Banner_ActiveDateTime]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_html_markedForSchedule]') AND type = 'D')
BEGIN
ALTER TABLE [content].[html] DROP CONSTRAINT [DF_html_markedForSchedule]
END

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_html_isPreview]') AND type = 'D')
BEGIN
ALTER TABLE [content].[html] DROP CONSTRAINT [DF_html_isPreview]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__brands__Active__7913E27D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Brands _DeleteLater] DROP CONSTRAINT [DF__brands__Active__7913E27D]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__brands__Page__7A0806B6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Brands _DeleteLater] DROP CONSTRAINT [DF__brands__Page__7A0806B6]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Brands_isMAP]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Brands _DeleteLater] DROP CONSTRAINT [DF_Brands_isMAP]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Brands_ShowMAPPrice]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Brands _DeleteLater] DROP CONSTRAINT [DF_Brands_ShowMAPPrice]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cpBrands_Brands]') AND parent_object_id = OBJECT_ID(N'[dbo].[cpBrands _DeleteLater]'))
ALTER TABLE [dbo].[cpBrands _DeleteLater] DROP CONSTRAINT [FK_cpBrands_Brands]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_cpBrands_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[cpBrands _DeleteLater] DROP CONSTRAINT [DF_cpBrands_Active]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cpPhones_cpBrands]') AND parent_object_id = OBJECT_ID(N'[dbo].[cpPhones _DeleteLater]'))
ALTER TABLE [dbo].[cpPhones _DeleteLater] DROP CONSTRAINT [FK_cpPhones_cpBrands]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cpPhones_Products]') AND parent_object_id = OBJECT_ID(N'[dbo].[cpPhones _DeleteLater]'))
ALTER TABLE [dbo].[cpPhones _DeleteLater] DROP CONSTRAINT [FK_cpPhones_Products]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PromotionCodes_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PromotionCodes_DeleteLater] DROP CONSTRAINT [DF_PromotionCodes_DateCreated]
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PromotionEntries_Promotions]') AND parent_object_id = OBJECT_ID(N'[dbo].[PromotionEntries_DeleteLater]'))
ALTER TABLE [dbo].[PromotionEntries_DeleteLater] DROP CONSTRAINT [FK_PromotionEntries_Promotions]


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PromotionEnteries_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PromotionEntries_DeleteLater] DROP CONSTRAINT [DF_PromotionEnteries_CreateDate]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Promotion__Activ__1486F2C8]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PromotionEntries_DeleteLater] DROP CONSTRAINT [DF__Promotion__Activ__1486F2C8]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Promotions_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Promotions_DeleteLater] DROP CONSTRAINT [DF_Promotions_CreateDate]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Promotion__Activ__129EAA56]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Promotions_DeleteLater] DROP CONSTRAINT [DF__Promotion__Activ__129EAA56]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Rebates_Price]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Rebates_DeleteLater] DROP CONSTRAINT [DF_Rebates_Price]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Rebates_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Rebates_DeleteLater] DROP CONSTRAINT [DF_Rebates_Active]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Sale_Actv]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Sale_DeleteLater] DROP CONSTRAINT [DF_Sale_Actv]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Sale_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Sale_DeleteLater] DROP CONSTRAINT [DF_Sale_CreateDate]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Sale_CreateBy]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Sale_DeleteLater] DROP CONSTRAINT [DF_Sale_CreateBy]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Sale_UpdateBy]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Sale_DeleteLater] DROP CONSTRAINT [DF_Sale_UpdateBy]
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Sale_HomePageFeatured]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Sale_DeleteLater] DROP CONSTRAINT [DF_Sale_HomePageFeatured]
END


---- START TABLE REMOVAL ----

-- Object:  Table [catalog].[AccessoryForDevice_01_17_2012]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[AccessoryForDevice_01_17_2012]') AND type in (N'U'))
DROP TABLE [catalog].[AccessoryForDevice_01_17_2012]


-- Object:  Table [catalog].[accessory_10_17_2011]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[accessory_10_17_2011]') AND type in (N'U'))
DROP TABLE [catalog].[accessory_10_17_2011]


-- Object:  Table [catalog].[ProductTagBackup]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[ProductTagBackup]') AND type in (N'U'))
DROP TABLE [catalog].[ProductTagBackup]


-- Object:  Table [catalog].[ChannelAddress]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[ChannelAddress]') AND type in (N'U'))
DROP TABLE [catalog].[ChannelAddress]


-- Object:  Table [catalog].[AccessoryForDevice3]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[AccessoryForDevice3]') AND type in (N'U'))
DROP TABLE [catalog].[AccessoryForDevice3]


-- Object:  Table [catalog].[accessory_10_17_2011]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[accessory_10_17_2011]') AND type in (N'U'))
DROP TABLE [catalog].[accessory_10_17_2011]


-- Object:  Table [catalog].[DeviceService09D843A3EF044941A9B0AD0E0F27107B]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[DeviceService09D843A3EF044941A9B0AD0E0F27107B]') AND type in (N'U'))
DROP TABLE [catalog].[DeviceService09D843A3EF044941A9B0AD0E0F27107B]


-- Object:  Table [catalog].[DeviceServiceDF7BB51F9FDD4FE19837E6B0A5536A6E]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[DeviceServiceDF7BB51F9FDD4FE19837E6B0A5536A6E]') AND type in (N'U'))
DROP TABLE [catalog].[DeviceServiceDF7BB51F9FDD4FE19837E6B0A5536A6E]


-- Object:  Table [catalog].[ProductTagPrdBak]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[ProductTagPrdBak]') AND type in (N'U'))
DROP TABLE [catalog].[ProductTagPrdBak]


-- Object:  Table [catalog].[Market_test]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[Market_test]') AND type in (N'U'))
DROP TABLE [catalog].[Market_test]


-- Object:  Table [catalog].[Table1]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[Table1]') AND type in (N'U'))
DROP TABLE [catalog].[Table1]


-- Object:  Table [content].[html]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[content].[html]') AND type in (N'U'))
DROP TABLE [content].[html]


-- Object:  Table [content].[Banner]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[content].[Banner]') AND type in (N'U'))
DROP TABLE [content].[Banner]


-- Object:  Table [dbo].[AAIAToProd_ DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AAIAToProd_ DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[AAIAToProd_ DeleteLater]


-- Object:  Table [dbo].[access_ DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[access_ DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[access_ DeleteLater]


-- Object:  Table [dbo].[Accessories_ DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Accessories_ DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Accessories_ DeleteLater]


-- Object:  Table [dbo].[accessoryload_ DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[accessoryload_ DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[accessoryload_ DeleteLater]


-- Object:  Table [dbo].[AccessoryRelationships_ DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccessoryRelationships_ DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[AccessoryRelationships_ DeleteLater]


-- Object:  Table [dbo].[AccessoryRelationships2_ DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccessoryRelationships2_ DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[AccessoryRelationships2_ DeleteLater]


-- Object:  Table [dbo].[Affiliate_ DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Affiliate_ DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Affiliate_ DeleteLater]


-- Object:  Table [dbo].[Affiliate_order_ DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Affiliate_order_ DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Affiliate_order_ DeleteLater]


-- Object:  Table [dbo].[Affiliate_payment_ DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Affiliate_payment_ DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Affiliate_payment_ DeleteLater]


-- Object:  Table [dbo].[affiliate_site_type_ DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[affiliate_site_type_ DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[affiliate_site_type_ DeleteLater]


-- Object:  Table [dbo].[AllowedStatusChange_ DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AllowedStatusChange_ DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[AllowedStatusChange_ DeleteLater]


-- Object:  Table [dbo].[Amazon_OrderAdjustment _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Amazon_OrderAdjustment _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Amazon_OrderAdjustment _DeleteLater]


-- Object:  Table [dbo].[Amazon_OrderFulfillment _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Amazon_OrderFulfillment _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Amazon_OrderFulfillment _DeleteLater]


-- Object:  Table [dbo].[Amazon_OrderFulfillmentItem _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Amazon_OrderFulfillmentItem _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Amazon_OrderFulfillmentItem _DeleteLater]


-- Object:  Table [dbo].[amazon_products _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[amazon_products _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[amazon_products _DeleteLater]


-- Object:  Table [dbo].[amazon_promotion _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[amazon_promotion _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[amazon_promotion _DeleteLater]


-- Object:  Table [dbo].[Attribute_Category _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Attribute_Category _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Attribute_Category _DeleteLater]


-- Object:  Table [dbo].[Attribute_ObjectGroup _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Attribute_ObjectGroup _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Attribute_ObjectGroup _DeleteLater]


-- Object:  Table [dbo].[Attribute_Type _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Attribute_Type _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Attribute_Type _DeleteLater]

-- Object:  Table [dbo].[batch _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[batch _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[batch _DeleteLater]


-- Object:  Table [dbo].[BrandImages _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BrandImages _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[BrandImages _DeleteLater]


-- Object:  Table [dbo].[CashShort _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CashShort _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[CashShort _DeleteLater]


-- Object:  Table [dbo].[Cat_Reorg _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cat_Reorg _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Cat_Reorg _DeleteLater]


-- Object:  Table [dbo].[CategoriesTemp _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CategoriesTemp _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[CategoriesTemp _DeleteLater]


-- Object:  Table [dbo].[CC3Transactions _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CC3Transactions _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[CC3Transactions _DeleteLater]


-- Object:  Table [dbo].[certitax _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[certitax _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[certitax _DeleteLater]


-- Object:  Table [dbo].[CertiTAXorder _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CertiTAXorder _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[CertiTAXorder _DeleteLater]


-- Object:  Table [dbo].[Comments _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Comments _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Comments _DeleteLater]


-- Object:  Table [dbo].[communication _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[communication _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[communication _DeleteLater]


-- Object:  Table [dbo].[Comp_User _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Comp_User _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Comp_User _DeleteLater]


-- Object:  Table [dbo].[Companies _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Companies _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Companies _DeleteLater]


-- Object:  Table [dbo].[CompaniesTemp _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompaniesTemp _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[CompaniesTemp _DeleteLater]


-- Object:  Table [dbo].[CompanyCorrespondence _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyCorrespondence _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyCorrespondence _DeleteLater]


-- Object:  Table [dbo].[CompanyDatasources _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyDatasources _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyDatasources _DeleteLater]


-- Object:  Table [dbo].[content.html _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[content.html _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[content.html _DeleteLater]


-- Object:  Table [dbo].[Countries ]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Countries ]') AND type in (N'U'))
DROP TABLE [dbo].[Countries ]


-- Object:  Table [dbo].[cpBrands _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cpBrands _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[cpBrands _DeleteLater]


-- Object:  Table [dbo].[cpPhones _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cpPhones _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[cpPhones _DeleteLater]


-- Object:  Table [dbo].[cpPhoneToProd _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cpPhoneToProd _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[cpPhoneToProd _DeleteLater]


-- Object:  Table [dbo].[cpPhoneToUser _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cpPhoneToUser _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[cpPhoneToUser _DeleteLater]


-- Object:  Table [dbo].[CPS_ARTICLES _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CPS_ARTICLES _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[CPS_ARTICLES _DeleteLater]


-- Object:  Table [dbo].[CPS_PAGES _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CPS_PAGES _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[CPS_PAGES _DeleteLater]


-- Object:  Table [dbo].[CPS_Static _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CPS_Static _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[CPS_Static _DeleteLater]


-- Object:  Table [dbo].[dailysales _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dailysales _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[dailysales _DeleteLater]


-- Object:  Table [dbo].[DataSourceMaster _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataSourceMaster _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[DataSourceMaster _DeleteLater]


-- Object:  Table [dbo].[Department _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Department _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Department _DeleteLater]


-- Object:  Table [dbo].[DiscountOpts _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DiscountOpts _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[DiscountOpts _DeleteLater]


-- Object:  Table [dbo].[email_delete_me _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[email_delete_me _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[email_delete_me _DeleteLater]


-- Object:  Table [dbo].[email_history _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[email_history _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[email_history _DeleteLater]


-- Object:  Table [dbo].[email_queue _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[email_queue _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[email_queue _DeleteLater]


-- Object:  Table [dbo].[EmailSubscription _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmailSubscription _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[EmailSubscription _DeleteLater]


-- Object:  Table [dbo].[esn_feed_not_used _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[esn_feed_not_used _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[esn_feed_not_used _DeleteLater]


-- Object:  Table [dbo].[esp _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[esp _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[esp _DeleteLater]


-- Object:  Table [dbo].[esp_class _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[esp_class _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[esp_class _DeleteLater]


-- Object:  Table [dbo].[Exactor _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Exactor _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Exactor _DeleteLater]


-- Object:  Table [dbo].[FBA_Orders _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FBA_Orders _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[FBA_Orders _DeleteLater]


-- Object:  Table [dbo].[FBA_Taxes _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FBA_Taxes _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[FBA_Taxes _DeleteLater]


-- Object:  Table [dbo].[FeaturedProducts _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FeaturedProducts _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[FeaturedProducts _DeleteLater]


-- Object:  Table [dbo].[friendly_ip _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[friendly_ip _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[friendly_ip _DeleteLater]


-- Object:  Table [dbo].[FTPConfig _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FTPConfig _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[FTPConfig _DeleteLater]


-- Object:  Table [dbo].[Gift_Cert_Pay_Opts _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Gift_Cert_Pay_Opts _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Gift_Cert_Pay_Opts _DeleteLater]


-- Object:  Table [dbo].[Gift_Certificate_Config _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Gift_Certificate_Config _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Gift_Certificate_Config _DeleteLater]


-- Object:  Table [dbo].[Gift_Certificates _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Gift_Certificates _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Gift_Certificates _DeleteLater]


-- Object:  Table [dbo].[Group_Permission _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Group_Permission _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Group_Permission _DeleteLater]


-- Object:  Table [dbo].[GroupFilter_Values _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GroupFilter_Values _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[GroupFilter_Values _DeleteLater]


-- Object:  Table [dbo].[GroupFilters _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GroupFilters _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[GroupFilters _DeleteLater]


-- Object:  Table [dbo].[GroupsTemp _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GroupsTemp _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[GroupsTemp _DeleteLater]


-- Object:  Table [dbo].[Host_IP_Addr _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Host_IP_Addr _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Host_IP_Addr _DeleteLater]


-- Object:  Table [dbo].[ImageSize _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ImageSize _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ImageSize _DeleteLater]


-- Object:  Table [dbo].[insuranceclaims _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[insuranceclaims _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[insuranceclaims _DeleteLater]


-- Object:  Table [dbo].[KioskStaff _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KioskStaff _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[KioskStaff _DeleteLater]


-- Object:  Table [dbo].[KitLevels _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KitLevels _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[KitLevels _DeleteLater]


-- Object:  Table [dbo].[KitOrderDetails _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KitOrderDetails _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[KitOrderDetails _DeleteLater]


-- Object:  Table [dbo].[KitProducts _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KitProducts _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[KitProducts _DeleteLater]


-- Object:  Table [dbo].[Location_IP_Addr _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Location_IP_Addr _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Location_IP_Addr _DeleteLater]


-- Object:  Table [dbo].[MAPtoPartNum _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MAPtoPartNum _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[MAPtoPartNum _DeleteLater]


-- Object:  Table [dbo].[MarketplaceProductPrice _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarketplaceProductPrice _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[MarketplaceProductPrice _DeleteLater]


-- Object:  Table [dbo].[MarketplaceProductPriceSale _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarketplaceProductPriceSale _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[MarketplaceProductPriceSale _DeleteLater]


-- Object:  Table [dbo].[MarketplaceProductShippingOverride _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarketplaceProductShippingOverride _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[MarketplaceProductShippingOverride _DeleteLater]


-- Object:  Table [dbo].[MarketPlaceShippingValues_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarketPlaceShippingValues_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[MarketPlaceShippingValues_DeleteLater]


-- Object:  Table [dbo].[Mercent_OrderAdjustments_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Mercent_OrderAdjustments_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Mercent_OrderAdjustments_DeleteLater]


-- Object:  Table [dbo].[Mercent_OrderAdjustments_OLD_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Mercent_OrderAdjustments_OLD_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Mercent_OrderAdjustments_OLD_DeleteLater]


-- Object:  Table [dbo].[Mercent_OrderDetails _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Mercent_OrderDetails _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Mercent_OrderDetails _DeleteLater]


-- Object:  Table [dbo].[Mercent_Orders _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Mercent_Orders _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Mercent_Orders _DeleteLater]


-- Object:  Table [dbo].[MinorToGroup _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MinorToGroup _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[MinorToGroup _DeleteLater]


-- Object:  Table [dbo].[months _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[months _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[months _DeleteLater]


-- Object:  Table [dbo].[NEW_PA_SKUs _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NEW_PA_SKUs _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[NEW_PA_SKUs _DeleteLater]


-- Object:  Table [dbo].[ObjectGroup_Accessory _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObjectGroup_Accessory _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ObjectGroup_Accessory _DeleteLater]


-- Object:  Table [dbo].[ObjectGroupRights _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObjectGroupRights _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ObjectGroupRights _DeleteLater]


-- Object:  Table [dbo].[ObjectGroupRightsTemp _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObjectGroupRightsTemp _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ObjectGroupRightsTemp _DeleteLater]


-- Object:  Table [dbo].[Objectgroups_to_Amazon_Producttypes _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Objectgroups_to_Amazon_Producttypes _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Objectgroups_to_Amazon_Producttypes _DeleteLater]


-- Object:  Table [dbo].[ObjectGroupsTemp _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObjectGroupsTemp _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ObjectGroupsTemp _DeleteLater]


-- Object:  Table [dbo].[Objects _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Objects _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Objects _DeleteLater]


-- Object:  Table [dbo].[ObjectTypes _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObjectTypes _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ObjectTypes _DeleteLater]


-- Object:  Table [dbo].[OMKTTransactions _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OMKTTransactions _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OMKTTransactions _DeleteLater]


-- Object:  Table [dbo].[OMRequest _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OMRequest _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OMRequest _DeleteLater]


-- Object:  Table [dbo].[OptionalFeatures _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OptionalFeatures _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OptionalFeatures _DeleteLater]


-- Object:  Table [dbo].[ordebystringbkp _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ordebystringbkp _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ordebystringbkp _DeleteLater]


-- Object:  Table [dbo].[order_term _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[order_term _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[order_term _DeleteLater]


-- Object:  Table [dbo].[order_view _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[order_view _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[order_view _DeleteLater]


-- Object:  Table [dbo].[OrderAttributes _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderAttributes _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OrderAttributes _DeleteLater]


-- Object:  Table [dbo].[orderbundle _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[orderbundle _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[orderbundle _DeleteLater]


-- Object:  Table [dbo].[OrderComments _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderComments _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OrderComments _DeleteLater]


-- Object:  Table [dbo].[OrderCommentTemplate _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderCommentTemplate _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OrderCommentTemplate _DeleteLater]


-- Object:  Table [dbo].[orderdetail_vehicle _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[orderdetail_vehicle _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[orderdetail_vehicle _DeleteLater]


-- Object:  Table [dbo].[OrderDetailStatus _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDetailStatus _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OrderDetailStatus _DeleteLater]


-- Object:  Table [dbo].[orders_bkp _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[orders_bkp _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[orders_bkp _DeleteLater]


-- Object:  Table [dbo].[OrderStatus _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderStatus _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OrderStatus _DeleteLater]


-- Object:  Table [dbo].[OrderStatusCode _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderStatusCode _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OrderStatusCode _DeleteLater]


-- Object:  Table [dbo].[OrderStatusType_ _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderStatusType_ _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OrderStatusType_ _DeleteLater]


-- Object:  Table [dbo].[OrdersToRebates _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrdersToRebates _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OrdersToRebates _DeleteLater]


-- Object:  Table [dbo].[OrdersToSessions _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrdersToSessions _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OrdersToSessions _DeleteLater]


-- Object:  Table [dbo].[OrderTracking _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderTracking _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OrderTracking _DeleteLater]


-- Object:  Table [dbo].[OrderWirelessDetails _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderWirelessDetails _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OrderWirelessDetails _DeleteLater]


-- Object:  Table [dbo].[output2 _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[output2 _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[output2 _DeleteLater]


-- Object:  Table [dbo].[ow_types _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ow_types _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ow_types _DeleteLater]


-- Object:  Table [dbo].[Payments _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payments _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Payments _DeleteLater]


-- Object:  Table [dbo].[PerfAccToCar _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PerfAccToCar _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PerfAccToCar _DeleteLater]


-- Object:  Table [dbo].[PerfUniversal _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PerfUniversal _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PerfUniversal _DeleteLater]


-- Object:  Table [dbo].[Permission_PermissionType _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Permission_PermissionType _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Permission_PermissionType _DeleteLater]


-- Object:  Table [dbo].[PermissionType _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PermissionType _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PermissionType _DeleteLater]


-- Object:  Table [dbo].[PhoneOffers_NW _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PhoneOffers_NW _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PhoneOffers_NW _DeleteLater]


-- Object:  Table [dbo].[PhoneOffersTitle_NW _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PhoneOffersTitle_NW _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PhoneOffersTitle_NW _DeleteLater]


-- Object:  Table [dbo].[PrdTOPrds _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PrdTOPrds _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PrdTOPrds _DeleteLater]


-- Object:  Table [dbo].[prdtoprds_old _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prdtoprds_old _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[prdtoprds_old _DeleteLater]


-- Object:  Table [dbo].[PrdToPrdsTypes _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PrdToPrdsTypes _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PrdToPrdsTypes _DeleteLater]


-- Object:  Table [dbo].[PriceProducts _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceProducts _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PriceProducts _DeleteLater]


-- Object:  Table [dbo].[PriceUser _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceUser _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PriceUser _DeleteLater]


-- Object:  Table [dbo].[PriceWatch _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceWatch _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PriceWatch _DeleteLater]


-- Object:  Table [dbo].[PriceWatchComments _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceWatchComments _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PriceWatchComments _DeleteLater]


-- Object:  Table [dbo].[ProdRelationType _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProdRelationType _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ProdRelationType _DeleteLater]


-- Object:  Table [dbo].[prodsimagesbkp _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prodsimagesbkp _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[prodsimagesbkp _DeleteLater]


-- Object:  Table [dbo].[PriceMatch _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceMatch _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PriceMatch _DeleteLater]


-- Object:  Table [dbo].[PriceMatchStatus _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceMatchStatus _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PriceMatchStatus _DeleteLater]


-- Object:  Table [dbo].[ProductAttributes _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductAttributes _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ProductAttributes _DeleteLater]


-- Object:  Table [dbo].[ProductAttributes_bkp _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductAttributes_bkp _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ProductAttributes_bkp _DeleteLater]


-- Object:  Table [dbo].[ProdToRebate _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProdToRebate _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ProdToRebate _DeleteLater]


-- Object:  Table [dbo].[ProductImageAdditionalAttributes_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductImageAdditionalAttributes_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ProductImageAdditionalAttributes_DeleteLater]


-- Object:  Table [dbo].[ProductImageDetails_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductImageDetails_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ProductImageDetails_DeleteLater]


-- Object:  Table [dbo].[ProductFeatures_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductFeatures_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ProductFeatures_DeleteLater]


-- Object:  Table [dbo].[ProductImages_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductImages_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ProductImages_DeleteLater]


-- Object:  Table [dbo].[ProductKeywords_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductKeywords_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ProductKeywords_DeleteLater]


-- Object:  Table [dbo].[ProductOptions_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductOptions_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ProductOptions_DeleteLater]


-- Object:  Table [dbo].[productreview_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[productreview_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[productreview_DeleteLater]


-- Object:  Table [dbo].[productreviewstatus_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[productreviewstatus_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[productreviewstatus_DeleteLater]


-- Object:  Table [dbo].[Products_backup_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Products_backup_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Products_backup_DeleteLater]


-- Object:  Table [dbo].[products_dev_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[products_dev_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[products_dev_DeleteLater]


-- Object:  Table [dbo].[ProductSpecials_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductSpecials_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ProductSpecials_DeleteLater]


-- Object:  Table [dbo].[productspecials2_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[productspecials2_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[productspecials2_DeleteLater]


-- Object:  Table [dbo].[ProductToGroup_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductToGroup_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ProductToGroup_DeleteLater]


-- Object:  Table [dbo].[producttogroupbkp_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[producttogroupbkp_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[producttogroupbkp_DeleteLater]


-- Object:  Table [dbo].[ProductTypes_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductTypes_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ProductTypes_DeleteLater]


-- Object:  Table [dbo].[profiler]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[profiler]') AND type in (N'U'))
DROP TABLE [dbo].[profiler]


-- Object:  Table [dbo].[PromotionEntries_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PromotionEntries_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PromotionEntries_DeleteLater]


-- Object:  Table [dbo].[Promotions_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Promotions_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Promotions_DeleteLater]


-- Object:  Table [dbo].[Provinces_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Provinces_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Provinces_DeleteLater]


-- Object:  Table [dbo].[Rates_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Rates_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Rates_DeleteLater]


-- Object:  Table [dbo].[rebate_templates_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rebate_templates_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[rebate_templates_DeleteLater]


-- Object:  Table [dbo].[Rebate_Type_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Rebate_Type_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Rebate_Type_DeleteLater]


-- Object:  Table [dbo].[Rebates_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Rebates_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Rebates_DeleteLater]


-- Object:  Table [dbo].[RestrictionGroups_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RestrictionGroups_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[RestrictionGroups_DeleteLater]


-- Object:  Table [dbo].[RestrictionGroupstoProds_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RestrictionGroupstoProds_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[RestrictionGroupstoProds_DeleteLater]


-- Object:  Table [dbo].[ResultCode_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ResultCode_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ResultCode_DeleteLater]


-- Object:  Table [dbo].[Rights_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Rights_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Rights_DeleteLater]


-- Object:  Table [dbo].[roleinbundle_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[roleinbundle_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[roleinbundle_DeleteLater]


-- Object:  Table [dbo].[Sale_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sale_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Sale_DeleteLater]


-- Object:  Table [dbo].[SaleItem_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SaleItem_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[SaleItem_DeleteLater]


-- Object:  Table [dbo].[SearchTerms_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SearchTerms_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[SearchTerms_DeleteLater]


-- Object:  Table [dbo].[Sheet1$_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sheet1$_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Sheet1$_DeleteLater]


-- Object:  Table [dbo].[Sheet1_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sheet1_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Sheet1_DeleteLater]


-- Object:  Table [dbo].[ship_types_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ship_types_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ship_types_DeleteLater]


-- Object:  Table [dbo].[shipclass_criterion_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[shipclass_criterion_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[shipclass_criterion_DeleteLater]


-- Object:  Table [dbo].[Shipopts_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Shipopts_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Shipopts_DeleteLater]


-- Object:  Table [dbo].[Shippable_Types_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Shippable_Types_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Shippable_Types_DeleteLater]


-- Object:  Table [dbo].[shipper_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[shipper_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[shipper_DeleteLater]


-- Object:  Table [dbo].[Shippingtemp_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Shippingtemp_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Shippingtemp_DeleteLater]


-- Object:  Table [dbo].[shiprate_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[shiprate_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[shiprate_DeleteLater]


-- Object:  Table [dbo].[showcase_comments_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[showcase_comments_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[showcase_comments_DeleteLater]


-- Object:  Table [dbo].[showcase_status_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[showcase_status_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[showcase_status_DeleteLater]


-- Object:  Table [dbo].[ShowcaseProducts_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShowcaseProducts_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ShowcaseProducts_DeleteLater]


-- Object:  Table [dbo].[SiteParameters_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SiteParameters_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[SiteParameters_DeleteLater]


-- Object:  Table [dbo].[Special_Discounts_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Special_Discounts_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Special_Discounts_DeleteLater]


-- Object:  Table [dbo].[Special_Discounts_Temp_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Special_Discounts_Temp_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Special_Discounts_Temp_DeleteLater]


-- Object:  Table [dbo].[SQL Server Destination_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SQL Server Destination_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[SQL Server Destination_DeleteLater]


-- Object:  Table [dbo].[St_Af_Banners_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[St_Af_Banners_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[St_Af_Banners_DeleteLater]


-- Object:  Table [dbo].[St_Af_Referrals_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[St_Af_Referrals_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[St_Af_Referrals_DeleteLater]


-- Object:  Table [dbo].[St_Aff_Config_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[St_Aff_Config_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[St_Aff_Config_DeleteLater]


-- Object:  Table [dbo].[St_Aff_Payments_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[St_Aff_Payments_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[St_Aff_Payments_DeleteLater]


-- Object:  Table [dbo].[St_Affiliates_Cat_Ref_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[St_Affiliates_Cat_Ref_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[St_Affiliates_Cat_Ref_DeleteLater]


-- Object:  Table [dbo].[St_Affiliates_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[St_Affiliates_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[St_Affiliates_DeleteLater]


-- Object:  Table [dbo].[Stock_Feed_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Stock_Feed_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Stock_Feed_DeleteLater]


-- Object:  Table [dbo].[Stock_File_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Stock_File_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Stock_File_DeleteLater]


-- Object:  Table [dbo].[stock_file2_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stock_file2_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[stock_file2_DeleteLater]


-- Object:  Table [dbo].[Store_Inventory_bkp_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Store_Inventory_bkp_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Store_Inventory_bkp_DeleteLater]


-- Object:  Table [dbo].[Store_Inventory_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Store_Inventory_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Store_Inventory_DeleteLater]


-- Object:  Table [dbo].[Style_Thumbs_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Style_Thumbs_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Style_Thumbs_DeleteLater]


-- Object:  Table [dbo].[Styles_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Styles_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Styles_DeleteLater]


-- Object:  Table [dbo].[stylestemp_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stylestemp_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[stylestemp_DeleteLater]


-- Object:  Table [dbo].[t1_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t1_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[t1_DeleteLater]


-- Object:  Table [dbo].[Table_1_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Table_1_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Table_1_DeleteLater]


-- Object:  Table [dbo].[Taxes_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Taxes_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Taxes_DeleteLater]


-- Object:  Table [dbo].[TaxLinks_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TaxLinks_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[TaxLinks_DeleteLater]


-- Object:  Table [dbo].[TaxRates_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TaxRates_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[TaxRates_DeleteLater]


-- Object:  Table [dbo].[TemplateWizardOptions_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TemplateWizardOptions_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[TemplateWizardOptions_DeleteLater]


-- Object:  Table [dbo].[TemplateWizards_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TemplateWizards_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[TemplateWizards_DeleteLater]


-- Object:  Table [dbo].[TemplateWizardTypes_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TemplateWizardTypes_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[TemplateWizardTypes_DeleteLater]


-- Object:  Table [dbo].[terms_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[terms_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[terms_DeleteLater]


-- Object:  Table [dbo].[test_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[test_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[test_DeleteLater]


-- Object:  Table [dbo].[TEST1_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TEST1_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[TEST1_DeleteLater]


-- Object:  Table [dbo].[testbckp_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[testbckp_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[testbckp_DeleteLater]


-- Object:  Table [dbo].[TextDescription_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TextDescription_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[TextDescription_DeleteLater]


-- Object:  Table [dbo].[thin_banner_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[thin_banner_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[thin_banner_DeleteLater]


-- Object:  Table [dbo].[TMO_FutureDatedDevice]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMO_FutureDatedDevice]') AND type in (N'U'))
DROP TABLE [dbo].[TMO_FutureDatedDevice]


-- Object:  Table [dbo].[TMO_FutureDatedDevices]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMO_FutureDatedDevices]') AND type in (N'U'))
DROP TABLE [dbo].[TMO_FutureDatedDevices]


-- Object:  Table [dbo].[TMO_FutureDatedOffers]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMO_FutureDatedOffers]') AND type in (N'U'))
DROP TABLE [dbo].[TMO_FutureDatedOffers]


-- Object:  Table [dbo].[TMO_SaleInfo]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMO_SaleInfo]') AND type in (N'U'))
DROP TABLE [dbo].[TMO_SaleInfo]


-- Object:  Table [dbo].[tmpMarketplaceProductPrice_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tmpMarketplaceProductPrice_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[tmpMarketplaceProductPrice_DeleteLater]


-- Object:  Table [dbo].[tmpOrderDetails_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tmpOrderDetails_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[tmpOrderDetails_DeleteLater]


-- Object:  Table [dbo].[tmpOrderWirelessDetails_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tmpOrderWirelessDetails_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[tmpOrderWirelessDetails_DeleteLater]


-- Object:  Table [dbo].[tmpProductFeed_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tmpProductFeed_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[tmpProductFeed_DeleteLater]


-- Object:  Table [dbo].[TopCategories_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TopCategories_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[TopCategories_DeleteLater]


-- Object:  Table [dbo].[TopcategoriesTemp_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TopcategoriesTemp_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[TopcategoriesTemp_DeleteLater]


-- Object:  Table [dbo].[tyson_image_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tyson_image_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[tyson_image_DeleteLater]


-- Object:  Table [dbo].[UPSWorldShip_CTInfo_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UPSWorldShip_CTInfo_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[UPSWorldShip_CTInfo_DeleteLater]


-- Object:  Table [dbo].[user_audit_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user_audit_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[user_audit_DeleteLater]


-- Object:  Table [dbo].[User_old_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User_old_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[User_old_DeleteLater]


-- Object:  Table [dbo].[usercars_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usercars_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[usercars_DeleteLater]


-- Object:  Table [dbo].[usercars_for_perf_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usercars_for_perf_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[usercars_for_perf_DeleteLater]


-- Object:  Table [dbo].[UserGroupsTemp_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserGroupsTemp_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[UserGroupsTemp_DeleteLater]


-- Object:  Table [dbo].[Users_old_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users_old_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Users_old_DeleteLater]


-- Object:  Table [dbo].[usershipaddress_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usershipaddress_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[usershipaddress_DeleteLater]


-- Object:  Table [dbo].[userstores_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[userstores_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[userstores_DeleteLater]


-- Object:  Table [dbo].[weblink_batch_contents_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[weblink_batch_contents_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[weblink_batch_contents_DeleteLater]


-- Object:  Table [dbo].[weblink_batch_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[weblink_batch_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[weblink_batch_DeleteLater]


-- Object:  Table [dbo].[weblink_batch_test_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[weblink_batch_test_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[weblink_batch_test_DeleteLater]


-- Object:  Table [dbo].[Weblink_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Weblink_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Weblink_DeleteLater]


-- Object:  Table [dbo].[ZipCodeMarket_RemoveLate]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZipCodeMarket_RemoveLate]') AND type in (N'U'))
DROP TABLE [dbo].[ZipCodeMarket_RemoveLate]


-- Object:  Table [test].[AccDes_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[test].[AccDes_DeleteLater]') AND type in (N'U'))
DROP TABLE [test].[AccDes_DeleteLater]


-- Object:  Table [test].[DeletedOrderDetail_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[test].[DeletedOrderDetail_DeleteLater]') AND type in (N'U'))
DROP TABLE [test].[DeletedOrderDetail_DeleteLater]


-- Object:  Table [test].[DeletedWirelessLine_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[test].[DeletedWirelessLine_DeleteLater]') AND type in (N'U'))
DROP TABLE [test].[DeletedWirelessLine_DeleteLater]


-- Object:  Table [test].[DeleteLater_BulkLoadPropertyBackup_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[test].[DeleteLater_BulkLoadPropertyBackup_DeleteLater]') AND type in (N'U'))
DROP TABLE [test].[DeleteLater_BulkLoadPropertyBackup_DeleteLater]


-- Object:  Table [test].[GersItm_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[test].[GersItm_DeleteLater]') AND type in (N'U'))
DROP TABLE [test].[GersItm_DeleteLater]


-- Object:  Table [test].[IncomingProductTags_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[test].[IncomingProductTags_DeleteLater]') AND type in (N'U'))
DROP TABLE [test].[IncomingProductTags_DeleteLater]


-- Object:  Table [test].[ProductTags_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[test].[ProductTags_DeleteLater]') AND type in (N'U'))
DROP TABLE [test].[ProductTags_DeleteLater]


-- Object:  Table [test].[SrvDes_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[test].[SrvDes_DeleteLater]') AND type in (N'U'))
DROP TABLE [test].[SrvDes_DeleteLater]


-- Object:  Table [test].[StdOut_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[test].[StdOut_DeleteLater]') AND type in (N'U'))
DROP TABLE [test].[StdOut_DeleteLater]


-- Object:  Table [test].[WirelessAccountBackup_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[test].[WirelessAccountBackup_DeleteLater]') AND type in (N'U'))
DROP TABLE [test].[WirelessAccountBackup_DeleteLater]


-- Object:  Table [test].[WirelessLineFixIMEIOnDupShipments_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[test].[WirelessLineFixIMEIOnDupShipments_DeleteLater]') AND type in (N'U'))
DROP TABLE [test].[WirelessLineFixIMEIOnDupShipments_DeleteLater]


-- Object:  Table [dbo].[attributes _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[attributes _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[attributes _DeleteLater]


-- Object:  Table [dbo].[Brands _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Brands _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Brands _DeleteLater]


-- Object:  Table [dbo].[carfitbox_values _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[carfitbox_values _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[carfitbox_values _DeleteLater]


-- Object:  Table [dbo].[Categories _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Categories _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Categories _DeleteLater]


-- Object:  Table [dbo].[detailedaddress _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[detailedaddress _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[detailedaddress _DeleteLater]


-- Object:  Table [dbo].[DepositType _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DepositType _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[DepositType _DeleteLater]


-- Object:  Table [dbo].[Email_body _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Email_body _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Email_body _DeleteLater]


-- Object:  Table [dbo].[ObjectGroups _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObjectGroups _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ObjectGroups _DeleteLater]


-- Object:  Table [dbo].[Options _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Options _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Options _DeleteLater]


-- Object:  Table [dbo].[Orders _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Orders _DeleteLater]


-- Object:  Table [dbo].[OrderWireless _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderWireless _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OrderWireless _DeleteLater]


-- Object:  Table [dbo].[PaymentMethods _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentMethods _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PaymentMethods _DeleteLater]


-- Object:  Table [dbo].[Permission _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Permission _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Permission _DeleteLater]


-- Object:  Table [dbo].[PriceGroups _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceGroups _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PriceGroups _DeleteLater]


-- Object:  Table [dbo].[Products_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Products_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Products_DeleteLater]


-- Object:  Table [dbo].[required_type_flag_values_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[required_type_flag_values_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[required_type_flag_values_DeleteLater]


-- Object:  Table [dbo].[shipclass_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[shipclass_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[shipclass_DeleteLater]


-- Object:  Table [dbo].[shipclassbracket_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[shipclassbracket_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[shipclassbracket_DeleteLater]


-- Object:  Table [dbo].[ShipMethods_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShipMethods_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[ShipMethods_DeleteLater]


-- Object:  Table [dbo].[Showcase_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Showcase_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Showcase_DeleteLater]


-- Object:  Table [dbo].[Stores_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Stores_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Stores_DeleteLater]


-- Object:  Table [dbo].[OrderDetails _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDetails _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[OrderDetails _DeleteLater]


-- Object:  Table [dbo].[PromotionCodes_DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PromotionCodes_DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[PromotionCodes_DeleteLater]


-- Object:  Table [dbo].[Groups _DeleteLater]    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Groups _DeleteLater]') AND type in (N'U'))
DROP TABLE [dbo].[Groups _DeleteLater]


-- Object:  Table [service].[TestSIMS]   
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[service].[TestSIMS]') AND type in (N'U'))
DROP TABLE [service].[TestSIMS]


-- Object:  Table [catalog].[rebate_good]
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[rebate_good]') AND type in (N'U'))
DROP TABLE [catalog].[rebate_good]


-- Object:  Table [catalog].[producttag2]
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[producttag2]') AND type in (N'U'))
DROP TABLE [catalog].[producttag2]


-- Object:  Table [account].[UserRoleBackup]
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[account].[UserRoleBackup]') AND type in (N'U'))
DROP TABLE [account].[UserRoleBackup]

-- Object:  Table [catalog].[AccessoryForDevice2]
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[AccessoryForDevice2]') AND type in (N'U'))
DROP TABLE [catalog].[AccessoryForDevice2]



    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
END CATCH
