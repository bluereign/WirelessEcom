CREATE procedure [orders].[sp_GetItemsWithFakeInventory]
  @OrderID bigint
 
 as
SELECT distinct od.OrderID, od.OrderDetailType, od.OrderDetailID, od.ProductID, od.GersSKU, od.GroupNumber, gs.OutletCode, gs.IMEI
FROM salesorder.OrderDetail od with (nolock)
LEFT JOIN catalog.GersStock gs with (nolock) ON gs.OrderDetailId = od.OrderDetailId
WHERE (gs.OutletID like 'FK%' and len(gs.IMEI) = 0)
AND od.OrderId = @OrderID                                   
AND od.OrderDetailType IN ('d', 'a')