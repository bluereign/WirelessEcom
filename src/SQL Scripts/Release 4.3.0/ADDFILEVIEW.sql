USE [CARTOYS]
GO

/****** Object:  View [squaretrade].[AddFile]    Script Date: 02/26/2013 14:42:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [squaretrade].[AddFile] AS
--ADD FILE
WITH SquareTrade AS (
SELECT * FROM salesorder.OrderDetail WHERE OrderId IN
(SELECT OrderId FROM salesorder.OrderDetail WHERE GersSku = 'CWSHPPALL')
)

SELECT DISTINCT
	--,st.GroupNumber AS 'Item'
	'sale' AS 'source'
	,so.OrderId AS 'orderID'
	,so.EmailAddress AS 'buyerEmail'
	,sa.State AS 'buyerState'
	,'USA' AS 'buyerCountry'
	,so.OrderDate AS 'purchaseDate'
	,'99.99' AS 'warrantyPurchasePrice'
	,'689986' AS 'resaleProductId'
	,'CWSHPPALL' AS 'merchantResaleWarrantySKU'
	,st.Qty AS 'Quantity'
	,sa.FirstName AS 'buyerFirstName'
	,sa.LastName AS 'buyerLastName'
	,sa.Address1 AS 'buyerAddress1'
	,sa.Address2 AS 'buyerAddress2'
	,sa.City AS 'buyerCity'
	,sa.Zip AS 'buyerZip'
	,sa.DaytimePhone AS 'buyerPhone'
	,st.ProductId AS 'itemId'
	,st.ProductTitle AS 'itemDescription'
	,st.NetPrice AS 'itemPrice'
	,cc2.CompanyName AS 'itemManufacturer'
	,cd.Name AS 'itemModel'
	,swl.IMEI AS 'itemSerialNumber'
	,cc1.CompanyName AS 'itemCarrier'
FROM salesorder.Address sa
INNER JOIN salesorder.[Order] so ON sa.AddressGuid = so.BillAddressGuid
INNER JOIN SquareTrade st ON st.OrderId = so.OrderId AND st.GroupNumber IN (SELECT GroupNumber FROM squaretrade WHERE GersSku = 'CWSHPPALL' AND OrderId = so.OrderId)
INNER JOIN catalog.Company cc1 ON cc1.CarrierId = so.CarrierId
INNER JOIN catalog.Product cp ON cp.GersSku = st.GersSku
INNER JOIN catalog.Device cd ON cd.DeviceGuid = cp.ProductGuid
INNER JOIN catalog.Company cc2 ON cc2.CompanyGuid = cd.ManufacturerGuid
LEFT OUTER JOIN salesorder.WirelessLine swl ON swl.OrderDetailId = st.OrderDetailId
WHERE
CAST(so.OrderDate AS DATE) = CONVERT(VARCHAR(10),GETDATE()-1, 101)
AND so.Status = '3'


GO


