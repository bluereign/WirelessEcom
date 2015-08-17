CREATE PROCedure [orders].[sp_GetOrderPhone]
  @OrderID bigint
as 

	select ProductID, GroupNumber from  salesorder.OrderDetail
	where orderid = @OrderID and OrderDetailType = 'd'
	order by ProductID, GroupNumber