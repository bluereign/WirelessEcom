SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ron Delzer
-- Create date: 10/28/2010
-- Description:	 Added salesorder.ReviseShipMethod
-- function 02/10/2011 by Greg Montague
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
		SELECT	O.OrderId,  
				salesorder.ReviseShipMethodId (sa.Zip,o.ShipMethodId) ShipMethodId, --added function 2/10/2011 GSM
				O.ShipmentDeliveryDate, 
				SA.Zip
		FROM	salesorder.[Order] O
				INNER JOIN salesorder.Address SA
		ON		O.ShipAddressGuid = SA.AddressGuid
		WHERE	O.OrderId = @OrderId
	)
	, DynamicShipMethod AS
	(
		SELECT O.OrderId, O.ShipMethodId, O.ShipmentDeliveryDate, O.Zip, ZL.*, ROW_NUMBER() OVER(PARTITION BY O.OrderId ORDER BY ZL.ServiceOrdinal) AS ServiceRank
		FROM OrderInfo O
			OUTER APPLY ups.GetZoneListForZipCode(O.Zip) ZL
		WHERE (ZL.ExpectedDeliveryDate <= O.ShipmentDeliveryDate AND ZL.GersZone >= O.ShipMethodId) OR ZL.GersZone = O.ShipMethodId
	)
	SELECT * FROM DynamicShipMethod WHERE ServiceRank = 1

)
GO
