
CREATE PROCEDURE [dbo].[spSaveXMLVariableToFile]
  @TheXML XML,
  @Filename VARCHAR(255)
AS
  SET NOCOUNT ON
  DECLARE @MySpecialTempTable VARCHAR(255)
  DECLARE @Command NVARCHAR(4000)
  DECLARE @RESULT INT

--firstly we create a global temp table with a unique name
  SELECT  @MySpecialTempTable = '##temp'
       + CONVERT(VARCHAR(12), CONVERT(INT, RAND() * 1000000))
--then we create it using dynamic SQL, & insert a single row
--in it with the variable stocked with the XML we want
  SELECT  @Command = 'create table ['
       + @MySpecialTempTable
       + '] (MyID int identity(1,1), Bulkcol XML)
insert into ['
       + @MySpecialTempTable
       + '](BulkCol) select @TheXML'
  EXECUTE sp_ExecuteSQL @command, N'@TheXML XML',
           @TheXML

--then we execute the BCP to save the file
  SELECT  @Command = 'bcp "select BulkCol from ['
          + @MySpecialTempTable + ']'
          + '" queryout '
          + @Filename + ' '
         + '-w'--save as unicode
          + ' -T -S' + @@servername
  EXECUTE @RESULT= MASTER..xp_cmdshell @command, NO_OUTPUT
  EXECUTE ( 'Drop table ' + @MySpecialTempTable )
  RETURN @result