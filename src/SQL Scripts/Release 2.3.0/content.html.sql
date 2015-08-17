
/****** Object:  Table [content].[html]    Script Date: 09/01/2011 14:39:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [content].[html](
	[htmlID] [int] IDENTITY(1,1) NOT NULL,
	[html] [text] NOT NULL,
	[htmlnote] [text] NULL,
	[updatedBy] [varchar](50) NOT NULL,
	[updatedDate] [datetime] NOT NULL,
	[scheduledForDate] [datetime] NULL,
	[markedForSchedule] [bit] NOT NULL,
	[isLiveRecord] [bit] NOT NULL,
 CONSTRAINT [PK_html] PRIMARY KEY CLUSTERED 
(
	[htmlID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [content].[html] ADD  CONSTRAINT [DF_html_markedForSchedule]  DEFAULT ((0)) FOR [markedForSchedule]
GO

ALTER TABLE [content].[html] ADD  CONSTRAINT [DF_html_isPreview]  DEFAULT ((1)) FOR [isLiveRecord]
GO


INSERT INTO [content].[html]
VALUES
(
'<h1>Default HTML record</h1>'
,'This is the default record'
,'System'
,GETDATE()
, null
, 0
, 1
)
