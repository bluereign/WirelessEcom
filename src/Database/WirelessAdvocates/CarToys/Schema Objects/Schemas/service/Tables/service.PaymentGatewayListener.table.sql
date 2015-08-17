CREATE TABLE [service].[PaymentGatewayListener] (
    [AsyncId]     INT            IDENTITY (1, 1) NOT NULL,
    [Content]     NVARCHAR (MAX) NULL,
    [CreatedDate] DATETIME       NULL
);

