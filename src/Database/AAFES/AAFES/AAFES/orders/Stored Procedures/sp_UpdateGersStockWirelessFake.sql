CREATE PROCedure [orders].[sp_UpdateGersStockWirelessFake]
  @OrderID bigint,
  @OutletID varchar(10),
  @GersSku varchar(9),
  @OrderDetailID bigint  
as 
declare @RetCode int
set @RetCode = 1

declare @imei varchar(50)
declare @sim varchar(50)
declare @OrderType varchar(1)

-- remove Fake gers stock
delete from catalog.GersStock
where OrderDetailID = @OrderDetailID

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
		
		set @RetCode = 0
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

	set @RetCode = 0
end

-- just get rid of the fake stock item, leave rest alone.

---- Get rid of remaining stock that hasn't been assigned yet.
--if (@RetCode = 0)
--begin
--	declare @CountStock int

--	select @CountStock = (Select Count(*) from Catalog.GersStock 
--	   where GersSku = @GersSku and OrderDetailID is null and OutletCode <> 'FAK')
	
--	if (@CountStock > 2)
--	begin
--		delete from Catalog.GersStock
--		where OutletCode = 'FAK' and StoreCode = 'XX' and GersSku = @GersSku and OrderDetailID is null 
--	end
--end

SELECT @RetCode