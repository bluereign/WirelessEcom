CREATE TABLE [dbo].[HistoryTypes] (
    [Key]               NVARCHAR (128) NOT NULL,
    [Value]             NVARCHAR (MAX) NULL,
    [OrderType_QueueID] BIGINT         NULL,
    CONSTRAINT [PK_dbo.HistoryTypes] PRIMARY KEY CLUSTERED ([Key] ASC),
    CONSTRAINT [FK_dbo.HistoryTypes_dbo.OrderTypes_OrderType_QueueID] FOREIGN KEY ([OrderType_QueueID]) REFERENCES [dbo].[OrderTypes] ([QueueID])
);


GO
CREATE NONCLUSTERED INDEX [IX_OrderType_QueueID]
    ON [dbo].[HistoryTypes]([OrderType_QueueID] ASC);

