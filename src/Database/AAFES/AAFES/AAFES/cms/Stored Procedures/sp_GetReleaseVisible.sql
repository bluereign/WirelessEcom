
CREATE proc [cms].[sp_GetReleaseVisible]

    @CurrentDateTime datetime,
    @ReleaseID bigint,
    @EnvironmentGUID uniqueidentifier,
    @SiteGUID uniqueidentifier
    
AS

begin

	DECLARE @ReleaseIDActive int
	
	SET @ReleaseIDActive = 
	(SELECT TOP 1 ReleaseID
	FROM cms.Releases r with (nolock) inner join cms.Sites s with (nolock) on r.SiteGroupID = s.SiteGroupID
	inner join cms.Environments e with (nolock) on r.EnvironmentID = e.EnvironmentID
	WHERE Active = 1 and @CurrentDateTime >= r.ReleaseDate and e.EnvironmentGUID = @EnvironmentGUID and s.SiteGUID = @SiteGUID
	ORDER BY r.ReleaseDate DESC)
		
	If (@ReleaseIDActive = @ReleaseID) 
	BEGIN
		select 1
	END
	ELSE
	BEGIN
		select 0
	END
	
end