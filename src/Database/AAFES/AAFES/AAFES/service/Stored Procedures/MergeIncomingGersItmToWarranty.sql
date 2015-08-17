
CREATE PROCEDURE [service].[MergeIncomingGersItmToWarranty] 
AS
BEGIN
       SET NOCOUNT ON;

       MERGE INTO [catalog].[GersItmToWarranty] trg
              USING [service].[IncomingGersItmToWarranty] src
                     ON trg.GersSku = src.GersSku AND trg.WarrantySku = src.WarrantySku
       WHEN MATCHED AND trg.WarrantyPrice != src.WarrantyPrice THEN
              UPDATE SET WarrantyPrice = src.WarrantyPrice
       WHEN NOT MATCHED BY TARGET THEN
              INSERT (GersSku, WarrantySku, WarrantyPrice) VALUES (src.GersSku, src.WarrantySku, src.WarrantyPrice)
       WHEN NOT MATCHED BY SOURCE THEN
              DELETE
       ;
END