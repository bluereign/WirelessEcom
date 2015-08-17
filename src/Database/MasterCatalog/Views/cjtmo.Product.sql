SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW cjtmo.Product AS
SELECT ProductId,ProductGuid,GersSku,Active FROM [CATALOG.CONFIGURE].catalog.product
WHERE ChannelId = '3' AND ProductGuid IN (SELECT DeviceGuid FROM [CATALOG.CONFIGURE].catalog.Device WHERE CarrierGuid = '84C15B47-C976-4403-A7C4-80ABA6EEC189')
AND ProductGuid NOT IN (SELECT ppc.ProductGuid FROM [CATALOG.CONFIGURE].catalog.dn_Phones dp INNER JOIN [CATALOG.CONFIGURE].catalog.ProductToParentChannel ppc ON ppc.ParentProductGuid = dp.ProductGuid WHERE MetaKeywords LIKE '%prepaid%')
AND GersSku IN (
SELECT GersSku FROM [CommissionReporting].staging.GersPrice WHERE GersSku IS NOT NULL)
GO
