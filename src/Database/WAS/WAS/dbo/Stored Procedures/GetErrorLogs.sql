
-- =============================================
-- Author:		Andrew Stringer
-- Create date: 2014-09-03
-- Description:	Retrieves error logs for AppleCare service.
--     @StartDate - less than LoggedDateTime value.
--     @EndDate - greater than LoggedDateTime value.
--     @UtcOffset - a signed int to specify the timezone used for @StartDate and @EndDate. It is the
--        offset from UTC.
-- Updates:
-- =============================================

CREATE PROCEDURE [dbo].[GetErrorLogs] (
	@StartDate datetime,
	@EndDate datetime = NULL,
	@UtcOffset int = 0
)
AS
BEGIN
	select
		e.ErrorLogId
		,e.ErrorCode
		,e.ErrorMessage 
		,s.[ServiceLogId]
		,DATEADD(hh, @UtcOffset, s.LoggedDateTime) AS 'LoggedDateTime'
		,s.[ClientId]
		,s.[ReferenceId]
		,s.[ApiName]
		,s.[LogType]
		,s.[LogDirection]
		,s.[Data]		
	from dbo.ErrorLogs e
	 left join dbo.ServiceLogs s on s.ServiceLogId = e.ServiceLogId
	where @StartDate < dateadd(hh, @UtcOffset, e.LoggedDateTime)
		and (@EndDate is null or @EndDate > dateadd(hh, @UtcOffset, e.LoggedDateTime))
	order by e.LoggedDateTime desc

	select
		row_number() over(partition by  dateadd(DAY,0, datediff(day,0, LoggedDateTime))
								 order by ErrorMessage) as 'Row Number',
		dateadd(DAY,0, datediff(day,0, LoggedDateTime)) as 'LoggedDateTime'
		,max(ErrorCode) as 'ErrorCode'
		,ErrorMessage
		,count(*) as 'Count'
	from dbo.ErrorLogs
	where @StartDate < dateadd(hh, @UtcOffset, LoggedDateTime)
		and (@EndDate is null or @EndDate > dateadd(hh, @UtcOffset, LoggedDateTime))
	group by dateadd(DAY,0, datediff(day,0, LoggedDateTime)), ErrorMessage
	order by dateadd(DAY,0, datediff(day,0, LoggedDateTime)) desc, ErrorCode
END
GO