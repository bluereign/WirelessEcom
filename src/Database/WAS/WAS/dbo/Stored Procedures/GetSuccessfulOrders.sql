
-- =============================================
-- Author:		Andrew Stringer
-- Create date: 2014-09-03
-- Description:	Retrieves successful AppleCare sales and total sales per Client Id.
--     @StartDate - less than LoggedDateTime value.
--     @EndDate - greater than LoggedDateTime value.
--     @UtcOffset - a signed int to specify the timezone used for @StartDate and @EndDate. It is the
--        offset from UTC.
-- Updates:
-- =============================================

CREATE PROCEDURE [dbo].[GetSuccessfulOrders] (
	@StartDate datetime,
	@EndDate datetime = NULL,
	@UtcOffset int = 0
)
AS begin
	select [ServiceLogId]
		  ,dateadd(hh, @UtcOffset, LoggedDateTime) as 'LoggedDateTime'
		  ,[ClientId]
		  ,[ReferenceId]
		  ,[StringName]
		  ,[StringValue]
	from [dbo].[SuccessfulOrders]
	where @StartDate < dateadd(hh, @UtcOffset, LoggedDateTime)
    and (@EndDate is null or @EndDate > dateadd(hh, @UtcOffset, LoggedDateTime))
	order by LoggedDateTime desc

    select [ServiceLogId]
		  ,dateadd(hh, @UtcOffset, LoggedDateTime) as 'LoggedDateTime'
		  ,[ClientId]
		  ,[ReferenceId]
		  ,[StringName]
		  ,[StringValue]
	from [dbo].[SuccessfulOrders]
	where @StartDate < dateadd(hh, @UtcOffset, LoggedDateTime)
    and (@EndDate is null or @EndDate > dateadd(hh, @UtcOffset, LoggedDateTime))
	and StringName = 'deviceId'
	order by LoggedDateTime desc	

	select ClientId, count(*) as 'Count'
	  from dbo.ServiceLogs
	 where ApiName = 'CreateOrder'
	and LogType = 'Response'
	and LogDirection = 'Inbound'
	and @StartDate < dateadd(hh, @UtcOffset, LoggedDateTime)
	and (@EndDate is null or @EndDate > dateadd(hh, @UtcOffset, LoggedDateTime))
	group by ClientId
	order by count(*) desc
end
GO