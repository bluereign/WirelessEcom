




CREATE  proc [maintenance].[WebLinkFailure_Minus_7_usp]
@OrderID INT
--,@OrderDetailId INT
AS 
--Issue : -7 AK/HI Shipping Method                             
--Replace ShipMethodId from 3 to 2 and update GERSStatus to 0 for the Order

select *from salesorder.[Order] where orderid=@OrderID
BEGIN

update salesorder.[Order] 
set ShipMethodId =2
where OrderId=@OrderID 

  
		Update  salesorder.[Order] 
		Set GERSStatus =0
		Where orderid= @OrderID       
 



END
      



