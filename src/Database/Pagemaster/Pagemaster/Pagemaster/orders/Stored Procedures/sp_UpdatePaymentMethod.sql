CREATE PROCedure [orders].[sp_UpdatePaymentMethod]
	@PaymentID bigint,
	@PaymentMethodID bigint

as
  declare @OrderID bigint
  
  SELECT @OrderID = (SELECT OrderID FROM salesorder.[Payment]
   where PaymentID = @PaymentID)
  
  IF (@OrderID IS NOT NULL)
  BEGIN
	  update salesorder.[Payment]
	  set PaymentMethodID = @PaymentMethodID
	  where PaymentID = @PaymentID
	  
	  update salesorder.[Order]
	  set GERSStatus = 0
	  where OrderID = @OrderID
  END