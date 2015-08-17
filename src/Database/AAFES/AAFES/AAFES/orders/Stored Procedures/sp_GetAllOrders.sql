CREATE PROCedure [orders].[sp_GetAllOrders]
as
	select QueueID, Active, CreatedOn, ModifiedOn, AutomationProcessed, AutomationStatus,
	 UserInterventionRequired, OrderID, GERSStatus, Attempt, OrderDate,
	 Processing, OrderErrorType, AccessToken from [Orders].[OrderQueue] with (nolock)
	-- where automationprocessed = 0 and userinterventionrequired = 0
	
  order by automationstatus asc, orderdate asc