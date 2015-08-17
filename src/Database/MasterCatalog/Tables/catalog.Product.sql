CREATE TABLE [catalog].[Product]
(
[ProductId] [int] NULL,
[ProductGuid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ProductGuidUni] DEFAULT (newid()),
[GersSku] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Product_Active] DEFAULT ((0)),
[ChannelID] [int] NOT NULL CONSTRAINT [DF__Product__Channel__7A0EC0D3] DEFAULT ((0)),
[Seed] [int] NOT NULL IDENTITY(15000, 1),
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Product_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [catalog].[Product] ADD CONSTRAINT [UC_ProductIdChannelId] UNIQUE NONCLUSTERED  ([ProductId], [ChannelID]) ON [PRIMARY]

GO
ALTER TABLE [catalog].[Product] ADD CONSTRAINT [UC_ProductIdGersSkuChannelId] UNIQUE NONCLUSTERED  ([ProductId], [GersSku], [ChannelID]) ON [PRIMARY]

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE TRIGGER [catalog].[tr_MasterActive]
   ON  [catalog].[Product]
   AFTER INSERT, UPDATE
AS 
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

DECLARE @ProductGuid uniqueidentifier

SELECT @ProductGuid = ProductGuid FROM inserted

DECLARE @Active bit

SELECT @Active = Active FROM inserted


IF @ProductGuid IN (    SELECT 
	cp.ProductGuid
FROM catalog.Product cp
INNER JOIN (
SELECT DISTINCT
ppc.ParentProductGuid
,p.Active AS 'Active'
FROM
	catalog.Product p
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = p.ProductGuid
WHERE p.Active = '1'
GROUP BY p.ProductId, ppc.ParentProductGuid,p.Active
) AS chick ON chick.ParentProductGuid = cp.ProductGuid
WHERE cp.ProductGuid = @ProductGuid AND cp.ChannelID = '1' AND (cp.Active = '0' AND chick.Active = '1'))

	BEGIN
    UPDATE catalog.Product SET Active = '1'
    WHERE ProductGuid = @ProductGuid 

END ELSE IF @ProductGuid IN (SELECT 
	cp.ProductGuid
FROM catalog.Product cp
INNER JOIN (
SELECT DISTINCT
ppc.ParentProductGuid
,p.Active AS 'Active'
FROM
	catalog.Product p
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = p.ProductGuid
WHERE p.Active = '1'
GROUP BY p.ProductId, ppc.ParentProductGuid,p.Active
) AS chick ON chick.ParentProductGuid = cp.ProductGuid
WHERE ChannelID > '1' AND @Active = '0'
AND chick.Active = '1'
)

	BEGIN
    UPDATE catalog.Product SET Active = '0'
    WHERE ProductGuid IN (SELECT ParentProductGuid FROM catalog.ProducttoParentChannel WHERE ProductGuid = @ProductGuid)


END ELSE IF @ProductGuid IN (SELECT 
	cp.ProductGuid
FROM catalog.Product cp
INNER JOIN (
SELECT DISTINCT
ppc.ParentProductGuid
,p.Active AS 'Active'
FROM
	catalog.Product p
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = p.ProductGuid
WHERE p.Active = '1'
GROUP BY p.ProductId, ppc.ParentProductGuid,p.Active
) AS chick ON chick.ParentProductGuid = cp.ProductGuid
WHERE ChannelID > '1' AND @Active = '0'
AND chick.Active = '0'
)

	BEGIN
    UPDATE catalog.Product SET Active = '0'
    WHERE ProductGuid IN (SELECT ParentProductGuid FROM catalog.ProducttoParentChannel WHERE ProductGuid = @ProductGuid)

END ELSE IF @ProductGuid IN (SELECT 
	cp.ProductGuid
FROM catalog.Product cp
WHERE ChannelID > '1' AND @Active = '1')

	BEGIN
    UPDATE catalog.Product SET Active = '1'
    WHERE ProductGuid IN (SELECT ParentProductGuid FROM catalog.ProducttoParentChannel WHERE ProductGuid = @ProductGuid)
    END




	

END







GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [catalog].[tr_logproduct] ON [catalog].[Product] FOR INSERT, UPDATE, DELETE

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
SELECT @TableName = 'product'

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

CREATE STATISTICS [_dta_stat_1951786877_2_5] ON [catalog].[Product] ([ProductGuid], [ChannelID])

GO
ALTER TABLE [catalog].[Product] ADD CONSTRAINT [IX_ChanneledProductCopy] UNIQUE NONCLUSTERED  ([ProductId], [GersSku], [ChannelID]) ON [PRIMARY]

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE TRIGGER [catalog].[tr_SeedRowInsert]
   ON  [catalog].[Product]
   AFTER INSERT, UPDATE
AS 
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	--IF (SELECT ProductID FROM inserted) IS NULL
	BEGIN
    UPDATE a SET a.ProductId = a.Seed
    FROM catalog.Product a JOIN inserted i ON a.Seed = i.Seed
    WHERE a.ProductId IS NULL
    END

END


GO




ALTER TABLE [catalog].[Product] WITH NOCHECK ADD
CONSTRAINT [FK_Product_GersItm] FOREIGN KEY ([GersSku]) REFERENCES [catalog].[GersItm] ([GersSku])
ALTER TABLE [catalog].[Product] ADD 
CONSTRAINT [PK__Product__D8BC025F763E2FEF] PRIMARY KEY CLUSTERED  ([ProductGuid]) ON [PRIMARY]
GO

EXEC sp_addextendedproperty N'MS_Description', N'List of all products, regardless of it being device, accessory, tablet, etc. with its GERS Sku. Also includes if the product should be actively available on the site or not.', 'SCHEMA', N'catalog', 'TABLE', N'Product', NULL, NULL
GO

EXEC sp_addextendedproperty N'CreateDate', N'25-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'Active'
GO

EXEC sp_addextendedproperty N'MS_Description', N'Whether or not the product is actively listed on the site. (1) Active and (0) Inactive.', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'Active'
GO

EXEC sp_addextendedproperty N'Owner', N'Naomi Hall', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'Active'
GO

EXEC sp_addextendedproperty N'MS_Description', N'Link to GersItm table', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'GersSku'
GO

EXEC sp_addextendedproperty N'MS_Description', N'Link to ProductGuid table', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'ProductGuid'
GO

EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'catalog', 'TABLE', N'Product', 'COLUMN', N'ProductId'
GO
