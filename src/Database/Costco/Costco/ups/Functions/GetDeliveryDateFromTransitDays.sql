-- =============================================
-- Author:		Ron Delzer
-- Create date: 10/15/2010
-- Description:	
-- =============================================
CREATE FUNCTION [ups].[GetDeliveryDateFromTransitDays]
(
	@TransitDays int,
	@IsAir bit
)
RETURNS date
AS
BEGIN
	DECLARE @PackDate date;
	DECLARE @ShipDate date;
	DECLARE @DeliveryDate date;
	
	-- Daily Shipping Cutoff time is 1:00PM Pacific.
	-- Logic: if (CurrentTime < 1:00 PM) then Today else Tomorrow
	-- Optimizing by adding 11 hours to now, then truncating the time portion.
	SET @PackDate = CONVERT(date, DATEADD(hour, 11, GETDATE()));

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
		SET @TempDate = DATEADD(day, @I, @PackDate);
		INSERT INTO @Dates VALUES (@TempDate, service.IsWeekend(@TempDate));
		SET @I = @I + 1;
	END
	
	--Determine Ship Date and Delivery Date
	IF (@IsAir = 1)
	BEGIN
		-- @ShipDate = next valid pickup date on or after @PackDate
		WITH ShipDays AS
		(
			SELECT D.Day, ROW_NUMBER() OVER (ORDER BY D.Day) AS SEQ
			FROM @Dates D LEFT OUTER JOIN ups.HolidayCalendar UH on D.Day = UH.Day
			WHERE D.Day >= @PackDate AND D.IsWeekend = 0 AND ISNULL(UH.IsAirPickupDay, 1) = 1
		)
		SELECT @ShipDate = Day FROM ShipDays WHERE SEQ = 1;
		
		-- @DeliverDate = next valid delivery date on or after @ShipDate + @TransitDays
		WITH DeliveryDays AS
		(
			SELECT D.Day, ROW_NUMBER() OVER (ORDER BY D.Day) AS SEQ
			FROM @Dates D LEFT OUTER JOIN ups.HolidayCalendar UH on D.Day = UH.Day
			WHERE D.Day > @ShipDate AND D.IsWeekend = 0 AND ISNULL(UH.IsAirDeliveryDay, 1) = 1
		)
		SELECT @DeliveryDate = Day FROM DeliveryDays WHERE SEQ = @TransitDays;
	
	END
	ELSE
	BEGIN
		WITH ShipDays AS
		(
			SELECT D.Day, ROW_NUMBER() OVER (ORDER BY D.Day) AS SEQ
			FROM @Dates D LEFT OUTER JOIN ups.HolidayCalendar UH on D.Day = UH.Day
			WHERE D.Day >= @PackDate AND D.IsWeekend = 0 AND ISNULL(UH.IsPickupDay, 1) = 1
		)
		SELECT @ShipDate = Day FROM ShipDays WHERE SEQ = 1;
		
		-- @DeliverDate = next valid deliver date on or after @ShipDate + 2
		WITH DeliveryDays AS
		(
			SELECT D.Day, ROW_NUMBER() OVER (ORDER BY D.Day) AS SEQ
			FROM @Dates D LEFT OUTER JOIN ups.HolidayCalendar UH on D.Day = UH.Day
			WHERE D.Day > @ShipDate AND D.IsWeekend = 0 AND ISNULL(UH.IsDeliveryDay, 1) = 1
		)
		SELECT @DeliveryDate = Day FROM DeliveryDays WHERE SEQ = @TransitDays;
	END

	-- Return the result of the function
	RETURN @DeliveryDate

END