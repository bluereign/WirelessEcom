CREATE PROCedure [orders].[sp_UpdateOrderPrice]

  @OrderDetailID bigint, 
  @NetPrice money,
  @Tax money
  
as 

IF (@Tax>0)
begin
	UPDATE salesorder.OrderDetail
	SET Taxable = 1
	WHERE OrderDetailID = @OrderDetailID
end

UPDATE salesorder.OrderDetail
SET NetPrice = @NetPrice, Taxes = @Tax
WHERE OrderDetailID = @OrderDetailID