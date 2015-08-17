CREATE procedure [orders].[sp_UpdateGersStatus]
	 @OrderID bigint
as

UPDATE salesorder.[Order]
SET GERSStatus = 0
WHERE OrderId = @OrderID