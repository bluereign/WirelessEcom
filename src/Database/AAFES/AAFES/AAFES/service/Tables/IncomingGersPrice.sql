CREATE TABLE [service].[IncomingGersPrice] (
    [GersSku]        NVARCHAR (9)  NOT NULL,
    [PriceGroupCode] NVARCHAR (3)  NOT NULL,
    [Price]          MONEY         NOT NULL,
    [StartDate]      DATE          NOT NULL,
    [EndDate]        DATE          NOT NULL,
    [Comment]        NVARCHAR (70) NULL,
    CONSTRAINT [PK_IncomingGersPrice] PRIMARY KEY CLUSTERED ([GersSku] ASC, [PriceGroupCode] ASC, [StartDate] ASC)
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_IncomingGersPrice_11_2119530684__K2_K1_K4_3_5_6]
    ON [service].[IncomingGersPrice]([PriceGroupCode] ASC, [GersSku] ASC, [StartDate] ASC)
    INCLUDE([Price], [EndDate], [Comment]);

