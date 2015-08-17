CREATE TABLE [catalog].[CommissionSKU]
(
[Instance] [int] NOT NULL IDENTITY(1, 1),
[CommissionSKU] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CarrierId] [int] NOT NULL,
[ActivationType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RateplanType] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeviceType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lines] [int] NULL,
[MinAmount] [money] NULL,
[MaxAmount] [money] NULL,
[IsApple] [bit] NOT NULL CONSTRAINT [DF__Commissio__IsApp__39BF3194] DEFAULT ((0)),
[Channel] [int] NOT NULL CONSTRAINT [DF__Commissio__Chann__3AB355CD] DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [catalog].[CommissionSKU] ADD CONSTRAINT [PK__Commissi__842EE79137D6E922] PRIMARY KEY CLUSTERED  ([Instance]) ON [PRIMARY]
GO
