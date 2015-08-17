CREATE TABLE [dbo].[DashboardData] (
    [DashboardDataID] BIGINT       IDENTITY (1, 1) NOT NULL,
    [RunDate]         VARCHAR (20) NOT NULL,
    [Name]            VARCHAR (50) NOT NULL,
    [Value]           VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_DashboardData] PRIMARY KEY CLUSTERED ([DashboardDataID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DashboardData', @level2type = N'COLUMN', @level2name = N'DashboardDataID';

