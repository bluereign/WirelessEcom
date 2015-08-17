CREATE proc [cms].[sp_CopyReleaseTemplate]
	@ReleaseTemplateID bigint
as

begin
	--cursor 1
	
	DECLARE @Enabled bit
	DECLARE @Template_ReleaseID bigint
	DECLARE @TemplateID bigint
	DECLARE @LocationID bigint
	DECLARE @DisplayOrder int
	
	--cursor 2
	DECLARE @ContentID uniqueidentifier
	DECLARE @Content_ReleaseID bigint
	DECLARE @Content_ReleaseTemplateID bigint
	DECLARE @Content_TemplateID bigint
	
    -- new values
	DECLARE @NewReleaseTemplateID bigint
	DECLARE @NewContentID uniqueidentifier		
	
	DECLARE templatecursor CURSOR
	FOR 
		SELECT ReleaseTemplateID, Enabled, ReleaseID, TemplateID, LocationID
		FROM cms.ReleaseTemplates with (nolock) 
		WHERE ReleaseTemplateID = @ReleaseTemplateID
	
	OPEN templatecursor;
	
	FETCH NEXT FROM templatecursor
	INTO @ReleaseTemplateID, @Enabled, @Template_ReleaseID, @TemplateID, @LocationID
		
	WHILE @@FETCH_STATUS = 0
	BEGIN				
					
			INSERT INTO cms.ReleaseTemplates
			SELECT distinct Enabled, @Template_ReleaseID as ReleaseID, TemplateID, null 
as LocationID
			FROM cms.ReleaseTemplates with (nolock) 
			WHERE ReleaseTemplateID = @ReleaseTemplateID
			
			SET @NewReleaseTemplateID = SCOPE_IDENTITY()
			
				DECLARE contentitems CURSOR
				FOR 
					SELECT TemplateID, ReleaseID, ReleaseTemplateID, ContentID, 
DisplayOrder
					FROM cms.TemplateReleaseContent with (nolock) 
					WHERE ReleaseTemplateID = @ReleaseTemplateID		 
					
				OPEN contentitems
									
				FETCH NEXT FROM contentitems
				INTO @Content_TemplateID, @Content_ReleaseID, 
@Content_ReleaseTemplateID, @ContentID, @DisplayOrder
					
				WHILE @@FETCH_STATUS = 0
				BEGIN									
						DECLARE @CreateID uniqueidentifier
						SET @CreateID = newid()
							
						INSERT INTO cms.Content
						SELECT @CreateID as ContentID, TagID, ImageGUID, 
ContentType, BinaryContent,
						Text, Reference, LinkURL, AltTag, Height, Width, 
ContentExists, CacheInterval,
						'', getdate(), null, null, Rel
						FROM Content with (nolock) 
						WHERE ContentID = @ContentID
											
						INSERT INTO cms.TemplateReleaseContent
						SELECT @TemplateID, @Template_ReleaseID, 
@NewReleaseTemplateID, @CreateID as ContentID, @DisplayOrder
					
						INSERT INTO cms.ReleaseTemplateCarriers
						SELECT @NewReleaseTemplateID, CarrierID
						FROM cms.ReleaseTemplateCarriers
						WHERE ReleaseTemplateID = @ReleaseTemplateID
						
					FETCH NEXT FROM contentitems
					INTO @Content_TemplateID, @Content_ReleaseID, 
@Content_ReleaseTemplateID, @ContentID, @DisplayOrder
					
				END
				CLOSE contentitems
				DEALLOCATE contentitems
		
			FETCH NEXT FROM templatecursor
			INTO @ReleaseTemplateID, @Enabled, @Template_ReleaseID, @TemplateID, 
@LocationID
		
		END
		
		CLOSE templatecursor
		DEALLOCATE templatecursor		
	end