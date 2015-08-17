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
    PRIMARY KEY CLUSTERED ([PaymentId] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Payments_Orders] FOREIGN KEY ([OrderId]) REFERENCES [salesorder].[Order] ([OrderId]),
    CONSTRAINT [FK_Payments_PaymentMethods] FOREIGN KEY ([PaymentMethodId]) REFERENCES [salesorder].[PaymentMethod] ([PaymentMethodId])
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Payment_11_548965082__K2_K9_K1]
    ON [salesorder].[Payment]([OrderId] ASC, [PaymentMethodId] ASC, [PaymentId] ASC);


GO
CREATE STATISTICS [_dta_stat_548965082_1_2]
    ON [salesorder].[Payment]([PaymentId], [OrderId]);


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
GO

CREATE TRIGGER [salesorder].[NoRowDeletePayment] ON [salesorder].[Payment]
INSTEAD OF DELETE
AS
BEGIN
IF @@rowcount > 0
BEGIN
RAISERROR( 'Rows in Payment cannot be deleted or you create extra work for the gnomes!', 16, 2 )
ROLLBACK
END
END
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
DISABLE TRIGGER [salesorder].[tr_logpayment]
    ON [salesorder].[Payment];


GO
---------------------------------------------------------------------------- 
-- Object Type : Trigger
-- Object Name : msdb.tr_payment_updated
-- Description : E-mail me when a payment goes through without a paymentid
-- Author : NH
-- Date : September 6th, 2012
---------------------------------------------------------------------------- 

CREATE TRIGGER [salesorder].[tr_payment_updated] ON [salesorder].[Payment]
    AFTER INSERT

AS

    SET NOCOUNT ON 
     DECLARE
        @paymentid VARCHAR(1),
        @orderid VARCHAR(5),
        @paymentamount MONEY,
        @paymentdate DATETIME,
        @creditcardauthorizationnumber VARCHAR(30),
        @paymentmethodid int,
        @authorizationorigid VARCHAR(40),
        @gersstatus VARCHAR(1),
        @Body VARCHAR(4000), 
		@SubjectText VARCHAR(200),
		@Servername VARCHAR(50),
		@UserName VARCHAR(50), 
		@HostName VARCHAR(50) 
		        
	SELECT @UserName = SYSTEM_USER, @HostName = HOST_NAME() 
	SELECT @Servername = @@servername
        

			IF EXISTS(SELECT 1 FROM inserted)
			    BEGIN
			        SELECT
						@PaymentId = sp.PaymentId -- int
						,@Orderid = sp.OrderId -- int
						,@PaymentAmount = sp.PaymentAmount -- money
						,@PaymentDate = sp.PaymentDate --datetime
						,@CreditCardAuthorizationNumber = sp.CreditCardAuthorizationNumber -- nvarchar30
						,@PaymentMethodId = sp.PaymentMethodId --int
						,@AuthorizationOrigId = sp.AuthorizationOrigId
					FROM salesorder.payment sp
                    
                        
	SET @body = '<html><body>STATS: '+@UserName+', '+@HostName+' at '+CONVERT(VARCHAR(20),GETDATE(),100)+'<br>ORDER: '+@orderid+'
	<p>PaymentAmount - '+@paymentamount+'<br>
	PaymentDate - '+@paymentdate+'<br>
	CreditCardAuthorizationNumber - '+@creditcardauthorizationnumber+'<br>
	PaymentMethodId - '+@paymentmethodid+'<br>
	AuthorizationOrigId - '+@authorizationorigid
    
    SET @subjecttext = @Servername+' : salesorder.Payment Updated at '+CONVERT(VARCHAR(20),GETDATE(),100) 


--SET @subjecttext = 'salesorder.Payment Update: ' + @subjecttext 


DECLARE @table AS TABLE(Emp_Email NVARCHAR(100), ID int IDENTITY(1,1))

--populate the above table
INSERT @table (Emp_Email) VALUES('nhall@wirelessadvocates.com')
--INSERT @table (Emp_Email) VALUES('rlinmark@wirelessadvocates.com')
--INSERT @table (Emp_Email) VALUES('cgeorge@wirelessadvocates.com')

DECLARE @count AS int
SET @count =1 --initialize the count parameter
DECLARE @Recepient_Email AS VARCHAR(100)
WHILE (@count <=(SELECT COUNT(*) FROM @table))
        BEGIN
        SET @Recepient_Email =(SELECT TOP(1) Emp_Email FROM @table WHERE ID=@count)
        EXEC msdb.dbo.sp_send_dbmail
            @recipients=@Recepient_Email,
            @body_format = 'HTML',            
			@body = @body, 
			@subject = @subjecttext,
			@profile_name ='Default'
            SET @count = @count + 1
            END 
              
			    END
GO
DISABLE TRIGGER [salesorder].[tr_payment_updated]
    ON [salesorder].[Payment];

