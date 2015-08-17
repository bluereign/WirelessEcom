﻿












CREATE VIEW [squaretrade].[SpecificAddFile] AS 
--ADD FILE
WITH SquareTrade AS (
SELECT * FROM salesorder.OrderDetail WHERE OrderId IN
(SELECT OrderId FROM salesorder.OrderDetail WHERE GersSku = 'cwshppec')
)

SELECT DISTINCT
	--'sale' AS 'source'
	so.OrderId AS 'orderID'
	,so.EmailAddress AS 'buyerEmail'
	,sa.State AS 'buyerState'
	,'USA' AS 'buyerCountry'
	,CONVERT(VARCHAR(10),so.OrderDate, 110) AS 'purchaseDate'
	,'99.99' AS 'warrantyPurchasePrice'
	,'689986' AS 'resaleProductId'
	--,st.Qty AS 'Quantity'
	,sa.FirstName AS 'buyerFirstName'
	,sa.LastName AS 'buyerLastName'
	,sa.Address1 AS 'buyerAddress1'
	,sa.Address2 AS 'buyerAddress2'
	,sa.City AS 'buyerCity'
	,sa.Zip AS 'buyerZip'
	,swl.CurrentMDN AS 'buyerPhone'
	--,st.ProductId AS 'itemId'
	,st.ProductTitle AS 'itemDescription'
	,st.NetPrice AS 'itemPrice'
	,cc2.CompanyName AS 'itemManufacturer'
	,cd.Name AS 'itemModel'
	--,swl.IMEI AS 'itemSerialNumber'
	,cc1.CompanyName AS 'itemCarrier'
FROM salesorder.Address sa
INNER JOIN salesorder.[Order] so ON sa.AddressGuid = so.BillAddressGuid
INNER JOIN SquareTrade st ON st.OrderId = so.OrderId AND st.GroupNumber IN (SELECT GroupNumber FROM squaretrade WHERE GersSku = 'cwshppec' AND OrderId = so.OrderId)
INNER JOIN catalog.Company cc1 ON cc1.CarrierId = so.CarrierId
INNER JOIN catalog.Product cp ON cp.GersSku = st.GersSku
INNER JOIN catalog.Device cd ON cd.DeviceGuid = cp.ProductGuid
INNER JOIN catalog.Company cc2 ON cc2.CompanyGuid = cd.ManufacturerGuid
LEFT OUTER JOIN salesorder.WirelessLine swl ON swl.OrderDetailId = st.OrderDetailId
WHERE
--CAST(so.OrderDate AS DATE) = CONVERT(VARCHAR(10),GETDATE()-1, 110)
--AND 
so.Status = '3'
AND so.OrderId = '150227'
--WHERE CONVERT(VARCHAR(10),insertdate,110) <> CONVERT(VARCHAR(10),GETDATE()-1,110)