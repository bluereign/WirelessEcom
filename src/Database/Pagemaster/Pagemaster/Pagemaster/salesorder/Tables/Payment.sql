CREATE TABLE [salesorder].[Payment] (
    [PaymentId]                     INT           IDENTITY (1, 1) NOT NULL,
    [OrderId]                       INT           NULL,
    [PaymentAmount]                 MONEY         NULL,
    [PaymentDate]                   DATETIME      NULL,
    [CreditCardExpDate]             NVARCHAR (50) NULL,
    [CreditCardAuthorizationNumber] NVARCHAR (30) NULL,
    [PaymentMethodId]               INT           NULL,
    [BankCode]                      NVARCHAR (10) NULL,
    [AuthorizationOrigId]           VARCHAR (44)  NULL,
    [RefundOrigId]                  VARCHAR (15)  NULL,
    [ChargebackOrigId]              VARCHAR (30)  NULL,
    [PaymentToken]                  VARCHAR (20)  NULL,
    CONSTRAINT [PK__Payments__DA6C7FE122A0D34C] PRIMARY KEY CLUSTERED ([PaymentId] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_Payments_Orders] FOREIGN KEY ([OrderId]) REFERENCES [salesorder].[Order] ([OrderId])
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Payment_11_548965082__K2_K9_K1]
    ON [salesorder].[Payment]([OrderId] ASC, [PaymentMethodId] ASC, [PaymentId] ASC);


GO
CREATE STATISTICS [_dta_stat_548965082_1_2]
    ON [salesorder].[Payment]([PaymentId], [OrderId]);


GO
---------------------------------------------------------------------------- 
-- Object Type : Trigger
-- Object Name : msdb.tr_logsalesorderpayment
-- Description : Monitor all changes in the salesorder.payment table
-- Author : Naomi Hall
-- Date : December 18th, 2012 -- Edited January 3, 2013
---------------------------------------------------------------------------- 

--The Trigger
CREATE TRIGGER [salesorder].[tr_logpayment] ON [salesorder].[payment] FOR INSERT, UPDATE, DELETE

AS

DECLARE @bit int
	,@field int
	,@maxfield int
	,@char int
	,@fieldname varchar(128)
	,@TableName varchar(128)
	,@SchemaName varchar(128)
	,@PKCols varchar(1000)
	,@PKHeader varchar(128)
	,@PKValue varchar(128)
	,@sql nvarchar(MAX)
	,@sql1 nvarchar(MAX)
	,@UserName varchar(128)
	,@HostName varchar(128)
	,@ServerName varchar(128)
	,@Type varchar(1)
	,@PKSelect varchar(1000)
	
SELECT @SchemaName = 'salesorder'
SELECT @TableName = 'payment'

-- Date, User, Host, Server
SELECT 	@UserName = SYSTEM_USER
		,@HostName = HOST_NAME()
		,@ServerName = @@SERVERNAME


-- Action
	IF EXISTS (SELECT * FROM inserted)
	IF EXISTS (SELECT * FROM deleted)
			SELECT @Type = 'U'
		ELSE
			SELECT @Type = 'I'
	ELSE
		SELECT @Type = 'D'
	
-- Get list of columns changed
	SELECT * INTO #ins FROM inserted
	SELECT * INTO #del FROM deleted
	
-- Get primary key columns for full outer join
	SELECT	@PKCols = coalesce(@PKCols + ' and', ' on') + ' i.' + c.COLUMN_NAME + ' = d.' + c.COLUMN_NAME
	FROM	INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,
		INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
	WHERE 	pk.TABLE_NAME = @TableName
	AND pk.TABLE_SCHEMA = @SchemaName
	AND	CONSTRAINT_TYPE = 'PRIMARY KEY'
	AND	c.TABLE_NAME = pk.TABLE_NAME
	and c.TABLE_SCHEMA = pk.TABLE_SCHEMA
	AND	c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME
	
-- Get primary key select for insert
	SELECT @PKSelect = coalesce(@PKSelect+'+','') + '''<' + COLUMN_NAME + '=''+convert(varchar(100),coalesce(i.' + COLUMN_NAME +',d.' + COLUMN_NAME + '))+''>''' 
	FROM	INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,
		INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
	WHERE 	pk.TABLE_NAME = @TableName
	AND pk.TABLE_SCHEMA = @SchemaName
	AND	CONSTRAINT_TYPE = 'PRIMARY KEY'
	AND	c.TABLE_NAME = pk.TABLE_NAME
	AND	c.TABLE_SCHEMA = pk.TABLE_SCHEMA
	AND	c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME

-- Get primary key select for insert
	SELECT @PKHeader = c.COLUMN_NAME
	FROM	INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,
		INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
	WHERE 	pk.TABLE_NAME = @TableName
	AND pk.TABLE_SCHEMA = @SchemaName
	AND	CONSTRAINT_TYPE = 'PRIMARY KEY'
	AND	c.TABLE_NAME = pk.TABLE_NAME
	AND	c.TABLE_SCHEMA = pk.TABLE_SCHEMA
	AND	c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME

SET @sql1 = N'SELECT ' + @PKHeader + N' FROM #ins'

DECLARE  @t TABLE
(
a varchar(128)
)
INSERT INTO @t (a)
EXEC sp_executesql @sql1

SELECT @PKValue = a FROM @t

	IF @PKCols is null
	BEGIN
		RAISERROR('no PK on table %s', 16, -1, @TableName)
		RETURN
	END
	
	SELECT @field = 0, @maxfield = max(ORDINAL_POSITION) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName
	WHILE @field < @maxfield
	BEGIN
		SELECT @field = min(ORDINAL_POSITION) from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TableName and ORDINAL_POSITION > @field
		SELECT @bit = (@field - 1 )% 8 + 1
		SELECT @bit = power(2,@bit - 1)
		SELECT @char = ((@field - 1) / 8) + 1
		IF substring(COLUMNS_UPDATED(),@char, 1) & @bit > 0 or @Type in ('I','D')
		BEGIN
			SELECT @fieldname = COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TableName AND TABLE_SCHEMA = @SchemaName AND ORDINAL_POSITION = @field
			SELECT @SQL = 'INSERT INTO logging.Payment (Type, SchemaName, TableName, PKCol, FieldName, OldValue, NewValue, UpdateDate, UserName, Hostname, ServerName)'
			+' SELECT '+''''+ @Type+''''+', '+''''+@SchemaName+''''+', '+''''+@TableName+''''+', '+''''+@PKValue+''''+', convert(varchar(1000),'+''''+@FieldName+''''+'),convert(varchar(1000),d.'+@fieldname+'),'
			+' convert(varchar(1000),i.'+@fieldname+'),GETDATE(),convert(varchar(1000),'''+@UserName+'''),convert(varchar(1000),'''+@HostName+'''),convert(varchar(1000),'''+@ServerName+''')'
			+' FROM #ins i FULL OUTER JOIN #del d '+@PKCols
			+' WHERE i.'+@fieldname+' <> d.'+@fieldname+' OR (i.'+@fieldname+' IS NULL AND d.'+@fieldname+' IS NOT NULL)'
			+' OR (i.'+@fieldname+' IS NOT NULL AND d.'+@fieldname+' IS NULL)'
			EXECUTE (@sql)
		END
	END
GO
CREATE TRIGGER [salesorder].[BlockTool4PaymentMethodIdUpdate]
   ON  [salesorder].[Payment]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @RevertedUpdates TABLE (
		OrderId int,
		PaymentId int,
		OldPaymentMethodId int,
		NewPaymentMethodId int
		)
	;

    UPDATE P
	SET P.PaymentMethodId = D.PaymentMethodId
		, P.BankCode = D.BankCode
	OUTPUT I.OrderId, I.PaymentId, D.PaymentMethodId, I.PaymentMethodId INTO @RevertedUpdates
	FROM [salesorder].[Payment] P
		INNER JOIN deleted D ON P.PaymentId = D.PaymentId
		INNER JOIN inserted I ON P.PaymentId = I.PaymentId
	WHERE D.PaymentMethodId IS NOT NULL
		AND I.PaymentMethodId IS NULL
		AND I.BankCode = 'Tool4'
		AND COALESCE(D.BankCode, ' ') != I.BankCode
	;

	INSERT INTO salesorder.Activity (
		OrderId
		, Name
		, [Description]
		)
	SELECT OrderId
		, 'PaymentMethodId Update Reverted'
		, 'User ''' + SYSTEM_USER + ''' attempted to update PaymentMethodId from ' + COALESCE(CONVERT(nvarchar,OldPaymentMethodId),'NULL') + ' to ' + COALESCE(CONVERT(nvarchar,NewPaymentMethodId),'NULL') + ' for PaymentId ' + CONVERT(nvarchar,PaymentId) + ' using ''' + APP_NAME() + '''.'
	FROM @RevertedUpdates
	;

END