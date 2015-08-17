CREATE TABLE [catalog].[RateplanException]
(
[RateplanExceptionGuid] [uniqueidentifier] NOT NULL,
[CarrierGuid] [uniqueidentifier] NULL,
[LOBType] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanType] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RateplanGuid] [uniqueidentifier] NULL,
[DeviceGuid] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [catalog].[RateplanException] ADD CONSTRAINT [PK_RateplanException] PRIMARY KEY CLUSTERED  ([RateplanExceptionGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'catalog', 'TABLE', N'RateplanException', 'COLUMN', N'RateplanExceptionGuid'
GO
