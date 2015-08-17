SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[new_market]
AS
SELECT * FROM catalogthisweek.market cmt WHERE NOT EXISTS
(SELECT * FROM cataloglastweek.market cml WHERE cmt.CarrierMarketCode = cml.CarrierMarketCode)
GO
