CREATE TABLE [catalog].[RebateToFilter]
(
[RebateToFilterGuid] [uniqueidentifier] NOT NULL,
[RebateGuid] [uniqueidentifier] NOT NULL,
[FilterOptionId] [int] NOT NULL,
[FilterGroupId] [int] NULL
) ON [PRIMARY]
GO
