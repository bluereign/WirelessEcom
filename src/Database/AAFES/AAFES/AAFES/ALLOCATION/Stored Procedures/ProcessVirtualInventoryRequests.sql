
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