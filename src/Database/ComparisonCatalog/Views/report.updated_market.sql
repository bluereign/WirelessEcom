SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[updated_market]
AS
SELECT 'New' AS 'Updated', cdt.* FROM catalogthisweek.Market cdt
INNER JOIN cataloglastweek.Market cdl ON cdl.CarrierMarketCode = cdt.CarrierMarketCode AND cdl.CarrierMarketId = cdt.CarrierMarketId
WHERE (cdt.CarrierMarketName <> cdt.CarrierMarketName)

UNION

SELECT 'Previous' AS 'Updated', cdl.* FROM catalogthisweek.Market cdt
INNER JOIN cataloglastweek.Market cdl ON cdl.CarrierMarketCode = cdt.CarrierMarketCode AND cdl.CarrierMarketId = cdt.CarrierMarketId
WHERE (cdt.CarrierMarketName <> cdt.CarrierMarketName)
GO
