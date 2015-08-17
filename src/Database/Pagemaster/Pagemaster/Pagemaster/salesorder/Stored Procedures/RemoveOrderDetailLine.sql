
CREATE procedure [salesorder].[RemoveOrderDetailLine] (@OrderDetailId int)
as

SET NOCOUNT ON
declare @orderid int;


select @orderid=ISNULL(od.OrderId,-1) from salesorder.OrderDetail od where od.OrderDetailId=@orderdetailid and od.OrderId>0

If @orderid>0 set @orderid=@orderid-(@orderid*2)


update salesorder.OrderDetail
set	OrderId=@orderid
where OrderDetailId=@orderdetailid

update catalog.GersStock
set OrderDetailId = Null
where OrderDetailId = @orderdetailid

PRINT	'OrderDetailId: '+CAST(@OrderDetailId as varchar(15))+' on '
		+CAST(@orderid as varchar(10))
		+' has been removed.'