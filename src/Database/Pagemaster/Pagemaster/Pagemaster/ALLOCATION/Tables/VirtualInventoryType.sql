CREATE TABLE [ALLOCATION].[VirtualInventoryType] (
    [InventoryTypeId] INT            IDENTITY (1, 1) NOT NULL,
    [Description]     NVARCHAR (100) NOT NULL,
    CONSTRAINT [pk_InventoryTypeId] PRIMARY KEY CLUSTERED ([InventoryTypeId] ASC)
);

