SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [logging].[sp_dp_prodstart] AS
BEGIN
	
	IF (SELECT TOP 1 Pushed FROM logging.DataPush ORDER BY Timestamp DESC) = 'STAGE'
	BEGIN

	INSERT INTO logging.DataPush (Pushed)
	SELECT 'PROD'

	END	ELSE
	PRINT 'Data has not been pushed to STAGE yet, so data cannot be pushed to PROD.'

END



GO
