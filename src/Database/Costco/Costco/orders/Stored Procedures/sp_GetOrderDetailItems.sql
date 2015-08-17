CREATE procedure [orders].[sp_GetOrderDetailItems]
  @OrderID bigint
 
 as
SELECT distinct od.OrderID, od.OrderDetailType, od.OrderDetailID, od.ProductID,
 od.GersSKU, od.GroupNumber, gs.OutletCode, gs.IMEI, gs.OutletID
FROM salesorder.OrderDetail od with (nolock)
left JOIN catalog.GersStock gs with (nolock) ON gs.OrderDetailId = od.OrderDetailId
WHERE od.OrderId = @OrderID                                   
AND od.OrderDetailType IN ('d', 'a')
order by GROUPNUMBER