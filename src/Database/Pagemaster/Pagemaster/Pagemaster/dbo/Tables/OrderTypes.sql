CREATE TABLE [dbo].[OrderTypes] (
    [QueueID]                  BIGINT           IDENTITY (1, 1) NOT NULL,
    [Active]                   BIT              NOT NULL,
    [CreatedOn]                DATETIME         NOT NULL,
    [ModifiedOn]               NVARCHAR (MAX)   NULL,
    [AutomationProcessed]      BIT              NOT NULL,
    [AutomationStatus]         NVARCHAR (MAX)   NULL,
    [UserInterventionRequired] BIT              NOT NULL,
    [OrderID]                  BIGINT           NOT NULL,
    [GERSStatus]               INT              NOT NULL,
    [Attempt]                  INT              NOT NULL,
    [OrderDate]                DATETIME         NOT NULL,
    [Processing]               NVARCHAR (MAX)   NULL,
    [OrderErrorType]           INT              NOT NULL,
    [AccessToken]              UNIQUEIDENTIFIER NOT NULL,
    [ErrorType]                INT              NOT NULL,
    CONSTRAINT [PK_dbo.OrderTypes] PRIMARY KEY CLUSTERED ([QueueID] ASC)
);

