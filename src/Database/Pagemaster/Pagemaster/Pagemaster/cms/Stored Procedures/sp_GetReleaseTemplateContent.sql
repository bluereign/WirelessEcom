

CREATE proc [cms].[sp_GetReleaseTemplateContent] 
    @ReleaseTemplateID bigint,
    @Carrier varchar(20) = null
AS

begin	
	if (@Carrier is null)
	begin
		SELECT     TOP (100)  cms.Tags.TagKey AS Tag_Name, cms.[Content].ContentType, cms.
[Content].Text, cms.[Content].ContentID, 
							  cms.[Content].LinkURL as LinkURL, cms.
[Content].AltTag, cms.[Content].Height, cms.[Content].Width,
							  cms.[Content].ContentExists, cms.
[Content].ImageGUID as ImageGUID		, cms.[Content].Rel					
 		
		FROM         cms.TemplateReleaseContent WITH (nolock) INNER JOIN
                      cms.[Content] WITH (nolock) ON cms.TemplateReleaseContent.ContentID = cms.
[Content].ContentID LEFT OUTER JOIN
                      cms.ReleaseTemplateCarriers ON cms.TemplateReleaseContent.ReleaseTemplateID = 
cms.ReleaseTemplateCarriers.ReleaseTemplateID LEFT OUTER JOIN
                      cms.Carriers ON cms.ReleaseTemplateCarriers.CarrierID = cms.Carriers.CarrierID 
FULL OUTER JOIN
                      cms.Tags WITH (nolock) ON cms.[Content].TagID = cms.Tags.TagID       
		WHERE     cms.TemplateReleaseContent.ReleaseTemplateID = @ReleaseTemplateID and 
cms.Carriers.CarrierKey IS NULL
			ORDER BY cms.TemplateReleaseContent.DisplayOrder ASC, 
cms.TemplateReleaseContent.TemplateReleaseContentID ASC
	end
	else
	begin
		SELECT     TOP (100)  cms.Tags.TagKey AS Tag_Name, cms.[Content].ContentType, cms.
[Content].Text, cms.[Content].ContentID, 
							  cms.[Content].LinkURL as LinkURL, cms.
[Content].AltTag, cms.[Content].Height, cms.[Content].Width,
							  cms.[Content].ContentExists, cms.
[Content].ImageGUID as ImageGUID, cms.[Content].Rel							
	 		
		FROM         cms.TemplateReleaseContent WITH (nolock) INNER JOIN
                      cms.[Content] WITH (nolock) ON cms.TemplateReleaseContent.ContentID = cms.
[Content].ContentID INNER JOIN
                      cms.ReleaseTemplateCarriers ON cms.TemplateReleaseContent.ReleaseTemplateID = 
cms.ReleaseTemplateCarriers.ReleaseTemplateID LEFT OUTER JOIN
                      cms.Carriers ON cms.ReleaseTemplateCarriers.CarrierID = cms.Carriers.CarrierID 
FULL OUTER JOIN
                      cms.Tags WITH (nolock) ON cms.[Content].TagID = cms.Tags.TagID    
		WHERE     cms.TemplateReleaseContent.ReleaseTemplateID = @ReleaseTemplateID and 
cms.Carriers.CarrierKey = @Carrier
		ORDER BY cms.TemplateReleaseContent.DisplayOrder ASC, 
cms.TemplateReleaseContent.TemplateReleaseContentID ASC
	end
	
end