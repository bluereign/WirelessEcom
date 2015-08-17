
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/* Push Static Data to catalog.Service */

CREATE VIEW [PAGEMASTER].[Service] AS
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
WHERE cp.ChannelId = '5'






GO
