CREATE TABLE [catalog].[GersPrice] (
    [GersSku]        NVARCHAR (9)  NOT NULL,
    [PriceGroupCode] NVARCHAR (3)  NOT NULL,
    [Price]          MONEY         NOT NULL,
    [StartDate]      DATE          NOT NULL,
    [EndDate]        DATE          NOT NULL,
    [Comment]        NVARCHAR (70) NULL,
    CONSTRAINT [FK_GersPrice_GersPriceGroup] FOREIGN KEY ([PriceGroupCode]) REFERENCES [catalog].[GersPriceGroup] ([PriceGroupCode])
);


GO
CREATE CLUSTERED INDEX [_dta_index_GersPrice_c_11_228963942__K2_K1_K4]
    ON [catalog].[GersPrice]([PriceGroupCode] ASC, [GersSku] ASC, [StartDate] ASC);


GO
CREATE STATISTICS [_dta_stat_228963942_4_2_1]
    ON [catalog].[GersPrice]([StartDate], [PriceGroupCode], [GersSku]);


GO

-------------------------
--The Trigger
CREATE TRIGGER [catalog].[tr_logersprice] ON [catalog].[GersPrice] FOR INSERT, UPDATE, DELETE

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
	
SELECT @SchemaName = 'catalog'
SELECT @TableName = 'gersprice'

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


	IF @Type = 'I'
		BEGIN
		
	INSERT INTO logging.LogGersprice (
	[GersSku],
	[PriceGroupCode],
	[Price],
	[StartDate],
	[EndDate],
	[Comment],
	[Changes],
	[ChangeDate])
	SELECT i.GersSku, i.PriceGroupCode, i.Price, i.StartDate, i.EndDate, i.Comment, @Type, GETDATE() FROM #ins i

END
ELSE
	
	IF @Type = 'D'
		BEGIN
		
	INSERT INTO logging.LogGersprice (
	[GersSku],
	[PriceGroupCode],
	[Price],
	[StartDate],
	[EndDate],
	[Comment],
	[Changes],
	[ChangeDate])
	SELECT d.GersSku, d.PriceGroupCode, d.Price, d.StartDate, d.EndDate, d.Comment, @Type, GETDATE() FROM #del d
	
	END