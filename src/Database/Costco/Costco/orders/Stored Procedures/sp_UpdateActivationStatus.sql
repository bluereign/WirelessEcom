create procedure [orders].[sp_UpdateActivationStatus]
      @OrderID bigint,
      @Status int = null
as


update salesorder.[WirelessAccount]
set activationstatus = @Status, activationdate = null
where orderid = @OrderID 

update wl
set wl.activationstatus = @Status
from salesorder.[OrderDetail] od inner join salesorder.[Wirelessline] wl on 
  wl.orderdetailid = od.orderdetailid
where od.OrderID = @OrderID