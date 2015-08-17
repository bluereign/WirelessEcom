CREATE PROC [orders].sp_DeleteTemplate
	@TemplateID bigint = null
AS
 delete from [orders].[EmailTemplates]
  WHERE EmailTemplateID = @TemplateID