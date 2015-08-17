

CREATE proc [salesorder].[PendingDevices]
	@PendingDeviceName nvarchar(250)
as

begin



SELECT DISTINCT
CONVERT(varchar(10),o.OrderDate,101) AS 'OrderDate'
,CASE WHEN o.Status = '1' THEN 'Submitted'
WHEN o.Status = '2' THEN 'Placed' ELSE 'Pending' END AS 'Status'
,o.OrderId
,od.GroupNumber
,od.ProductId
,(sELECT companyname from catalog.company where carrierid = o.CarrierId) AS 'Carrier'
,od.GersSku
,od.ProductTitle
,od.COGS
,od.RetailPrice
,od.NetPrice
,od.Taxes
FROM salesorder.orderdetail od
INNER JOIN salesorder.[order] o ON o.orderid = od.orderid
WHERE O.status IN ('1','2') AND od.producttitle like '%' + @PendingDeviceName + '%'

		
end