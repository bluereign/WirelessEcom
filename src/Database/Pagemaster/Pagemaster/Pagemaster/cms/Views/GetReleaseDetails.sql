

CREATE VIEW [cms].[GetReleaseDetails]
AS
SELECT     cms.Releases.EnvironmentID, cms.Environments.EnvironmentGUID, cms.Sites.SiteGUID, cms.Sites.SiteGroupID, cms.Sites.SiteURL, cms.Sites.DisableCache
FROM         cms.Releases INNER JOIN
                      cms.Sites ON cms.Releases.SiteGroupID = cms.Sites.SiteGroupID LEFT OUTER JOIN
                      cms.Environments ON cms.Releases.EnvironmentID = cms.Environments.EnvironmentID