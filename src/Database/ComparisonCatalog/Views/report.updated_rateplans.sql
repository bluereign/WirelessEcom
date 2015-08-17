SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[updated_rateplans]
AS
SELECT 'New' AS 'Updated', cdt.* FROM catalogthisweek.rateplan cdt
INNER JOIN cataloglastweek.rateplan cdl ON cdl.CarrierBillCode = cdt.CarrierBillCode
WHERE (cdt.Title <> cdl.Title) OR (cdt.Type <> cdl.Type) OR (cdt.ContractTerm <> cdl.ContractTerm)
 OR (cdt.IncludedLines <> cdl.IncludedLines) OR (cdt.MaxLines <> cdl.MaxLines)
 OR (cdt.MonthlyFee <> cdl.MonthlyFee) OR (cdt.AdditionalLineFee <> cdl.AdditionalLineFee)
 OR (cdt.PrimaryActivationFee <> cdl.PrimaryActivationFee) OR (cdt.SecondaryActivationFee <> cdl.SecondaryActivationFee)

UNION

SELECT 'Previous' AS 'Updated', cdl.* FROM catalogthisweek.rateplan cdt
INNER JOIN cataloglastweek.rateplan cdl ON cdl.CarrierBillCode = cdt.CarrierBillCode
WHERE (cdt.Title <> cdl.Title) OR (cdt.Type <> cdl.Type) OR (cdt.ContractTerm <> cdl.ContractTerm)
 OR (cdt.IncludedLines <> cdl.IncludedLines) OR (cdt.MaxLines <> cdl.MaxLines)
 OR (cdt.MonthlyFee <> cdl.MonthlyFee) OR (cdt.AdditionalLineFee <> cdl.AdditionalLineFee)
 OR (cdt.PrimaryActivationFee <> cdl.PrimaryActivationFee) OR (cdt.SecondaryActivationFee <> cdl.SecondaryActivationFee)
GO
