CREATE TABLE [catalog].[RebateToFilter] (
    [RebateToFilterGuid] UNIQUEIDENTIFIER NOT NULL,
    [RebateGuid]         UNIQUEIDENTIFIER NOT NULL,
    [FilterOptionId]     INT              NOT NULL,
    [FilterGroupId]      INT              NULL
);

