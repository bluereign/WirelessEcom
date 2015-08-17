SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION dbo.regexFind
(
@source varchar(5000),
@regexp varchar(1000),
@ignoreCase bit = 0
)
RETURNS bit AS
BEGIN
DECLARE @hr integer
DECLARE @objRegExp integer
DECLARE @results bit

SET @results = 0

EXECUTE @hr = sp_OACreate 'VBScript.RegExp', @objRegExp OUTPUT
IF @hr <> 0 BEGIN
EXEC @hr = sp_OADestroy @objRegExp
RETURN NULL
END
EXECUTE @hr = sp_OASetProperty @objRegExp, 'Pattern', @regexp
IF @hr <> 0 BEGIN
EXEC @hr = sp_OADestroy @objRegExp
RETURN NULL
END
EXECUTE @hr = sp_OASetProperty @objRegExp, 'Global', false
IF @hr <> 0 BEGIN
EXEC @hr = sp_OADestroy @objRegExp
RETURN NULL
END
EXECUTE @hr = sp_OASetProperty @objRegExp, 'IgnoreCase', @ignoreCase
IF @hr <> 0 BEGIN
EXEC @hr = sp_OADestroy @objRegExp
RETURN NULL
END
EXECUTE @hr = sp_OAMethod @objRegExp, 'Test', @results OUTPUT, @source
IF @hr <> 0 BEGIN
EXEC @hr = sp_OADestroy @objRegExp
RETURN NULL
END
EXECUTE @hr = sp_OADestroy @objRegExp
IF @hr <> 0 BEGIN
RETURN NULL
END

RETURN @results
END
GO
