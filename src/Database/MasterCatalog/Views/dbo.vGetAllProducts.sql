SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vGetAllProducts]
as
SELECT AccessoryGuid AS ProductGuid, [Name] AS Title FROM catalog.Accessory
UNION ALL
SELECT ServiceGuid AS ProductGuid, Title FROM catalog.[Service]
UNION ALL
SELECT RatePlanGuid AS ProductGuid, Title FROM catalog.Rateplan
UNION ALL
SELECT DeviceGuid AS ProductGuid, [Name] AS Title FROM catalog.Device
GO
