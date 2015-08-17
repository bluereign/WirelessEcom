/****** Object:  Table [ups].[MilitaryBranch]    Script Date: 06/07/2013 15:06:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ups].[MilitaryBranch]') AND type in (N'U'))
DROP TABLE [ups].[MilitaryBranch]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [ups].[MilitaryBranch](
	[BranchId] int PRIMARY KEY IDENTITY NOT NULL,
	[Name] nvarchar(3) NOT NULL,
	[DisplayName] nvarchar(100) NOT NULL)
GO

SET ANSI_PADDING OFF
GO

CREATE UNIQUE INDEX MilBranchName_index ON [ups].[MilitaryBranch] (Name)
CREATE UNIQUE INDEX MilBranchDispName_index ON [ups].[MilitaryBranch] (DisplayName)
CREATE UNIQUE INDEX MilBranchDispPreName_index ON [ups].[MilitaryBranch] (Name,DisplayName)

INSERT INTO ups.MilitaryBranch (Name, DisplayName)
VALUES ('ARM','Army')
,('AFB','Air Force')
,('NVY','Navy/Marines')
,('OTH','Other')

SELECT * FROM ups.MilitaryBranch