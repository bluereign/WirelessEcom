CREATE VIEW report.OrderDump
AS
SELECT     O.UserId, 'EC' + CONVERT(nvarchar(10), CONVERT(binary(4), O.UserId), 2) AS CUST_CD, O.OrderDate, O.Status AS OrderStatus, O.OrderId, 
                      O.GERSRefNum, C.CompanyName, A.FirstName, A.LastName, WA.ActivationStatus AS OrderActivationStatus, ISNULL(P.PaymentAmount, 0) 
                      AS PaymentAmount, P.PaymentDate, O.ParentOrderId, O.SortCode, O.ActivationType,
                          (SELECT     SUM(Qty * NetPrice) AS Expr1
                            FROM          salesorder.OrderDetail
                            WHERE      (OrderId = O.OrderId)) AS OrderItemSubtotal,
                          (SELECT     SUM(Qty * Taxes) AS Expr1
                            FROM          salesorder.OrderDetail AS OrderDetail_1
                            WHERE      (OrderId = O.OrderId)) AS OrderTaxes, O.ShipCost
FROM         salesorder.[Order] AS O INNER JOIN
                      catalog.Company AS C ON O.CarrierId = C.CarrierId INNER JOIN
                      salesorder.Address AS A ON O.ShipAddressGuid = A.AddressGuid INNER JOIN
                      salesorder.WirelessAccount AS WA ON O.OrderId = WA.OrderId LEFT OUTER JOIN
                      salesorder.Payment AS P ON O.OrderId = P.OrderId AND P.PaymentMethodId IS NOT NULL
WHERE     (P.PaymentDate IS NOT NULL)