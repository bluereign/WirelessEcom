CREATE proc [cms].[sp_GetStaticSiteURL]   
   @URL nvarchar(255)   
    
AS

begin

  select EnvironmentGUID, SiteGUID, URLIdentifier, StaticImageURL
  from cms.Sites s with (nolock) inner join cms.Environments e with (nolock)
  on e.EnvironmentID = s.EnvironmentID
  where PatIndex('%' + @URL + '%', URLIdentifier)>0
	
end