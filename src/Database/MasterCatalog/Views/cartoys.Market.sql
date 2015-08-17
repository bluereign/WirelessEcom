SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [cartoys].[Market] AS

SELECT C.CompanyName AS CarrierName
       , ZCM.ZipCode
       , M.CarrierMarketCode
       , M.CarrierMarketName
FROM catalog.Market M
       INNER JOIN catalog.Company C ON M.CarrierGuid = C.CompanyGuid
       INNER JOIN catalog.ZipCodeMarket ZCM ON M.MarketGuid = ZCM.MarketGuid
WHERE C.CompanyName IN ('AT&T')
;

GO
