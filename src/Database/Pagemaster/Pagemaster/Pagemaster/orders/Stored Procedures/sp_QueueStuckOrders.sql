CREATE PROCedure [orders].[sp_QueueStuckOrders]
      @Environment varchar(5) = null
as

-- Statement 1 checks for Order Detail items that do not have an IMEI assigned to it and Payment Amount set
insert into [orders].[OrderQueue]
(Active, CreatedOn, ModifiedOn, AutomationProcessed, AutomationStatus, UserInterventionRequired, OrderID, GERSStatus, OrderDate, Processing, OrderErrorType)   
 SELECT distinct 1 as Active, getdate() as CreatedOn, null as ModifiedOn, 0, 'Not processed yet', 0, o.OrderID, -100 as GERSStatus, o.OrderDate, @Environment, 0
  FROM salesorder.[order] o with (nolock) LEFT join salesorder.OrderDetail  d with (nolock) 
  ON d.OrderId=o.OrderId  RIGHT  join salesorder.WirelessLine w
  ON d.OrderDetailId=w.OrderDetailId  LEFT JOIN [orders].[OrderQueue] q with (nolock)
   ON o.OrderID = q.OrderID right JOIN [salesorder].[Payment] p with (nolock) on p.OrderID = o.OrderID
  WHERE CONVERT(VARCHAR(10),o.orderdate,101) BETWEEN  GETDATE()-20 and GETDATE()                
    AND OrderDetailType = 'D'  -- Only look at Devices
    AND (w.IMEI IS NULL OR w.SIM IS NULL) -- Empty IMEI and SIM
    AND (o.Status NOT IN (0,4)) -- Not Pending or Cancelled
    AND (o.GersStatus NOT IN (2,3))
    AND q.OrderID IS NULL  -- Not already in Queue
    AND ((p.PaymentAmount > 0 AND p.PaymentMethodID IS NULL)  -- Payment Amount set, Method Not
      OR (p.PaymentAmount = 0 AND p.PaymentMethodID IS NOT NULL)) -- Payment Amount 0, Method Set

-- Statement 2 checks for Order Detail items that do not have an IMEI assigned to it and no Payment record
insert into [orders].[OrderQueue]
(Active, CreatedOn, ModifiedOn, AutomationProcessed, AutomationStatus, UserInterventionRequired, OrderID, GERSStatus, OrderDate, Processing, OrderErrorType)   
 SELECT distinct 1 as Active, getdate() as CreatedOn, null as ModifiedOn, 0, 'Not processed yet', 0, o.OrderID, -101 as GERSStatus, o.OrderDate,@Environment , 0
  FROM salesorder.[order] o with (nolock) LEFT join salesorder.OrderDetail  d with (nolock) 
  ON d.OrderId=o.OrderId  RIGHT  join salesorder.WirelessLine w
  ON d.OrderDetailId=w.OrderDetailId  LEFT JOIN [orders].[OrderQueue] q with (nolock)
   ON o.OrderID = q.OrderID right JOIN [salesorder].[Payment] p with (nolock) on p.OrderID = o.OrderID
  WHERE CONVERT(VARCHAR(10),o.orderdate,101) BETWEEN  GETDATE()-20 and GETDATE()                
    AND OrderDetailType = 'D' -- Only look at Devices
    AND (w.IMEI IS NULL OR w.SIM IS NULL) -- Empty IMEI and SIM
    AND (o.Status NOT IN (0,4)) -- Not Pending or Cancelled
    AND q.OrderID IS NULL  -- Not already in Queue
    AND p.PaymentID IS NULL
    
-- Statement 3 looks for Orders with < GersStatus and not added to the Queue yet.
  insert into [orders].[OrderQueue]
   (Active, CreatedOn, ModifiedOn, AutomationProcessed, AutomationStatus, UserInterventionRequired, OrderID, GERSStatus, OrderDate, Processing, OrderErrorType)   
  select distinct 1 as Active, getdate() as CreatedOn, null as ModifiedOn, 0, 'Not processed yet', 0, o.OrderID,  o.GERSStatus, o.OrderDate, @Environment, 0
  from salesorder.[Order] o with (nolock) LEFT JOIN [orders].[OrderQueue] q with (nolock)
   ON o.OrderID = q.OrderID 
  where o.GERSStatus < 0 -- Flagged by Weblink as a bad order
  AND ((q.OrderID IS NULL)) -- Not already in Queue
  AND (o.Status NOT IN (0,4)) -- Not Pending or Cancelled