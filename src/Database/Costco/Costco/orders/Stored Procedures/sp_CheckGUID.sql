
CREATE PROCEDURE [orders].[sp_CheckGUID]
	@GUID Uniqueidentifier
as
    DECLARE @Count int
    
    SELECT @Count = (SELECT COUNT(*) FROM orders.[OrderQueue] where AccessToken = @GUID and Active = 1)
    
    IF (@Count > 0)
		SELECT 0
	ELSE 
		SELECT 1