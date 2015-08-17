ALTER TABLE dbo.[Users]
ALTER COLUMN [UserName] [varchar] (100) NOT NULL

ALTER TABLE dbo.[Users]
ALTER COLUMN [Email] [varchar] (100) NOT NULL

/*
To undo the above changes:

ALTER TABLE dbo.[Users]
ALTER COLUMN [UserName] [varchar] (100) NULL

ALTER TABLE dbo.[Users]
ALTER COLUMN [Email] [varchar] (100) NULL

*/