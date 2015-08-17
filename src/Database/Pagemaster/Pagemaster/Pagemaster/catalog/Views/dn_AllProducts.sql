CREATE VIEW [catalog].[dn_AllProducts]
AS
SELECT DeviceGuid, CarrierGuid, ManufacturerGuid, UPC, Name FROM catalog.device
UNION
SELECT TabletGuid, CarrierGuid, ManufacturerGuid, UPC, Name FROM catalog.tablet