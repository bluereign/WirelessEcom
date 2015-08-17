

CREATE PROCEDURE [salesorder].[AddDeviceToOrder] (@OrderDetailId int)

AS
BEGIN
	exec salesorder.AllocateStockToOrderDetail @OrderDetailId;
	exec salesorder.AssignIMEIToWirelessLine @OrderDetailId;

END	

