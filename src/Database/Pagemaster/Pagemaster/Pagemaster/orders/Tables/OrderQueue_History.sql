CREATE TABLE [orders].[OrderQueue_History] (
    [QueueHistoryID]           BIGINT         IDENTITY (1, 1) NOT NULL,
    [CreatedOn]                DATETIME       NOT NULL,
    [ModifiedOn]               VARCHAR (50)   NULL,
    [AutomationProcessed]      BIT            NOT NULL,
    [AutomationStatus]         VARCHAR (255)  NULL,
    [UserInterventionRequired] BIT            NOT NULL,
    [OrderID]                  INT            NOT NULL,
    [GERSStatus]               INT            NOT NULL,
    [Attempt]                  INT            NOT NULL,
    [OrderDate]                DATETIME       NOT NULL,
    [Processing]               VARCHAR (6)    NULL,
    [OrderErrorType]           INT            NOT NULL,
    [ChangesMade]              VARCHAR (1024) NULL,
    [ChangedBy]                VARCHAR (255)  NULL,
    CONSTRAINT [PK_OrderQueue_History] PRIMARY KEY CLUSTERED ([QueueHistoryID] ASC)
);

