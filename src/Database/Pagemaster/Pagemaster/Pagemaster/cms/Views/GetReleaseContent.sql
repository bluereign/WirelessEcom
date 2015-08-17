

CREATE VIEW [cms].[GetReleaseContent]
AS
SELECT     TOP (100) cms.Tags.TagKey AS Tag_Name, cms.[Content].ContentType, cms.[Content].Text, cms.[Content].ContentID, cms.[Content].LinkURL, cms.[Content].AltTag, 
                      cms.[Content].Height, cms.[Content].Width, cms.[Content].ContentExists, cms.TemplateReleaseContent.ReleaseTemplateID
FROM         cms.TemplateReleaseContent WITH (nolock) INNER JOIN
                      cms.[Content] WITH (nolock) ON cms.TemplateReleaseContent.ContentID = cms.[Content].ContentID FULL OUTER JOIN
                      cms.Tags WITH (nolock) ON cms.[Content].TagID = cms.Tags.TagID
WHERE     (cms.TemplateReleaseContent.ReleaseTemplateID = 609)