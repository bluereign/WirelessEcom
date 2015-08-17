CREATE TABLE [service].[IncomingGersPriceGroup]
(
[PriceGroupCode] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PriceGroupDescription] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [service].[IncomingGersPriceGroup] ADD CONSTRAINT [PK__Incoming__C1DF1DF33EEDFB05] PRIMARY KEY CLUSTERED  ([PriceGroupCode]) ON [PRIMARY]
GO
