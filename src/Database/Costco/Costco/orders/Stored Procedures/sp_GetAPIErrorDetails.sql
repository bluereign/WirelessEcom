	   
	   
CREATE proc [orders].[sp_GetAPIErrorDetails]
	@OrderID bigint
as

SELECT (SELECT TOP 1 Description FROM salesorder.Activity a WHERE a.OrderId = o.OrderId and Name = 'Weblink Failure' ORDER BY TimeStamp DESC)
 as Description
      ,(SELECT TOP 1 Timestamp FROM salesorder.Activity a WHERE a.OrderId = o.OrderId and Name = 'Weblink Failure' ORDER BY TimeStamp DESC)
 as Timestamp
FROM salesorder.[Order] o
WHERE o.OrderId = @OrderID