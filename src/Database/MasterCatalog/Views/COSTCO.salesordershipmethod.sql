SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* Push Static Data to service.PaymentGatewayType */

CREATE VIEW [COSTCO].[salesordershipmethod] AS

SELECT
	ShipmethodId
	,Name
	,DisplayName
	,IsActive
	,DefaultFixedCost
	,GersShipMethodId
	,CarrierId
	,PromoPrice
	,PromoDisplayName
	,PromoCarrierId
	,IsApoAfoAvailable
FROM salesorder.shipmethod WHERE ChannelId = '2'

GO
