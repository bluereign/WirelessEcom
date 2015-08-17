-- =============================================
-- Author:		Ron Delzer
-- Create date: 8/13/2010
-- Description:	
-- =============================================
CREATE PROCEDURE [catalog].[SetHoldBackQty] 
	-- Add the parameters for the stored procedure here
	@GERSSku nvarchar(9), 
	@HoldBackQty int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ProductGuid uniqueidentifier;
	
	SELECT @ProductGuid = P.ProductGuid FROM catalog.Product P --INNER JOIN catalog.Device D ON P.ProductGuid = D.DeviceGuid
	WHERE P.GersSku = @GERSSku;
	
	IF (@ProductGuid IS NULL)
	BEGIN
		PRINT 'Product not found.';
		RETURN 1;
	END;
	
	MERGE catalog.Property Trg
	USING (VALUES (@ProductGuid, 1, GETDATE(), 'sproc', 'Inventory.HoldBackQty', @HoldBackQty, 1))
		AS Src (ProductGuid, IsCustom, LastmodifiedDate, LastModifiedBy, Name, Value, Active)
	ON (Trg.ProductGuid = Src.ProductGuid AND Trg.Name = Src.Name)
	WHEN MATCHED AND @HoldBackQty IS NULL
		THEN DELETE
	WHEN MATCHED
		THEN UPDATE SET Trg.IsCustom = Src.IsCustom, Trg.LastModifiedDate = Src.LastModifiedDate, Trg.LastModifiedBy = Src.LastModifiedBy, Trg.Value = Src.Value, Trg.Active = Src.Active
	WHEN NOT MATCHED
		THEN INSERT (ProductGuid, IsCustom, LastmodifiedDate, LastModifiedBy, Name, Value, Active)
			VALUES (Src.ProductGuid, Src.IsCustom, Src.LastmodifiedDate, Src.LastModifiedBy, Src.Name, Src.Value, Src.Active);
END