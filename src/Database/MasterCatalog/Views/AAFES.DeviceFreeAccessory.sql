
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* Push Static Data to catalog.DeviceFreeAccessory */

CREATE VIEW [AAFES].[DeviceFreeAccessory] AS

SELECT
	cdfa.DeviceFreeAccessoryGuid
	,cdfa.DeviceGuid
	,cdfa.ProductGuid
	,cdfa.StartDate
	,cdfa.EndDate
FROM
	catalog.DeviceFreeAccessory cdfa
WHERE cdfa.DeviceGuid IN (SELECT ProductGuid FROM catalog.Product WHERE ChannelID = '3')
AND cdfa.ProductGuid IN (SELECT ProductGuid FROM catalog.Product WHERE ChannelID = '3')


GO
