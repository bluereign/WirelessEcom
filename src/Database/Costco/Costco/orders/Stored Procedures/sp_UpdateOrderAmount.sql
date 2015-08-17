CREATE procedure [orders].[sp_UpdateOrderAmount]
	@OrderID bigint,
	@Amount money,
	@Token varchar(20) = null
as
 
 DECLARE @NumPaymentsWithID INT = 0
 DECLARE @NumPaymentsNoID INT = 0
 
 DECLARE @RetCode INT = 0
 
 set @NumPaymentsWithID = (select count(*) from salesorder.Payment with (nolock) where OrderId = @OrderID
   and PaymentMethodId IS NOT NULL)
   
 IF (@NumPaymentsWithID = 1)
  BEGIN
	UPDATE salesorder.Payment 
	set PaymentAmount = @Amount, BankCode = 'Tool2'
	where OrderId = @OrderID and PaymentMethodId IS NOT NULL
  end
  else
  begin
   if (@NumPaymentsWithID > 1)
   begin
      update top (@NumPaymentsWithID-1) salesorder.Payment
	  set PaymentMethodId = null, BankCode = 'Tool4-1'
	  where OrderId = @OrderId and PaymentMethodId is not null
	   
	   UPDATE salesorder.Payment 
		set PaymentAmount = @Amount, BankCode = 'Tool4-2'
		where OrderId = @OrderID and PaymentMethodId IS NOT NULL
   end
   else
   begin
	set @NumPaymentsWithID = (select count(*) from salesorder.Payment with (nolock) where OrderId = @OrderID)
   
	IF (@NumPaymentsWithID = 1)
		BEGIN
			UPDATE salesorder.Payment 
			set PaymentAmount = @Amount, BankCode = 'Tool3'
			where OrderId = @OrderID 
		end
	end
	  
	 if (@NumPaymentsWithID = 0)
	 begin
	   insert into salesorder.Payment
	   (OrderID, PaymentAmount, PaymentDate, CreditCardAuthorizationNumber, BankCode, PaymentToken)
	   values(@OrderID, @Amount, getdate(), 'Manual','Tool4',@Token )
	 end
 end
  
  SELECT 0