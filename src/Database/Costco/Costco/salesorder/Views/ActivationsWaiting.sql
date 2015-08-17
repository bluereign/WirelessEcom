




/* carriers only*/
CREATE VIEW [salesorder].[ActivationsWaiting]
WITH SCHEMABINDING 
AS
	--PENDING ACTIVATION ORDERS
		select 
			o.OrderId
			, o.OrderDate
			, o.EmailAddress
			, o.ActivationType
			, c.CarrierId
			, c.CompanyName
			, o.CheckoutReferenceNumber
			, o.OrderAssistanceUsed
			, w.CurrentAcctNumber
			, w.ActivationStatus
			, sum(case gs.OutletCode when 'FAK' then 1 else 0 end) PhantomInventoryCount		
		from salesorder.[Order] o WITH (NOLOCK)
		join salesorder.WirelessAccount w WITH (NOLOCK) on w.OrderId = o.OrderId
		join catalog.Company c WITH (NOLOCK) on c.CarrierId = o.CarrierId
		inner join salesorder.OrderDetail od WITH (NOLOCK) on od.OrderId = o.OrderId
		inner join catalog.GersStock gs WITH (NOLOCK) on gs.OrderDetailId = od.OrderDetailId
		where
			o.Status = 2
			and (w.ActivationStatus is null or w.ActivationStatus IN (0,3,4,5))
			and o.ActivationType is not null
		group by
			o.OrderId
			, o.OrderDate
			, o.EmailAddress
			, o.ActivationType
			, c.CarrierId
			, c.CompanyName
			, o.CheckoutReferenceNumber
			, o.OrderAssistanceUsed
			, w.CurrentAcctNumber
			, w.ActivationStatus