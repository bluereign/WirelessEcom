CREATE PROCedure [orders].[sp_UpdateOrderSKU]

  @OrderDetailID bigint, 
  @ProductID int,
  @GersSku varchar(9),
  @Name varchar(50) = null
  
as 

update catalog.GersStock
set OrderDetailID = null
where OrderDetailID = @OrderDetailID

if @Name is not null
begin

UPDATE salesorder.OrderDetail
SET GersSku = @GersSku, ProductID = @ProductID, ProductTitle = @Name
WHERE OrderDetailID = @OrderDetailID
end
else
begin

UPDATE salesorder.OrderDetail
SET GersSku = @GersSku, ProductID = @ProductID
WHERE OrderDetailID = @OrderDetailID
end