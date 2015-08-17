
/****** Object:  View [report].[OrderDetailDump]    Script Date: 01/16/2012 13:58:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [report].[OrderDetailDump]
AS
SELECT     
	O.OrderId
	, O.OrderDate
	, O.Status AS OrderStatus
	, O.GERSStatus
	, O.GERSRefNum
	, O.UserId
	, 'EC' + CONVERT(nvarchar(10)
	, CONVERT(binary(4), O.UserId), 2) AS CUST_CD
	, C.CompanyName
	, A.FirstName
	, A.LastName
	, OD.OrderDetailId
	, OD.GersSku
	, OD.ProductTitle
	, WL.ActivationStatus AS LineActivationStatus
	, OD.Qty * OD.NetPrice AS Subtotal
	, OD.Taxes
	, WL.MonthlyFee MonthlyAccessFee
	, CASE 
		WHEN OD.OrderDetailType = 'd' THEN OD.ProductTitle 
		ELSE NULL 
	  END HandsetType
	, ISNULL(WL.NewMDN, WL.CurrentMDN) ActivatedPhoneNumber
	, WL.IMEI AS ESN_IMEI
FROM salesorder.[Order] AS O 
INNER JOIN salesorder.OrderDetail AS OD ON O.OrderId = OD.OrderId 
INNER JOIN catalog.Company AS C ON O.CarrierId = C.CarrierId 
INNER JOIN salesorder.Address AS A ON O.ShipAddressGuid = A.AddressGuid 
LEFT OUTER JOIN salesorder.WirelessLine AS WL ON OD.OrderDetailId = WL.OrderDetailId


GO


