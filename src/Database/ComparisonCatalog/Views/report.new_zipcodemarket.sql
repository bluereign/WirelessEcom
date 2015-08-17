SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[new_zipcodemarket]
AS
SELECT * FROM catalogthisweek.zipcodemarket cmt WHERE NOT EXISTS
(SELECT * FROM cataloglastweek.zipcodemarket cml WHERE cmt.ZipCode = cml.ZipCode)
GO
