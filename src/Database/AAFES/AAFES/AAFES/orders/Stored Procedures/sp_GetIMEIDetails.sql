CREATE PROCedure [orders].[sp_GetIMEIDetails]
   @IMEI varchar(15)
as

SELECT top 100 od.OrderID, o.OrderDate, OrderDetailType = CASE OrderDetailType WHEN 'd' THEN 'Device'
 WHEN 'r' THEN 'Rate Plan'
 WHEN 's' THEN 'Service Plan'
 WHEN 'a' THEN 'Accessory'
 WHEN 'u' THEN 'Upgrade'
 ELSE OrderDetailType
END, GroupNumber, od.GersSku, ProductTitle, od.Qty as QtyOrdered, gs.OutletID,
 (SELECT COUNT(*) FROM catalog.GersStock WHERE GersSku = od.GersSku and OrderDetailID is null) as QtyAvailable,
  osg.OrderStatus as GERSStatus,
  os.OrderStatus as OrderStatus,   
  (SELECT TOP 1 PaymentID FROM salesorder.[Payment] -- Look for an item where the PaymentMethodID is null
  WHERE OrderID = o.OrderID and PaymentMethodID is null 
  ORDER BY PaymentDate DESC) as MissingPaymentID,
  
  (SELECT TOP 1 CreditCardAuthorizationNumber FROM salesorder.[Payment] 
  WHERE OrderID = o.OrderID and PaymentMethodID is null 
  ORDER BY PaymentDate DESC) as ReceiptNumber,
  
  (SELECT TOP 1 Name 
  FROM salesorder.[Payment] p -- Look for current payment method
  INNER JOIN salesorder.[PaymentMethod] pm ON p.PaymentMethodID = pm.PaymentMethodID
  WHERE p.OrderID = o.OrderID and p.PaymentMethodID is not null 
  ORDER BY PaymentDate DESC) as PaymentMethod,
  
  (SELECT TOP 1 PaymentID FROM salesorder.[Payment] -- Look for current payment method
  WHERE OrderID = o.OrderID and PaymentMethodID is not null 
  ORDER BY PaymentDate DESC) as CurrentPaymentID
  
from salesorder.[Order] o LEFT JOIN salesorder.[OrderDetail] od 
	ON o.OrderID = od.OrderID LEFT JOIN catalog.GersStock gs ON od.OrderDetailID = gs.OrderDetailID
	LEFT JOIN salesorder.[OrderStatus] osg ON (o.GERSStatus = osg.OrderStatusId AND osg.OrderType = 'GERS')
	LEFT JOIN salesorder.[OrderStatus] os ON (o.Status = os.OrderStatusId AND os.OrderType = 'WA')	
	
where gs.IMEI = @IMEI