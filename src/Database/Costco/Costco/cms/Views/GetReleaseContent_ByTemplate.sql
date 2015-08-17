
CREATE VIEW [cms].[GetReleaseContent_ByTemplate]
AS
SELECT     TOP (100) PERCENT cms.ReleaseTemplates.ReleaseID, cms.Templates.TemplateGUID, cms.Templates.HTMLContent AS Template_HTML, 
                      cms.Templates.DynamicData, cms.Templates.TemplateID, cms.ReleaseTemplates.ReleaseTemplateID, cms.SiteTemplates.CacheInterval, 
                      cms.SiteTemplates.CacheTemplate
FROM         cms.SiteTemplates INNER JOIN
                      cms.ReleaseTemplates WITH (nolock) INNER JOIN
                      cms.Templates WITH (nolock) ON cms.ReleaseTemplates.TemplateID = cms.Templates.TemplateID ON 
                      cms.SiteTemplates.TemplateID = cms.Templates.TemplateID LEFT OUTER JOIN
                      cms.Releases WITH (nolock) ON cms.SiteTemplates.SiteGroupID = cms.Releases.SiteGroupID AND cms.ReleaseTemplates.ReleaseID = cms.Releases.ReleaseID