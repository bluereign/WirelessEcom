CREATE TABLE [catalog].[Channel] (
    [ChannelGuid] UNIQUEIDENTIFIER CONSTRAINT [DF_ChannelizeID] DEFAULT (newid()) NULL,
    [ChannelId]   INT              NOT NULL,
    [Channel]     NVARCHAR (128)   NULL,
    PRIMARY KEY CLUSTERED ([ChannelId] ASC)
);

