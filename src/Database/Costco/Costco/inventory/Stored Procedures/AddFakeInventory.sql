
CREATE PROCEDURE [inventory].[AddFakeInventory] ( @GersSku		NVARCHAR(9), 
	                                             @Cost			MONEY,
	                                             @Quantity		INT,
												 @BlockId		INT
											   )
AS


/******************************************************************************************
*
*  Object: AddFakeInventory
*  Schema: inventory
*
*  Example Call:


		DECLARE @GersSku nvarchar(9) = 'AGXNOTE3W', -- GERS SKU from catalog.GersItm table active in catalog.Product table
		        @Cost money = 0.001, -- COGS
		        @Quantity int = 15, -- amount to be added
				@BlockId INT =183
				
		-- Run the SPROC
		EXEC [inventory].[AddFakeInventory] 
		   @GersSku
		  ,@Cost
		  ,@Quantity
		  ,@BlockId
		  
		-- View the SPROC results
		SELECT * FROM catalog.GersStock gs 
		WHERE BlockId = 183

*  Purpose: Generates "virtual inventory" for the provided GersSku

*
*  Date             User          Detail
*  07/14/2010       Ron Delzer    Initial coding
*  08/28/2014		scampbell	  Minor refactor with commenting.	
*  09/03/2014		scampbell	  Added check for existing blockId usage.
*  09/04/2014		scampbell	  Reworked fake OrderId creation to use a numeric value instead of a pseudo-GUID
*
*****************************************************************************************/

BEGIN
	SET NOCOUNT ON;

    DECLARE @Counter			INT = 0;
	 
	CREATE TABLE #FakeSKUs( rowId INT IDENTITY(1,1), sku VARCHAR(10) )

	-- Generate the maximum number of fake skus for a single day ( 4 digits )
	DECLARE @i INT = 0;
	WHILE(@i <= 9999 )
	  BEGIN 
	    INSERT #FakeSKUs( sku )
		  SELECT N'FK' 
	               + RIGHT(CAST(DATEPART(YY, GETDATE()) AS VARCHAR(4)),1) 
				   + CAST(DATEPART(DayOfYear, GETDATE()) AS VARCHAR(3))
				   + RIGHT(CAST(@i AS VARCHAR(5)), 4 )
	      SET @i += 1;
	  END
	  
	  -- Remove any already SKUs already used today
	DELETE #FakeSkus
	  WHERE Sku IN ( SELECT OutletId FROM [catalog].[GersStock] )
	
	DECLARE @FakeCount INT;

	SELECT @FakeCount = COUNT(*) FROM #FakeSKUs

	IF( @FakeCount < @Quantity )
	  BEGIN
	    RAISERROR( 'The request allocation exceeds the virtual skus remaining today.', 10, 1 );
		RETURN;
	  END

	IF EXISTS( SELECT 1 FROM [catalog].[GersStock] WHERE BlockId = @BlockId) 
	  BEGIN
	    RAISERROR( 'The supplied allocation blockId (%i) is already in use.', 10, 1, @BlockId );
		RETURN;
	  END
	  
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
									, [OrderDetailId]
									, [BlockId] )
        SELECT TOP (@Quantity) @GersSku
		      , sku
		      , N'FAK'
			  , N'XX'
			  , N'FAKEIN'
			  , 1
			  , @Cost
			  , CONVERT(date,GETDATE())
			  , N''
			  , N''
			  , NULL
			  , @BlockId 
		  FROM #FakeSKUs
		WHERE sku NOT IN ( SELECT GersSku FROM [catalog].[GersStock] )

    -- Update COGS
	;WITH cogs(GersSku, PriceGroupCode, Price, StartDate, EndDate)
	AS
	(
	  SELECT GersSku, 
	         'COG', 
			 @Cost, --AVG(Cost),					-- Why the average over the life of the device instead of the current price?
			 '1/1/1900', '12/31/2049'
	    FROM [catalog].[GersStock]
       WHERE OrderDetailId IS NULL 
	     AND GersSku = @GersSku
	   GROUP BY GersSku
	)


	MERGE INTO [catalog].GersPrice AS [target]
	  USING COGS AS [source]
		 ON [target].GersSku = [source].GersSku 
		AND [target].PriceGroupCode = [source].PriceGroupCode
	WHEN MATCHED THEN 
	   UPDATE SET PriceGroupCode = [source].PriceGroupCode, 
	              Price = [source].Price, 
				  StartDate = [source].StartDate, 
				  EndDate = [source].EndDate
	WHEN NOT MATCHED THEN 
	   INSERT (GersSku, PriceGroupCode, Price, StartDate, EndDate) 
	    VALUES ( [source].GersSku, [source].PriceGroupCode, [source].Price, [source].StartDate, [source].EndDate );

END