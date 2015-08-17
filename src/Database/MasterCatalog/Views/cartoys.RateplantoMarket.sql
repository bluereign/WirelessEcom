
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [cartoys].[RateplantoMarket] AS

--SELECT C.CompanyName AS CarrierName
--       , M.CarrierMarketCode
--       , R.CarrierBillCode AS CarrierRateplanCode
--       , RM.CarrierPlanReference -- Verizon has a per-market code for rateplan activation
--FROM catalog.RateplanMarket RM
--       INNER JOIN catalog.ProducttoParentChannel PPC ON PPC.ProductGuid = RM.RateplanGuid AND PPC.ChannelId = 1
--       INNER JOIN catalog.Rateplan R ON RM.RateplanGuid = R.RateplanGuid
--       INNER JOIN catalog.Market M ON RM.MarketGuid = M.MarketGuid
--       INNER JOIN catalog.Company C ON M.CarrierGuid = C.CompanyGuid
--WHERE C.CompanyName IN ('AT&T')


--rd7151 2014-01-20 quick fix to align cartoys.Rateplan with cartoys.RateplantoMarket

SELECT DISTINCT C.CompanyName AS CarrierName
       , M.CarrierMarketCode
       , R.CarrierBillCode AS CarrierRateplanCode
       , RM.CarrierPlanReference -- Verizon has a per-market code for rateplan activation
FROM catalog.RateplanMarket RM
       INNER JOIN catalog.Rateplan R ON RM.RateplanGuid = R.RateplanGuid
       INNER JOIN catalog.Market M ON RM.MarketGuid = M.MarketGuid
       INNER JOIN catalog.Company C ON M.CarrierGuid = C.CompanyGuid
WHERE EXISTS (SELECT * FROM cartoys.Rateplan WHERE Carrier = C.CompanyName AND CarrierBillCode = R.CarrierBillCode)



GO
