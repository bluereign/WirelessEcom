CREATE PROC [dbo].[sp_readTextFile] @filename sysname
as


     BEGIN 
     SET nocount ON 
     CREATE TABLE #tempfile (line varchar(8000))
     EXEC ('bulk INSERT #tempfile FROM "' + @filename + '"')
     SELECT * FROM #tempfile
     DROP TABLE #tempfile
 END