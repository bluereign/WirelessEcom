SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [service].[MergeIncomingDeviceFreeAccessory]
AS
BEGIN
	SET NOCOUNT ON;

	-- Use cursor to create new accessories
	DECLARE @NewAccessorySku nvarchar(9);
	DECLARE @NewAccessoryUPC nvarchar(9);
	DECLARE @NewAccessoryName nvarchar(30);

	DECLARE NewAccessoryCursor INSENSITIVE CURSOR FOR
		SELECT DISTINCT I.AccessorySku, I.AccessoryVendorServiceNumber, I.AccessoryDescription
		FROM [service].[IncomingFreeAccessories] I
			LEFT OUTER JOIN [catalog].[Product] P ON I.AccessorySku = P.GersSku
		WHERE P.ProductId IS NULL 
	;

	OPEN NewAccessoryCursor;
	FETCH NEXT FROM NewAccessoryCursor INTO @NewAccessorySku, @NewAccessoryUPC, @NewAccessoryName;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC [catalog].[CreateFreeAccessory] @NewAccessorySku, @NewAccessoryUPC, @NewAccessoryName;
		FETCH NEXT FROM NewAccessoryCursor INTO @NewAccessorySku, @NewAccessoryUPC, @NewAccessoryName;
	END

	CLOSE NewAccessoryCursor;
	DEALLOCATE NewAccessoryCursor;


	-- Update Device to Free Accessory relationship table
	MERGE INTO [catalog].[DeviceFreeAccessory] AS trg
	USING (SELECT D.ProductGuid AS DeviceGuid
				,A.ProductGuid
				,'1753-01-01' AS StartDate -- smallest datetime date
				,'9999-12-31' AS EndDate   -- largetst datetime date
			FROM [service].[IncomingFreeAccessories] I
				INNER JOIN [catalog].[Product] D ON I.PhoneSku = D.GersSku
				INNER JOIN [catalog].[Product] A ON I.AccessorySku = A.GersSku
			) AS src
	ON trg.DeviceGuid = src.DeviceGuid
		AND trg.ProductGuid = src.ProductGuid
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (DeviceGuid, ProductGuid, StartDate, EndDate)
			VALUES (src.DeviceGuid, src.ProductGuid, src.StartDate, src.EndDate)
	WHEN MATCHED THEN
		UPDATE SET trg.StartDate = src.StartDate, trg.EndDate = src.EndDate
	WHEN NOT MATCHED BY SOURCE THEN
		DELETE
	;
END
GO
