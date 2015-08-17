CREATE TABLE [service].[PaymentGatewayListener] (
    [AsyncId]     INT            IDENTITY (1, 1) NOT NULL,
    [Content]     NVARCHAR (MAX) NULL,
    [CreatedDate] DATETIME       NULL,
    CONSTRAINT [PK_PaymentGatewayListener] PRIMARY KEY CLUSTERED ([AsyncId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'service', @level1type = N'TABLE', @level1name = N'PaymentGatewayListener', @level2type = N'COLUMN', @level2name = N'AsyncId';

