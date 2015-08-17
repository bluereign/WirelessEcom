
CREATE proc [cms].[sp_GetTemplateTags] 

    @TemplateID bigint
   
AS

begin

	select TagKey from cms.tags with (nolock)
	where TemplateID = @TemplateID and TagType = 'Field'
	
end