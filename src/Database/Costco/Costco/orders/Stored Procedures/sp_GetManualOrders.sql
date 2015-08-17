CREATE procedure [orders].[sp_GetManualOrders]
as
	select QueueID, Active, CreatedOn, ModifiedOn, AutomationProcessed, AutomationStatus,
	 UserInterventionRequired, OrderID, GERSStatus,
	  Attempt, OrderDate, Processing, OrderErrorType, AccessToken from [Orders].[OrderQueue] with (nolock)
	where UserInterventionRequired = 1 and Active = 1
	order by OrderDate DESC