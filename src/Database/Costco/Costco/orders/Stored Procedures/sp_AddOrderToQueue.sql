CREATE procedure [orders].[sp_AddOrderToQueue]
	@Environment varchar(5) = null,
	@OrderID bigint
as


insert into [orders].[OrderQueue]
 (Active, CreatedOn, ModifiedOn, AutomationProcessed, AutomationStatus, UserInterventionRequired, OrderID, GERSStatus, OrderDate, Processing, OrderErrorType)   
 SELECT distinct 1 as Active, getdate() as CreatedOn, null as ModifiedOn, 0, 'Not processed yet - addded manually', 0, o.OrderID, -102 as GERSStatus, o.OrderDate,@Environment , 0
  FROM salesorder.[order] o with (nolock) LEFT join salesorder.OrderDetail  d with (nolock) 
  ON d.OrderId=o.OrderId  RIGHT  join salesorder.WirelessLine w
  ON d.OrderDetailId=w.OrderDetailId  LEFT JOIN [orders].[OrderQueue] q with (nolock)
   ON o.OrderID = q.OrderID 
  WHERE q.OrderID IS NULL  -- Not already in Queue
 and o.OrderID = @OrderID