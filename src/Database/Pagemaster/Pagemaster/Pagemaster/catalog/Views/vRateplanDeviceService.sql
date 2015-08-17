
CREATE view [catalog].[vRateplanDeviceService]
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