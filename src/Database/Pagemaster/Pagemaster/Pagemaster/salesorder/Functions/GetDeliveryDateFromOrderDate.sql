
CREATE FUNCTION [salesorder].[GetDeliveryDateFromOrderDate] 
(
	@OrderDate datetime,
	@IsOvernightShipping bit
)
RETURNS date
AS
BEGIN


	-- Local Variables
	DECLARE @EffectiveOrderDate date;
	DECLARE @ShipDate date;
	DECLARE @DeliveryDate date;
	DECLARE @Hours smallint=11;
	DECLARE @EffectiveOrderDay smallint;
	DECLARE @GetShipDays smallint;
	DECLARE @Holidays smallint;
	
SET @EffectiveOrderDate =DATEADD(hour, @Hours, @OrderDate);



SELECT @EffectiveOrderDay=DATEPART(weekday,DATEADD(hour, @Hours, @OrderDate))

IF @IsOvernightShipping=0
SELECT	@GetShipDays=CASE
		WHEN @EffectiveOrderDay=1 THEN 5
		WHEN @EffectiveOrderDay=2 THEN 4
		ELSE 6 END
		
IF @IsOvernightShipping=1
SELECT	@GetShipDays=CASE
		WHEN @EffectiveOrderDay=1 THEN 4
		WHEN @EffectiveOrderDay IN (2,3) THEN 3
		ELSE 5 END
		

SET @DeliveryDate=DATEADD(d,@GetShipDays,@EffectiveOrderDate)


SELECT	@Holidays=Count(u.Day)
FROM	ups.GetHolidays (year(getdate())) u
WHERE	U.Day between @EffectiveOrderDate and @DeliveryDate
		and DATEPART(weekday,u.Day) not in (7,1)

IF @Holidays>0
BEGIN
	
	SET @DeliveryDate=DATEADD(d,@Holidays,@DeliveryDate)

	SELECT @GetShipDays=CASE	
			WHEN DATEPART(weekday,@DeliveryDate)=7 THEN 2
			WHEN DATEPART(weekday,@DeliveryDate)=1 THEN 1
			ELSE 0 END
			
	IF @GetShipDays>0
		SET @DeliveryDate=DATEADD(d,@GetShipDays,@DeliveryDate)
END
RETURN @DeliveryDate

END
--SELECT @EffectiveOrderDate EffDate, @DeliveryDate DeliveryDate,@Holidays Holidays