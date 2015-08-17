CREATE PROCedure [orders].[sp_UpdateGersStock]
  @OrderID bigint,
  @OutletID varchar(10),
  @GersSku varchar(9),
  @OrderDetailID bigint  
as 

UPDATE catalog.GersStock
SET OrderDetailId = @OrderDetailID
WHERE OutletId = @OutletID
 AND GersSku = @GersSku

UPDATE salesorder.[Order]
SET GERSStatus = 0
WHERE OrderId = @OrderID

select 0