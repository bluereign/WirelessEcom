CREATE TABLE [salesorder].[PaymentMethod] (
    [PaymentMethodId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]            NVARCHAR (50) NULL,
    [Sort]            INT           NULL,
    [IsActive]        BIT           NULL,
    [GersMopCd]       VARCHAR (3)   NULL
);

