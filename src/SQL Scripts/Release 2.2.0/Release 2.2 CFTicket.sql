-- DROP TABLE [admin].[OrderNote]
-- DROP TABLE [admin].[OrderNoteSubject]

------------------------------------------------------


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [admin].OrderNoteSubject(
	[OrderNoteSubjectId] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[Name] [varchar](100) NULL,
	[Ordinal] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



--------------------------------------------------------

SET IDENTITY_INSERT [admin].OrderNoteSubject	 ON
GO

INSERT INTO [admin].OrderNoteSubject ([OrderNoteSubjectId], [Name], [Ordinal])
SELECT 
	FilterID
	, FilterName
	, SortOrder
FROM CFTicket.dbo.Filters

SET IDENTITY_INSERT [admin].OrderNoteSubject	 OFF
GO


--------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [admin].OrderNote(
	[OrderNoteId] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[OrderId] [int] NOT NULL,
	[OrderNoteSubjectId] INT NULL,
	[DateCreated] [datetime] NULL,
	[CreatedById] [int] NOT NULL,
	[NoteBody] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

-----------------------------------------------



SET IDENTITY_INSERT [admin].OrderNote	 ON
GO

INSERT INTO [admin].OrderNote ([OrderNoteId], OrderId, [OrderNoteSubjectId], DateCreated, CreatedById, [NoteBody])			
SELECT 
	t.TicketID
	, cv.FieldValue
	, f.FilterID
	, t.DateCreated
	, ISNULL(t.createdByUserId, 0) createdByUserId
	, thr.body
FROM CFTicket.dbo.Tickets t 
INNER JOIN CFTicket.dbo.TicketStatus ts ON ts.StatusID = t.Status
LEFT JOIN CFTicket.dbo.SecurityUsers su ON su.UserID = t.Owner
INNER JOIN CFTicket.dbo.CustomValues cv ON cv.TicketID = t.TicketID
INNER JOIN CFTicket.dbo.CustomFields cf ON cf.FieldID = cv.FieldID
INNER JOIN CFTicket.dbo.Threads thr ON thr.TicketID = t.TicketID
LEFT JOIN CFTicket.dbo.Filters f ON f.FilterID = t.Filter
WHERE CreatedByUserId <> 0

SET IDENTITY_INSERT [admin].OrderNote	 OFF
GO