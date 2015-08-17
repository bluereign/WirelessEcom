


-- =============================================
-- Author:		Ron Delzer
-- Create date: 7/15/2014
-- Description:	
-- =============================================
CREATE PROCEDURE [ALLOCATION].[SwapDevice] 
	@OrderDetailId int,
	@ReasonCode int,
	@NewIMEI nvarchar(15) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @OrderId int;
	DECLARE @OrderStatus int;
	DECLARE @GersStatus int;
	DECLARE @GersSku nvarchar(9);
	DECLARE @AvailableQty int;
	DECLARE @ErrMsg nvarchar(255);


	
	SELECT @OrderId = O.OrderId
		, @OrderStatus = O.[Status]
		, @GersStatus = O.GERSStatus
		,@GersSku = od.GersSku
	FROM salesorder.[Order] O
		INNER JOIN salesorder.OrderDetail OD
			ON O.OrderId = OD.OrderId
	WHERE OD.OrderDetailId = @OrderDetailId
	;

	SELECT @AvailableQty = AvailableQty
	FROM catalog.Inventory
	WHERE GersSku = @GersSku
	;

	-- The ReasonCode gets used as the OrderDetailId, it must be negative to avoid number conflicts
	IF (@ReasonCode >= 0)
		BEGIN
			SET @ErrMsg = N'ReasonCode must be negative';
			RAISERROR (@ErrMsg,16,1);
		END

	-- Restrict to open orders
	ELSE IF (NOT (@OrderStatus = 1 AND @GersStatus = 0))
		 BEGIN
			SET @ErrMsg = N'Invalid Order Status, order must be pending and not weblinked';
			RAISERROR (@ErrMsg,16,1);
		 END

	ELSE IF (@AvailableQty < 1)
		 BEGIN
			SET @ErrMsg = N'No inventory available';
			RAISERROR (@ErrMsg,16,1);
		 END
	ELSE
		 BEGIN
			INSERT INTO salesorder.Activity (OrderId, Name, Description)
			VALUES (@OrderId, N'DeviceSwap', N'OrderDetailId: ' + CONVERT(nvarchar,@OrderDetailId) + '  GersSku: ' + @GersSku);

			-- Mark existing allocation with supplied reason code
			UPDATE catalog.GersStock
			SET OrderDetailId = @ReasonCode
			WHERE OrderDetailId = @OrderDetailId
			;

			--Allocate a new unit
			EXEC salesorder.AllocateStockToOrderDetail @OrderDetailId
			;
		 END
END