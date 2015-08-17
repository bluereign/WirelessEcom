SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[old_market]
AS
SELECT * FROM cataloglastweek.market cml WHERE NOT EXISTS
(SELECT * FROM catalogthisweek.market cmt WHERE cml.CarrierMarketCode = cmt.CarrierMarketCode)
GO
