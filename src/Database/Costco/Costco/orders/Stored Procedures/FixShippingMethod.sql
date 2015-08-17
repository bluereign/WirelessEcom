
CREATE  proc [orders].[FixShippingMethod]
@OrderID bigint

AS 

update salesorder.[Order] 
set ShipMethodId =2
where OrderId=@OrderID 
  
Update  salesorder.[Order] 
Set GERSStatus =0
Where orderid= @OrderID