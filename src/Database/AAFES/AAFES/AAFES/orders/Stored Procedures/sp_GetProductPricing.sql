
CREATE procedure [orders].[sp_GetProductPricing]
  @GersSKU varchar(30),
  @PriceGroupCode varchar(10),
  @OrderType  varchar(10)
as

DECLARE @realcnt int
DECLARE @fakecnt int
DECLARE @price money

set @price = (select top 1 price from catalog.gersprice where PriceGroupCode = @PriceGroupCode and gerssku = @GersSKU order by startdate desc)

DECLARE @t TABLE (a int)
INSERT INTO @t (a)
EXECUTE [orders].[sp_GetRealInventoryCount] @GersSku = @GersSKU

set @realcnt = (select * from @t)

DECLARE @t2 TABLE (a int)
INSERT INTO @t2 (a)
EXECUTE [orders].[sp_GetFakeInventoryCount] @GersSku = @GersSKU

set @fakecnt = (select * from @t2)

DECLARE @OrderTypeID int

SELECT @OrderTypeID = CASE @OrderType WHEN 'd' THEN 1
WHEN 'r' THEN 2
WHEN 's' THEN 3
WHEN 'a' THEN 4
END

IF @OrderType = 'a'
	BEGIN

SELECT  
CASE @OrderTypeID WHEN 1 THEN cp.Value 
      WHEN 4 THEN a.Name 
END as ProductTitle, (select top 1 price from catalog.gersprice where PriceGroupCode = 'ECP' and gerssku = @GersSKU order by startdate desc) AS NetPrice, @realcnt as QtyAvailable, @fakecnt as FakeAvailable
FROM [catalog].[ProductGuid] pg with (nolock)
INNER JOIN [catalog].[Accessory] a with (nolock) ON pg.ProductGUID = a.AccessoryGUID
LEFT JOIN [catalog].[property] v on v.ProductGUID = pg.ProductGUID and v.Active = 1 and  v.Name = 'Inventory.HoldBackQty' 
INNER JOIN catalog.property cp on pg.ProductGuid = cp.ProductGuid and cp.Name = 'title'
INNER JOIN catalog.Product p ON p.ProductGuid = pg.ProductGuid
LEFT JOIN [catalog].[GersStock] gs with (nolock) ON p.GersSku = gs.GersSku
WHERE [ProductTypeId] = @OrderTypeID and p.Active = 1 and gs.OrderDetailID is null  and gs.GersSku = @GersSku
GROUP BY  p.[GersSku], a.Name, p.ProductId,  v.Value, cp.Value
order by a.Name, cp.Value
END
ELSE IF @OrderType = 'd'
BEGIN
SELECT  
CASE @OrderTypeID WHEN 1 THEN cp.Value 
      WHEN 4 THEN a.Name 
END as ProductTitle, @price AS NetPrice, @realcnt as QtyAvailable, @fakecnt as FakeAvailable
FROM [catalog].[ProductGuid] pg with (nolock)
LEFT JOIN [catalog].[Device] d with (nolock) ON pg.ProductGUID = d.DeviceGUID
LEFT JOIN [catalog].[Accessory] a with (nolock) ON pg.ProductGUID = a.AccessoryGUID
LEFT JOIN [catalog].[property] v on v.ProductGUID = pg.ProductGUID and v.Active = 1 and  v.Name = 'Inventory.HoldBackQty' 
INNER JOIN catalog.property cp on pg.ProductGuid = cp.ProductGuid and cp.Name = 'title'
INNER JOIN catalog.Product p ON p.ProductGuid = pg.ProductGuid
LEFT JOIN [catalog].[GersStock] gs with (nolock) ON p.GersSku = gs.GersSku
WHERE [ProductTypeId] = @OrderTypeID and p.Active = 1 and gs.OrderDetailID is null  and gs.GersSku = @GersSku
GROUP BY  p.[GersSku], d.Name, a.Name, p.ProductId,  v.Value, cp.Value
order by d.Name, a.Name, cp.Value
END