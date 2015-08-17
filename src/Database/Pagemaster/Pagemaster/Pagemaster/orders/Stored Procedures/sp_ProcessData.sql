CREATE PROCedure [orders].[sp_ProcessData]
  @Operation varchar(20),
  @Table varchar(20),
  @OrderDetailID bigint = null,
  @OrderDetailType varchar(1),
  @OutletID varchar(10),
  @OrderID bigint,
  @GroupNumber int,
  @ProductID int,
  @GersSKU varchar(20),
  @ProductTitle varchar(500), 
  @SIM varchar(20),
  @IMEI varchar(15)
as 

declare @ID bigint

set @ID = 0
IF @Table = 'OrderDetails' 
BEGIN
	IF @Operation = 'Add' 
	BEGIN
		INSERT INTO salesorder.[OrderDetail]
		(OrderID, OrderDetailType, GroupNumber, GroupName, ProductID, GersSKU, ProductTitle, PartNumber, Qty, COGS, RetailPrice, NetPrice, Weight,
		 TotalWeight, Taxable, Taxes)	
		SELECT TOP 1 @OrderID as OrderID, @OrderDetailType as OrderDetailType, @GroupNumber as GroupNumber,
		 'Line ' + cast(@GroupNumber as varchar) as GroupName, @ProductID as ProductID, @GersSKU as GersSKU,
		  @ProductTitle as ProductTitle, '000000000' as PartNumber, 1 as Qty, COGS, RetailPrice, NetPrice, Weight,
		 TotalWeight, 0 as Taxable, 0 as Taxes
		FROM salesorder.[OrderDetail]
		WHERE GersSku = @GersSku
		SET @ID = @@IDENTITY
	END

	--IF @Operation = 'Update' 
	--BEGIN
	--	UPDATE salesorder.[OrderDetail]
	--	SET x = x
	--	WHERE OrderDetailID = @OrderDetailID
	--END

	--IF @Operation = 'Delete' 
	--BEGIN
	--	DELETE FROM salesorder.[OrderDetail]
	--	WHERE OrderDetailID = @OrderDetailID
	--END
END


IF @Table = 'GersStock' 
BEGIN
	
	IF @Operation = 'Update' 
	BEGIN
		UPDATE catalog.GersStock
		SET OrderDetailID = @OrderDetailID
		WHERE OutletID = @OutletID
	END

	IF @Operation = 'Delete' 
	BEGIN
		DELETE FROM catalog.GersStock
		WHERE OutletID = @OutletID
	END
END


IF @Table = 'WirelessLine' 
BEGIN
	IF @Operation = 'Add' 
	BEGIN
		INSERT INTO salesorder.WirelessLine
		(OrderDetailID, IMEI, SIM)
		VALUES (@OrderDetailID, @IMEI, @SIM)
	END

	IF @Operation = 'Update' 
	BEGIN
		IF (SELECT COUNT(*) FROM salesorder.WirelessLine
		WHERE  OrderDetailID = @OrderDetailID) > 0
		begin
		UPDATE salesorder.WirelessLine
		SET SIM = @Sim, IMEI = @IMEI
		WHERE OrderDetailID = @OrderDetailID
		end
		else
		begin
		INSERT INTO salesorder.WirelessLine
		(OrderDetailID, IMEI, SIM)
		VALUES (@OrderDetailID, @IMEI, @SIM)
		end
	END

	--IF @Operation = 'Delete' 
	--BEGIN
	--	DELETE FROM salesorder.WirelessLine
	--	WHERE OrderDetailID = @OrderDetailID
	--END
END

select @id