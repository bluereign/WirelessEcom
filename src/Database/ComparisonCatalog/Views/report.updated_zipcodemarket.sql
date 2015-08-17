SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[updated_zipcodemarket]
AS
SELECT 'New' AS 'Updated', cdt.* FROM catalogthisweek.ZipcodeMarket cdt
INNER JOIN cataloglastweek.ZipcodeMarket cdl ON cdl.ZipCode = cdt.ZipCode
WHERE (cdt.CarrierMarketCode <> cdl.CarrierMarketCode)

UNION

SELECT 'Previous' AS 'Updated', cdl.* FROM catalogthisweek.ZipcodeMarket cdt
INNER JOIN cataloglastweek.ZipcodeMarket cdl ON cdl.ZipCode = cdt.ZipCode
WHERE (cdt.CarrierMarketCode <> cdl.CarrierMarketCode)
GO
