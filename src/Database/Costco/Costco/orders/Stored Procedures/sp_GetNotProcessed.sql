CREATE procedure [orders].[sp_GetNotProcessed]
as
	select QueueID, Active, CreatedOn, ModifiedOn, AutomationProcessed, AutomationStatus,
	 UserInterventionRequired, OrderID, GERSStatus, Attempt, OrderDate,
	 Processing, OrderErrorType, AccessToken from [Orders].[OrderQueue] with (nolock)
	where UserInterventionRequired = 0 and Active = 1