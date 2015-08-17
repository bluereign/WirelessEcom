CREATE TABLE [catalogthisweek].[DeviceService]
(
[UPC] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CarrierServiceId] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsDefault] [bit] NOT NULL CONSTRAINT [DF__DeviceSer__IsDef__0DAF0CB0] DEFAULT ((0)),
[CarrierDeviceServiceId] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'ASSOCIATION. [catalog].[Device] + [catalog].[Service]', 'SCHEMA', N'catalogthisweek', 'TABLE', N'DeviceService', NULL, NULL
GO
