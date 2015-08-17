CREATE TABLE [salesorder].[PaymentMethod] (
    [PaymentMethodId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]            NVARCHAR (50) NULL,
    [Sort]            INT           CONSTRAINT [DF__PaymentMet__Sort__51851410] DEFAULT ((0)) NULL,
    [IsActive]        BIT           NULL,
    [GersMopCd]       VARCHAR (3)   NULL,
    CONSTRAINT [PK__PaymentMethods__5090EFD7] PRIMARY KEY CLUSTERED ([PaymentMethodId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'PaymentMethod', @level2type = N'COLUMN', @level2name = N'PaymentMethodId';

