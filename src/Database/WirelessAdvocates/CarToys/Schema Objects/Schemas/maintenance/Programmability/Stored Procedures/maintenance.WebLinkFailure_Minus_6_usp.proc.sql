CREATE  proc [maintenance].[WebLinkFailure_Minus_6_usp]  
 @orderid  int
,@DeviceGersSku Varchar(50)
as 
/*************************************************
Proc name    : [maintenance].[WebLinkFailure_Minus_6_usp] 43444, 'AQUANTUM'
Server Name  : 10.7.0.62
DB Name      : CarToys
Created By   : Sekar Muniyandi
Created Date : April 8th, 2011
Description  : Missing Accessory
Modified Date: None
Select to get GersSku
select gerssku  from salesorder.OrderDetail  where orderdetailtype='a' and  OrderId= 45032   

DECLARE 52353 as int
SET 52353 = 52353        

select * from salesorder.[Order] where OrderId = 52353
select * from salesorder.WirelessAccount where OrderId = 52353

select * from salesorder.OrderDetail where OrderId = 52353
select * from salesorder.WirelessLine where OrderDetailId IN (select OrderDetailId from salesorder.OrderDetail where OrderId = 52353)
select * from salesorder.LineService where OrderDetailId IN (select OrderDetailId from salesorder.OrderDetail where OrderId = 52353)

select * from salesorder.Payment where OrderId = 52353
select * from catalog.GersStock where OrderDetailId IN (select OrderDetailId from salesorder.OrderDetail where OrderId = 52353)

AATRIX
**************************************************/
BEGIN

--TODO: SELECT INTO
--DECLARE @OrderId INT = 43643 --
--DECLARE @DeviceGersSku VARCHAR(50) = 'TSIENA259' --  Device gersSKU

INSERT INTO salesorder.OrderDetail (OrderId, ProductTitle, ProductId, GersSku, RetailPrice, NetPrice, Taxes, OrderDetailType, Qty, GroupNumber, GroupName)
SELECT 
      @OrderId OrderId
      , p.Value
      , ap.ProductId
      , ap.GersSku
      , 0 RetailPrice
      , 0 NetPrice
      , 0 Taxes
      , 'a' OrderDetailType
      , 1 Qty
      , 1 GroupNumber
      , 'Exchange Line 1' GroupName 
      --, *
FROM catalog.Device d 
INNER JOIN catalog.Product dp ON dp.ProductGuid = d.DeviceGuid
INNER JOIN catalog.DeviceFreeAccessory da ON da.DeviceGuid = d.DeviceGuid
INNER JOIN catalog.Accessory a ON a.AccessoryGuid = da.ProductGuid
INNER JOIN catalog.Product ap ON ap.ProductGuid = a.AccessoryGuid
LEFT JOIN catalog.Property p ON p.ProductGuid = a.AccessoryGuid AND p.Name = 'Title'
WHERE dp.GersSku = @DeviceGersSku

      
		Update  salesorder.[Order] 
		Set GERSStatus =0
		Where orderid=@orderid    
    END