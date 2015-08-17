CREATE PROCedure [orders].[sp_GetSKUsWithInventory]
  @OrderType varchar(1),
  @SKU varchar(10) = null
as 

DECLARE @OrderTypeID int

IF @SKU is null
begin

	SELECT @OrderTypeID = CASE @OrderType WHEN 'd' THEN 1
	 WHEN 'r' THEN 2
	 WHEN 's' THEN 3
	 WHEN 'a' THEN 4
	END

SELECT p.[GersSku], 
CASE @OrderTypeID WHEN 1 THEN cp.Value 
				  WHEN 4 THEN a.Name 
END as Name,
 CASE WHEN v.Value IS NULL THEN count(*)
  ELSE count(*)-v.Value
END as QtyAvailable, p.ProductId
FROM [catalog].[ProductGuid] pg with (nolock)
LEFT JOIN [catalog].[Product] p with (nolock)
ON pg.ProductGUID = p.ProductGUID  
LEFT JOIN [catalog].[Device] d with (nolock)
ON p.ProductGUID = d.DeviceGUID
LEFT JOIN [catalog].[Accessory] a with (nolock)
ON p.ProductGUID = a.AccessoryGUID
LEFT JOIN [catalog].[GersStock] gs with (nolock)
ON p.GersSku = gs.GersSku
LEFT JOIN [catalog].[property] v on v.ProductGUID = p.ProductGUID and v.Active = 1 and
  v.Name = 'Inventory.HoldBackQty' 
LEFT JOIN  catalog.property cp on p.ProductGuid = cp.ProductGuid and cp.Name = 'title'

WHERE [ProductTypeId] = @OrderTypeID and p.Active = 1 and gs.OrderDetailID is null -- and gs.GersSku = @SKU
GROUP BY  p.[GersSku], d.Name, a.Name, p.ProductId,  v.Value, cp.Value
order by d.Name, a.Name, cp.Value
end
else
begin
	

	SELECT @OrderTypeID = CASE @OrderType WHEN 'd' THEN 1
	 WHEN 'r' THEN 2
	 WHEN 's' THEN 3
	 WHEN 'a' THEN 4
	END

SELECT p.[GersSku], 
CASE @OrderTypeID WHEN 1 THEN cp.Value 
				  WHEN 4 THEN a.Name 
END as Name,
 CASE WHEN v.Value IS NULL THEN count(*)
  ELSE count(*)-v.Value
END as QtyAvailable, p.ProductId
FROM [catalog].[ProductGuid] pg with (nolock)
LEFT JOIN [catalog].[Product] p with (nolock)
ON pg.ProductGUID = p.ProductGUID  
LEFT JOIN [catalog].[Device] d with (nolock)
ON p.ProductGUID = d.DeviceGUID
LEFT JOIN [catalog].[Accessory] a with (nolock)
ON p.ProductGUID = a.AccessoryGUID
LEFT JOIN [catalog].[GersStock] gs with (nolock)
ON p.GersSku = gs.GersSku
LEFT JOIN [catalog].[property] v on v.ProductGUID = p.ProductGUID and v.Active = 1 and
  v.Name = 'Inventory.HoldBackQty' 
LEFT JOIN  catalog.property cp on p.ProductGuid = cp.ProductGuid and cp.Name = 'title'

WHERE [ProductTypeId] = @OrderTypeID and p.Active = 1 and gs.OrderDetailID is null  and gs.GersSku = @SKU
GROUP BY  p.[GersSku], d.Name, a.Name, p.ProductId,  v.Value, cp.Value
order by d.Name, a.Name, cp.Value
end