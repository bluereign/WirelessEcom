SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Naomi Hall
-- Create date: 01/07/2014
-- Description:	provide filter management
-- =============================================

CREATE PROCEDURE [catalog].[sp_FilterChangeStatus]
(

@FilterId int -- ID of filter
,@Costco varchar(1) -- include for Costco (Y or N)
,@AAFES varchar(1) -- include for AAFES (Y or N)
,@Status int -- 1 for active, 0 for inactive


	
)
AS


BEGIN
	SET NOCOUNT ON;

IF (SELECT @Status) NOT IN ('0','1')
 RAISERROR('ERROR: Cannot complete request. Remember to set a status of 0 (Inactive) or 1 (Active).', 16, -1, @Status)
 ELSE

	IF (@Costco = 'Y')
		BEGIN
			UPDATE catalog.FilterChannel
			SET Active = @Status
			WHERE FilterOptionId = @FilterId AND ChannelId = '2'
		END
		
	IF (@AAFES = 'Y')
		BEGIN
			UPDATE catalog.FilterChannel
			SET Active = @Status
			WHERE FilterOptionId = @FilterId AND ChannelId = '3'
		END

	SET NOCOUNT OFF 
END



GO
GRANT EXECUTE ON  [catalog].[sp_FilterChangeStatus] TO [managefilter]
GO
