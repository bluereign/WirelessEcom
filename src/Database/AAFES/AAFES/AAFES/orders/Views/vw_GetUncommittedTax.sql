
CREATE view [orders].[vw_GetUncommittedTax]
as


SELECT
	so.OrderDate

	,so.orderid AS 'Invoice Number'

	,sa.FirstName + ' ' + sa.LastName AS 'Ship To Name'
	
	,sp.PaymentAmount AS 'Gross Amount'
	,so.SalesTaxTransactionId
FROM salesorder.[Order] so
LEFT OUTER JOIN salesorder.[Address] sa ON sa.AddressGuid = so.ShipAddressGuid
LEFT OUTER JOIN salesorder.Payment sp ON sp.OrderId = so.OrderId AND sp.PaymentAmount <> '0.00' AND PaymentMethodId IS NOT NULL	
WHERE  Status IN (3)
      AND IsSalesTaxTransactionCommited = 0