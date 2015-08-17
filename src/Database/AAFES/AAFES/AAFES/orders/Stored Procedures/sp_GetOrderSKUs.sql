CREATE PROCedure [orders].[sp_GetOrderSKUs]
	@OrderID bigint

as

 select distinct GersSku from salesorder.[OrderDetail]
 where OrderID = @OrderID and OrderDetailType in ('a','d')