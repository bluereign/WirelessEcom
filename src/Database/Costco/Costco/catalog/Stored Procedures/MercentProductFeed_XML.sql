

CREATE proc [catalog].[MercentProductFeed_XML]
as
declare @XmlOutput xml 
set @XmlOutput = (select * from catalog.vw_MercentProductFeed
FOR XML AUTO, ROOT('Products'), ELEMENTS)
 
--EXECUTE dbo.spSaveXMLVariableToFile @XmlOutput, 'c:\temp\Products.xml'  

--EXEC s_ftp_PutFile @FTPServer = 'sftp.mercent.com', @FTPUser = 'WirelessAdvocatFTP', @FTPPWD = 'Nus8_se5h@9U',
-- @FTPPath = '', @FTPFilename = '', @SourcePath = 'c:\temp\', @SourceFile = 'Products.xml', @WorkDir = 'c:\temp'


select @XmlOutput