SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Ron Delzer
-- Create date: 7/14/2010
-- Description:	
-- =============================================
CREATE PROCEDURE [inventory].[AddFakeInventory] 
	@GersSku nvarchar(9), 
	@Cost money,
	@Quantity int
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @Counter int = 0;
    
    WHILE (@Counter < @Quantity)
    BEGIN TRY    
		INSERT [catalog].[GersStock] ([GersSku]
									, [OutletId]
									, [OutletCode]
									, [StoreCode]
									, [LocationCode]
									, [Qty]
									, [Cost]
									, [FiflDate]
									, [IMEI]
									, [SIM]
									, [OrderDetailId]) 
		VALUES (@GersSku
			  , N'FK' + LEFT(CONVERT(nvarchar(36),NEWID()),8)
			  , N'FAK'
			  , N'XX'
			  , N'FAKEIN'
			  , 1
			  , @Cost
			  , CONVERT(date,GETDATE())
			  , N''
			  , N''
			  , NULL);
    
		SET @Counter = @Counter + 1;
    END TRY
    BEGIN CATCH
		-- Loop without incrementing counter
    END CATCH
    
    -- Update COGS
	MERGE INTO catalog.GersPrice AS target

	USING (SELECT GersSku, 'COG', AVG(Cost), '1/1/1900', '12/31/2049'
			FROM catalog.GersStock
			WHERE OrderDetailId IS NULL AND GersSku = @GersSku
			GROUP BY GersSku) AS source (GersSku, PriceGroupCode, Price, StartDate, EndDate)
			
	ON target.GersSku = source.GersSku AND target.PriceGroupCode = source.PriceGroupCode

	WHEN MATCHED 
		THEN UPDATE SET PriceGroupCode = source.PriceGroupCode, Price = source.Price, StartDate = source.StartDate, EndDate = source.EndDate
	WHEN NOT MATCHED
		THEN INSERT (GersSku, PriceGroupCode, Price, StartDate, EndDate) VALUES (source.GersSku, source.PriceGroupCode, source.Price, source.StartDate, source.EndDate)
	--OUTPUT $action, inserted.*
	;
END

GO
