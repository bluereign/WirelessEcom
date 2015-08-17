-- =============================================
-- Author:		Ron Delzer
-- Create date: 10/8/2010
-- Description:	Return UPS Zones for Specified Zip Code
-- =============================================
CREATE FUNCTION [ups].[GetZonesForZipCode]
(	
	-- Add the parameters for the function here
	@ZipCode nvarchar(5)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT CASE LEN(ZipStart) WHEN 5 THEN ZipStart ELSE ZipStart + '-' + ZipEnd END AS DestinationZip
		, ZoneGround
		, Zone3Day
		, Zone2Day
		, Zone2DayAM
		, ZoneNextDaySaver
		, ZoneNextDay
	FROM ups.ZoneCodes980
	WHERE LEN(@ZipCode) = 5 AND ((ZipStart = @ZipCode) OR (ZipStart <= LEFT(@ZipCode, 3) AND ZipEnd >= LEFT(@ZipCode, 3)))
)