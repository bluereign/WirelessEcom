CREATE VIEW salesorder.vPaymentDiffs
AS

WITH

OrderTotals AS
(
SELECT	distinct o.OrderId, 
		o.Status,
		o.GERSStatus,
		o.ShipCost,
		SUM(od.NetPrice) Net,
		SUM(od.Taxes) Tax,
		(o.ShipCost+SUM(od.NetPrice)+SUM(od.Taxes)) Total
FROM	salesorder.[Order] o WITH(NOLOCK)
		INNER JOIN salesorder.OrderDetail od WITH(NOLOCK)
ON		o.OrderId=od.OrderId
WHERE	o.Status in (2,3)
		and o.GERSStatus=0
		and od.OrderDetailType IN ('d','a')
GROUP BY o.OrderId, o.Status, o.GERSStatus,o.ShipCost
),

OrderPaid AS
(
SELECT	o.OrderId, SUM(p.PaymentAmount) Total
FROM	salesorder.[Order] o WITH(NOLOCK)
		INNER JOIN salesorder.Payment P WITH(NOLOCK)
ON		o.OrderId=p.OrderId
WHERE	o.Status in (2,3)
		and o.GERSStatus=0
		and p.PaymentMethodId>0
GROUP BY o.OrderId
)

SELECT	ot.OrderId,
		ot.Status,
		ot.GERSStatus,
		ot.ShipCost,
		ot.Net,
		ot.Tax,
		ot.Total,
		op.Total Paid,
		ot.Total-op.Total PaymentDiffs
FROM	OrderTotals ot 
		INNER JOIN OrderPaid op
ON		ot.OrderId=op.OrderId
		AND ot.Total!=op.Total