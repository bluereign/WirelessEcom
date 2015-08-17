SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [filter].[AddProducts]
(

@FilterId int -- ID of filter
,@Phones VARCHAR(1000) -- GERS SKUs for phones to add


	
)
AS


BEGIN
	SET NOCOUNT ON;

IF (SELECT @FilterId) IS NULL
	PRINT 'Cannot find the filter specified.'
ELSE IF (SELECT @FilterId) IS NOT NULL
	BEGIN
		IF (SELECT @Phones) IS NULL
		PRINT 'BOO, NO GERSSKUS SPECIFIED!'
				ELSE IF (SELECT @Phones) IS NOT NULL
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

DELETE FROM @NewTagTable
WHERE CAST(ProductGuid AS NVARCHAR(36))+''+CAST(Tag AS NVARCHAR(36)) IN (SELECT DISTINCT CAST(ProductGuid AS NVARCHAR(36))+''+CAST(Tag AS NVARCHAR(36)) FROM catalog.ProductTag)

INSERT INTO catalog.ProductTag (ProductGuid, Tag)
SELECT ProductGuid, Tag FROM @NewTagTable

END
END

	SET NOCOUNT OFF 
END


GO
