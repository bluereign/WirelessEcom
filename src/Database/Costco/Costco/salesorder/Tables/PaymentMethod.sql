CREATE TABLE [salesorder].[PaymentMethod] (
    [PaymentMethodId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]            NVARCHAR (50) NULL,
    [Sort]            INT           CONSTRAINT [DF__PaymentMet__Sort__51851410] DEFAULT ((0)) NULL,
    [IsActive]        BIT           NULL,
    [GersMopCd]       VARCHAR (3)   NULL,
    CONSTRAINT [PK__PaymentMethods__5090EFD7] PRIMARY KEY CLUSTERED ([PaymentMethodId] ASC) WITH (FILLFACTOR = 90)
);

