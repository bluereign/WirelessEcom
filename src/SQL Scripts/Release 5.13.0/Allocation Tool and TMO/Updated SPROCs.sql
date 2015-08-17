
/****** Object:  StoredProcedure [inventory].[AddFakeInventory]    Script Date: 09/04/2014 17:35:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [inventory].[AddFakeInventory] ( @GersSku		NVARCHAR(9), 
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

		DECLARE @GersSku nvarchar(9) = 'SONEBLKKT', -- GERS SKU from catalog.GersItm table active in catalog.Product table
		        @Cost money = 0.001, -- COGS
		        @Quantity int = 1500, -- amount to be added
				@BlockId INT =149
				
		-- Run the SPROC
		EXEC [inventory].[AddFakeInventory] 
		   @GersSku
		  ,@Cost
		  ,@Quantity
		  ,@BlockId

		-- View the SPROC results
		SELECT * FROM catalog.GersStock gs
		WHERE BlockId = 149
		SELECT SUM(Quantity) FROM allocation.Block
		WHERE BlockId IS NOT NULL

		SELECT SUM(Quantity) FROM allocation.Block
		WHERE gs.GersSku = 'SONEBLKKT'



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
	 DROP TABLE #FakeSKUs
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
			 AVG(Cost),					-- Why the average over the life of the device instead of the current price?
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

GO




/****** Object:  StoredProcedure [ALLOCATION].[ProcessVirtualInventoryRequests]    Script Date: 09/04/2014 17:35:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ALLOCATION].[ProcessVirtualInventoryRequests]
AS
/******************************************************************************************
*
*  Object: ProcessFakeInventoryRequest
*  Schema: allocation
*
*  Example Call:

		-- Run the SPROC
		EXEC [allocation].[ProcessVirtualInventoryRequests]

        SELECT * 
		  FROM catalog.GersStock gs
		 WHERE gs.GersSku = 'BSGXS3W16'

		SELECT * FROM catalog.GersStock WHERE BlockId = 45

*  Purpose: Calls the [inventory].[AddFakeInventory] sproc for the currently active BlockIds

*
*  Date             User			Detail
*  08/29/2014		scampbell		Initial coding.
*  09/02/2014		scampbell		Bug fix with StartDate and added [GersStock] check.
*
*****************************************************************************************/

BEGIN
  SET NOCOUNT ON;
	
  DECLARE @gersSku	 NVARCHAR(9),
          @Cost		 MONEY,
          @Quantity	 INT,
		  @BlockId	 INT

  DECLARE curRequestForFakeInv CURSOR FORWARD_ONLY
    FOR 

      SELECT vi.GersSku
	         , vi.COGS
		     , b.Quantity
		     , b.BlockId
	    FROM [allocation].[Block] AS b
	         JOIN [allocation].[BlockVirtualInventory] AS bvi
		       ON b.BlockId = bvi.BlockId
		     JOIN [allocation].[VirtualInventory] As vi
		       ON bvi.VirtualInventoryId = vi.VirtualInventoryId
       WHERE vi.StartDate < GETDATE()	   
         AND (vi.EndDate IS NULL OR vi.EndDate > GETDATE())
		 AND b.blockId NOT IN ( SELECT DISTINCT gs.BlockId FROM [catalog].[GersStock] AS gs WHERE BlockId IS NOT NULL )
		 AND b.IsDeleted = 0

  OPEN curRequestForFakeInv;

  FETCH NEXT FROM curRequestForFakeInv INTO @gersSku, @Cost, @Quantity, @BlockId;

  WHILE( @@FETCH_STATUS = 0 )
    BEGIN
	  PRINT '@gersSku= ' + @gersSku + ', @Quantity = ' + CAST(@Quantity AS VARCHAR(10))

      EXEC [inventory].[AddFakeInventory] @GersSku=@GersSku, 
	                                      @Cost=@Cost,
	                                      @Quantity=@Quantity,
			   	                          @BlockId=@BlockId
										  
								
      FETCH NEXT FROM curRequestForFakeInv INTO @gersSku, @Cost, @Quantity, @BlockId;

    END

  CLOSE curRequestForFakeInv;
  DEALLOCATE curRequestForFakeInv;

END




GO

