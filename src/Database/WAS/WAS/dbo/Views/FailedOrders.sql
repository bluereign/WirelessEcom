
CREATE VIEW [dbo].[FailedOrders]
AS
SELECT
	s.[ServiceLogId],
	s.LoggedDateTime,
	s.[ClientId],
	s.[ReferenceId],
	d.NAME AS 'StringName',
	d.StringValue
FROM [dbo].[ServiceLogs] s
CROSS APPLY dbo.ParseJSON(s.Data) d
INNER JOIN dbo.ErrorLogs e
	ON e.ServiceLogId = s.ServiceLogId
WHERE ApiName = 'VerifyOrder'