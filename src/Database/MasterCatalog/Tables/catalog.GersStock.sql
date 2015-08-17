CREATE TABLE [catalog].[GersStock]
(
[GersSku] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OutletId] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OutletCode] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StoreCode] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LocationCode] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Qty] [int] NOT NULL,
[Cost] [money] NOT NULL,
[FiflDate] [date] NOT NULL,
[IMEI] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SIM] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderDetailId] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
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
GO
ALTER TABLE [catalog].[GersStock] ADD CONSTRAINT [PK_GersStock] PRIMARY KEY CLUSTERED  ([OutletId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<GersStockSku, sysname,>] ON [catalog].[GersStock] ([OrderDetailId]) INCLUDE ([GersSku]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'What is in stock on the site. Each device that is in stock is indicated by a unique OutletId. If the device or accessory is not in this table, it is considered out of stock and unavailable. In PROD, this table is always populated through a GERS job. On TEST, it is automatically populated by a separate job that creates fake inventory for testing purposes.', 'SCHEMA', N'catalog', 'TABLE', N'GersStock', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'GersStock', 'COLUMN', N'GersSku'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Links to [catalog].[Product] and [catalog].[GersItm] to name a few', 'SCHEMA', N'catalog', 'TABLE', N'GersStock', 'COLUMN', N'GersSku'
GO
EXEC sp_addextendedproperty N'CreateDate', N'21-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'GersStock', 'COLUMN', N'IMEI'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Links to the [salesorder].[WirelessLine] table', 'SCHEMA', N'catalog', 'TABLE', N'GersStock', 'COLUMN', N'IMEI'
GO
EXEC sp_addextendedproperty N'CreateDate', N'21-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'GersStock', 'COLUMN', N'OrderDetailId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'
Links to the [salesorder].[OrderDetail] table', 'SCHEMA', N'catalog', 'TABLE', N'GersStock', 'COLUMN', N'OrderDetailId'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'GersStock', 'COLUMN', N'OutletId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'catalog', 'TABLE', N'GersStock', 'COLUMN', N'OutletId'
GO
EXEC sp_addextendedproperty N'CreateDate', N'21-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'GersStock', 'COLUMN', N'SIM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'
Links to the [salesorder].[WirelessLine] table', 'SCHEMA', N'catalog', 'TABLE', N'GersStock', 'COLUMN', N'SIM'
GO
