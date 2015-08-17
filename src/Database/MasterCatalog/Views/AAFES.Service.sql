
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* Push Static Data to catalog.Service */

CREATE VIEW [AAFES].[Service] AS

SELECT
	cp.ProductGuid AS 'ServiceGuid'
	,s.CarrierGuid
	,s.CarrierServiceId
	,s.CarrierBillCode
	,s.Title
	,s.MonthlyFee
	,s.CartTypeId
FROM
	catalog.Service s
INNER JOIN catalog.Product cp ON cp.ProductGuid = s.ServiceGuid
WHERE cp.ChannelId = '3'



GO
