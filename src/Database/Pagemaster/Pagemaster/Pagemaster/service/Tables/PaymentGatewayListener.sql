CREATE TABLE [service].[PaymentGatewayListener] (
    [AsyncId]     INT            IDENTITY (1, 1) NOT NULL,
    [Content]     NVARCHAR (MAX) NULL,
    [CreatedDate] DATETIME       NULL,
    CONSTRAINT [PK_PaymentGatewayListener] PRIMARY KEY CLUSTERED ([AsyncId] ASC) WITH (FILLFACTOR = 80)
);

