
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    CREATE VIEW COSTCO.AccessoryForDevice AS 
    SELECT DISTINCT DeviceGuid,AccessoryGuid,Ordinal FROM [COSTCO].[AccessoryForDeviceStage] WHERE AccessoryGuid IS NOT NULL AND DeviceGuid IS NOT NULL
GO
