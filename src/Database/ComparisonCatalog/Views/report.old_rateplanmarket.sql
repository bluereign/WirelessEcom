SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[old_rateplanmarket]
AS
SELECT * FROM cataloglastweek.RateplanMarket crml WHERE NOT EXISTS
(SELECT * FROM catalogthisweek.RateplanMarket crmt WHERE crml.CarrierMarketCode = crmt.CarrierMarketCode
AND crml.RateplanCarrierBillCode = crmt.RateplanCarrierBillCode)
GO
