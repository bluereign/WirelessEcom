







/* carriers only*/
CREATE VIEW [salesorder].[CapturesWaiting]
WITH SCHEMABINDING 
AS
	--PENDING CAPTURE ORDERS
	select 
		o.OrderId
		, o.OrderDate
		, o.EmailAddress
		, o.ActivationType
		, c.CarrierId
		, c.CompanyName
		, o.CheckoutReferenceNumber
		, o.OrderAssistanceUsed
		, sum(case gs.OutletCode when 'FAK' then 1 else 0 end) PhantomInventoryCount
		, sm.DisplayName ShippingMethod
	from salesorder.[order] o
	join salesorder.WirelessAccount w on w.OrderId = o.OrderId
	join catalog.Company c on c.CarrierId = o.CarrierId
	inner join salesorder.OrderDetail od on od.OrderId = o.OrderId
	inner join catalog.GersStock gs on gs.OrderDetailId = od.OrderDetailId
	inner join salesorder.ShipMethod sm on sm.ShipMethodId = o.ShipMethodId
	where
		o.Status = 1
		and (w.ActivationStatus is null or w.ActivationStatus = 0)
		and o.ActivationType is not null
		and o.ActivationType <> 'E'
	group by
		o.OrderId
		, o.OrderDate
		, o.EmailAddress
		, o.ActivationType
		, c.CarrierId
		, c.CompanyName
		, o.CheckoutReferenceNumber
		, o.OrderAssistanceUsed
		, sm.DisplayName