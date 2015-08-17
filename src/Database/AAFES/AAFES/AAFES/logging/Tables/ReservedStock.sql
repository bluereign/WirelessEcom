CREATE TABLE [logging].[ReservedStock] (
    [SessionId]    VARCHAR (36) NOT NULL,
    [GroupNumber]  INT          NOT NULL,
    [ProductId]    INT          NOT NULL,
    [Qty]          INT          NOT NULL,
    [ReservedTime] DATETIME     NOT NULL,
    [CampaignId]   INT          NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'logging', @level1type = N'TABLE', @level1name = N'ReservedStock', @level2type = N'COLUMN', @level2name = N'ProductId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'logging', @level1type = N'TABLE', @level1name = N'ReservedStock', @level2type = N'COLUMN', @level2name = N'GroupNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'logging', @level1type = N'TABLE', @level1name = N'ReservedStock', @level2type = N'COLUMN', @level2name = N'SessionId';

