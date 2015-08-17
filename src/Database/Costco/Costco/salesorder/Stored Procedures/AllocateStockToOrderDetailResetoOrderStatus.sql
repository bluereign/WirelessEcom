



-- =============================================
-- Author:		Ron Delzer
-- Create date: 4/1/2010
-- Description:	Revamped to support multiple calls
-- Modified: Greg Montague, 3/8/2011
-- =============================================
CREATE PROCEDURE [salesorder].[AllocateStockToOrderDetailResetoOrderStatus] 
	@OrderDetailId int, 
	@GersSku varchar(9)=NULL,
	@Qty int=NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @OrderId int;
	DECLARE @AllocatedQty int;
	DECLARE @NewQty int;
	DECLARE @RowCount int;
	
	-- Ignore incoming GersSku and Qty, get them from table
	-- They should be removed as parameters in the future
	SELECT @OrderId=OrderId, @GersSku=GersSku, @Qty=Qty
	FROM salesorder.OrderDetail
	WHERE OrderDetailId=@OrderDetailId;

	-- Check for previously allocated stock
	SELECT @AllocatedQty = SUM(Qty)
	FROM catalog.GersStock
	WHERE OrderDetailId=@OrderDetailId
	GROUP BY OrderDetailId;

	SET @NewQty=@Qty-ISNULL(@AllocatedQty,0)

	IF (@NewQty < 0)
		BEGIN
			INSERT INTO salesorder.Activity (OrderId, Name, Description)
			VALUES (@OrderId, N'Over Allocation', N'OrderDetailId: ' + CONVERT(nvarchar,@OrderDetailId) + '  GersSku: ' + @GersSku + '  Qty: ' + CONVERT(nvarchar,@NewQty));
			
			RETURN 2;
		END
	ELSE
		BEGIN
			UPDATE TOP (@NewQty ) catalog.GersStock
			SET OrderDetailId=@OrderDetailId
			WHERE GersSku = @GersSku AND OrderDetailId IS NULL;
			
			SET @RowCount=@@ROWCOUNT;
			
			INSERT INTO salesorder.Activity (OrderId, Name, Description)
			VALUES (@OrderId, N'Stock Allocation', N'OrderDetailId: ' + CONVERT(nvarchar,@OrderDetailId) + '  GersSku: ' + @GersSku + '  Qty: ' + CONVERT(nvarchar,@NewQty));
			
			UPDATE	salesorder.[Order] 
			SET		Status=2,
					GERSStatus=0
			WHERE	OrderId=@OrderId AND GERSStatus<0
		
		
		END
	
	IF @RowCount < @NewQty
	BEGIN
		INSERT INTO salesorder.Activity (OrderId, Name, Description)
		VALUES (@OrderId, N'Back Order', N'OrderDetailId: ' + CONVERT(nvarchar,@OrderDetailId) + '  GersSku: ' + @GersSku + '  Qty: ' + CONVERT(nvarchar,@NewQty));
		
		RETURN 1;
	END
END