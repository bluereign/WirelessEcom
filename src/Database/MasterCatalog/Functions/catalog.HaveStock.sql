SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [catalog].[HaveStock] (@GersSku nvarchar(10))
	RETURNS int
AS
BEGIN
	DECLARE @Stock int;
	SELECT @Stock=Count(gs.GersSku) FROM catalog.GersStock gs where gs.GersSku=@GersSku and gs.OrderDetailId is null;
	RETURN @Stock
END
GO
