CREATE TABLE [catalog].[FilterChannel]
(
[FilterChannelGuid] [uniqueidentifier] NULL CONSTRAINT [DF_FilterChannelizeID] DEFAULT (newsequentialid()),
[ChannelId] [int] NOT NULL,
[FilterOptionId] [int] NOT NULL,
[FilterGroupId] [int] NOT NULL,
[Active] [int] NOT NULL CONSTRAINT [DF_FilterChannel_Active] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [catalog].[FilterChannel] ADD CONSTRAINT [FK__FilterCha__Chann__71797AD2] FOREIGN KEY ([ChannelId]) REFERENCES [catalog].[Channel] ([ChannelId])
GO
ALTER TABLE [catalog].[FilterChannel] ADD CONSTRAINT [FK__FilterCha__Filte__7361C344] FOREIGN KEY ([FilterGroupId]) REFERENCES [catalog].[FilterGroup] ([FilterGroupId])
GO
ALTER TABLE [catalog].[FilterChannel] ADD CONSTRAINT [FK__FilterCha__Filte__726D9F0B] FOREIGN KEY ([FilterOptionId]) REFERENCES [catalog].[FilterOption] ([FilterOptionId])
GO
