CREATE PROCedure [orders].[sp_UpdateGersStockWireless]
  @OrderID bigint,
  @OutletID varchar(10),
  @GersSku varchar(9),
  @OrderDetailID bigint  
as 


declare @imei varchar(50)
declare @sim varchar(50)
declare @OrderType varchar(1)

set @OrderType = (Select OrderDetailType from salesorder.[OrderDetail] where OrderDetailID = @OrderDetailID)

if (@OrderType ='d')
begin
	set @imei = (select imei FROM catalog.GersStock WHERE OutletId = @OutletID)
	set @sim = (select sim FROM catalog.GersStock WHERE OutletId = @OutletID)

	if ((@imei is not null) and (@sim is not null))
	begin
		update salesorder.WirelessLine
		set imei = @imei, sim = @sim
		where OrderDetailId = @OrderDetailID

		UPDATE catalog.GersStock
		SET OrderDetailId = @OrderDetailID
		WHERE OutletId = @OutletID
		 AND GersSku = @GersSku

		UPDATE salesorder.[Order]
		SET GERSStatus = 0
		WHERE OrderId = @OrderID  
		
		select 0
	end
end
else
begin
	UPDATE catalog.GersStock
	SET OrderDetailId = @OrderDetailID
	WHERE OutletId = @OutletID
	 AND GersSku = @GersSku

	UPDATE salesorder.[Order]
	SET GERSStatus = 0
	WHERE OrderId = @OrderID  

	select 0
end
select 1