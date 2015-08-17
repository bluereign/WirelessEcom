CREATE TABLE [service].[VerizonCatsCreditStatus] (
    [ReportDate]        DATETIME      NULL,
    [AgentID]           VARCHAR (25)  NULL,
    [ETMOrderID]        VARCHAR (25)  NULL,
    [OrderDate]         DATETIME      NULL,
    [ReferenceNo]       VARCHAR (25)  NULL,
    [ApplicationNumber] VARCHAR (25)  NULL,
    [CATS]              VARCHAR (5)   NULL,
    [DepositAmt]        DECIMAL (18)  NULL,
    [AceLocation]       VARCHAR (25)  NULL,
    [ACEOrderNumber]    VARCHAR (25)  NULL,
    [LastName]          VARCHAR (50)  NULL,
    [FirstName]         VARCHAR (50)  NULL,
    [SSN]               VARCHAR (20)  NULL,
    [AreaName]          VARCHAR (10)  NULL,
    [NbrofLines]        INT           NULL,
    [RiskAssmtRsn]      VARCHAR (100) NULL,
    [CreditStatus]      VARCHAR (25)  NULL
);

