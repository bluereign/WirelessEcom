SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION dbo.regexObj
(
@regexp varchar(1000),
@globalReplace bit = 0,
@ignoreCase bit = 0
)
RETURNS integer AS
BEGIN
DECLARE @hr integer
DECLARE @objRegExp integer

EXECUTE @hr = sp_OACreate 'VBScript.RegExp', @objRegExp OUTPUT
IF @hr <> 0 BEGIN
RETURN NULL
END
EXECUTE @hr = sp_OASetProperty @objRegExp, 'Pattern', @regexp
IF @hr <> 0 BEGIN
RETURN NULL
END
EXECUTE @hr = sp_OASetProperty @objRegExp, 'Global', @globalReplace
IF @hr <> 0 BEGIN
RETURN NULL
END
EXECUTE @hr = sp_OASetProperty @objRegExp, 'IgnoreCase', @ignoreCase
IF @hr <> 0 BEGIN
RETURN NULL
END

RETURN @objRegExp
END
GO
