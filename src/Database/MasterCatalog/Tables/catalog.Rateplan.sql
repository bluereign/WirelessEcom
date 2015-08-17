CREATE TABLE [catalog].[Rateplan]
(
[RateplanGuid] [uniqueidentifier] NOT NULL,
[CarrierGuid] [uniqueidentifier] NOT NULL,
[CarrierBillCode] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContractTerm] [int] NULL,
[IncludedLines] [int] NULL,
[MaxLines] [int] NULL,
[MonthlyFee] [money] NULL,
[AdditionalLineBillCode] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalLineFee] [money] NULL,
[PrimaryActivationFee] [money] NULL,
[SecondaryActivationFee] [money] NULL,
[IsShared] [bit] NOT NULL CONSTRAINT [DF__Rateplan__IsShar__767BC50C] DEFAULT ((0))
) ON [PRIMARY]
GO
CREATE STATISTICS [_dta_stat_1235587540_2_1] ON [catalog].[Rateplan] ([CarrierGuid], [RateplanGuid])

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------- 
-- Object Type : Trigger
-- Object Name : msdb.tr_lograteplan
-- Description : Monitor all changes in the catalog.rateplan table
-- Author : Naomi Hall
-- Date : December 18th, 2012 -- Edited January 3, 2013
---------------------------------------------------------------------------- 

--The Trigger
CREATE TRIGGER [catalog].[tr_lograteplan] ON [catalog].[Rateplan] FOR INSERT, UPDATE, DELETE

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
SELECT @TableName = 'rateplan'

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
ALTER TABLE [catalog].[Rateplan] ADD CONSTRAINT [PK_Rateplan] PRIMARY KEY CLUSTERED  ([RateplanGuid]) ON [PRIMARY]
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Rateplan] ON [catalog].[Rateplan] ([RateplanGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [catalog].[Rateplan] WITH NOCHECK ADD CONSTRAINT [FK_Rateplan_ProductGuidType] FOREIGN KEY ([RateplanGuid]) REFERENCES [catalog].[ProductGuid] ([ProductGuid])
GO
EXEC sp_addextendedproperty N'Bug', N'3654: http://tfserver:8080/tfs/web/wi.aspx?pguid=9af0ae7b-6890-4e1a-81aa-368b430d7527&id=3654', 'SCHEMA', N'catalog', 'TABLE', N'Rateplan', 'COLUMN', N'IsShared'
GO
EXEC sp_addextendedproperty N'CreateDate', N'27-JUN-2012', 'SCHEMA', N'catalog', 'TABLE', N'Rateplan', 'COLUMN', N'IsShared'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Implemented to originally handle Verizon Share plans', 'SCHEMA', N'catalog', 'TABLE', N'Rateplan', 'COLUMN', N'IsShared'
GO
EXEC sp_addextendedproperty N'Owner', N'Naomi Hall', 'SCHEMA', N'catalog', 'TABLE', N'Rateplan', 'COLUMN', N'IsShared'
GO
EXEC sp_addextendedproperty N'Release', N'3.4.0', 'SCHEMA', N'catalog', 'TABLE', N'Rateplan', 'COLUMN', N'IsShared'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to ProductGuid table', 'SCHEMA', N'catalog', 'TABLE', N'Rateplan', 'COLUMN', N'RateplanGuid'
GO
