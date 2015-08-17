CREATE TABLE [service].[OrderDetailLog] (
    [OrderDetailLogId] INT           IDENTITY (1, 1) NOT NULL,
    [LoggedDateTime]   DATETIME      CONSTRAINT [DF_LoggedDateTime_Default] DEFAULT (getdate()) NOT NULL,
    [OrderDetailId]    INT           NULL,
    [Source]           VARCHAR (150) NULL,
    [Type]             VARCHAR (50)  NULL,
    [Log]              XML           NULL,
    CONSTRAINT [pk_OrderDetailLogId] PRIMARY KEY CLUSTERED ([OrderDetailLogId] ASC),
    CONSTRAINT [FK_OrderDetailID_LogId] FOREIGN KEY ([OrderDetailId]) REFERENCES [salesorder].[OrderDetail] ([OrderDetailId])
);

