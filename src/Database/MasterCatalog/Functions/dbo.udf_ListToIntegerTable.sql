SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[udf_ListToIntegerTable] ( 
	@list AS VARCHAR(8000), 
	@delimiter AS VARCHAR(10) = ',')

RETURNS @tbl TABLE ([ID] int)

AS

BEGIN

DECLARE @nextID AS VARCHAR(20)
DECLARE @ptr AS int
DECLARE @match AS int
DECLARE @list_length AS int
SET @ptr = 1
SET @list_length = DATALENGTH(@list)
-- Loop until finished
WHILE @ptr <= @list_length
	BEGIN
	SET @match = CHARINDEX(@delimiter, @list, @ptr) 
	IF @match > 0
		SET @nextID = SUBSTRING(@list, @ptr, @match - @ptr)
	ELSE
		-- Last element - no more delimeters found
		BEGIN
		SET @nextID = SUBSTRING(@list, @ptr, @list_length - (@ptr - 1))
		-- Allows us to exit
		SET @ptr = -1
		END
	-- Add our number to the stack
	IF ISNUMERIC(@nextID) = 1
		BEGIN
		INSERT INTO @tbl ([ID]) VALUES (CAST(@nextID AS int))
		END
	-- Exit if we just added the last element
	IF @ptr = -1 BREAK
	-- Advance the pointer to the next position past the delimiter
	SET @ptr = (@match + DATALENGTH(@delimiter))
	END
RETURN
END

GO
