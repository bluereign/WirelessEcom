CREATE procedure [dbo].[GetFailedOrders] (
	@StartDate datetime,
	@EndDate datetime = null,
	@UtcOffset int = -7,
	@ClientId varchar(50) = null
)
as
begin
	declare @SuccessfulOrders table (
		ClientId nvarchar(50),
		ReferenceId nvarchar(50),
		DeviceId nvarchar(50)
	)

	insert @SuccessfulOrders
	select distinct ClientId, ReferenceId, StringValue as 'DeviceId' from dbo.SuccessfulOrders 
	where (@ClientId is null or @ClientId = ClientId)
	  and @StartDate < dateadd(hh, @UtcOffset, LoggedDateTime)
	  and (@EndDate is null or @EndDate > dateadd(hh, @UtcOffset, LoggedDateTime))
	  and StringName='deviceId'

	-- return failed orders
	select
	   [ServiceLogId]
      ,[LoggedDateTime]
      ,[ClientId]
      ,[ReferenceId]
      ,[StringName]
      ,[StringValue]
	 from dbo.FailedOrders
	where (@ClientId is null or @ClientId = ClientId)
	  and @StartDate < dateadd(hh, @UtcOffset, LoggedDateTime)
	  and (@EndDate is null or @EndDate > dateadd(hh, @UtcOffset, LoggedDateTime))	  
	  and ReferenceId in (
		select ReferenceId 
		  from dbo.FailedOrders
		 where StringName='deviceId'		   
		   and StringValue not in (
		     select DeviceId from @SuccessfulOrders
			 )
	  )
end