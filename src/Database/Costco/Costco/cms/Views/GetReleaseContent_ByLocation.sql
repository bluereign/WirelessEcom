
CREATE VIEW [cms].[GetReleaseContent_ByLocation]
AS
SELECT     TOP (100) PERCENT cms.ReleaseTemplates.ReleaseID, cms.Templates.TemplateGUID, cms.Templates.HTMLContent AS Template_HTML, 
                      cms.Templates.DynamicData, cms.Templates.TemplateID, cms.ReleaseTemplates.ReleaseTemplateID, cms.SiteTemplates.CacheTemplate, 
                      cms.SiteTemplates.CacheInterval
FROM         cms.ReleaseTemplates WITH (nolock) INNER JOIN
                      cms.Templates WITH (nolock) ON cms.ReleaseTemplates.TemplateID = cms.Templates.TemplateID INNER JOIN
                      cms.SiteTemplates ON cms.Templates.TemplateID = cms.SiteTemplates.TemplateID FULL OUTER JOIN
                      cms.Locations WITH (nolock) ON cms.SiteTemplates.SiteGroupID = cms.Locations.SiteGroupID AND cms.ReleaseTemplates.LocationID = cms.Locations.LocationID