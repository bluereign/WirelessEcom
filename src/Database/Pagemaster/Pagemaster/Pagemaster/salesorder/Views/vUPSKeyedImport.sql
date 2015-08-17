CREATE VIEW salesorder.vUPSKeyedImport
AS
SELECT     O.OrderId, O.GERSRefNum, O.ShipMethodId, A.FirstName, A.LastName, A.Company, A.Address1, A.Address2, A.Address3, A.City, A.State, A.Zip, A.DaytimePhone, 
                      A.EveningPhone, '730150.8992' AS RefNum, O.EmailAddress
FROM         salesorder.[Order] AS O INNER JOIN
                      salesorder.Address AS A ON O.ShipAddressGuid = A.AddressGuid