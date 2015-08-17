

CREATE FUNCTION [salesorder].[GetOrderSLA] (@OrderDate datetime)
	RETURNS date
AS
BEGIN

DECLARE @WeekDay tinyint;
DECLARE @SLADays tinyint;
DECLARE @SLA date;

SET	@Weekday = DATEPART(weekday,@OrderDate);

SELECT	@SLADays=
		CASE
		WHEN @Weekday IN(1,2,3,4) THEN 2
		WHEN @Weekday IN(5,6) THEN 4
		WHEN @Weekday=7 THEN 3
		END 

SET	@SLA=DATEADD(dd,@SLADays,@OrderDate);	


RETURN @SLA;

END