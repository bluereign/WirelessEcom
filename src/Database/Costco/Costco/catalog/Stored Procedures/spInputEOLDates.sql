

create procedure [catalog].[spInputEOLDates] (
@GersSku1 varchar(9)=Null, @eold1 varchar(12)=Null,@GersSku2 varchar(9)=Null, @eold2 varchar(12)=Null,
@GersSku3 varchar(9)=Null, @eold3 varchar(12)=Null,@GersSku4 varchar(9)=Null, @eold4 varchar(12)=Null,
@GersSku5 varchar(9)=Null, @eold5 varchar(12)=Null,@GersSku6 varchar(9)=Null, @eold6 varchar(12)=Null,
@GersSku7 varchar(9)=Null, @eold7 varchar(12)=Null,@GersSku8 varchar(9)=Null, @eold8 varchar(12)=Null,
@GersSku9 varchar(9)=Null, @eold9 varchar(12)=Null,@GersSku10 varchar(9)=Null, @eold10 varchar(12)=Null,
@GersSku11 varchar(9)=Null, @eold11 varchar(12)=Null,@GersSku12 varchar(9)=Null, @eold12 varchar(12)=Null)
as

SET NOCOUNT ON

DECLARE @EOLDates TABLE (GersSku nvarchar(9), EOLDate varchar(12), ValidSku bit, ValidDate bit);
DECLARE @GersSku varchar(9)
DECLARE @eold varchar(12)
DECLARE @ErrSku bit
DECLARE @ErrDate bit
DECLARE @ErrorsXml varchar(max)=''

IF @GersSku1 IS NOT NULL AND @eold1 IS NOT NULL
	INSERT INTO @EOLDates VALUES (@GersSku1,@eold1,catalog.CheckGersSku(@GersSku1),ISDATE(@eold1))
IF @GersSku2 IS NOT NULL AND @eold2 IS NOT NULL
	INSERT INTO @EOLDates VALUES (@GersSku2,@eold2,catalog.CheckGersSku(@GersSku2),ISDATE(@eold2))
IF @GersSku3 IS NOT NULL AND @eold3 IS NOT NULL
	INSERT INTO @EOLDates VALUES (@GersSku3,@eold3,catalog.CheckGersSku(@GersSku3),ISDATE(@eold3))
IF @GersSku4 IS NOT NULL AND @eold4 IS NOT NULL
	INSERT INTO @EOLDates VALUES (@GersSku4,@eold4,catalog.CheckGersSku(@GersSku4),ISDATE(@eold4))
IF @GersSku5 IS NOT NULL AND @eold5 IS NOT NULL
	INSERT INTO @EOLDates VALUES (@GersSku5,@eold5,catalog.CheckGersSku(@GersSku5),ISDATE(@eold5))
IF @GersSku6 IS NOT NULL AND @eold1 IS NOT NULL
	INSERT INTO @EOLDates VALUES (@GersSku6,@eold6,catalog.CheckGersSku(@GersSku6),ISDATE(@eold6))
IF @GersSku7 IS NOT NULL AND @eold1 IS NOT NULL
	INSERT INTO @EOLDates VALUES (@GersSku7,@eold7,catalog.CheckGersSku(@GersSku7),ISDATE(@eold7))
IF @GersSku8 IS NOT NULL AND @eold1 IS NOT NULL
	INSERT INTO @EOLDates VALUES (@GersSku8,@eold8,catalog.CheckGersSku(@GersSku8),ISDATE(@eold8))
IF @GersSku9 IS NOT NULL AND @eold1 IS NOT NULL
	INSERT INTO @EOLDates VALUES (@GersSku9,@eold9,catalog.CheckGersSku(@GersSku9),ISDATE(@eold9))
IF @GersSku10 IS NOT NULL AND @eold1 IS NOT NULL
	INSERT INTO @EOLDates VALUES (@GersSku10,@eold10,catalog.CheckGersSku(@GersSku10),ISDATE(@eold10))					
IF @GersSku11 IS NOT NULL AND @eold1 IS NOT NULL
	INSERT INTO @EOLDates VALUES (@GersSku11,@eold11,catalog.CheckGersSku(@GersSku11),ISDATE(@eold11))
IF @GersSku12 IS NOT NULL AND @eold1 IS NOT NULL
	INSERT INTO @EOLDates VALUES (@GersSku12,@eold12,catalog.CheckGersSku(@GersSku12),ISDATE(@eold12));	

IF (SELECT COUNT(*) FROM @EOLDates WHERE ValidSku=0 or ValidDate=0)>0	
BEGIN
	DECLARE my_cursor CURSOR FOR
	SELECT GersSku, EOLDate, ValidSku, ValidDate FROM @EOLDates WHERE ValidSku=0 OR ValidDate=0

	OPEN my_cursor

	FETCH NEXT FROM my_cursor
	INTO @GersSku, @eold, @ErrSku, @ErrDate

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET	@ErrorsXml=@ErrorsXml+
			'<Errors>'+CHAR(13)+
			'<GersSku>'+@GersSku+'</GersSku>'+CHAR(13)+
			'<EOLDate>'+@eold+'</EOLDate>'+CHAR(13)+
			'<ErrSku>'+
			case
			when @ErrSku=0 Then 'Bad GersSku'
			else '' end+'</ErrSku>'+CHAR(13)+
			'<ErrDate>'+
			case
			when @ErrDate=0 then 'Invalid Date'
			else '' end+'</ErrDate>'+CHAR(13)+
			'</Errors>'+CHAR(13)
		FETCH NEXT FROM my_cursor
		INTO @GersSku, @eold, @ErrSku, @ErrDate
	END

CLOSE my_cursor
DEALLOCATE my_cursor

	PRINT @ErrorsXml --Do Something with output	 
	
END;


WITH 
	ExistingEOLDateProperties AS 
		(
			SELECT *
			FROM catalog.Property
			WHERE Name = 'EOLDate'
		),
	NewEOLDateProperties AS
		(
			SELECT	P.ProductGuid,
					1 AS IsCustom,
					GETDATE() AS LastModifiedDate,
					SUSER_SNAME() AS LastModifiedBy,
					'EOLDate' AS Name,
					CAST(L.EOLDate AS DATE)AS Value,
					1 AS Active
			FROM	@EOLDates L
					INNER JOIN catalog.Product P 
			ON		L.GersSku = P.GersSku
			WHERE	L.ValidDate=1 AND L.ValidSku=1
		)
		
MERGE INTO ExistingEOLDateProperties AS trg
USING NewEOLDateProperties AS src
ON	trg.ProductGuid = src.ProductGuid AND trg.Name = src.name
	WHEN NOT MATCHED BY TARGET
		THEN INSERT
			([ProductGuid],
           [IsCustom],
           [LastModifiedDate],
           [LastModifiedBy],
           [Name],
           [Value],
           [Active])
		VALUES
			(src.ProductGuid,
			src.IsCustom,
			src.LastModifiedDate,
			src.LastModifiedBy,
			src.Name,
			CAST(src.Value AS DATE),
			src.Active)
	WHEN MATCHED AND trg.Value != src.Value
		THEN UPDATE SET trg.IsCustom = src.IsCustom,
						trg.LastModifiedDate = src.LastModifiedDate,
						trg.LastModifiedBy = src.LastModifiedBy,
						trg.Value = CAST(src.Value AS DATE),
						trg.Active = src.Active;