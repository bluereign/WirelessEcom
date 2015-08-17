-- =============================================
-- Author:		Ron Delzer
-- Create date: 10/28/2010
-- Description:	
-- =============================================
CREATE FUNCTION [salesorder].[GetShipMethodForOrder] 
(	
	@OrderId int
)
RETURNS TABLE 
AS
RETURN 
(
	WITH OrderInfo AS
	(
		SELECT O.OrderId, O.ShipMethodId, O.ShipmentDeliveryDate, SA.Zip
		FROM salesorder.[Order] O
			INNER JOIN salesorder.Address SA
				ON O.ShipAddressGuid = SA.AddressGuid
		WHERE O.OrderId = @OrderId
	)
	, DynamicShipMethod AS
	(
		SELECT	O.OrderId, 
				O.ShipMethodId, 
				O.ShipmentDeliveryDate, 
				O.Zip, 
				ZL.*, 
				ROW_NUMBER() OVER(PARTITION BY O.OrderId ORDER BY ZL.ServiceOrdinal) AS ServiceRank
		FROM	OrderInfo O
				OUTER APPLY ups.GetZoneListForZipCode(O.Zip) ZL
		WHERE	(ZL.ExpectedDeliveryDate <= O.ShipmentDeliveryDate 
				AND ZL.GersZone >= O.ShipMethodId) 
				OR ZL.GersZone = O.ShipMethodId
	)
	SELECT * FROM DynamicShipMethod WHERE ServiceRank = 1

)