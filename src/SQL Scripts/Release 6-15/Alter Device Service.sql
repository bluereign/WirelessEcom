USE [CARTOYS]
GO

/****** Object:  View [catalog].[vRateplanDeviceService]    Script Date: 06/13/2011 18:17:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [catalog].[vRateplanDeviceService]
as

SELECT     *
FROM         catalog.vRateplanDeviceServiceATT
UNION ALL
SELECT     *
FROM         catalog.vRateplanDeviceServiceTMO
UNION ALL
SELECT     *
FROM         catalog.vRateplanDeviceServiceVZW
UNION ALL
SELECT *
FROM     catalog.vRateplanDeviceServiceSPT

GO


