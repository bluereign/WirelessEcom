SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[old_rateplans]
AS
SELECT * FROM cataloglastweek.rateplan crl WHERE NOT EXISTS
(SELECT * FROM catalogthisweek.rateplan crt WHERE crl.CarrierBillCode = crt.CarrierBillCode)
GO
