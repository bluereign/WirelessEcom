SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[old_services]
AS
SELECT * FROM cataloglastweek.service crl WHERE NOT EXISTS
(SELECT * FROM catalogthisweek.Service  crt WHERE crl.CarrierBillCode = crt.CarrierBillCode)
GO
