
CREATE VIEW [report].[OrderStatus]
AS
SELECT     O.OrderId, CONVERT(date, O.OrderDate) AS OrderDate, ISNULL(O.ActivationType, '') AS Type, O.Status, O.GERSStatus, ISNULL(O.GERSRefNum, '') AS [GERS SO], 
                      ISNULL(WA.ActivationStatus, '') AS ActivationStatus, ISNULL(C.CompanyName, '') AS Carrier, O.ShipMethodId
FROM         salesorder.[Order] AS O LEFT OUTER JOIN
                      salesorder.WirelessAccount AS WA ON O.OrderId = WA.OrderId LEFT OUTER JOIN
                      catalog.Company AS C ON O.CarrierId = C.CarrierId
WHERE     (O.GERSStatus > - 9999) AND (O.Status > 0)