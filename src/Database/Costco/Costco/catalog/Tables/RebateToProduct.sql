CREATE TABLE [catalog].[RebateToProduct] (
    [RebateToProductGuid] UNIQUEIDENTIFIER NOT NULL,
    [RebateGuid]          UNIQUEIDENTIFIER NOT NULL,
    [ProductGuid]         UNIQUEIDENTIFIER NOT NULL,
    [RebateMode]          CHAR (1)         NULL,
    [StartDate]           DATETIME         NOT NULL,
    [EndDate]             DATETIME         NOT NULL
);

