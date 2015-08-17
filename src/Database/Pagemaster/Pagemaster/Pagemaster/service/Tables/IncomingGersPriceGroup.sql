CREATE TABLE [service].[IncomingGersPriceGroup] (
    [PriceGroupCode]        NVARCHAR (3)  NOT NULL,
    [PriceGroupDescription] NVARCHAR (40) NOT NULL,
    CONSTRAINT [PK__Incoming__C1DF1DF33EEDFB05] PRIMARY KEY CLUSTERED ([PriceGroupCode] ASC)
);

