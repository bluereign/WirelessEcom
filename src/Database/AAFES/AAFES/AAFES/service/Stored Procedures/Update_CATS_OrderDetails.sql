

CREATE proc [service].[Update_CATS_OrderDetails] (
 @OrderID int,
 @LineID int = null,
 @MobileNumber nvarchar(10) = null,
 @AccountNo varchar(20) = null
)
as

 if (@AccountNo is not null)
 begin
	update Salesorder.wirelessaccount
	set CurrentAcctNumber = @AccountNo
	where OrderID = @OrderID
 end
 
 if (@MobileNumber is not null) and (@LineID is not null)
 begin
	Declare @OrderDetailID int
	
	select @OrderDetailID = (select OrderDetailID from SalesOrder.OrderDetail
	where OrderID = @OrderID and OrderDetailType = 'd' and GroupNumber = @LineID)
	
	if (@OrderDetailID is not null)
	begin
		update Salesorder.WirelessLine
		set CurrentMDN = @MobileNumber
		where OrderDetailID = @OrderDetailID
    end
 end