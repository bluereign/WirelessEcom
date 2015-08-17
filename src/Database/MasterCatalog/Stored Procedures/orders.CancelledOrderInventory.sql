SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Naomi Hall
-- Create date: 6/8/2012
-- =============================================
CREATE PROCEDURE [orders].[CancelledOrderInventory] 

AS

BEGIN

SELECT
	o.OrderId
	,o.OrderDate
	,od.GersSku
	,od.ProductTitle
--	,o.Status AS 'WA StatusID'
	,sos.OrderStatus AS 'WA Status'
--	,o.GERSStatus AS 'GERS StatusID'
	,sos2.OrderStatus AS 'GERS Status'
--	,o.GERSRefNum
--	,sp.PaymentAmount
	,sp.PaymentDate
	,sp.AuthorizationOrigId
	,o.CheckoutReferenceNumber
	,o.ShipmentDeliveryDate
	,ss.TrackingNumber
	,od.OrderDetailId AS 'Order OrderDiD'
	,od.GroupName
	,od.ProductId
	,gs.OutletId
	,gs.LocationCode
	,gs.IMEI
	,gs.OrderDetailId AS 'Stock OrderDiD'
	,o.TimeSentToGERS
FROM salesorder.[Order] o
INNER JOIN salesorder.OrderDetail od ON od.OrderId = o.OrderId
INNER JOIN catalog.GersStock gs ON gs.OrderDetailId = od.OrderDetailId
LEFT OUTER JOIN salesorder.OrderStatus sos ON sos.OrderStatusId = o.Status AND sos.OrderType = 'WA'
LEFT OUTER JOIN salesorder.OrderStatus sos2 ON sos2.OrderStatusId = o.GersStatus AND sos2.OrderType = 'GERS'
LEFT OUTER JOIN salesorder.Payment sp ON sp.OrderId = o.OrderId AND sp.OrderId = od.OrderId
LEFT OUTER JOIN salesorder.Shipment ss ON ss.ShipmentId = od.ShipmentId
WHERE sp.PaymentDate IS NULL AND o.Status = '1' AND o.GERSStatus = '0'
ORDER BY GersSku

END
GO
