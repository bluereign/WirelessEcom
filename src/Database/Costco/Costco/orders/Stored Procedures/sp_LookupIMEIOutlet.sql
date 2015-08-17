
CREATE PROC [orders].[sp_LookupIMEIOutlet]
	@IMEI varchar(15) = null,
	@OutletID varchar(10) = null
AS
 
  SELECT DISTINCT o.OrderID, o.OrderDate, gs.OutletID as GersStockOutletID, gs.IMEI as GersStockIMEI, wa.IMEI as WirelessLineIMEI, wa.CurrentMDN
  FROM catalog.GersStock gs LEFT JOIN salesorder.[OrderDetail] od ON gs.OrderDetailID = od.OrderDetailID
  LEFT JOIN salesorder.[Order] o ON od.OrderID = o.OrderID
  LEFT JOIN salesorder.[WirelessLine] wa ON od.OrderDetailID = wa.OrderDetailID
  WHERE gs.IMEI = @IMEI or gs.OutletID = @OutletID or wa.IMEI = @IMEI
   UNION
  SELECT DISTINCT o.OrderID, o.OrderDate, gs.OutletID as GersStockOutletID, gs.IMEI as GersStockIMEI, wa.IMEI as WirelessLineIMEI, wa.CurrentMDN
  FROM catalog.GersStock gs RIGHT JOIN salesorder.[OrderDetail] od ON gs.OrderDetailID = od.OrderDetailID
  RIGHT JOIN salesorder.[Order] o ON od.OrderID = o.OrderID
  RIGHT JOIN salesorder.[WirelessLine] wa ON od.OrderDetailID = wa.OrderDetailID
  WHERE wa.IMEI = @IMEI