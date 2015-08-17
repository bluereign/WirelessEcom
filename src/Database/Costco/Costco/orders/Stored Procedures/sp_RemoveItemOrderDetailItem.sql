CREATE proc [orders].[sp_RemoveItemOrderDetailItem]

  @OrderDetailID bigint
  
as

update catalog.GersStock
set OrderDetailID = null
where OrderDetailID = @OrderDetailID

delete from salesorder.WirelessLine
where OrderDetailID = @OrderDetailID

delete from salesorder.LineService
where OrderDetailID = @OrderDetailID

delete from salesorder.OrderDetail
where OrderDetailID = @OrderDetailID

select 0