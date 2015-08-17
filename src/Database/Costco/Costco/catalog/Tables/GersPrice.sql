CREATE TABLE [catalog].[GersPrice] (
    [GersSku]        NVARCHAR (9)  NOT NULL,
    [PriceGroupCode] NVARCHAR (3)  NOT NULL,
    [Price]          MONEY         NOT NULL,
    [StartDate]      DATE          NOT NULL,
    [EndDate]        DATE          NOT NULL,
    [Comment]        NVARCHAR (70) NULL,
    CONSTRAINT [FK_GersPrice_GersPriceGroup] FOREIGN KEY ([PriceGroupCode]) REFERENCES [catalog].[GersPriceGroup] ([PriceGroupCode])
);


GO
CREATE NONCLUSTERED INDEX [IDX_GersPrice]
    ON [catalog].[GersPrice]([PriceGroupCode] ASC, [Price] ASC)
    INCLUDE([GersSku], [StartDate], [EndDate], [Comment]);


GO
CREATE CLUSTERED INDEX [_dta_index_GersPrice_c_11_228963942__K2_K1_K4]
    ON [catalog].[GersPrice]([PriceGroupCode] ASC, [GersSku] ASC, [StartDate] ASC);


GO
CREATE STATISTICS [_dta_stat_228963942_1_2]
    ON [catalog].[GersPrice]([GersSku], [PriceGroupCode]);


GO
CREATE STATISTICS [_dta_stat_228963942_4_2_1]
    ON [catalog].[GersPrice]([StartDate], [PriceGroupCode], [GersSku]);

