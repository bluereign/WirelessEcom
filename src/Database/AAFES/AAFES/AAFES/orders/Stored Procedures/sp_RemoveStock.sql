CREATE PROCedure [orders].[sp_RemoveStock]
  @OutletID varchar(10)
as 

declare @OrderDetailID bigint

select @OrderDetailID = (SELECT OrderDetailID FROM catalog.gersstock
where outletid = @outletid and OrderDetailID is not null)

delete from catalog.GersStock
WHERE OutletId = @OutletID

if (@OrderDetailID is not null)
begin
	update salesorder.wirelessline
	set imei = '', sim = ''
	where orderdetailid = @OrderDetailID
end

select 0