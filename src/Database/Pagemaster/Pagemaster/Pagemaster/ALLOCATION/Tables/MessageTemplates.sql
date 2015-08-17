CREATE TABLE [ALLOCATION].[MessageTemplates] (
    [MessageId]      INT            IDENTITY (1, 1) NOT NULL,
    [UserId]         INT            NOT NULL,
    [Subject]        VARCHAR (125)  NULL,
    [Message]        NVARCHAR (MAX) NOT NULL,
    [LocationId]     INT            NOT NULL,
    [Active]         BIT            CONSTRAINT [DF__MessageTe__Activ__0431209D] DEFAULT ((0)) NOT NULL,
    [MessageGroupId] INT            NOT NULL,
    [DateCreated]    DATETIME       CONSTRAINT [DF__MessageTe__DateC__052544D6] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [pk_MessageId] PRIMARY KEY CLUSTERED ([MessageId] ASC),
    CONSTRAINT [FK_MG_MGId] CHECK ([allocation].[udf_CheckforMessageGroup]([MessageGroupId])='1'),
    CONSTRAINT [FK_MD_LocationId] FOREIGN KEY ([LocationId]) REFERENCES [ALLOCATION].[MessageDestination] ([LocationId]),
    CONSTRAINT [FK_MT_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([User_ID])
);

