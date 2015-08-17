CREATE TABLE [catalog].[RebateToProduct]
(
[RebateToProductGuid] [uniqueidentifier] NOT NULL,
[RebateGuid] [uniqueidentifier] NOT NULL,
[ProductGuid] [uniqueidentifier] NOT NULL,
[RebateMode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
