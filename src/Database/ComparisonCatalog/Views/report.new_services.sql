SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[new_services]
AS
SELECT * FROM catalogthisweek.service crl WHERE NOT EXISTS
(SELECT * FROM cataloglastweek.Service  crt WHERE crl.CarrierBillCode = crt.CarrierBillCode)
GO
