
-- =============================================
-- Author:		Ron Delzer
-- Create date: 10/13/2010
-- Description:	Returns TRUE if the @InDate
--              parameter is a Saturday or Sunday
-- =============================================
CREATE FUNCTION [service].[IsWeekend] 
(
	@InDate date
)
RETURNS bit
AS
BEGIN
	DECLARE @Result bit;

	IF (DATEPART(weekday, @InDate) IN (1, 7)) SET @Result = 1
	ELSE SET @Result = 0

	RETURN @Result

END