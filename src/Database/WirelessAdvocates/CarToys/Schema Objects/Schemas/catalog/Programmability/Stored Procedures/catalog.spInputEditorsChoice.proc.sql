
create procedure catalog.spInputEditorsChoice (
@ec1 varchar(9)=Null,@ec2 varchar(9)=Null,@ec3 varchar(9)=Null,@ec4 varchar(9)=Null,
@ec5 varchar(9)=Null,@ec6 varchar(9)=Null,@ec7 varchar(9)=Null,@ec8 varchar(9)=Null,
@ec9 varchar(9)=Null,@ec10 varchar(9)=Null, @ec11 varchar(9)=Null,@ec12 varchar(9)=Null)
	
as

/*

AUTHOR: Greg Montague
CREATED: 11/10/2010

*/
SET NOCOUNT ON
DECLARE @EditorsChoiceRanks TABLE (GersSku nvarchar(9), EditorsChoiceRank smallint, Valid bit);
DECLARE @ErrorsXml varchar(max)=''
DECLARE @GersSku varchar(9)
DECLARE @EditorsChoiceRank smallint

IF @ec1 IS NOT NULL INSERT INTO @EditorsChoiceRanks VALUES (@ec1,1,catalog.CheckGersSku(@ec1));
IF @ec2 IS NOT NULL INSERT INTO @EditorsChoiceRanks VALUES (@ec2,2,catalog.CheckGersSku(@ec2));
IF @ec3 IS NOT NULL INSERT INTO @EditorsChoiceRanks VALUES (@ec3,3,catalog.CheckGersSku(@ec3));
IF @ec4 IS NOT NULL INSERT INTO @EditorsChoiceRanks VALUES (@ec4,4,catalog.CheckGersSku(@ec4));
IF @ec5 IS NOT NULL INSERT INTO @EditorsChoiceRanks VALUES (@ec5,5,catalog.CheckGersSku(@ec5));
IF @ec6 IS NOT NULL INSERT INTO @EditorsChoiceRanks VALUES (@ec6,6,catalog.CheckGersSku(@ec6));
IF @ec7 IS NOT NULL INSERT INTO @EditorsChoiceRanks VALUES (@ec7,7,catalog.CheckGersSku(@ec7));
IF @ec8 IS NOT NULL INSERT INTO @EditorsChoiceRanks VALUES (@ec8,8,catalog.CheckGersSku(@ec8));
IF @ec9 IS NOT NULL INSERT INTO @EditorsChoiceRanks VALUES (@ec9,9,catalog.CheckGersSku(@ec9));
IF @ec10 IS NOT NULL INSERT INTO @EditorsChoiceRanks VALUES (@ec10,10,catalog.CheckGersSku(@ec10));
IF @ec11 IS NOT NULL INSERT INTO @EditorsChoiceRanks VALUES (@ec11,11,catalog.CheckGersSku(@ec11));
IF @ec12 IS NOT NULL INSERT INTO @EditorsChoiceRanks VALUES (@ec12,12,catalog.CheckGersSku(@ec12));

IF (SELECT Count(GersSku)FROM @EditorsChoiceRanks WHERE Valid=0)>0
BEGIN
	DECLARE my_cursor CURSOR FOR
	SELECT GersSku, EditorsChoiceRank FROM @EditorsChoiceRanks WHERE Valid=0

	OPEN my_cursor

	FETCH NEXT FROM my_cursor
	INTO @GersSku, @EditorsChoiceRank

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET	@ErrorsXml=@ErrorsXml+
			'<errors>'+CHAR(13)+
			'<GersSku>'+@GersSku+'</GersSku>'+CHAR(13)+
			'<EditorsChoiceRank>'+CAST(@EditorsChoiceRank AS varchar(2))+'</EditorsChoiceRank>'+CHAR(13)+
			'<ErrMsg>Bad GersSku</ErrMsg>'+CHAR(13)+
			'</errors>'+CHAR(13)
		FETCH NEXT FROM my_cursor
		INTO @GersSku, @EditorsChoiceRank
	END

CLOSE my_cursor
DEALLOCATE my_cursor

	PRINT @ErrorsXml --Do Something with output	 
	
END;


DELETE FROM catalog.Property WHERE Name='sort.EditorsChoice';

INSERT INTO	catalog.Property  (
			ProductGuid, 
			IsCustom,
			LastModifiedDate, 
			LastModifiedBy, 
			Name, 
			Value, 
			Active)
		
SELECT	P.ProductGuid,
		1 AS IsCustom, 
		GETDATE() AS LastModifiedDate, 
		SUSER_SNAME() AS LastModifiedBy, 
		'sort.EditorsChoice' AS Name, 
		E.EditorsChoiceRank AS Value, 
		1 AS Active
FROM	@EditorsChoiceRanks E
		INNER JOIN catalog.Product P 
ON		E.GersSku = P.GersSku
WHERE	E.Valid=1
ORDER BY E.EditorsChoiceRank 
















