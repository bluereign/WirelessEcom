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