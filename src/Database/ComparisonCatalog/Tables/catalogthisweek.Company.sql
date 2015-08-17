CREATE TABLE [catalogthisweek].[Company]
(
[CompanyGuid] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Company_CompanyGuid] DEFAULT (newid()),
[CompanyName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsCarrier] [bit] NOT NULL CONSTRAINT [DF_Company_IsCarrier] DEFAULT ((0)),
[CarrierId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [catalogthisweek].[Company] ADD CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED  ([CompanyGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'List of carriers and device/accessory manufacturer names.', 'SCHEMA', N'catalogthisweek', 'TABLE', N'Company', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalogthisweek', 'TABLE', N'Company', 'COLUMN', N'CarrierId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Only assigned to carriers.', 'SCHEMA', N'catalogthisweek', 'TABLE', N'Company', 'COLUMN', N'CarrierId'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalogthisweek', 'TABLE', N'Company', 'COLUMN', N'CompanyGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'catalogthisweek', 'TABLE', N'Company', 'COLUMN', N'CompanyGuid'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalogthisweek', 'TABLE', N'Company', 'COLUMN', N'CompanyName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the carrier or accessory/kit company.', 'SCHEMA', N'catalogthisweek', 'TABLE', N'Company', 'COLUMN', N'CompanyName'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalogthisweek', 'TABLE', N'Company', 'COLUMN', N'IsCarrier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates if the company name is a cell phone carrier.', 'SCHEMA', N'catalogthisweek', 'TABLE', N'Company', 'COLUMN', N'IsCarrier'
GO
