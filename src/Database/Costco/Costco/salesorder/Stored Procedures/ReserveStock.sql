
-- =============================================
-- Author:		Ron Delzer
-- Create date: 1/31/2010
-- Description:	
-- =============================================
CREATE PROCEDURE [salesorder].[ReserveStock] 
	@SessionId varchar(36), 
	@GroupNumber int = NULL,
	@OrderDetailId int = NULL,
	@ProductId int = NULL,
	@Qty int = NULL
AS
BEGIN
	DECLARE @ReturnValue int;
	DECLARE @CurrentReservedTime datetime;
	DECLARE @RowsAffected int;
	DECLARE @GersSku nvarchar(9);
	
	-- If the only argument is @sessionId then just update ReservedTime
	IF @GroupNumber IS NULL AND @OrderDetailId IS NULL AND @ProductId IS NULL AND @Qty IS NULL
	BEGIN
		UPDATE catalog.SessionStockReservation
		SET ReservedTime = CURRENT_TIMESTAMP
		WHERE SessionId = @SessionId;
		
		RETURN 0;
	END

--TODO: Remove temporary OldProdToNewProd mapping once new catalog is in use.
--Production Code:
/*
	SELECT @GersSku = GersSku FROM catalog.Product WHERE ProductId = @ProductId;
*/
--Begin Temp Code
	SELECT     @GersSku = P.GersSku
	FROM         catalog.Product AS P INNER JOIN
						  OldProdToNewProd AS O2N ON P.ProductId = O2N.NewProductId
	WHERE     (O2N.OldProductId = @ProductId);
	
	IF @GersSku IS NULL
	BEGIN
		SELECT @GersSku = GersSku FROM catalog.Product WHERE ProductId = @ProductId;
	END	
--End Temp code
	
	-- Check to see if this is a new reservation or refresh	
	SELECT @CurrentReservedTime=ReservedTime
	FROM catalog.SessionStockReservation
	WHERE SessionId=@SessionId AND GroupNumber=@GroupNumber AND ProductId=@ProductId;
	
	SET @RowsAffected = @@ROWCOUNT;
	
	IF @RowsAffected=0 -- New Reservation
	BEGIN
		IF @OrderDetailId IS NULL
			INSERT INTO catalog.SessionStockReservation (SessionId, GroupNumber, ProductId, Qty, ReservedTime)
			VALUES(@SessionId, @GroupNumber, @ProductId, @Qty, CURRENT_TIMESTAMP);
		ELSE -- Hard Reservation without a previous soft reservation. Odd, but I don't see any reason not to allow it.
		BEGIN
			INSERT INTO catalog.SessionStockReservation (SessionId, GroupNumber, ProductId, Qty, ReservedTime)
			VALUES(@SessionId, @GroupNumber, @ProductId, 0, CURRENT_TIMESTAMP);
			
			EXEC @ReturnValue=salesorder.AllocateStockToOrderDetail @OrderDetailId, @GersSku, @Qty;
		END	
	END
	ELSE IF @RowsAffected=1 -- Update Reservation
		BEGIN
			IF @OrderDetailId IS NULL
				UPDATE catalog.SessionStockReservation
				SET Qty=@Qty, ReservedTime=CURRENT_TIMESTAMP
				WHERE SessionId=@SessionId AND GroupNumber=@GroupNumber AND ProductId = @ProductId;
			ELSE
			BEGIN
				UPDATE catalog.SessionStockReservation
				SET Qty=Qty-@Qty, ReservedTime=CURRENT_TIMESTAMP
				WHERE SessionId=@SessionId AND GroupNumber=@GroupNumber AND ProductId = @ProductId;
				
				EXEC @ReturnValue=salesorder.AllocateStockToOrderDetail @OrderDetailId, @GersSku, @Qty;
			END
		END
	ELSE -- This should never happen, it would violate the primary key
	BEGIN
		PRINT 'Multiple soft reservations for Session/Line/Product. This should be a PK violation.';
		RETURN 1;
	END
END