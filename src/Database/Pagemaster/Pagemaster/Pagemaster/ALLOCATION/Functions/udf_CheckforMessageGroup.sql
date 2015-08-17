
CREATE FUNCTION [allocation].[udf_CheckforMessageGroup] (@MessageGroupId int)
RETURNS tinyint
AS
BEGIN
DECLARE @Result tinyint
IF @MessageGroupId = (SELECT MessageGroupId FROM allocation.MessageGroup WHERE MessageGroupId = @MessageGroupId)
	SET @Result= 1
ELSE 
	SET @Result= 0
RETURN @Result
END