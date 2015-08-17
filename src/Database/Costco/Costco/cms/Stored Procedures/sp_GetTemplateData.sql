CREATE proc [cms].[sp_GetTemplateData] 

    @TemplateID bigint,
    @EnvironmentID bigint,
    @SiteGroupID bigint
    
AS

begin

	select dg.SelectSQL, d.Connection
	from cms.DataGroups dg with (nolock) INNER JOIN cms.Data d with (nolock) ON
	 d.DataGroupID = dg.DataGroupID
	where d.EnvironmentID = @EnvironmentID and d.SiteGroupID = @SiteGroupID
	
end