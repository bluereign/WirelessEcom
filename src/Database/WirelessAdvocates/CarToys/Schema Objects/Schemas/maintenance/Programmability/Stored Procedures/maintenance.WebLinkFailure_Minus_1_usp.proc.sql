

CREATE  proc [maintenance].[WebLinkFailure_Minus_1_usp]
 @OrderID INT
,@OrderDetailId INT
as 
/*************************************************
Proc name    : [maintenance].[WebLinkFailure_Minus_1_usp]
Server Name  : 10.7.0.62
DB Name      : CarToys
Created By   : Sekar Muniyandi
Created Date : Map 1st, 2011
Description  : GERS API Error ( Minus -1 may occur different scenario)
Modified Date: None
**************************************************/
BEGIN
-- Before excutive this statement , please send the email to Paula Roffe, saying that to clear out (-1)
---Can you please clear these negative 1s?

SELECT ShipCost FROM salesorder.[Order] WHERE OrderId = @OrderId
SELECT SUM(Netprice+Taxes) FROM salesorder.OrderDetail WHERE OrderId = @OrderId
SELECT * FROM salesorder.Payment WHERE OrderId = @OrderId
SELECT Taxes FROM  salesorder.OrderDetail WHERE OrderDetailId = @OrderDetailId
SELECT GERSStatus FROM salesorder.[Order]   WHERE OrderId = @OrderId
--------

---Update statement

-- You add  the taxes to Accessory or Device

UPDATE salesorder.OrderDetail
SET Taxes =1.4
WHERE OrderDetailId=@OrderDetailId

update  salesorder.[Order]
set GERSStatus =0
WHERE orderid=@OrderId   




SELECT Top 50
      o.OrderId
      , o.OrderDate
      , o.Status
      , o.GERSStatus
      ,(SELECT TOP 1 Name FROM salesorder.Activity a WHERE a.OrderId = o.OrderId and Name = 'Weblink Failure' ORDER BY TimeStamp DESC) 
      ,(SELECT TOP 1 Description FROM salesorder.Activity a WHERE a.OrderId = o.OrderId and Name = 'Weblink Failure' ORDER BY TimeStamp DESC)
      ,(SELECT TOP 1 Timestamp FROM salesorder.Activity a WHERE a.OrderId = o.OrderId and Name = 'Weblink Failure' ORDER BY TimeStamp DESC)
FROM salesorder.[Order] o
WHERE o.OrderId = 39854




END
      







