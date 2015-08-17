CREATE TABLE [catalog].[ProductTag] (
    [ProductGuid] UNIQUEIDENTIFIER NOT NULL,
    [Tag]         NVARCHAR (100)   NOT NULL,
    CONSTRAINT [PK_ProductTag] PRIMARY KEY CLUSTERED ([ProductGuid] ASC, [Tag] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_ProductTag_ProductGuid] FOREIGN KEY ([ProductGuid]) REFERENCES [catalog].[ProductGuid] ([ProductGuid])
);


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
	ELSE
	SELECT * FROM inserted
GO
DISABLE TRIGGER [catalog].[tr_releasesafetystock]
    ON [catalog].[ProductTag];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'ProductTag', @level2type = N'COLUMN', @level2name = N'Tag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to [catalog].[ProductGuid] table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'ProductTag', @level2type = N'COLUMN', @level2name = N'ProductGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The majority of filters in [catalog].[FilterOption] depends on the tags in this table, which are assigned by the Catalog Analyst through the admin center such as http://10.7.0.80/admin.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'ProductTag';

