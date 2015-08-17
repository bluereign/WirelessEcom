-- =============================================
-- Author:		Ron Delzer
-- Create date: 10/13/2010
-- Description:	
-- =============================================
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

	-- Daily order cutoff is 6:00PM Pacific.
	-- Logic: if (CurrentTime < 6:00 PM) then Today else Tomorrow
	-- Optimizing by adding 6 hours to now, then truncating the time portion.
	SET @EffectiveOrderDate = CONVERT(date, DATEADD(hour, 6, @OrderDate));

	-- Build temp table of dates
	DECLARE @Dates TABLE 
	(
		Day date, 
		IsWeekend bit
	);
	DECLARE @TempDate date;
	DECLARE @I int = 0;
	WHILE (@I < 30)
	BEGIN
		SET @TempDate = DATEADD(day, @I, @EffectiveOrderDate);
		INSERT INTO @Dates VALUES (@TempDate, service.IsWeekend(@TempDate));
		SET @I = @I + 1;
	END
	
	--Determine Ship Date and Delivery Date
	IF (@IsOvernightShipping = 1)
	BEGIN
		-- @ShipDate = next valid pickup date on or after @OrderDate + 2
		SELECT TOP(2) @ShipDate = D.Day
		FROM @Dates D LEFT OUTER JOIN ups.HolidayCalendar UH on D.Day = UH.Day
		WHERE D.Day > @EffectiveOrderDate AND D.IsWeekend = 0 AND ISNULL(UH.IsAirPickupDay, 1) = 1;
		
		-- @DeliverDate = next valid deliver date on or after @ShipDate + 1
		SELECT TOP(1) @DeliveryDate = D.Day
		FROM @Dates D LEFT OUTER JOIN ups.HolidayCalendar UH on D.Day = UH.Day
		WHERE D.Day > @ShipDate AND D.IsWeekend = 0 AND ISNULL(UH.IsAirDeliveryDay, 1) = 1;
	END
	ELSE
	BEGIN
		-- @ShipDate = next valid pickup date on or after @OrderDate + 2
		SELECT TOP(2) @ShipDate = D.Day
		FROM @Dates D LEFT OUTER JOIN ups.HolidayCalendar UH on D.Day = UH.Day
		WHERE D.Day > @EffectiveOrderDate AND D.IsWeekend = 0 AND ISNULL(UH.IsPickupDay, 1) = 1;
		
		-- @DeliverDate = next valid deliver date on or after @ShipDate + 2
		SELECT TOP(2) @DeliveryDate = D.Day
		FROM @Dates D LEFT OUTER JOIN ups.HolidayCalendar UH on D.Day = UH.Day
		WHERE D.Day > @ShipDate AND D.IsWeekend = 0 AND ISNULL(UH.IsDeliveryDay, 1) = 1;
	END
	
	-- Return the result of the function
	RETURN @DeliveryDate
END
