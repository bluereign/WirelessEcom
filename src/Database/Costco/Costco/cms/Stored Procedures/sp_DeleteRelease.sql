
CREATE proc [cms].[sp_DeleteRelease]
	@ReleaseID bigint
as

begin

	DELETE FROM cms.Releases
	WHERE ReleaseID = @ReleaseID

	DELETE rtc FROM cms.ReleaseTemplateCarriers rtc INNER JOIN cms.ReleaseTemplates rt
	ON rtc.ReleaseTemplateID = rt.ReleaseTemplateID	
	WHERE rt.ReleaseID = @ReleaseID
	
	DELETE FROM cms.ReleaseTemplates
	WHERE ReleaseID = @ReleaseID
	
	-- remove content joined to TRC
	DELETE c
	FROM cms.Content c INNER JOIN cms.TemplateReleaseContent trc
	on trc.ContentID = c.ContentID
	WHERE trc.ReleaseID = @ReleaseID
	
	DELETE FROM cms.TemplateReleaseContent
	WHERE ReleaseID = @ReleaseID
		
end