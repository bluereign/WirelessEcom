SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [cartoys].[ServiceImport] AS


SELECT C.CompanyName AS CarrierName --carrier
       , S.CarrierServiceId --this is the same as CarrierBillCode in many cases, but not all
       , S.CarrierBillCode AS ServiceBillCode --serviceBillCode
       ,(SELECT CONVERT(nvarchar(256), Value) FROM catalog.Property WHERE ProductGuid = S.ServiceGuid AND Name = 'title') AS CleanName --cleanName
       , S.Title --direct from carrier catalog
       , S.MonthlyFee --monthlyFee
       ,(SELECT CONVERT(nvarchar(4000), Value) FROM catalog.Property WHERE ProductGuid = S.ServiceGuid AND Name = 'shortDescription') AS shortDescription --shortDescription
       ,(SELECT CONVERT(nvarchar(4000), Value) FROM catalog.Property WHERE ProductGuid = S.ServiceGuid AND Name = 'longDescription') AS longDescription --longDescription
       , S.CartTypeId --applicableActivationTypes
FROM catalog.[Service] S
       INNER JOIN catalog.ProducttoParentChannel PPC ON PPC.ProductGuid = S.ServiceGuid AND PPC.ChannelId = 1
       INNER JOIN catalog.Company C ON S.CarrierGuid = C.CompanyGuid
WHERE C.CompanyName IN ('AT&T')





GO
