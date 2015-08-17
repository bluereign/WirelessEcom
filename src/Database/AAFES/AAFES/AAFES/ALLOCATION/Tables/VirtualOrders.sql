CREATE TABLE [ALLOCATION].[VirtualOrders] (
    [VirtualOrderId] INT            IDENTITY (1, 1) NOT NULL,
    [BlockId]        INT            NOT NULL,
    [GersSku]        NVARCHAR (9)   NOT NULL,
    [OutletId]       NVARCHAR (100) NOT NULL,
    [OrderId]        INT            NOT NULL,
    [OrderDetailId]  INT            NOT NULL,
    [ProcessDate]    DATETIME       NOT NULL,
    [MessageGroupId] INT            NOT NULL,
    CONSTRAINT [pk_VirtualOrderId] PRIMARY KEY CLUSTERED ([VirtualOrderId] ASC),
    CONSTRAINT [FK_VO_CascadeId] FOREIGN KEY ([BlockId]) REFERENCES [ALLOCATION].[Block] ([BlockId])
);

