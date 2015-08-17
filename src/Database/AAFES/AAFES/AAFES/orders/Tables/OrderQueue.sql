CREATE TABLE [orders].[OrderQueue] (
    [QueueID]                  BIGINT           IDENTITY (1, 1) NOT NULL,
    [Active]                   BIT              CONSTRAINT [DF_OrderQueue_Active] DEFAULT ((1)) NOT NULL,
    [CreatedOn]                DATETIME         CONSTRAINT [DF_OrderQueue_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [ModifiedOn]               VARCHAR (50)     NULL,
    [AutomationProcessed]      BIT              CONSTRAINT [DF_OrderQueue_AutomationProcessed] DEFAULT ((0)) NOT NULL,
    [AutomationStatus]         VARCHAR (255)    NULL,
    [UserInterventionRequired] BIT              CONSTRAINT [DF_OrderQueue_UserInterventionRequired] DEFAULT ((0)) NOT NULL,
    [OrderID]                  INT              NOT NULL,
    [GERSStatus]               INT              NOT NULL,
    [Attempt]                  INT              CONSTRAINT [DF_OrderQueue_Attempt] DEFAULT ((0)) NOT NULL,
    [OrderDate]                DATETIME         NOT NULL,
    [Processing]               VARCHAR (6)      NULL,
    [OrderErrorType]           INT              NOT NULL,
    [AccessToken]              UNIQUEIDENTIFIER CONSTRAINT [DF_OrderQueue_AccessToken] DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_OrderQueue] PRIMARY KEY CLUSTERED ([QueueID] ASC)
);

