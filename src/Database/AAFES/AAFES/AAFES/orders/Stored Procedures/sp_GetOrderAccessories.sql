CREATE PROCedure [orders].[sp_GetOrderAccessories]
	@OrderID bigint,
	@GroupNumber int
as

select ProductID, GersSku, GroupNumber from salesorder.OrderDetail
where orderid = @OrderID and OrderDetailType = 'a' and (GroupNumber = @GroupNumber or GroupNumber = 999)
order by ProductID asc, GersSku asc