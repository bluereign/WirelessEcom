CREATE PROCedure [orders].[sp_MissingorDoublePayment]
	@OrderID bigint
as
 DECLARE @NumAuthPayments INT = 0
 DECLARE @NumPayments INT = 0
 DECLARE @NumPaymentsWithID INT = 0
 DECLARE @NumPaymentsNoID INT = 0
 DECLARE @PaymentAmount MONEY = null
 DECLARE @OrderTotal MONEY = 0
 DECLARE @TaxDiff MONEY = 0
 DECLARE @RetCode INT = 0
 
 set @NumPayments = (select count(*) from salesorder.Payment with (nolock) where OrderId = @OrderID)

 set @NumAuthPayments = (select count(*) from salesorder.Payment with (nolock) where OrderId = @OrderID
   and PaymentAmount = 0)
   
 set @NumPaymentsWithID = (select count(*) from salesorder.Payment with (nolock) where OrderId = @OrderID
   and PaymentMethodId IS NOT NULL and PaymentAmount > 0)
 
 set @NumPaymentsNoID = (select count(*) from salesorder.Payment with (nolock) where OrderId = @OrderID
   and PaymentMethodId IS NULL and PaymentAmount > 0)
   
 set @OrderTotal = (select sum(netprice) + sum(taxes) as Amount from salesorder.[OrderDetail]  
					where OrderId = @OrderID) 
 
 --PRINT @NumPaymentsWithID
 
 set @PaymentAmount = (select top 1 PaymentAmount from salesorder.Payment where OrderId = @OrderID and PaymentAmount > 0)
 
 if (@NumPaymentsWithID > 1)
 begin 
	   update top (@NumPaymentsWithID-1) salesorder.Payment
	   set PaymentMethodId = null, BankCode = 'Tool4'
	   where OrderId = @OrderId and PaymentMethodId is not null
	   
	   UPDATE salesorder.[Order]
	   SET GERSStatus = 0
	   WHERE OrderId = @OrderID

	   SET @RetCode = 1

  end
  ELSE IF (@NumPaymentsWithID = 1)
  BEGIN
   	SET @RetCode = 2
  end
 
  ELSE  IF (@NumPaymentsNoID = 1)
  BEGIN
   SET @RetCode = 5
  END
  ELSE IF (@NumPaymentsNoID > 1)
  BEGIN
   SET @RetCode =4 
  END
   ELSE IF (@NumPaymentsWithID = 0)
  BEGIN
	IF (@NumAuthPayments = 1)
	BEGIN
		SET @RetCode = 3
	END
	ELSE
	BEGIN
		if @NumPayments = 0
		begin
   			SET @RetCode = 6
   		end
   		else
   		begin
   			set @RetCode = 1
   		end
	END
END
 
 --if (@PaymentAmount is not null)
 --begin
	--set @TaxDiff = @PaymentAmount - @OrderTotal
	
	--if (@TaxDiff > 0)
	--begin
	--	set @RetCode = 4
		
	--	update top (1) salesorder.[OrderDetail]
	--	set taxes = taxes + @TaxDiff
	--	where orderid = @OrderID and orderdetailtype = 'd'
		
	--end
	
 --end
  
  SELECT @RetCode