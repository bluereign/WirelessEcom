CREATE TABLE [dbo].[DashboardData] (
    [DashboardDataID] BIGINT       IDENTITY (1, 1) NOT NULL,
    [RunDate]         VARCHAR (20) NOT NULL,
    [Name]            VARCHAR (50) NOT NULL,
    [Value]           VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_DashboardData] PRIMARY KEY CLUSTERED ([DashboardDataID] ASC)
);

