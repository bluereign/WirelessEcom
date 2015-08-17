SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Naomi Hall
-- Create date: 01/07/2014
-- Description:	provide filter management
-- =============================================

CREATE PROCEDURE [catalog].[sp_FilterRemove]
(

@FilterName varchar(100) -- name of filter
,@All varchar(1) -- all phones or some phones (Y or N)
,@Phones VARCHAR(1000) -- GERS SKUs for phones to add



	
)
AS


BEGIN
	SET NOCOUNT ON;



DECLARE @FilterId int
SELECT @FilterId = FilterOptionId FROM catalog.FilterOption WHERE Label = @FilterName

IF (SELECT @FilterId) IS NULL
	PRINT 'Cannot find the filter specified.'
ELSE IF (SELECT @FilterId) IS NOT NULL
	BEGIN
		IF (SELECT @All) IS NULL AND (SELECT @Phones) IS NULL
			PRINT 'You haven''t specified any phones to remove from the filter.'
				ELSE IF (SELECT @Phones) IS NOT NULL OR (SELECT @All) IS NOT NULL
					BEGIN
						IF (SELECT @Phones) IS NOT NULL
							BEGIN						
								DECLARE @GersSkuTable TABLE (PK int IDENTITY(1,1), GersSku nvarchar(9))
								INSERT INTO @GersSkuTable (GersSku)
								SELECT data FROM dbo.split(@Phones,',')
												
								DECLARE @Tag varchar(100)

								SELECT @Tag = LTRIM(REPLACE(REPLACE(REPLACE(DynamicTag,'select productguid from catalog.producttag where tag =',''),'select productguid from catalog.producttag where tag=',''),'''',''))
								FROM catalog.FilterOption
								WHERE FilterOptionId = @FilterId

								DECLARE @NewTagTable TABLE (ProductGuid uniqueidentifier, Tag nvarchar(100))

								INSERT INTO @NewTagTable (ProductGuid, Tag)
								SELECT ProductGuid, @Tag
								FROM catalog.Product cp
								WHERE cp.GersSku IN (
								SELECT GersSku FROM @GersSkuTable
								)

								DELETE FROM catalog.ProductTag
								WHERE CAST(ProductGuid AS NVARCHAR(36))+''+CAST(Tag AS NVARCHAR(36)) IN (SELECT DISTINCT CAST(ProductGuid AS NVARCHAR(36))+''+CAST(Tag AS NVARCHAR(36)) FROM @NewTagTable)

							END
					IF (SELECT @All) = 'Y'
								BEGIN


									DECLARE @RemoveTable TABLE (ProductGuid uniqueidentifier, Tag nvarchar(100))
									INSERT INTO @RemoveTable (ProductGuid, Tag)
									SELECT cpt.ProductGuid, cpt.Tag FROM catalog.ProductTag cpt WHERE cpt.Tag = @Tag
									
									DELETE FROM catalog.ProductTag
									WHERE CAST(ProductGuid AS NVARCHAR(36))+''+CAST(Tag AS NVARCHAR(36)) IN (SELECT DISTINCT CAST(ProductGuid AS NVARCHAR(36))+''+CAST(Tag AS NVARCHAR(36)) FROM @RemoveTable)




END


END
END



	SET NOCOUNT OFF 
END

GO
GRANT EXECUTE ON  [catalog].[sp_FilterRemove] TO [managefilter]
GO
