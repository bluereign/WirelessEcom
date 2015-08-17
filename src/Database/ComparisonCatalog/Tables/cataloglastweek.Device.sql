CREATE TABLE [cataloglastweek].[Device]
(
[CarrierName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UPC] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manufacturer] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierDeviceId] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [cataloglastweek].[Device] ADD CONSTRAINT [PK_Device_1] PRIMARY KEY CLUSTERED  ([UPC]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tells what carrier each device should sell under. Also indicates the manufacturer of the device.', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Device', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Device', 'COLUMN', N'CarrierName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Links to [catalog].[Company].[CompanyGuid]', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Device', 'COLUMN', N'CarrierName'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Device', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of device provided by carrier.', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Device', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Device', 'COLUMN', N'UPC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifier from carrier.', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Device', 'COLUMN', N'UPC'
GO
