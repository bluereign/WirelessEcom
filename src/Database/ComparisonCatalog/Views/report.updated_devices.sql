SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[updated_devices]
AS
SELECT 'New' AS 'Updated', cdt.* FROM catalogthisweek.device cdt
INNER JOIN cataloglastweek.device cdl ON cdl.UPC = cdt.UPC
WHERE (cdt.Name <> cdl.Name) OR (cdt.Manufacturer <> cdl.Manufacturer) OR (cdt.CarrierDeviceId <> cdl.CarrierDeviceId)

UNION

SELECT 'Previous' AS 'Updated', cdl.* FROM catalogthisweek.device cdt
INNER JOIN cataloglastweek.device cdl ON cdl.UPC = cdt.UPC
WHERE (cdt.Name <> cdl.Name) OR (cdt.Manufacturer <> cdl.Manufacturer) OR (cdt.CarrierDeviceId <> cdl.CarrierDeviceId)
GO
