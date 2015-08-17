CREATE TABLE [catalog].[GersStock] (
    [GersSku]       NVARCHAR (9)  NOT NULL,
    [OutletId]      NVARCHAR (10) NOT NULL,
    [OutletCode]    NVARCHAR (3)  NOT NULL,
    [StoreCode]     NVARCHAR (2)  NOT NULL,
    [LocationCode]  NVARCHAR (6)  NOT NULL,
    [Qty]           INT           NOT NULL,
    [Cost]          MONEY         NOT NULL,
    [FiflDate]      DATE          NOT NULL,
    [IMEI]          VARCHAR (15)  NULL,
    [SIM]           VARCHAR (20)  NULL,
    [OrderDetailId] INT           NULL,
    [BlockId]       INT           NULL,
    CONSTRAINT [PK_GersStock] PRIMARY KEY CLUSTERED ([OutletId] ASC),
    CONSTRAINT [FK_GS_CascadeId] FOREIGN KEY ([BlockId]) REFERENCES [ALLOCATION].[Block] ([BlockId])
);


GO
CREATE NONCLUSTERED INDEX [NCL_catalog_GersStock_GersSku]
    ON [catalog].[GersStock]([GersSku] ASC)
    INCLUDE([BlockId]) WITH (DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [<GersStockSku, sysname,>]
    ON [catalog].[GersStock]([OrderDetailId] ASC)
    INCLUDE([GersSku]);


GO
CREATE STATISTICS [_dta_stat_563585146_11_9]
    ON [catalog].[GersStock]([OrderDetailId], [IMEI]);


GO
CREATE STATISTICS [_dta_stat_563585146_2_1]
    ON [catalog].[GersStock]([OutletId], [GersSku]);


GO
CREATE STATISTICS [_dta_stat_563585146_11_3_1_2]
    ON [catalog].[GersStock]([OrderDetailId], [OutletCode], [GersSku], [OutletId]);


GO
CREATE STATISTICS [_dta_stat_563585146_1_11_8]
    ON [catalog].[GersStock]([GersSku], [OrderDetailId], [FiflDate]);


GO
CREATE STATISTICS [_dta_stat_563585146_11_2_1]
    ON [catalog].[GersStock]([OrderDetailId], [OutletId], [GersSku]);


GO
CREATE STATISTICS [_dta_stat_563585146_3_2_1]
    ON [catalog].[GersStock]([OutletCode], [OutletId], [GersSku]);


GO
CREATE STATISTICS [_dta_stat_563585146_9]
    ON [catalog].[GersStock]([IMEI]);


GO
CREATE STATISTICS [_dta_stat_563585146_3_11_2]
    ON [catalog].[GersStock]([OutletCode], [OrderDetailId], [OutletId]);


GO
CREATE STATISTICS [_dta_stat_563585146_2_3]
    ON [catalog].[GersStock]([OutletId], [OutletCode]);


GO
CREATE STATISTICS [_dta_stat_563585146_3_1_11_8]
    ON [catalog].[GersStock]([OutletCode], [GersSku], [OrderDetailId], [FiflDate]);


GO
CREATE trigger [catalog].[tr_logginggersstock] on [catalog].[GersStock] for insert, update, delete
as

declare @bit int ,
	@field int ,
	@maxfield int ,
	@char int ,
	@fieldname varchar(128) ,
	@TableName varchar(128) ,
	@SchemaName varchar(128) ,
	@PKCols varchar(1000) ,
	@sql varchar(2000), 
	@UpdateDate varchar(21) ,
	@UserName varchar(128) ,
	@Type char(1) ,
	@PKSelect varchar(1000)
	
	SELECT @SchemaName = 'catalog'
	SELECT @TableName = 'gersstock'

	-- date and user
	select 	@UserName = system_user ,
		@UpdateDate = convert(varchar(8), getdate(), 112) + ' ' + convert(varchar(12), getdate(), 114)

	-- Action
	if exists (select * from inserted)
		if exists (select * from deleted)
			select @Type = 'U'
		else
			select @Type = 'I'
	else
		select @Type = 'D'
	
	-- get list of columns
	select * into #ins from inserted
	select * into #del from deleted
	
	-- Get primary key columns for full outer join
	select	@PKCols = coalesce(@PKCols + ' and', ' on') + ' i.' + c.COLUMN_NAME + ' = d.' + c.COLUMN_NAME
	from	INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,
		INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
	where 	pk.TABLE_NAME = @TableName
	AND pk.TABLE_SCHEMA = @SchemaName
	and c.TABLE_SCHEMA = pk.TABLE_SCHEMA
	and	CONSTRAINT_TYPE = 'PRIMARY KEY'
	and	c.TABLE_NAME = pk.TABLE_NAME
	and	c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME
	
	-- Get primary key select for insert
	select @PKSelect = coalesce(@PKSelect+'+','') + '''<' + COLUMN_NAME + '=''+convert(varchar(100),coalesce(i.' + COLUMN_NAME +',d.' + COLUMN_NAME + '))+''>''' 
	from	INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,
		INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
	where 	pk.TABLE_NAME = @TableName
	and	CONSTRAINT_TYPE = 'PRIMARY KEY'
	and	c.TABLE_NAME = pk.TABLE_NAME
	and	c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME
	
	if @PKCols is null
	begin
		raiserror('no PK on table %s', 16, -1, @TableName)
		return
	end
	
	select @field = 0, @maxfield = max(ORDINAL_POSITION) from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TableName
	while @field < @maxfield
	begin
		select @field = min(ORDINAL_POSITION) from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TableName and ORDINAL_POSITION > @field
		select @bit = (@field - 1 )% 8 + 1
		select @bit = power(2,@bit - 1)
		select @char = ((@field - 1) / 8) + 1
		if substring(COLUMNS_UPDATED(),@char, 1) & @bit > 0 or @Type in ('I','D')
		begin
			select @fieldname = COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TableName and ORDINAL_POSITION = @field
			select @sql = 		'insert [logging].[gersaudit] (Type, TableName, PK, FieldName, OldValue, NewValue, UpdateDate, UserName)'
			select @sql = @sql + 	' select ''' + @Type + ''''
			select @sql = @sql + 	',''' + @TableName + ''''
			select @sql = @sql + 	',' + @PKSelect
			select @sql = @sql + 	',''' + @fieldname + ''''
			select @sql = @sql + 	',convert(varchar(1000),d.' + @fieldname + ')'
			select @sql = @sql + 	',convert(varchar(1000),i.' + @fieldname + ')'
			select @sql = @sql + 	',''' + @UpdateDate + ''''
			select @sql = @sql + 	',convert(varchar(1000),''' + @Username + ''')'
			select @sql = @sql + 	' from #ins i full outer join #del d'
			select @sql = @sql + 	@PKCols
			select @sql = @sql + 	' where i.' + @fieldname + ' <> d.' + @fieldname 
			select @sql = @sql + 	' or (i.' + @fieldname + ' is null and  d.' + @fieldname + ' is not null)' 
			select @sql = @sql + 	' or (i.' + @fieldname + ' is not null and  d.' + @fieldname + ' is null)' 
			exec (@sql)
		end
	end