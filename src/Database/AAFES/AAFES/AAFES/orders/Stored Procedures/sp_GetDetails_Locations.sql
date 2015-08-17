CREATE PROCedure [orders].[sp_GetDetails_Locations]
	@GersSku varchar(9) = null,
	@OrderDetailID bigint = null
as

if (@OrderDetailID is null) 
begin

SELECT gs.GersSku, OutletID, StoreCode, LocationCode, gs.Qty as Qty, cast(gs.OrderDetailID as varchar) as OrderDetailID,
 cast(od.OrderID as varchar) as OrderID, CAST(o.OrderDate AS VARCHAR) as OrderDate, os.OrderStatus as OrderStatus, gs.IMEI
 from catalog.GersStock gs 
LEFT JOIN salesorder.OrderDetail od on gs.OrderDetailID = od.OrderDetailID
LEFT JOIN salesorder.[Order] o on od.OrderID = o.OrderID
LEFT JOIN salesorder.[OrderStatus] os on o.Status = os.OrderStatusId and os.OrderType = 'WA'
WHERE gs.GersSku = @GersSku
end
else
begin

SELECT gs.GersSku, OutletID, StoreCode, LocationCode, gs.Qty as Qty, cast(gs.OrderDetailID as varchar) as OrderDetailID,
 cast(od.OrderID as varchar) as OrderID, CAST(o.OrderDate AS VARCHAR) as OrderDate, os.OrderStatus as OrderStatus, gs.IMEI
 from catalog.GersStock gs 
LEFT JOIN salesorder.OrderDetail od on gs.OrderDetailID = od.OrderDetailID
LEFT JOIN salesorder.[Order] o on od.OrderID = o.OrderID
LEFT JOIN salesorder.[OrderStatus] os on o.Status = os.OrderStatusId and os.OrderType = 'WA'
WHERE gs.OrderDetailID = @OrderDetailID
end