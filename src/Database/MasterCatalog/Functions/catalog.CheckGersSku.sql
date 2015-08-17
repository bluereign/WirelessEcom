SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create Function [catalog].[CheckGersSku] (@GersSku varchar(9))
	Returns bit
AS

/*

AUTHOR: Greg Montague
CREATED: 11/10/2010

*/
BEGIN
	DECLARE @Valid bit 
	IF @GersSku IN (SELECT GersSku FROM catalog.GersItm)
		SET @Valid=1
	ELSE 
		SET @Valid=0
	
	RETURN @Valid	
END	
	
GO
