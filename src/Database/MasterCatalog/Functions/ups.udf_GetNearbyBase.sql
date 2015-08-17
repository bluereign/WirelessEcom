SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [ups].[udf_GetNearbyBase] 
(
	-- Add the parameters for the function here
	@CurrentBase	nvarchar(100)
)


RETURNS nvarchar(100)

AS
BEGIN

	DECLARE @CurrentBaseTerm nvarchar(100)
	DECLARE @NewBase nvarchar(100)
	
	SELECT @CurrentBaseTerm = SearchTerm FROM ups.nearbybase WHERE CompleteName = @CurrentBase
	
	SELECT @NewBase = CompleteName FROM ups.nearbybase WHERE SearchTerm = @CurrentBaseTerm AND Active = '1'
	
	RETURN @NewBase;
	
END


GO
