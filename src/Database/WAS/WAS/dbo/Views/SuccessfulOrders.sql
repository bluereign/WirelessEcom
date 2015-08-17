
CREATE VIEW [dbo].[SuccessfulOrders]
AS
SELECT
	s.[ServiceLogId],
	s.LoggedDateTime,
	s.[ClientId],
	s.[ReferenceId],
	d.NAME AS 'StringName',
	d.StringValue
FROM [dbo].[ServiceLogs] s
CROSS APPLY dbo.ParseJSON(s.Data) AS d
WHERE ApiName = 'CreateOrder'
AND LogType = 'Response'
AND LogDirection = 'Inbound'