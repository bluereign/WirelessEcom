CREATE TABLE [ALLOCATION].[VirtualInventory] (
    [VirtualInventoryId] INT            IDENTITY (1, 1) NOT NULL,
    [UserId]             INT            NOT NULL,
    [GersSku]            NVARCHAR (9)   NOT NULL,
    [COGS]               MONEY          NOT NULL,
    [Name]               NVARCHAR (250) NOT NULL,
    [MessageGroupId]     INT            NOT NULL,
    [InventoryTypeId]    INT            NOT NULL,
    [Active]             BIT            DEFAULT ((0)) NOT NULL,
    [ReleaseDate]        DATETIME       NOT NULL,
    [IsDeleted]          BIT            DEFAULT ((0)) NOT NULL,
    [StartDate]          DATETIME       NOT NULL,
    [EndDate]            DATETIME       NOT NULL,
    [DateCreated]        DATETIME       DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [pk_VIId] PRIMARY KEY CLUSTERED ([VirtualInventoryId] ASC),
    CONSTRAINT [FK_MG_GroupId] FOREIGN KEY ([MessageGroupId]) REFERENCES [ALLOCATION].[MessageGroup] ([MessageGroupId]),
    CONSTRAINT [FK_VI_ProductGersSKU] FOREIGN KEY ([GersSku]) REFERENCES [catalog].[GersItm] ([GersSku]),
    CONSTRAINT [FK_VI_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([User_ID]),
    CONSTRAINT [FK_VIT_InventoryTypeId] FOREIGN KEY ([InventoryTypeId]) REFERENCES [ALLOCATION].[VirtualInventoryType] ([InventoryTypeId])
);

