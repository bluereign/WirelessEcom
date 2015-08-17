CREATE TABLE [salesorder].[ShipMethod]
(
[ShipMethodId] [int] NOT NULL,
[Name] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[DefaultFixedCost] [money] NULL,
[GersShipMethodId] [int] NOT NULL,
[CarrierId] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PromoPrice] [money] NULL,
[PromoDisplayName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PromoCarrierId] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsApoAfoAvailable] [bit] NULL,
[ChannelId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [salesorder].[ShipMethod] ADD CONSTRAINT [FK__ShipMetho__Chann__2AB1F82E] FOREIGN KEY ([ChannelId]) REFERENCES [catalog].[Channel] ([ChannelId])
GO
