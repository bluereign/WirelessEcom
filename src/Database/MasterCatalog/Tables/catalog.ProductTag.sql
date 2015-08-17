CREATE TABLE [catalog].[ProductTag]
(
[ProductGuid] [uniqueidentifier] NOT NULL,
[Tag] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
	
CREATE TRIGGER [catalog].[tr_producttag] ON [catalog].[ProductTag]
    AFTER INSERT, UPDATE, DELETE
AS
    SET NOCOUNT ON 
        
		IF EXISTS(SELECT 1 FROM inserted I)
			    BEGIN
			    INSERT INTO logging.ProductTag
			    (Type
			    ,ProductGuid
				,Tag
				)
			        SELECT
                        'I'
                        ,pt.ProductGuid
                        ,pt.Tag
                    FROM
                        catalog.ProductTag pt
                        INNER JOIN inserted b ON pt.ProductGuid = b.ProductGuid and pt.Tag = b.Tag
			    END 
			ELSE IF EXISTS(SELECT 1 FROM DELETED D)
			    BEGIN
			    INSERT INTO logging.ProductTag
			    (
			    Type
			    ,ProductGuid
				,Tag
				)
			        SELECT
                        'D'
                        ,pt.ProductGuid
                        ,pt.Tag
                    FROM
                        catalog.ProductTag pt
                        INNER JOIN deleted b ON pt.ProductGuid = b.ProductGuid and pt.Tag = b.Tag
			    END 


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE TRIGGER [catalog].[tr_producttag2] ON [catalog].[ProductTag]
    AFTER DELETE
AS
    SET NOCOUNT ON 
        
			IF EXISTS(SELECT 1 FROM DELETED D)
			    BEGIN
			    INSERT INTO logging.ProductTag
			    (
			    Type
			    ,ProductGuid
				,Tag
				)
			        SELECT
                        'D'
                        ,b.ProductGuid
                        ,b.Tag
                    FROM
                        deleted b
			    END 
GO

GRANT SELECT ON  [catalog].[ProductTag] TO [managefilter]
GO

DISABLE TRIGGER [catalog].[tr_logproducttag] ON [catalog].[ProductTag]
GO

DISABLE TRIGGER [catalog].[tr_logproducttag] ON [catalog].[ProductTag]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--The Trigger
CREATE TRIGGER [catalog].[tr_releasesafetystock] ON [catalog].[ProductTag] FOR INSERT, UPDATE, DELETE

AS

-- Action
	IF EXISTS (SELECT ProductGuid FROM inserted WHERE Tag = 'closeout')
	BEGIN
-- Get list of columns changed
	SELECT ProductGuid INTO #ins FROM inserted

	DECLARE @GersSku varchar(9)

	SELECT @GersSku = cp.GersSku FROM catalog.Product cp INNER JOIN #ins i ON i.ProductGuid = cp.ProductGuid

	EXEC catalog.SetHoldBackQty @GersSku, 0
	END
-- If doesn't exist?
	--ELSE
	--SELECT * FROM inserted


GO


ALTER TABLE [catalog].[ProductTag] ADD CONSTRAINT [PK_ProductTag] PRIMARY KEY CLUSTERED  ([ProductGuid], [Tag]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [catalog].[ProductTag] WITH NOCHECK ADD CONSTRAINT [FK_ProductTag_ProductGuid] FOREIGN KEY ([ProductGuid]) REFERENCES [catalog].[ProductGuid] ([ProductGuid])
GO
EXEC sp_addextendedproperty N'MS_Description', N'The majority of filters in [catalog].[FilterOption] depends on the tags in this table, which are assigned by the Catalog Analyst through the admin center such as http://10.7.0.80/admin.', 'SCHEMA', N'catalog', 'TABLE', N'ProductTag', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to [catalog].[ProductGuid] table', 'SCHEMA', N'catalog', 'TABLE', N'ProductTag', 'COLUMN', N'ProductGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'catalog', 'TABLE', N'ProductTag', 'COLUMN', N'Tag'
GO
