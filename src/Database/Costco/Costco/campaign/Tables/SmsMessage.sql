CREATE TABLE [campaign].[SmsMessage] (
    [MessageId]     INT           IDENTITY (1, 1) NOT NULL,
    [PhoneNumber]   VARCHAR (10)  NOT NULL,
    [CarrierId]     INT           NOT NULL,
    [Message]       VARCHAR (160) NOT NULL,
    [RunDate]       DATE          NOT NULL,
    [SmsMessageId]  VARCHAR (255) NULL,
    [ResultCode]    INT           NULL,
    [Result]        VARCHAR (255) NULL,
    [OrderDetailId] INT           NULL,
    CONSTRAINT [PK_SmsMessage] PRIMARY KEY CLUSTERED ([MessageId] ASC),
    CONSTRAINT [FK_WirelessOrderDetailId] FOREIGN KEY ([OrderDetailId]) REFERENCES [salesorder].[OrderDetail] ([OrderDetailId])
);

