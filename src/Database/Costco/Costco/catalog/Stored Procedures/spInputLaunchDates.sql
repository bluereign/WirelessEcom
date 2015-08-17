

CREATE procedure [catalog].[spInputLaunchDates] (
@GersSku1 varchar(9)=Null, @ld1 varchar(12)=Null,@GersSku2 varchar(9)=Null, @ld2 varchar(12)=Null,
@GersSku3 varchar(9)=Null, @ld3 varchar(12)=Null,@GersSku4 varchar(9)=Null, @ld4 varchar(12)=Null,
@GersSku5 varchar(9)=Null, @ld5 varchar(12)=Null,@GersSku6 varchar(9)=Null, @ld6 varchar(12)=Null,
@GersSku7 varchar(9)=Null, @ld7 varchar(12)=Null,@GersSku8 varchar(9)=Null, @ld8 varchar(12)=Null,
@GersSku9 varchar(9)=Null, @ld9 varchar(12)=Null,@GersSku10 varchar(9)=Null, @ld10 varchar(12)=Null,
@GersSku11 varchar(9)=Null, @ld11 varchar(12)=Null,@GersSku12 varchar(9)=Null, @ld12 varchar(12)=Null)
as

SET NOCOUNT ON

DECLARE @LaunchDates TABLE (GersSku nvarchar(9), LaunchDate varchar(12), ValidSku bit, ValidDate bit);
DECLARE @GersSku varchar(9)
DECLARE @ld varchar(12)
DECLARE @ErrSku bit
DECLARE @ErrDate bit
DECLARE @ErrorsXml varchar(max)=''

IF @GersSku1 IS NOT NULL AND @ld1 IS NOT NULL
	INSERT INTO @LaunchDates VALUES (@GersSku1,@ld1,catalog.CheckGersSku(@GersSku1),ISDATE(@ld1))
IF @GersSku2 IS NOT NULL AND @ld2 IS NOT NULL
	INSERT INTO @LaunchDates VALUES (@GersSku2,@ld2,catalog.CheckGersSku(@GersSku2),ISDATE(@ld2))
IF @GersSku3 IS NOT NULL AND @ld3 IS NOT NULL
	INSERT INTO @LaunchDates VALUES (@GersSku3,@ld3,catalog.CheckGersSku(@GersSku3),ISDATE(@ld3))
IF @GersSku4 IS NOT NULL AND @ld4 IS NOT NULL
	INSERT INTO @LaunchDates VALUES (@GersSku4,@ld4,catalog.CheckGersSku(@GersSku4),ISDATE(@ld4))
IF @GersSku5 IS NOT NULL AND @ld5 IS NOT NULL
	INSERT INTO @LaunchDates VALUES (@GersSku5,@ld5,catalog.CheckGersSku(@GersSku5),ISDATE(@ld5))
IF @GersSku6 IS NOT NULL AND @ld1 IS NOT NULL
	INSERT INTO @LaunchDates VALUES (@GersSku6,@ld6,catalog.CheckGersSku(@GersSku6),ISDATE(@ld6))
IF @GersSku7 IS NOT NULL AND @ld1 IS NOT NULL
	INSERT INTO @LaunchDates VALUES (@GersSku7,@ld7,catalog.CheckGersSku(@GersSku7),ISDATE(@ld7))
IF @GersSku8 IS NOT NULL AND @ld1 IS NOT NULL
	INSERT INTO @LaunchDates VALUES (@GersSku8,@ld8,catalog.CheckGersSku(@GersSku8),ISDATE(@ld8))
IF @GersSku9 IS NOT NULL AND @ld1 IS NOT NULL
	INSERT INTO @LaunchDates VALUES (@GersSku9,@ld9,catalog.CheckGersSku(@GersSku9),ISDATE(@ld9))
IF @GersSku10 IS NOT NULL AND @ld1 IS NOT NULL
	INSERT INTO @LaunchDates VALUES (@GersSku10,@ld10,catalog.CheckGersSku(@GersSku10),ISDATE(@ld10))					
IF @GersSku11 IS NOT NULL AND @ld1 IS NOT NULL
	INSERT INTO @LaunchDates VALUES (@GersSku11,@ld11,catalog.CheckGersSku(@GersSku11),ISDATE(@ld11))
IF @GersSku12 IS NOT NULL AND @ld1 IS NOT NULL
	INSERT INTO @LaunchDates VALUES (@GersSku12,@ld12,catalog.CheckGersSku(@GersSku12),ISDATE(@ld12));	

IF (SELECT COUNT(*) FROM @LaunchDates WHERE ValidSku=0 or ValidDate=0)>0	
BEGIN
	DECLARE my_cursor CURSOR FOR
	SELECT GersSku, LaunchDate, ValidSku, ValidDate FROM @LaunchDates WHERE ValidSku=0 OR ValidDate=0

	OPEN my_cursor

	FETCH NEXT FROM my_cursor
	INTO @GersSku, @ld, @ErrSku, @ErrDate

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET	@ErrorsXml=@ErrorsXml+
			'<Errors>'+CHAR(13)+
			'<GersSku>'+@GersSku+'</GersSku>'+CHAR(13)+
			'<LaunchDate>'+@ld+'</LaunchDate>'+CHAR(13)+
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
		INTO @GersSku, @ld, @ErrSku, @ErrDate
	END

CLOSE my_cursor
DEALLOCATE my_cursor

	PRINT @ErrorsXml --Do Something with output	 
	
END;


WITH 
	ExistingLaunchDateProperties AS 
		(
			SELECT *
			FROM catalog.Property
			WHERE Name = 'LaunchDate'
		),
	NewLaunchDateProperties AS
		(
			SELECT	P.ProductGuid,
					1 AS IsCustom,
					GETDATE() AS LastModifiedDate,
					SUSER_SNAME() AS LastModifiedBy,
					'LaunchDate' AS Name,
					CAST(L.LaunchDate AS DATE)AS Value,
					1 AS Active
			FROM	@LaunchDates L
					INNER JOIN catalog.Product P 
			ON		L.GersSku = P.GersSku
			WHERE	L.ValidDate=1 AND L.ValidSku=1
		)
		
MERGE INTO ExistingLaunchDateProperties AS trg
USING NewLaunchDateProperties AS src
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