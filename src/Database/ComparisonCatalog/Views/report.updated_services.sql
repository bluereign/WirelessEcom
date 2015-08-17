SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[updated_services]
AS
SELECT 'New' AS 'Updated', cdt.* FROM catalogthisweek.Service cdt
INNER JOIN cataloglastweek.Service cdl ON cdl.CarrierBillCode = cdt.CarrierBillCode
WHERE (cdt.Title <> cdl.Title) OR (cdt.MonthlyFee <> cdl.MonthlyFee)

UNION

SELECT 'Previous' AS 'Updated', cdl.* FROM catalogthisweek.Service cdt
INNER JOIN cataloglastweek.Service cdl ON cdl.CarrierBillCode = cdt.CarrierBillCode
WHERE (cdt.Title <> cdl.Title) OR (cdt.MonthlyFee <> cdl.MonthlyFee)
GO
