CREATE TABLE [service].[PaymentGatewayLog] (
    [PaymentGatewayLogId] INT          IDENTITY (1, 1) NOT NULL,
    [LoggedDateTime]      DATETIME     CONSTRAINT [DF_PaymentGatewayLog_LoggedDateTime] DEFAULT (getdate()) NOT NULL,
    [OrderId]             INT          NULL,
    [Type]                VARCHAR (50) NULL,
    [RequestType]         VARCHAR (50) NULL,
    [Data]                TEXT         NULL
);

