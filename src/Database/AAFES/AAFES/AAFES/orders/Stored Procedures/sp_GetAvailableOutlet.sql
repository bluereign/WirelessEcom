CREATE PROCedure [orders].[sp_GetAvailableOutlet]
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
	
	IF (@HoldBack IS NOT NULL)
	BEGIN
		IF (@StockCount > @HoldBack)
		begin				
			SET @OutletID = (SELECT TOP 1 OutletID FROM catalog.GersStock gs with (nolock)
			WHERE gs.GersSku = @GersSku AND OrderDetailId IS NULL)
		end
		ELSE
		SET @OutletID = NULL
	END
	ELSE
	BEGIN		
		SET @OutletID = (SELECT TOP 1 OutletID FROM catalog.GersStock gs with (nolock)
		WHERE gs.GersSku = @GersSku AND OrderDetailId IS NULL)
	END
	
	IF (@OutletID IS NULL)
	BEGIN
		SET @OrderDetailId = (SELECT TOP 1 od.OrderDetailID
		FROM salesorder.OrderDetail od with (nolock)
		LEFT JOIN salesorder.[Order] o with (nolock) ON o.OrderID = od.OrderID
		LEFT JOIN catalog.GersStock gs with (nolock) ON gs.OrderDetailId = od.OrderDetailId
		WHERE gs.GersSku = @GersSku and ((O.Status = 4 and o.GERSStatus = 0) or
		 (O.Status = 1 and o.GERSStatus = 0 and DateDiff(dd, o.OrderDate, GetDate()) > 30)))
		
		IF (@OrderDetailId IS NOT NULL)
		BEGIN		
			UPDATE catalog.GersStock
			SET OrderDetailId = null
			WHERE OrderDetailId = @OrderDetailId			
						
			SET @OutletID = (SELECT TOP 1 OutletID FROM catalog.GersStock gs with (nolock)
			WHERE gs.GersSku = @GersSku AND OrderDetailId IS NULL)
		
		END			
	END
	
	SELECT @OutletID