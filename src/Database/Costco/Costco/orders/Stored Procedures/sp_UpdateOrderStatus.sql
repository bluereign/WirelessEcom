create procedure [orders].[sp_UpdateOrderStatus]
      @OrderID bigint,
      @Status int
as

UPDATE salesorder.[Order]
SET Status = @Status
WHERE OrderId = @OrderID