CREATE PROC [orders].[sp_ReinstateOrder]
	@OrderId bigint
  as
  
      
      DECLARE @OrderDetailId int

      DECLARE @GersSku varchar(9)
      
      DECLARE @Qty int
      DECLARE @NewQty int
      DECLARE @RowCount int   
      
      DECLARE @table AS TABLE (OrderDetailId int, GersSku varchar(9), Qty int)
      DECLARE @count AS int
      SET @count = 1 -- the final countdown!

      --First, re-activate the order
      UPDATE salesorder.[order]
      SET Status = '1'
      WHERE OrderId = @OrderId            
            
      -- Count number of different SKUs
      INSERT INTO @table
      SELECT OrderDetailId, GersSku, Qty
      FROM salesorder.OrderDetail
      WHERE OrderId = @OrderId AND OrderDetailType IN ('d', 'a')
      
      -- Remove previously allocated stock from zee tables!
      DELETE FROM @table
      WHERE OrderDetailId IN (
      SELECT OrderDetailId
      FROM catalog.GersStock
      WHERE OrderDetailId IN (
      SELECT OrderDetailId
      FROM salesorder.OrderDetail
      WHERE OrderId = @OrderId AND OrderDetailType IN ('d', 'a') 
      ))

      -- Start the allocation!
      WHILE EXISTS(SELECT * FROM @table)
        BEGIN
        
      SELECT TOP(1) @OrderDetailId=OrderDetailId, @GersSku=GersSku, @Qty=Qty
      FROM @table
        
                  UPDATE TOP(1) catalog.GersStock
                  SET OrderDetailId=@OrderDetailId
                  WHERE GersSku = @GersSku AND OrderDetailId IS NULL;
                  
                        DECLARE @IMEI varchar(15)
                        DECLARE @SIM varchar(20)

                        SELECT @IMEI = IMEI
                        FROM catalog.GersStock
                        WHERE OrderDetailId = @OrderDetailId

                        SELECT @SIM = SIM
                        FROM catalog.GersStock
                        WHERE OrderDetailId = @OrderDetailId

                        UPDATE salesorder.WirelessLine
                        SET IMEI = @IMEI
                        WHERE OrderDetailId = @OrderDetailId

                        UPDATE salesorder.WirelessLine
                        SET SIM = @SIM
                        WHERE OrderDetailId = @OrderDetailId
                  
                  SET @RowCount=@@ROWCOUNT;
                  
                  IF @RowCount = @Qty
                  BEGIN
                        INSERT INTO salesorder.Activity (OrderId, Name, Description)
                        VALUES (@OrderId, N'Stock Allocation', N'OrderDetailId: ' + CONVERT(nvarchar,@OrderDetailId) + '  GersSku: ' + @GersSku + '  Qty: ' + CONVERT(nvarchar,@Qty));
                  END
                  ELSE
                        INSERT INTO salesorder.Activity (OrderId, Name, Description)
                        VALUES (@OrderId, N'Back Order', N'OrderDetailId: ' + CONVERT(nvarchar,@OrderDetailId) + '  GersSku: ' + @GersSku + '  Qty: ' + CONVERT(nvarchar,@NewQty));

                  
                        DELETE FROM @table
                        WHERE OrderDetailId IN (
                        SELECT OrderDetailId
                        FROM catalog.GersStock
                        WHERE OrderDetailId IN (
                        SELECT OrderDetailId
                        FROM salesorder.OrderDetail
                        WHERE OrderId = @OrderId AND OrderDetailType IN ('d', 'a') 
                        ))
                  
            END