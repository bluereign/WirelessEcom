CREATE TABLE [catalogthisweek].[Service]
(
[CarrierName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierServiceId] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierBillCode] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Title] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MonthlyFee] [money] NULL,
[CarrierServicesId] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [catalogthisweek].[Service] ADD CONSTRAINT [PK_Service_1] PRIMARY KEY CLUSTERED  ([CarrierBillCode]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'The code to be sent to the carrier when activating the service. This can be null for included services.', 'SCHEMA', N'catalogthisweek', 'TABLE', N'Service', 'COLUMN', N'CarrierBillCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to Company table', 'SCHEMA', N'catalogthisweek', 'TABLE', N'Service', 'COLUMN', N'CarrierName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used by the catalog loader to match services in the incoming catalog to existing services', 'SCHEMA', N'catalogthisweek', 'TABLE', N'Service', 'COLUMN', N'CarrierServiceId'
GO
