
CREATE proc [cms].[sp_GetReleaseTemplates] 

    @CurrentDateTime datetime,
    @EnvironmentGUID uniqueidentifier,
    @SiteGUID uniqueidentifier,
    @TemplateGUID uniqueidentifier = null,
    @LocationGUID uniqueidentifier = null,
    @ReleaseID bigint = null,
    @ReleaseTemplateID bigint = null,
    @Carrier varchar(20) = null
           
AS

begin

	DECLARE @ReleaseIDLookup bigint		

	IF (@ReleaseID IS NULL) AND (@ReleaseTemplateID IS NULL)
	BEGIN

		SET @ReleaseIDLookup = 
		(SELECT TOP 1 ReleaseID 
		FROM cms.Releases r with (nolock)  inner join cms.Sites s with (nolock) on r.SiteGroupID = s.SiteGroupID
		inner join cms.Environments e with (nolock) on r.EnvironmentID = e.EnvironmentID
		WHERE Active = 1 and @CurrentDateTime >= r.ReleaseDate and s.SiteGUID = @SiteGUID and e.EnvironmentGUID = @EnvironmentGUID
		ORDER BY ReleaseDate desc)			
	END
		
	-- Used for Admin site.
	IF (@ReleaseID IS NOT NULL) AND (@ReleaseTemplateID IS NOT NULL)
	BEGIN
	SELECT     TOP (100) PERCENT cms.ReleaseTemplates.ReleaseID, cms.Templates.TemplateGUID, cms.Templates.HTMLContent AS Template_HTML, cms.Templates.DynamicData, cms.Templates.TemplateID,
					cms.ReleaseTemplates.ReleaseTemplateID, cms.SiteTemplates.CacheInterval, cms.SiteTemplates.CacheTemplate
	FROM         cms.SiteTemplates INNER JOIN
                 cms.ReleaseTemplates WITH (nolock) INNER JOIN
				 cms.Templates WITH (nolock) ON cms.ReleaseTemplates.TemplateID = cms.Templates.TemplateID ON cms.SiteTemplates.TemplateID = cms.Templates.TemplateID		
	WHERE     cms.ReleaseTemplates.ReleaseID = @ReleaseID and cms.Templates.TemplateGUID = @TemplateGUID and cms.ReleaseTemplates.ReleaseTemplateID = @ReleaseTemplateID
	END
		
	IF (@ReleaseIDLookup is not null) 
	begin
		if (@Carrier IS NULL)
		BEGIN
			IF (@TemplateGUID IS NOT NULL) AND (@LocationGUID IS NULL)
			BEGIN
			SELECT     TOP (100) PERCENT cms.ReleaseTemplates.ReleaseID, cms.Templates.TemplateGUID, cms.Templates.HTMLContent AS Template_HTML,
			 cms.Templates.DynamicData, cms.Templates.TemplateID,
						cms.ReleaseTemplates.ReleaseTemplateID, cms.SiteTemplates.CacheInterval, cms.SiteTemplates.CacheTemplate
			FROM         cms.Carriers INNER JOIN
                      cms.ReleaseTemplateCarriers ON cms.Carriers.CarrierID = cms.ReleaseTemplateCarriers.CarrierID RIGHT OUTER JOIN
                      cms.SiteTemplates INNER JOIN
                      cms.ReleaseTemplates WITH (nolock) INNER JOIN
                      cms.Templates WITH (nolock) ON cms.ReleaseTemplates.TemplateID = cms.Templates.TemplateID ON 
                      cms.SiteTemplates.TemplateID = cms.Templates.TemplateID ON cms.ReleaseTemplateCarriers.ReleaseTemplateID = cms.ReleaseTemplates.ReleaseTemplateID	
			WHERE     cms.ReleaseTemplates.ReleaseID = @ReleaseIDLookup and cms.Templates.TemplateGUID = @TemplateGUID and cms.ReleaseTemplates.Enabled = 1
			END
			ELSE
			BEGIN
			SELECT     TOP (100) PERCENT  cms.ReleaseTemplates.ReleaseID, cms.Templates.TemplateGUID, cms.Templates.HTMLContent AS Template_HTML, 
			cms.Templates.DynamicData, cms.Templates.TemplateID,
			cms.ReleaseTemplates.ReleaseTemplateID, cms.SiteTemplates.CacheInterval, cms.SiteTemplates.CacheTemplate	
		 FROM         cms.ReleaseTemplates WITH (nolock) INNER JOIN
                      cms.Templates WITH (nolock) ON cms.ReleaseTemplates.TemplateID = cms.Templates.TemplateID INNER JOIN
                      cms.SiteTemplates ON cms.Templates.TemplateID = cms.SiteTemplates.TemplateID LEFT OUTER JOIN
                      cms.ReleaseTemplateCarriers ON cms.ReleaseTemplates.ReleaseTemplateID = cms.ReleaseTemplateCarriers.ReleaseTemplateID LEFT OUTER JOIN
                      cms.Carriers ON cms.ReleaseTemplateCarriers.CarrierID = cms.Carriers.CarrierID FULL OUTER JOIN
                      cms.Locations WITH (nolock) ON cms.SiteTemplates.SiteGroupID = cms.Locations.SiteGroupID AND cms.ReleaseTemplates.LocationID = cms.Locations.LocationID
			WHERE     cms.ReleaseTemplates.ReleaseID = @ReleaseIDLookup and cms.Locations.LocationGUID = @LocationGUID and cms.ReleaseTemplates.Enabled = 1
			END
		end	
		else
		BEGIN
			IF (@TemplateGUID IS NOT NULL) AND (@LocationGUID IS NULL)
			BEGIN
			SELECT     TOP (100) PERCENT cms.ReleaseTemplates.ReleaseID, cms.Templates.TemplateGUID, cms.Templates.HTMLContent AS Template_HTML,
			 cms.Templates.DynamicData, cms.Templates.TemplateID,
						cms.ReleaseTemplates.ReleaseTemplateID, cms.SiteTemplates.CacheInterval, cms.SiteTemplates.CacheTemplate
			FROM         cms.Carriers INNER JOIN
                      cms.ReleaseTemplateCarriers ON cms.Carriers.CarrierID = cms.ReleaseTemplateCarriers.CarrierID RIGHT OUTER JOIN
                      cms.SiteTemplates INNER JOIN
                      cms.ReleaseTemplates WITH (nolock) INNER JOIN
                      cms.Templates WITH (nolock) ON cms.ReleaseTemplates.TemplateID = cms.Templates.TemplateID ON 
                      cms.SiteTemplates.TemplateID = cms.Templates.TemplateID ON cms.ReleaseTemplateCarriers.ReleaseTemplateID = cms.ReleaseTemplates.ReleaseTemplateID	
			WHERE     cms.ReleaseTemplates.ReleaseID = @ReleaseIDLookup and cms.Templates.TemplateGUID = @TemplateGUID and cms.ReleaseTemplates.Enabled = 1
					  and cms.Carriers.CarrierKey is null
			END
			ELSE
			BEGIN
			SELECT     TOP (100) PERCENT  cms.ReleaseTemplates.ReleaseID, cms.Templates.TemplateGUID, cms.Templates.HTMLContent AS Template_HTML, 
			cms.Templates.DynamicData, cms.Templates.TemplateID,
			cms.ReleaseTemplates.ReleaseTemplateID, cms.SiteTemplates.CacheInterval, cms.SiteTemplates.CacheTemplate	
		 FROM         cms.ReleaseTemplates WITH (nolock) INNER JOIN
                      cms.Templates WITH (nolock) ON cms.ReleaseTemplates.TemplateID = cms.Templates.TemplateID INNER JOIN
                      cms.SiteTemplates ON cms.Templates.TemplateID = cms.SiteTemplates.TemplateID LEFT OUTER JOIN
                      cms.ReleaseTemplateCarriers ON cms.ReleaseTemplates.ReleaseTemplateID = cms.ReleaseTemplateCarriers.ReleaseTemplateID LEFT OUTER JOIN
                      cms.Carriers ON cms.ReleaseTemplateCarriers.CarrierID = cms.Carriers.CarrierID FULL OUTER JOIN
                      cms.Locations WITH (nolock) ON cms.SiteTemplates.SiteGroupID = cms.Locations.SiteGroupID AND cms.ReleaseTemplates.LocationID = cms.Locations.LocationID
			WHERE     cms.ReleaseTemplates.ReleaseID = @ReleaseIDLookup and cms.Locations.LocationGUID = @LocationGUID and cms.ReleaseTemplates.Enabled = 1
					and cms.Carriers.CarrierKey = @Carrier
			END
		end	
	END
	
end