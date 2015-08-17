CREATE TABLE [service].[IncomingGersPrice]
(
[GersSku] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PriceGroupCode] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Price] [money] NOT NULL,
[StartDate] [date] NOT NULL,
[EndDate] [date] NOT NULL,
[Comment] [nvarchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [service].[IncomingGersPrice] ADD CONSTRAINT [PK_IncomingGersPrice] PRIMARY KEY CLUSTERED  ([GersSku], [PriceGroupCode], [StartDate]) ON [PRIMARY]
GO
