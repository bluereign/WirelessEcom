



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
			, sum(case gs.OutletCode when 'FAK' then 1 else 0 end) PhantomInventoryCount
		from 
			salesorder.[order] o
		join
			salesorder.WirelessAccount w on w.OrderId = o.OrderId
		join 
			catalog.Company c on c.CarrierId = o.CarrierId
		inner join 
			salesorder.OrderDetail od on od.OrderId = o.OrderId
		inner join 
			catalog.GersStock gs on gs.OrderDetailId = od.OrderDetailId
		where
			o.Status = 2
			and (w.ActivationStatus is null or w.ActivationStatus = 0)
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
			




