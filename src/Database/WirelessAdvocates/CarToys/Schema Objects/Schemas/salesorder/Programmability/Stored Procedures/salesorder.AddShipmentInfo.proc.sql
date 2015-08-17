-- =============================================
-- Author:		Ron Delzer
-- Create date: 5/3/2010
-- Description:	
-- =============================================
CREATE PROCEDURE salesorder.AddShipmentInfo 
	-- Add the parameters for the stored procedure here
	@OrderId int, 
	@ShipMethodId int,
	@TrackingNumber int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO salesorder.Shipment (ShipMethodId, TrackingNumber) VALUES (@ShipMethodId, @TrackingNumber);
	
	UPDATE salesorder.OrderDetail SET ShipmentId = @@IDENTITY WHERE OrderId = @OrderId AND OrderDetailType IN ('d', 'a');
	
	UPDATE salesorder.[Order] SET GERSStatus = 3 WHERE OrderId = @OrderId;
	
END
