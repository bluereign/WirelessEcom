



CREATE Procedure [maintenance].[WeblinkFailures_Minus_3_usp]
@OrderID INT
AS
BEGIN

/*************************************************
Proc name    : [maintenance].[WeblinkFailures_Minus_3_usp]
Server Name  : 10.7.0.62
DB Name      : CarToys
Author name  : Sekar Muniyandi
Created Date : April 8th, 2011
Modified Date: None
Description  : Double Free Accessory
**************************************************/
	

    

select * from salesorder.[Order] where OrderId = @OrderId
select * from salesorder.WirelessAccount where OrderId = @OrderId

select * from salesorder.OrderDetail where OrderId = @OrderId
select * from salesorder.WirelessLine where OrderDetailId IN (select OrderDetailId from salesorder.OrderDetail where OrderId = @OrderId)
select * from salesorder.LineService where OrderDetailId IN (select OrderDetailId from salesorder.OrderDetail where OrderId = @OrderId)

select * from salesorder.Payment where OrderId = @OrderId
select * from catalog.GersStock where OrderDetailId IN (select OrderDetailId from salesorder.OrderDetail where OrderId = @OrderId)


DELETE FROM salesorder.OrderDetail
WHERE OrderDetailId = 192421

UPDATE catalog.GersStock
SET OrderDetailId = null
WHERE OrderDetailId = 192421

UPDATE salesorder.[Order]
SET GERSStatus = 0
WHERE OrderId = 39646

END




