SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* Push Static Data to catalog.ServiceDataFeature */

CREATE VIEW [AAFES].[ServiceDataFeature] AS

SELECT
	crd.ServiceDataFeatureId
	,crd.ServiceGuid
	,crd.ServiceDataGroupGuid
	,crd.DeviceType
FROM
	catalog.ServiceDataFeature crd
INNER JOIN catalog.Product cp ON cp.ProductGuid = crd.ServiceGuid
WHERE cp.ChannelID = '3'
GO
