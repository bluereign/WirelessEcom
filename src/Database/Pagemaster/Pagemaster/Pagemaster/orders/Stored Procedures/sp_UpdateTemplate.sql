
CREATE PROC [orders].[sp_UpdateTemplate]
	@TemplateID bigint = null,
	@Title varchar(255) = null,
	@Subject varchar(1024),
	@Template varchar(8000)
AS
 if (@TemplateID IS NULL)
 BEGIN
 INSERT INTO [orders].[EmailTemplates]
           ([Title]
           ,[Subject]
           ,[Template])
     VALUES (@Title, @Subject, @Template)
 END
 ELSE
 BEGIN
  UPDATE orders.EmailTemplates
  SET Subject = @Subject,
   Template = @Template,
   Title = @Title
  WHERE EmailTemplateID = @TemplateID
 END