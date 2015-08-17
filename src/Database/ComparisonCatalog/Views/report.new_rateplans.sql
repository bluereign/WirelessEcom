SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[new_rateplans]
AS
SELECT * FROM catalogthisweek.rateplan crt WHERE NOT EXISTS
(SELECT * FROM cataloglastweek.rateplan crl WHERE crt.CarrierBillCode = crl.CarrierBillCode)
GO
