
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author:		Ron Delzer
-- Create date: 3/3/2010
-- Description:	
-- =============================================
CREATE PROCEDURE [catalog].[CreateFreeAccessory] 
	-- Add the parameters for the stored procedure here
	@GersSku nvarchar(9),
	@UPC varchar(12),
	@Name nvarchar(67)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @GUID uniqueidentifier = NEWID();
	
	INSERT INTO catalog.Accessory (AccessoryGuid, UPC, Name) VALUES(@GUID, @UPC, @Name);
	INSERT INTO catalog.ProductGuid (ProductGuid, ProductTypeId) VALUES(@GUID, 4);
	INSERT INTO catalog.Product (ProductGuid, GersSku, Active) VALUES(@GUID, @GersSku, 1);
	INSERT INTO catalog.ProductTag (ProductGuid, Tag) VALUES (@GUID, 'freeaccessory');
END



GO
