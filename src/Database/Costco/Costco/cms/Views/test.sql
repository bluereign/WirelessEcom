

create view cms.test
as

	SELECT     cms.Releases.EnvironmentID, cms.Environments.EnvironmentGUID, cms.Sites.SiteGUID, cms.Sites.SiteGroupID, cms.Sites.SiteURL,
		cms.Sites.StaticImageURL
		FROM         cms.Releases with (nolock) INNER JOIN
                      cms.Sites with (nolock) ON cms.Releases.SiteGroupID = cms.Sites.SiteGroupID LEFT OUTER JOIN
                      cms.Environments with (nolock) ON cms.Releases.EnvironmentID = cms.Environments.EnvironmentID                 
		--WHERE     cms.Releases.ReleaseID = @ReleaseID