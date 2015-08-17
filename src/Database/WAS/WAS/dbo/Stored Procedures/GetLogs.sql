


CREATE PROCEDURE [dbo].[GetLogs] (
	@StartDate datetime,
	@EndDate datetime = NULL,
	@UtcOffset int = 0,
	@ClientId varchar(50) = NULL
)
AS
BEGIN	
	SELECT		
		s.[ServiceLogId]
		,DATEADD(hh, @UtcOffset, s.LoggedDateTime) AS 'LoggedDateTime'
		,s.[ClientId]
        ,s.[ReferenceId]
        ,s.[ApiName]
        ,s.[LogType]
        ,s.[LogDirection]
        ,s.[Data]        
		,e.ErrorLogId
		,e.ErrorCode
		,e.ErrorMessage 
	FROM ServiceLogs s
	LEFT JOIN ErrorLogs e ON e.ServiceLogId = s.ServiceLogId
	WHERE @StartDate < dateadd(hh, @UtcOffset, s.LoggedDateTime)
	  AND (@EndDate is null or @EndDate > dateadd(hh, @UtcOffset, s.LoggedDateTime))
	  AND (@ClientId is null or @ClientId = s.ClientId)
	ORDER BY s.LoggedDateTime DESC
END
GO