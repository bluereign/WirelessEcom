create proc [cms].[sp_CheckSiteCache] 
    @SiteGUID uniqueidentifier,
    @EnvironmentGUID uniqueidentifier    
AS

begin	
	SELECT     cms.Sites.DisableCache
	FROM        cms.Sites INNER JOIN
                cms.Environments ON cms.Sites.EnvironmentID = cms.Environments.EnvironmentID
    WHERE cms.Sites.SiteGUID = @SiteGUID and cms.Environments.EnvironmentGUID = @EnvironmentGUID
end