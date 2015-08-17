CREATE PROCedure [orders].[sp_GetRealAvailableOutlet]
  @GersSku varchar(9)
as 

	DECLARE @OutletID varchar(10)
	DECLARE @OrderDetailId varchar(9)
	DECLARE @StockCount int
	DECLARE @HoldBack int

	SET @StockCount = (SELECT COUNT(*) FROM catalog.GersStock gs with (nolock)
	WHERE gs.GersSku = @GersSku AND OrderDetailId IS NULL)
	
	SET @HoldBack = (select v.Value
	from catalog.product p INNER JOIN catalog.property v on v.ProductGUID = p.ProductGUID
	where Name = 'Inventory.HoldBackQty' and v.Active = 1 AND p.gerssku = @GersSku)
	
	--IF (@HoldBack IS NOT NULL)
	--BEGIN
	--	IF (@StockCount > @HoldBack)
	--	BEGIN			
	--		SET @OutletID = (SELECT TOP 1 OutletID FROM catalog.GersStock gs with (nolock)
	--		WHERE gs.GersSku = @GersSku AND OrderDetailId IS NULL and OutletID NOT LIKE 'FK%' AND OutletCode != 'FAK')
	--	END
	--	ELSE
	--		SET @OutletID = NULL
	--END
	--ELSE
	--BEGIN		
		SET @OutletID = (SELECT TOP 1 OutletID FROM catalog.GersStock gs with (nolock)
		WHERE gs.GersSku = @GersSku AND OrderDetailId IS NULL and OutletID NOT LIKE 'FK%' AND OutletCode != 'FAK')
	--END
	
	SELECT @OutletID