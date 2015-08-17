-- =============================================
-- Author:		Andrew Stringer
-- Create date: 
-- Description:	
-- =============================================

CREATE PROCEDURE dbo.GetLogs (@StartDate DATETIME = NULL,
@ClientId VARCHAR(50) = NULL)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	IF @StartDate IS NULL
	BEGIN
		SET @StartDate = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))
	END

	SELECT
		*
	FROM (SELECT
		'KioskApp' AS 'Source',
		s1.*,
		e1.ErrorLogId,
		e1.ErrorCode,
		e1.ErrorMessage
	FROM ServiceLogs s1
	LEFT JOIN ErrorLogs e1
		ON e1.ServiceLogId = s1.ServiceLogId
	UNION
	SELECT
		'WAS' AS 'Source',
		s2.*,
		e2.ErrorLogId,
		e2.ErrorCode,
		e2.ErrorMessage
	FROM [$(WAS)].dbo.ServiceLogs s2
	LEFT JOIN [$(WAS)].dbo.ErrorLogs e2
		ON e2.ServiceLogId = s2.ServiceLogId) x
	WHERE LoggedDateTime > @StartDate
	AND ClientId = ISNULL(@ClientId, ClientId)
END