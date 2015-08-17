

CREATE procedure [orders].[sp_GetFakeInventoryCount]
  @GersSku varchar(9)
as 

	
	DECLARE @OrderDetailId varchar(9)
	DECLARE @StockCount int
	DECLARE @HoldBack int

	SET @StockCount = (SELECT COUNT(*) FROM catalog.GersStock gs with (nolock)
	WHERE gs.GersSku = @GersSku AND OrderDetailId IS NULL AND OutletCode = 'FAK')
	
	SET @HoldBack = (select v.Value
	from catalog.product p INNER JOIN catalog.property v on v.ProductGUID = p.ProductGUID
	where Name = 'Inventory.HoldBackQty' and v.Active = 1 AND p.gerssku = @GersSku)
	
	IF (@HoldBack IS NOT NULL) AND (@HoldBack > 0)
	BEGIN
		IF (@StockCount > @HoldBack)
		BEGIN			
			SET @StockCount = @StockCount - @HoldBack
		END
		ELSE
			SET @StockCount = 0
	END
	
	SELECT @StockCount