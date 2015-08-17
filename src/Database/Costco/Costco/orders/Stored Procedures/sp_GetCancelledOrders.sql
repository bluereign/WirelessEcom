CREATE procedure [orders].[sp_GetCancelledOrders]
as
	select q.QueueID, q.Active,  q.CreatedOn, q.ModifiedOn, q.AutomationProcessed, q.AutomationStatus,
	 q.UserInterventionRequired, q.OrderID, o.GERSStatus, q.Attempt, q.OrderDate, q.Processing, q.AccessToken
	 from salesorder.[Order] o with (nolock) LEFT JOIN[Orders].[OrderQueue] q with (nolock) 
	   ON o.OrderID = q.OrderID
	where o.Status = 4 and q.Active = 1