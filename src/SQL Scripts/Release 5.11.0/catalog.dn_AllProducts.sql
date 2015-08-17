
/****** Object:  View [catalog].[dn_AllProducts]    Script Date: 06/17/2014 10:16:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [catalog].[dn_AllProducts]
AS
SELECT DeviceGuid, CarrierGuid, ManufacturerGuid, UPC, Name FROM catalog.device
UNION
SELECT TabletGuid, CarrierGuid, ManufacturerGuid, UPC, Name FROM catalog.tablet

GO


