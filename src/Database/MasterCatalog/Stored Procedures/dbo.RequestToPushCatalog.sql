SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE PROCEDURE [dbo].[RequestToPushCatalog] 
	
AS
BEGIN


DECLARE @table AS TABLE(Emp_Email NVARCHAR(100), ID int IDENTITY(1,1))

INSERT @table (Emp_Email) VALUES('nhall@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('rlinmark@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('smorrow@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('wil@cfwebtools.com')

DECLARE @count AS int
SET @count =1 --initialize the count parameter
DECLARE @Recepient_Email AS VARCHAR(100)
WHILE (@count <=(SELECT COUNT(*) FROM @table))
        BEGIN
        SET @Recepient_Email =(SELECT TOP(1) Emp_Email FROM @table WHERE ID=@count)
        EXEC msdb.dbo.sp_send_dbmail
            @recipients=@Recepient_Email,            
			@body= 'This is a request from the Merchandising team to push the catalog for viewing.',
			@body_format = 'HTML',
			@subject ='[Master Catalog] Request to Push Catalog for Viewing',
			@profile_name ='Default'
            SET @count = @count + 1
            END 
END
GO
