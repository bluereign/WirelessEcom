

CREATE VIEW [report].[CustomerServiceActivations]
AS
SELECT DISTINCT
	Convert(varchar,o.OrderDate,101) as OrderDate
	,  Convert(varchar,o.PcrDate,101) as PcrDate
	, CASE WHEN o.PcrDate IS NULL
		THEN
			Convert(varchar,DATEADD(d, 2, o.OrderDate), 101)
		ELSE
			Convert(varchar,DATEADD(d, 2, o.PcrDate), 101)
		END twodaydate

	, CASE WHEN o.PcrDate IS NULL
		THEN DATEDIFF(d, o.OrderDate, GETDATE())
	  ELSE DATEDIFF(d, o.PcrDate, GETDATE())
	    END DaysFromSLA
	, o.OrderId
	, c.CompanyName Carrier
	, o.ActivationType
	, CASE o.Status
		WHEN 0 THEN 'Pending'
		WHEN 1 THEN 'Submitted'
		WHEN 2 THEN 'Order Placed'
		WHEN 3 THEN
			CASE o.GERSStatus
				WHEN 2 THEN 'Packing'
				WHEN 3 THEN 'Shipped'
			ELSE 'Processing'
			END
		WHEN 4 THEN 'Cancelled'
		WHEN 5 THEN 'Other, could this be pending?'
		ELSE ''
	  END Status
	, Convert(varchar, wa.ActivationDate,101)as ActivationDate
	, (SELECT TOP 1 LTRIM(RTRIM(REPLACE(util.udf_StripHTML(REPLACE(CAST(n.NoteBody as VARCHAR(MAX)),'&nbsp;', ' ')), '  ', ' '))) FROM admin.OrderNote n WHERE n.OrderId = o.OrderId ORDER BY n.DateCreated DESC) LastActivationNote
	, (SELECT TOP 1 s.TrackingNumber FROM salesorder.OrderDetail od INNER JOIN salesorder.Shipment s ON s.ShipmentId = od.ShipmentId WHERE od.OrderId = o.OrderId AND s.TrackingNumber IS NOT NULL) TrackingNumber
	, Convert(varchar,o.ShipmentDeliveryDate,101) as ShipmentDeliveryDate
	, sm.DisplayName as ShipMethod
	, CASE wa.ActivationStatus
	  WHEN 2
		THEN 'PUSH'
	  WHEN 6
		THEN 'Manual'
	  WHEN 3
		THEN 'Manual'
	  ELSE 'Not Set'
	  END ActivationStatus                
	, (SELECT Count(1) FROM salesorder.OrderDetail od WHERE od.OrderId = o.OrderId AND od.OrderDetailType = 'd') DeviceTotal
	, (SELECT Count(1) FROM salesorder.OrderDetail od INNER JOIN salesorder.WirelessLine wl ON wl.OrderDetailId = od.OrderDetailId WHERE od.OrderId = o.OrderId AND od.OrderDetailType = 'd' AND wl.ActivationStatus = 2) PushActivationTotal
	, (SELECT Count(1) FROM salesorder.OrderDetail od INNER JOIN salesorder.WirelessLine wl ON wl.OrderDetailId = od.OrderDetailId WHERE od.OrderId = o.OrderId AND od.OrderDetailType = 'd' AND wl.ActivationStatus = 6) ManualActivationTotal
	, (SELECT Count(1) FROM salesorder.OrderDetail od WHERE od.OrderId = o.OrderId AND od.OrderDetailType = 'd') 
	  - (SELECT Count(1) FROM salesorder.OrderDetail od INNER JOIN salesorder.WirelessLine wl ON wl.OrderDetailId = od.OrderDetailId WHERE od.OrderId = o.OrderId AND od.OrderDetailType = 'd' AND wl.ActivationStatus = 2)
	  - (SELECT Count(1) FROM salesorder.OrderDetail od INNER JOIN salesorder.WirelessLine wl ON wl.OrderDetailId = od.OrderDetailId WHERE od.OrderId = o.OrderId AND od.OrderDetailType = 'd' AND wl.ActivationStatus = 6) PendingActivationTotal 
    , (SELECT COUNT(1) FROM salesOrder.CapturesWaiting  where OrderID = o.orderId) PendingCapture
    , cu.FirstName + ' ' + cu.LastName CapturedBy
    , au.FirstName + ' ' + au.LastName ActivatedBy
FROM salesorder.[Order] o WITH (NOLOCK) 
INNER JOIN catalog.Company c WITH (NOLOCK) ON c.CarrierId = o.CarrierId
INNER JOIN salesorder.WirelessAccount wa WITH (NOLOCK) ON wa.OrderId = o.OrderId
INNER JOIN salesorder.ShipMethod sm WITH (NOLOCK) ON o.ShipMethodId = sm.ShipMethodId
left join salesorder.Payment p WITH (NOLOCK) on o.OrderId = p.OrderId
LEFT JOIN Users cu WITH (NOLOCK) ON cu.User_Id = o.PaymentCapturedById
LEFT JOIN Users au WITH (NOLOCK) ON au.User_Id = o.ActivatedById
WHERE o.status <> 0