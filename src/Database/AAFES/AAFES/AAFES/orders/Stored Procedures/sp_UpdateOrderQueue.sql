CREATE PROCedure [orders].[sp_UpdateOrderQueue]
	 @QueueID bigint,
	 @Active bit = true,
	 @AutomationProcessed bit = false,
	 @AutomationStatus varchar(255) = '',
	 @UserInterventionRequired bit = false,
	 @Attempt int,
	 @ModifiedOn datetime,
	 @Processing varchar(6) = null,
	 @OrderErrorType int = null,
	 @AccessToken uniqueidentifier,
	 @GersStatus int
as

	update [orders].[OrderQueue]
	set Active = @Active,
		AutomationProcessed = @AutomationProcessed,
		AutomationStatus = @AutomationStatus,
		UserInterventionRequired = @UserInterventionRequired,
		ModifiedOn = CONVERT(DATETIME, @ModifiedOn, 101),
		Attempt = @Attempt,
		Processing = @Processing,
		OrderErrorType = @OrderErrorType,
		AccessToken = @AccessToken,
		GersStatus = @GersStatus
	where QueueID = @QueueID