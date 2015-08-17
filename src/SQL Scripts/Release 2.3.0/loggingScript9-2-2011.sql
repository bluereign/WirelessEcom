
/****** Object:  Table [logging].[Cart]    Script Date: 09/02/2011 15:08:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [logging].[Cart](
	[ActivityId] [int] IDENTITY(1,1) NOT NULL,
	[CFIDCFTOKEN] [varchar](255) NULL,
	[UserId] [int] NULL,
	[Path] [varchar](255) NULL,
	[ProductIDList] [varchar](1000) NULL,
	[ItemCount] [int] NULL,
	[Timestamp] [datetime] NOT NULL,
 CONSTRAINT [PK__Cart__45F4A79115872EB5] PRIMARY KEY CLUSTERED 
(
	[ActivityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [logging].[Cart] ADD  CONSTRAINT [DF__Cart__UserId__18639B60]  DEFAULT ((0)) FOR [UserId]
GO

ALTER TABLE [logging].[Cart] ADD  CONSTRAINT [DF__Cart__Timestamp__176F7727]  DEFAULT (getdate()) FOR [Timestamp]
GO


