-- =============================================
-- Author:		Ron Delzer
-- Create date: 6/22/2010
-- Description:	Adds tracking information to order
-- =============================================
CREATE PROCEDURE salesorder.AddSingleUpsTrackingNumberToOrder
	-- Add the parameters for the stored procedure here
	@OrderId int, 
	@TrackingNumber nvarchar(18)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @ShipmentId int;

    -- Insert statements for procedure here
	INSERT INTO salesorder.Shipment (TrackingNumber) VALUES (@TrackingNumber);
	SET @ShipmentId = @@IDENTITY;
	
	UPDATE salesorder.OrderDetail SET ShipmentId = @ShipmentId WHERE OrderId = @OrderId AND OrderDetailType IN ('d', 'a');
	
	UPDATE salesorder.[Order] SET GERSStatus = 3 WHERE OrderId = @OrderId;
END