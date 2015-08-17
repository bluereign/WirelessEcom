CREATE TABLE [catalog].[GersPriceGroup] (
    [PriceGroupCode]        NVARCHAR (3)  NOT NULL,
    [PriceGroupDescription] NVARCHAR (40) NOT NULL,
    CONSTRAINT [PK_GersPriceGroup] PRIMARY KEY CLUSTERED ([PriceGroupCode] ASC)
);

