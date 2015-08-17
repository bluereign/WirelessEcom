CREATE TABLE [ALLOCATION].[BlockVirtualInventory] (
    [BlockId]            INT NOT NULL,
    [VirtualInventoryId] INT NOT NULL,
    CONSTRAINT [PK__BlockVir__144215F107CCA757] PRIMARY KEY CLUSTERED ([BlockId] ASC),
    CONSTRAINT [FK_BVI_BlockId] FOREIGN KEY ([BlockId]) REFERENCES [ALLOCATION].[Block] ([BlockId]),
    CONSTRAINT [FK_BVI_VirtualInventoryId] FOREIGN KEY ([VirtualInventoryId]) REFERENCES [ALLOCATION].[VirtualInventory] ([VirtualInventoryId]),
    CONSTRAINT [FK_VIT_BVInvId] FOREIGN KEY ([VirtualInventoryId]) REFERENCES [ALLOCATION].[VirtualInventory] ([VirtualInventoryId]),
    CONSTRAINT [uc_BlockId] UNIQUE NONCLUSTERED ([BlockId] ASC),
    CONSTRAINT [uc_BlVI] UNIQUE NONCLUSTERED ([BlockId] ASC, [VirtualInventoryId] ASC)
);

