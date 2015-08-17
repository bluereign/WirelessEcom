CREATE TABLE [catalog].[GersStock] (
    [GersSku]       NVARCHAR (9)  NOT NULL,
    [OutletId]      NVARCHAR (10) NOT NULL,
    [OutletCode]    NVARCHAR (3)  NOT NULL,
    [StoreCode]     NVARCHAR (2)  NOT NULL,
    [LocationCode]  NVARCHAR (6)  NOT NULL,
    [Qty]           INT           NOT NULL,
    [Cost]          MONEY         NOT NULL,
    [FiflDate]      DATE          NOT NULL,
    [IMEI]          VARCHAR (15)  NULL,
    [SIM]           VARCHAR (20)  NULL,
    [OrderDetailId] INT           NULL,
    [BlockId]       INT           NULL,
    CONSTRAINT [PK_GersStock] PRIMARY KEY CLUSTERED ([OutletId] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_GS_CascadeId] FOREIGN KEY ([BlockId]) REFERENCES [ALLOCATION].[Block] ([BlockId])
);


GO
CREATE NONCLUSTERED INDEX [NCL_catalog_GersStock_GersSku]
    ON [catalog].[GersStock]([GersSku] ASC)
    INCLUDE([BlockId]) WITH (DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [<GersStockSku, sysname,>]
    ON [catalog].[GersStock]([OrderDetailId] ASC)
    INCLUDE([GersSku]) WITH (FILLFACTOR = 80);


GO
CREATE STATISTICS [_dta_stat_563585146_11_9]
    ON [catalog].[GersStock]([OrderDetailId], [IMEI]);


GO
CREATE STATISTICS [_dta_stat_563585146_2_1]
    ON [catalog].[GersStock]([OutletId], [GersSku]);


GO
CREATE STATISTICS [_dta_stat_563585146_11_3_1_2]
    ON [catalog].[GersStock]([OrderDetailId], [OutletCode], [GersSku], [OutletId]);


GO
CREATE STATISTICS [_dta_stat_563585146_1_11_8]
    ON [catalog].[GersStock]([GersSku], [OrderDetailId], [FiflDate]);


GO
CREATE STATISTICS [_dta_stat_563585146_11_2_1]
    ON [catalog].[GersStock]([OrderDetailId], [OutletId], [GersSku]);


GO
CREATE STATISTICS [_dta_stat_563585146_3_2_1]
    ON [catalog].[GersStock]([OutletCode], [OutletId], [GersSku]);


GO
CREATE STATISTICS [_dta_stat_563585146_9]
    ON [catalog].[GersStock]([IMEI]);


GO
CREATE STATISTICS [_dta_stat_563585146_3_11_2]
    ON [catalog].[GersStock]([OutletCode], [OrderDetailId], [OutletId]);


GO
CREATE STATISTICS [_dta_stat_563585146_2_3]
    ON [catalog].[GersStock]([OutletId], [OutletCode]);


GO
CREATE STATISTICS [_dta_stat_563585146_3_1_11_8]
    ON [catalog].[GersStock]([OutletCode], [GersSku], [OrderDetailId], [FiflDate]);


GO
---------------------------------------------------------------------------- 
-- Object Type : Trigger
-- Object Name : msdb.tr_loggersstock
-- Description : Monitor all changes in the catalog.gersstock table
-- Author : Naomi Hall
-- Date : December 18th, 2012
---------------------------------------------------------------------------- 

--The Trigger
CREATE TRIGGER [catalog].[tr_loggersstock] ON [catalog].[GersStock] FOR INSERT, UPDATE, DELETE

AS

DECLARE @bit int
	,@field int
	,@maxfield int
	,@char int
	,@fieldname varchar(128)
	,@TableName varchar(128)
	,@SchemaName varchar(128)
	,@PKCols varchar(1000)
	,@PKHeader varchar(128)
	,@PKValue varchar(128)
	,@sql nvarchar(MAX)
	,@sql1 nvarchar(MAX)
	,@UserName varchar(128)
	,@HostName varchar(128)
	,@ServerName varchar(128)
	,@Type varchar(1)
	,@PKSelect varchar(1000)
	
SELECT @SchemaName = 'catalog'
SELECT @TableName = 'gersstock'

-- Date, User, Host, Server
SELECT 	@UserName = SYSTEM_USER
		,@HostName = HOST_NAME()
		,@ServerName = @@SERVERNAME


-- Action
	IF EXISTS (SELECT * FROM inserted)
	IF EXISTS (SELECT * FROM deleted)
			SELECT @Type = 'U'
		ELSE
			SELECT @Type = 'I'
	ELSE
		SELECT @Type = 'D'
	
-- Get list of columns changed
	SELECT * INTO #ins FROM inserted
	SELECT * INTO #del FROM deleted
	
-- Get primary key columns for full outer join
	SELECT	@PKCols = coalesce(@PKCols + ' and', ' on') + ' i.' + c.COLUMN_NAME + ' = d.' + c.COLUMN_NAME
	FROM	INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,
		INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
	WHERE 	pk.TABLE_NAME = @TableName
	AND pk.TABLE_SCHEMA = @SchemaName
	AND	CONSTRAINT_TYPE = 'PRIMARY KEY'
	AND	c.TABLE_NAME = pk.TABLE_NAME
	and c.TABLE_SCHEMA = pk.TABLE_SCHEMA
	AND	c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME
	
-- Get primary key select for insert
	SELECT @PKSelect = coalesce(@PKSelect+'+','') + '''<' + COLUMN_NAME + '=''+convert(varchar(100),coalesce(i.' + COLUMN_NAME +',d.' + COLUMN_NAME + '))+''>''' 
	FROM	INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,
		INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
	WHERE 	pk.TABLE_NAME = @TableName
	AND pk.TABLE_SCHEMA = @SchemaName
	AND	CONSTRAINT_TYPE = 'PRIMARY KEY'
	AND	c.TABLE_NAME = pk.TABLE_NAME
	AND	c.TABLE_SCHEMA = pk.TABLE_SCHEMA
	AND	c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME

-- Get primary key select for insert
	SELECT @PKHeader = c.COLUMN_NAME
	FROM	INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,
		INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
	WHERE 	pk.TABLE_NAME = @TableName
	AND pk.TABLE_SCHEMA = @SchemaName
	AND	CONSTRAINT_TYPE = 'PRIMARY KEY'
	AND	c.TABLE_NAME = pk.TABLE_NAME
	AND	c.TABLE_SCHEMA = pk.TABLE_SCHEMA
	AND	c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME


	IF (@Type = 'D')
	
BEGIN
SET @sql1 = N'SELECT ' + @PKHeader + N' FROM #del'

DECLARE  @t TABLE
(
a varchar(128)
)
INSERT INTO @t (a)
EXEC sp_executesql @sql1

SELECT @PKValue = a FROM @t

END
ELSE 

SET @sql1 = N'SELECT ' + @PKHeader + N' FROM #ins'

DECLARE  @t2 TABLE
(
a varchar(128)
)
INSERT INTO @t2 (a)
EXEC sp_executesql @sql1

SELECT @PKValue = a FROM @t2

	
	IF @PKCols is null
	BEGIN
		RAISERROR('no PK on table %s', 16, -1, @TableName)
		RETURN
	END
	
	SELECT @field = 0, @maxfield = max(ORDINAL_POSITION) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName
	WHILE @field < @maxfield
	BEGIN
		SELECT @field = min(ORDINAL_POSITION) from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TableName and ORDINAL_POSITION > @field
		SELECT @bit = (@field - 1 )% 8 + 1
		SELECT @bit = power(2,@bit - 1)
		SELECT @char = ((@field - 1) / 8) + 1
		IF substring(COLUMNS_UPDATED(),@char, 1) & @bit > 0 or @Type in ('I','D')
		BEGIN
			SELECT @fieldname = COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TableName AND TABLE_SCHEMA = @SchemaName AND ORDINAL_POSITION = @field
			SELECT @SQL = 'INSERT INTO logging.CatalogAudit (Type, SchemaName, TableName, PKCol, FieldName, OldValue, NewValue, UpdateDate, UserName, Hostname, ServerName)'
			+' SELECT '+''''+ @Type+''''+', '+''''+@SchemaName+''''+', '+''''+@TableName+''''+', '+''''+@PKValue+''''+', convert(varchar(1000),'+''''+@FieldName+''''+'),convert(varchar(1000),d.'+@fieldname+'),'
			+' convert(varchar(1000),i.'+@fieldname+'),GETDATE(),convert(varchar(1000),'''+@UserName+'''),convert(varchar(1000),'''+@HostName+'''),convert(varchar(1000),'''+@ServerName+''')'
			+' FROM #ins i FULL OUTER JOIN #del d '+@PKCols
			+' WHERE i.'+@fieldname+' <> d.'+@fieldname+' OR (i.'+@fieldname+' IS NULL AND d.'+@fieldname+' IS NOT NULL)'
			+' OR (i.'+@fieldname+' IS NOT NULL AND d.'+@fieldname+' IS NULL)'
			EXECUTE (@sql)
		END
	END