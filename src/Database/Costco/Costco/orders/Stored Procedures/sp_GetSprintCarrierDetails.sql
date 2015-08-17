CREATE procedure [orders].[sp_GetSprintCarrierDetails]
  @OrderID bigint
as 


select data 
from service.carrierinterfacelog c inner join salesorder.[Order] o 
 on o.checkoutreferencenumber = c.referencenumber
where carrier='sprint' and type = 'request' and o.orderid = @OrderID