
CREATE procedure [orders].[sp_GetDetails_OrderDetails]
	@OrderID bigint
as

SELECT DISTINCT top 100 cast(od.OrderID as bigint) as OrderID, o.OrderDate, OrderDetailType = CASE OrderDetailType WHEN 'd' THEN 'Device'
 WHEN 'r' THEN 'Rate Plan'
 WHEN 's' THEN 'Service Plan'
 WHEN 'a' THEN 'Accessory'
 WHEN 'u' THEN 'Upgrade'
 WHEN 'w' THEN 'Other'
 ELSE OrderDetailType
END, GroupNumber, od.GersSku, od.ProductID, ProductTitle, od.Qty as QtyOrdered, 
  (SELECT TOP 1 OutletID FROM catalog.GersStock where OrderDetailID = od.OrderDetailID) as OutletID,
 (SELECT COUNT(*) FROM catalog.GersStock WHERE GersSku = od.GersSku and OrderDetailID is null) as QtyAvailable,
  osg.OrderStatus as GERSStatus,
  os.OrderStatus as OrderStatus,   
  (SELECT TOP 1 PaymentID FROM salesorder.[Payment] -- Look for an item where the PaymentMethodID is null
  WHERE OrderID = o.OrderID and PaymentMethodID is null 
  ORDER BY PaymentDate DESC) as MissingPaymentID,
  
  (SELECT TOP 1 CreditCardAuthorizationNumber FROM salesorder.[Payment] 
  WHERE OrderID = o.OrderID 
  ORDER BY PaymentDate DESC) as ReceiptNumber,
  
  (SELECT TOP 1 Name 
  FROM salesorder.[Payment] p -- Look for current payment method
  INNER JOIN salesorder.[PaymentMethod] pm ON p.PaymentMethodID = pm.PaymentMethodID
  WHERE p.OrderID = o.OrderID and p.PaymentMethodID is not null 
  ORDER BY PaymentDate DESC) as PaymentMethod,
  
  (SELECT TOP 1 PaymentID FROM salesorder.[Payment] -- Look for current payment method
  WHERE OrderID = o.OrderID and PaymentMethodID is not null 
  ORDER BY PaymentDate DESC) as CurrentPaymentID,
  (SELECT TOP 1 cast(PaymentAmount as varchar) as PaymentAmount FROM salesorder.[Payment] 
  WHERE OrderID = o.OrderID 
  ORDER BY PaymentDate DESC) as PaymentAmount,
   cast(od.OrderDetailID as bigint) as OrderDetailID,
   cast(od.NetPrice as varchar) as NetPrice,
   cast(od.Taxes as varchar) as Taxes,
    o.CarrierID as CarrierID
  ,(SELECT TOP 1 PaymentToken FROM salesorder.[Payment] 
  WHERE OrderID = o.OrderID and PaymentToken is not null
  ORDER BY PaymentDate DESC) as PaymentToken,
  (select FirstName + ' ' + LastName from salesorder.WirelessAccount
where orderid = o.OrderID) as Name,
 o.EmailAddress as Email,
 (SELECT count(OutletID) FROM catalog.GersStock where OrderDetailID = od.OrderDetailID and GersSku = od.GersSku) as CntInventory,
  a.FirstName + ' ' + a.LastName as ShipName,
  a.Address1 as ShipAddress1,
  a.Address2 as ShipAddress2,
  a.City as ShipCity,
  a.State as ShipState,
  a.Zip as ShipPostalCode,
  o.ActivationType,
  o.CheckoutReferenceNumber,
  cast(wa.ActivationStatus as varchar) as ActivationStatus
from salesorder.[Order] o with (nolock)LEFT JOIN salesorder.[OrderDetail] od with (nolock)
	ON o.OrderID = od.OrderID LEFT JOIN catalog.GersStock gs with (nolock) ON od.OrderDetailID = gs.OrderDetailID
	LEFT JOIN salesorder.[OrderStatus] osg with (nolock) ON (o.GERSStatus = osg.OrderStatusId AND osg.OrderType = 'GERS')
	LEFT JOIN salesorder.[OrderStatus] os with (nolock) ON (o.Status = os.OrderStatusId AND os.OrderType = 'WA')	
	LEFT JOIN salesorder.[Address] a with (nolock) on o.ShipAddressGuid = a.AddressGuid
	LEFT JOIN salesorder.[WirelessAccount] wa with (nolock) on wa.OrderID = o.OrderID
where o.OrderID = @OrderID 
order by GroupNumber, OrderDetailType