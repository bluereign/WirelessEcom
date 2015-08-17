CREATE PROCEDURE [orders].[sp_FixMissingProperty]
(@GersSku varchar(25))
As

	DECLARE @ProductGuid uniqueidentifier 
	
	SET @ProductGuid = (SELECT TOP 1 ProductGuid from Catalog.Product where GersSku = @GersSku)
	
	if @ProductGuid is not null	
	begin
		DECLARE @Count int
		
		SET @Count = (SELECT COUNT(*) FROM catalog.Property
			WHERE ProductGUID = @ProductGuid)
			
		IF (@Count = 0)
		begin
			DECLARE @Title varchar(255)
			
			SET @Title = (SELECT TOP 1 Description from catalog.GersItm
							where GersSku = @GersSku)
			
			IF @Title is not null
			begin
				insert into catalog.Property
				(ProductGUID, ISCustom, LastMOdifiedDate, LastmOdifiedBy, Name, Value, Active)
				values (@ProductGuid, 1, getdate(), 'Order Tool','title',@Title, 1)
			end
		end
		
		--IF (@Count = 2)
		--BEGIN
		--	DELETE TOP(1) FROM catalog.Property
		--	WHERE ProductGUID = @ProductGuid
		--END		
	end