-- =============================================
-- Author:		Ron Delzer
-- Create date: 10/14/2010
-- Description:	
-- =============================================
CREATE FUNCTION [ups].[GetZoneListForZipCode] 
(	
	-- Add the parameters for the function here
	@ZipCode nvarchar(5)
)
RETURNS TABLE 
AS
RETURN 
(
	WITH ZoneListForZip AS
	(
		SELECT DestinationZip, GroundZone, ServiceAbbreviation, ZoneCode
		FROM
		(
			SELECT DestinationZip
				 , ZoneGround AS GroundZone
				 , ZoneNextDay AS ND
				 , ZoneNextDaySaver AS NDS
				 , Zone2DayAM AS [2DA]
				 , Zone2Day AS [2D]
				 , Zone3Day AS [3D]
				 , ZoneGround AS G
			FROM ups.GetZonesForZipCode(@ZipCode)
		) AS p
		UNPIVOT (ZoneCode FOR ServiceAbbreviation IN (ND, NDS, [2DA], [2D], [3D], G)) AS upvt
	)
	SELECT ZL.DestinationZip AS DestinationZipRange 
		, ST.Name AS ServiceName
		, ST.Title AS ServiceTitle
		, ST.GersZoneCode AS GersZone
		, ZL.GroundZone
		, ZL.ZoneCode AS Zone
		, TT.TransitDays
		, ups.GetDeliveryDateFromTransitDays(TT.TransitDays, ST.IsAir) AS ExpectedDeliveryDate
		, ST.Ordinal AS ServiceOrdinal
	FROM ups.ServiceType ST
		INNER JOIN ZoneListForZip ZL
			ON ST.Abbreviation = ZL.ServiceAbbreviation
		INNER JOIN ups.TransitTime TT
			ON ZL.ZoneCode = TT.Zone
)
