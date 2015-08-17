CREATE TABLE [service].[IncomingGersPriceGroup] (
    [PriceGroupCode]        NVARCHAR (3)  NOT NULL,
    [PriceGroupDescription] NVARCHAR (40) NOT NULL,
    PRIMARY KEY CLUSTERED ([PriceGroupCode] ASC)
);

