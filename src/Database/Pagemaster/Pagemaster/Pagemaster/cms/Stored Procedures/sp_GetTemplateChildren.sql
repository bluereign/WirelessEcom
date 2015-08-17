

CREATE proc [cms].[sp_GetTemplateChildren] 

   
    @TemplateGUID uniqueidentifier = null
   
AS

begin

	DECLARE @TemplateID bigint
		
	SET @TemplateID = (SELECT TemplateID FROM cms.Templates with (nolock) WHERE TemplateGUID = @TemplateGUID)
	
	SELECT TemplateKey, HTMLContent
	FROM cms.Templates with (nolock)
	WHERE ParentTemplateID = @TemplateID
	
	
end