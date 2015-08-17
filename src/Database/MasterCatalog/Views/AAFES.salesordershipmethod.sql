SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* Push Static Data to salesorder.ShipMethod */

CREATE VIEW [AAFES].[salesordershipmethod] AS

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
FROM salesorder.shipmethod WHERE ChannelId = '3'

GO
