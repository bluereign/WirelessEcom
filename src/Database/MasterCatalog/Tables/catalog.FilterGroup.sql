CREATE TABLE [catalog].[FilterGroup]
(
[FilterGroupId] [int] NOT NULL IDENTITY(1, 1),
[ProductType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Label] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FieldName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AllowSelectMultiple] [int] NOT NULL,
[Ordinal] [int] NOT NULL,
[Active] [int] NOT NULL
) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------- 
-- Object Type : Trigger
-- Object Name : msdb.tr_logfiltergroup
-- Description : Monitor all changes in the catalog.filtergroup table
-- Author : Naomi Hall
-- Date : December 18th, 2012 -- Edited January 3, 2013
---------------------------------------------------------------------------- 

--The Trigger
CREATE TRIGGER [catalog].[tr_logfiltergroup] ON [catalog].[filtergroup] FOR INSERT, UPDATE, DELETE

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
SELECT @TableName = 'filtergroup'

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

SET @sql1 = N'SELECT ' + @PKHeader + N' FROM #ins'

DECLARE  @t TABLE
(
a varchar(128)
)
INSERT INTO @t (a)
EXEC sp_executesql @sql1

SELECT @PKValue = a FROM @t

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
DISABLE TRIGGER [catalog].[tr_logfiltergroup] ON [catalog].[FilterGroup]
GO

DISABLE TRIGGER [catalog].[tr_logfiltergroup] ON [catalog].[FilterGroup]
GO
ALTER TABLE [catalog].[FilterGroup] ADD CONSTRAINT [PK_FilterGroup] PRIMARY KEY CLUSTERED  ([FilterGroupId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lists categories for the filters. This complements the [catalog].[FilterOption] table.', 'SCHEMA', N'catalog', 'TABLE', N'FilterGroup', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'FilterGroup', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Whether the category should appear (1) on the site or not appear (0).', 'SCHEMA', N'catalog', 'TABLE', N'FilterGroup', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'FilterGroup', 'COLUMN', N'AllowSelectMultiple'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Box (1) versus radial (0) selection on the site.', 'SCHEMA', N'catalog', 'TABLE', N'FilterGroup', 'COLUMN', N'AllowSelectMultiple'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'FilterGroup', 'COLUMN', N'FieldName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Same as Label, but formatted for coding purposes.', 'SCHEMA', N'catalog', 'TABLE', N'FilterGroup', 'COLUMN', N'FieldName'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'FilterGroup', 'COLUMN', N'FilterGroupId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for table.', 'SCHEMA', N'catalog', 'TABLE', N'FilterGroup', 'COLUMN', N'FilterGroupId'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'FilterGroup', 'COLUMN', N'Label'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the category', 'SCHEMA', N'catalog', 'TABLE', N'FilterGroup', 'COLUMN', N'Label'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'FilterGroup', 'COLUMN', N'Ordinal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order the filter appears.', 'SCHEMA', N'catalog', 'TABLE', N'FilterGroup', 'COLUMN', N'Ordinal'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'FilterGroup', 'COLUMN', N'ProductType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'What belongs in the filter: phone
plan
accessory
datacardandnetbook
prepaid', 'SCHEMA', N'catalog', 'TABLE', N'FilterGroup', 'COLUMN', N'ProductType'
GO
