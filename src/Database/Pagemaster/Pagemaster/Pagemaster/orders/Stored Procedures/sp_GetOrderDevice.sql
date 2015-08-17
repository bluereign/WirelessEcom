
CREATE PROCedure [orders].sp_GetOrderDevice
	@OrderId bigint,
	@GersSku varchar(10),
	@GroupNumber int

as

select count(*) from 
 salesorder.[OrderDetail]
 where orderid = @OrderId and GroupNumber = @GroupNumber and GersSku = @GersSku and OrderDetailType = 'd'