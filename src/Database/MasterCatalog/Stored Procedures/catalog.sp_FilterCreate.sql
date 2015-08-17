
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:		Naomi Hall
-- Create date: 01/07/2014
-- Description:	provide filter management
-- =============================================

CREATE PROCEDURE [catalog].[sp_FilterCreate]
(

@FilterName varchar(100) -- Name of filter
,@Group varchar(100) -- where the filter will go
,@Tag varchar(100) -- include phones tagged with this phrase
,@Costco varchar(1) -- include for Costco (Y or N)
,@AAFES varchar(1) -- include for AAFES (Y or N)
,@Phones VARCHAR(1000) -- GERS SKUs for phones (it's ok to be blank if you don't know SKUs yet and want to add later_
,@Active varchar(1) -- Active (Y or N)
,@Ordinal int -- order in the group

	
)
AS


BEGIN
	SET NOCOUNT ON;



DECLARE @GroupID int
SELECT @GroupID = FilterGroupId FROM catalog.FilterGroup WHERE Label = @Group

DECLARE @ActInt int

IF (@Active = 'Y')
	BEGIN
		SET @ActInt = '1'
	END
IF (@Active = 'N')
	BEGIN
		SET @ActInt = '0'
	END

INSERT INTO [catalog].[FilterOption]
(
      FilterGroupId
      , Label
      , Tag
      , DynamicTag
      , Ordinal
      , Active
)
VALUES
(
      @GroupId
      , @FilterName
      , @Tag
      , NULL
      , @Ordinal
      , @ActInt
)

DECLARE @NewId int
SELECT @NewId = MAX(FilterOptionId) FROM catalog.FilterOption

UPDATE catalog.FilterOption
SET DynamicTag = 'SELECT productguid FROM catalog.producttag WHERE tag = ''' + @Tag + ''''
WHERE FilterOptionId = @NewId


SELECT 'Your new filter ID is ' + CONVERT(VARCHAR(10),@NewId) + '.' AS 'New Filter Id', @FilterName AS 'Filter Name'			

	IF (@Costco = 'Y')
		BEGIN
			INSERT INTO catalog.FilterChannel (FilterOptionId, FilterGroupId, ChannelId, Active)
			VALUES (@NewId, @GroupID, '2',@ActInt)
		END
		
	IF (@AAFES = 'Y')
		BEGIN
			INSERT INTO catalog.FilterChannel (FilterOptionId, FilterGroupId, ChannelId, Active)
			VALUES (@NewId, @GroupID, '3',@ActInt)
		END

	IF (LEN(@Phones) > '0')
		BEGIN

   			DECLARE @GersSkuTable TABLE (PK int IDENTITY(1,1), GersSku nvarchar(9))
			INSERT INTO @GersSkuTable (GersSku)
			SELECT data FROM dbo.split(@Phones,',')

			DECLARE @NewTagTable TABLE (ProductGuid uniqueidentifier, Tag nvarchar(100))

			INSERT INTO @NewTagTable (ProductGuid, Tag)
			SELECT ProductGuid, @Tag
			FROM catalog.Product cp
			WHERE cp.GersSku IN (
			SELECT GersSku FROM @GersSkuTable
			)

			DELETE FROM @NewTagTable
			WHERE CAST(ProductGuid AS NVARCHAR(36))+''+CAST(Tag AS NVARCHAR(36)) IN (SELECT DISTINCT CAST(ProductGuid AS NVARCHAR(36))+''+CAST(Tag AS NVARCHAR(36)) FROM catalog.ProductTag)


			INSERT INTO catalog.ProductTag (ProductGuid, Tag)
			SELECT ProductGuid, Tag FROM @NewTagTable
			END

	SET NOCOUNT OFF 
END


GO

GRANT EXECUTE ON  [catalog].[sp_FilterCreate] TO [managefilter]
GO
