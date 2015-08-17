SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[old_zipcodemarket]
AS
SELECT * FROM cataloglastweek.zipcodemarket cml WHERE NOT EXISTS
(SELECT * FROM catalogthisweek.zipcodemarket cmt WHERE cml.ZipCode = cmt.Zipcode)
GO
