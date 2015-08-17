CREATE procedure [orders].[sp_CheckDeviceUsed]
	@IMEI varchar(16),
	@OrderID bigint = null

as

	declare @cnt int = 0
	
	if (len(@IMEI)>0)
	begin
	if (@orderId is not null)
	begin
		select @cnt = (SELECT count(*) 
		FROM salesorder.[WirelessLine] wl 
			 inner join salesorder.[OrderDetail] d			 
			 on d.OrderDetailID = wl.OrderDetailID
			 inner join salesorder.[Order] o 
			 on o.OrderID = d.OrderID
		WHERE IMEI = @IMEI and d.OrderID != @OrderID and d.OrderDetailType = 'd' and o.GersStatus = 3)
	end
	else
	begin
		select @cnt = (SELECT count(*) 
		FROM salesorder.[WirelessLine] wl 
			 inner join salesorder.[OrderDetail] d
			 on d.OrderDetailID = wl.OrderDetailID 
			 inner join salesorder.[Order] o 
			 on o.OrderID = d.OrderID
		WHERE IMEI = @IMEI and d.OrderDetailType = 'd'and o.GersStatus = 3)
	end
	end

select @cnt