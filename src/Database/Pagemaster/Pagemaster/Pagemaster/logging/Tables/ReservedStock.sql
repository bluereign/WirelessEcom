CREATE TABLE [logging].[ReservedStock] (
    [SessionId]    VARCHAR (36) NOT NULL,
    [GroupNumber]  INT          NOT NULL,
    [ProductId]    INT          NOT NULL,
    [Qty]          INT          NOT NULL,
    [ReservedTime] DATETIME     NOT NULL,
    [CampaignId]   INT          NULL
);

