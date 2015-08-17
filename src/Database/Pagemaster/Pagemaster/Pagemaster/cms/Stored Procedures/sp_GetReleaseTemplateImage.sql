


CREATE proc [cms].[sp_GetReleaseTemplateImage] 
    @ImageGUID uniqueidentifier    
AS

begin	

		SELECT     TOP (100)  'Image' as ContentType, cms.Images.LinkURL as LinkURL, 
cms.Images.AltTag, cms.Images.Height, cms.Images.Width, cms.Images.Rel					
 				 		
		FROM         cms.Images
		WHERE     cms.Images.ImageGUID = @ImageGUID 

end