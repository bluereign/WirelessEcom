SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[new_rateplanmarket]
AS
SELECT * FROM catalogthisweek.RateplanMarket crmt WHERE NOT EXISTS
(SELECT * FROM cataloglastweek.RateplanMarket crml WHERE crmt.CarrierMarketCode = crml.CarrierMarketCode
AND crmt.RateplanCarrierBillCode = crml.RateplanCarrierBillCode)
GO
