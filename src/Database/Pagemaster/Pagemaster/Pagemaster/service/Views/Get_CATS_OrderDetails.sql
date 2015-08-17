

create view service.Get_CATS_OrderDetails 
as

select distinct o.OrderID, os.LineID, os.MobileNumber, os.AccountNo, os.ReferenceNum from
 [service].[VerizonCatsOrderStatus] os inner join [salesorder].[Order] o on
 os.ReferenceNum = o.checkoutreferencenumber