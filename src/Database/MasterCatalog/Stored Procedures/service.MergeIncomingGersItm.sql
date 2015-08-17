SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [service].[MergeIncomingGersItm]
AS
BEGIN
	SET NOCOUNT ON;
      
	MERGE INTO [catalog].[GersItm] AS trg
	USING [service].[IncomingGersItm] AS src
	ON (trg.GersSku = src.GersSku)
	WHEN MATCHED THEN
		UPDATE SET [VendorCode] = src.VendorCode
				 , [MajorCode] = src.MajorCode
				 , [MinorCode] = src.MinorCode
				 , [ItemTypeCode] = src.ItemTypeCode
				 , [CategoryCode] = src.CategoryCode
				 , [VendorStockNumber] = src.VendorStockNumber
				 , [Description] = src.[Description]
				 , [DescriptionAlternate] = src.DescriptionAlternate
				 , [DropCode] = src.DropCode
				 , [DropDate] = src.DropDate
				 , [UPC] = ISNULL(src.UPC, trg.UPC)
				 , [isPreventSale] = (CASE WHEN src.PreventSale = 'Y' THEN 1 ELSE 0 END)
				 , [isDeleted] = 0
	WHEN NOT MATCHED BY TARGET AND src.PreventSale != 'Y' THEN
		INSERT ([GersSku],[VendorCode],[MajorCode],[MinorCode],[ItemTypeCode],[CategoryCode],[VendorStockNumber]
		       ,[Description],[DescriptionAlternate],[DropCode],[DropDate],[UPC])
		VALUES ([src].GersSku,[src].VendorCode,[src].MajorCode,[src].MinorCode,[src].ItemTypeCode,[src].CategoryCode,[src].VendorStockNumber
		       ,[src].[Description],[src].[DescriptionAlternate],[src].[DropCode],[src].[DropDate],[src].[UPC])
	WHEN NOT MATCHED BY SOURCE AND trg.isManual != 1 THEN
			UPDATE SET [isDeleted] = 1
	;
END
GO
