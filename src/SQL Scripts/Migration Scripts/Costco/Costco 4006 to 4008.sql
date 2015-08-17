/*
This is the migration script to update the database with the set of uncommitted changes you selected.

You can customize the script, and your edits will be used in deployment.
The following objects will be affected:
  BETTER_WAY\gmontague, noah, WALLC\113227, jprior, ECOM\bhogan, ReleaseUser,
  apple, amety, bhogan, jrowles, WALLC\mmiller, db_datareader, db_ddladmin,
  db_datawriter, db_owner
*/

SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Altering members of role db_datareader'
GO
EXEC sp_droprolemember N'db_datareader', N'WALLC\113227'
GO
PRINT N'Altering members of role db_ddladmin'
GO
EXEC sp_droprolemember N'db_ddladmin', N'WALLC\113227'
GO
PRINT N'Altering members of role db_datawriter'
GO
EXEC sp_droprolemember N'db_datawriter', N'WALLC\113227'
GO
PRINT N'Altering members of role db_owner'
GO
EXEC sp_droprolemember N'db_owner', N'ReleaseUser'
GO
PRINT N'Dropping users'
GO
DROP USER [BETTER_WAY\gmontague]
GO
DROP USER [noah]
GO
DROP USER [WALLC\113227]
GO
DROP USER [jprior]
GO
DROP USER [ECOM\bhogan]
GO
DROP USER [ReleaseUser]
GO
DROP USER [apple]
GO
DROP USER [amety]
GO
DROP USER [bhogan]
GO
DROP USER [jrowles]
GO
DROP USER [WALLC\mmiller]
GO
