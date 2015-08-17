CREATE PROC [orders].[sp_RemoveItemOrderDetail]

  @OrderID bigint,
  @GroupNumber int,
  @GersSku varchar(9)

as

delete from salesorder.OrderDetail
where OrderID = @OrderID and GersSku = @GersSku and GroupNumber = @GroupNumber

update salesorder.[Order]
set GersStatus = 0
where OrderID = @OrderID

select 0