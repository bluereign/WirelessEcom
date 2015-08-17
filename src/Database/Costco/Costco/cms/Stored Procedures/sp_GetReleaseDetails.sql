CREATE proc [cms].[sp_GetReleaseDetails] 
    @ReleaseID bigint    
AS

begin	
		SELECT     cms.Releases.EnvironmentID, cms.Environments.EnvironmentGUID, cms.Sites.SiteGUID, cms.Sites.SiteGroupID, cms.Sites.SiteURL,
		cms.Sites.StaticImageURL
		FROM         cms.Releases WITH (nolock) INNER JOIN
                      cms.Environments WITH (nolock) ON cms.Releases.EnvironmentID = cms.Environments.EnvironmentID LEFT OUTER JOIN
                      cms.Sites WITH (nolock) ON cms.Environments.EnvironmentID = cms.Sites.EnvironmentID AND cms.Releases.SiteGroupID = cms.Sites.SiteGroupID            
		WHERE     cms.Releases.ReleaseID = @ReleaseID
end