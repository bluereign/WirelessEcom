SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ron Delzer
-- Create date: 2/9/2010
-- Description:	Clones Features for Device
-- =============================================
CREATE PROCEDURE [catalog].[CloneDeviceFeatures] 
	-- Add the parameters for the stored procedure here
	@SourceProductId int, 
	@DestinationProductId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Delete all features from destination device
	DELETE P
	FROM         catalog.PropertyMasterGroup AS PMG INNER JOIN
						  catalog.PropertyMaster AS PM ON PMG.PropertyMasterGroupGuid = PM.PropertyMasterGroupGuid INNER JOIN
						  catalog.PropertyMasterAlias AS PMA ON PM.PropertyMasterGuid = PMA.PropertyMasterGuid INNER JOIN
						  catalog.Property AS P ON PMA.CarrierPropertyName = P.Name INNER JOIN
						  catalog.Product AS Prod ON P.ProductGuid = Prod.ProductGuid
	WHERE     (Prod.ProductId = @DestinationProductId);
	
	-- copy features from source device to destination device
	INSERT INTO [catalog].[Property]
           ([ProductGuid]
           ,[IsCustom]
           ,[LastModifiedDate]
           ,[LastModifiedBy]
           ,[Name]
           ,[Value]
           ,[Active])
	SELECT     (SELECT     ProductGuid
						   FROM          catalog.Product
						   WHERE      (ProductId = @DestinationProductId)) AS ProductGuid, P.IsCustom, P.LastModifiedDate, P.LastModifiedBy, P.Name, P.Value, P.Active
	FROM         catalog.PropertyMasterGroup AS PMG INNER JOIN
						  catalog.PropertyMaster AS PM ON PMG.PropertyMasterGroupGuid = PM.PropertyMasterGroupGuid INNER JOIN
						  catalog.PropertyMasterAlias AS PMA ON PM.PropertyMasterGuid = PMA.PropertyMasterGuid INNER JOIN
						  catalog.Property AS P ON PMA.CarrierPropertyName = P.Name INNER JOIN
						  catalog.Product AS Prod ON P.ProductGuid = Prod.ProductGuid
	WHERE     (Prod.ProductId = @SourceProductId);
END
GO
