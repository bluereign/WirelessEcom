CREATE PROC [orders].[sp_DeleteTemplate]
	@TemplateID bigint = null
AS
 delete from [CARTOYS].[orders].[EmailTemplates]
  WHERE EmailTemplateID = @TemplateID