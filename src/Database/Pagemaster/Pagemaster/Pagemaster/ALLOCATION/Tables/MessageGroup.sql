CREATE TABLE [ALLOCATION].[MessageGroup] (
    [MessageGroupId]   INT           IDENTITY (1, 1) NOT NULL,
    [MessageGroupName] VARCHAR (125) NOT NULL,
    [Active]           BIT           CONSTRAINT [DF__MessageGr__Activ__08F5D5BA] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [pk_PMId] PRIMARY KEY CLUSTERED ([MessageGroupId] ASC)
);

