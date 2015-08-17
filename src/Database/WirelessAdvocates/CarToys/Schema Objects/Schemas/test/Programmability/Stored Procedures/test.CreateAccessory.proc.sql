﻿-- =============================================
-- Author:		Ron Delzer
-- Create date: 3/3/2010
-- Description:	
-- =============================================
CREATE PROCEDURE [test].[CreateAccessory] 
	-- Add the parameters for the stored procedure here
	@GersSku varchar(9),
	@UPC varchar(12),
	@Name nvarchar(67),
	@Tag nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @GUID uniqueidentifier = NEWID();
	
	INSERT INTO catalog.ProductGuid VALUES(@GUID, 4);
	INSERT INTO catalog.Accessory VALUES(@GUID, NULL, @UPC, @Name);
	INSERT INTO catalog.Product (ProductGuid, GersSku, Active) VALUES(@GUID, @GersSku, 1);
	INSERT INTO catalog.ProductTag VALUES (@GUID, @Tag);
	
	
	
	
END
