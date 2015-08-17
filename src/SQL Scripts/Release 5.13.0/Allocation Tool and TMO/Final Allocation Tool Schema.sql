PRINT '[allocation] script starting...'

BEGIN
    SET NOCOUNT ON;
    DECLARE @trancount int;
    SET @trancount = @@trancount;
    BEGIN TRY
        IF @trancount = 0
            BEGIN TRANSACTION
              else
            save transaction allocationschema;
--CREATE SCHEMA [ALLOCATION];


/*
ALTER TABLE allocation.messagetemplates DROP CONSTRAINT [FK_MG_MGId];
DROP TABLE allocation.VirtualOrders;
DROP FUNCTION allocation.udf_CheckforMessageGroup;
--ALTER TABLE allocation.messagegroup DROP CONSTRAINT [FK_PM_MessageId];
DROP TABLE allocation.messagetemplates; DROP TABLE allocation.MessageDestination; 
ALTER TABLE allocation.Block DROP CONSTRAINT [FK_VIT_VInvId];
ALTER TABLE allocation.VirtualInventory DROP CONSTRAINT FK_VI_UserId;
ALTER TABLE allocation.VirtualInventory DROP CONSTRAINT FK_VI_ProductGersSKU;
ALTER TABLE allocation.VirtualInventory DROP CONSTRAINT [FK_VIT_InventoryTypeId];
DROP TABLE allocation.VirtualInventoryType;
DROP TABLE allocation.VirtualInventory;
ALTER TABLE catalog.GersStock DROP CONSTRAINT [FK_GS_CascadeId];
ALTER TABLE catalog.GersStock DROP COLUMN BlockId;
DROP TABLE allocation.Block;
DROP TABLE allocation.messagegroup;
*/


--CREATE SCHEMA allocation;

PRINT 'New [allocation] schema created!'

--- This table lets you store all messaging templates. Messages can be re-used and edited as needed and be used across multiple areas.
--- For example, one message can be used as an e-mail and also placed within the long description on the product details page.

CREATE TABLE [allocation].[MessageTemplates] (
	[MessageId] [int] IDENTITY(1,1) NOT NULL
	,[UserId] [int] NOT NULL
	,[Subject] [varchar](125) NULL	
	,[Message] [nvarchar](max) NOT NULL
	,[LocationId] [int] NOT NULL
	,[Active] [bit] NOT NULL DEFAULT(0)
	,[MessageGroupId] [int] NOT NULL
	,[DateCreated] [datetime] DEFAULT(GETDATE()) NOT NULL
	,CONSTRAINT pk_MessageId PRIMARY KEY (MessageId)
	)
GO

--- Ensure a real user created this, the UserId is also in the Users table
ALTER TABLE [allocation].[MessageTemplates] ADD CONSTRAINT FK_MT_UserId FOREIGN KEY (UserId) REFERENCES [dbo].[Users] (User_Id)

PRINT 'New [allocation].[MessageTemplates] table created!'

--- This table allows you to assign one message to multiple products and dictate start/end times for messaging.

CREATE TABLE [allocation].[MessageGroup](
	[MessageGroupId] [int] IDENTITY (1,1) NOT NULL
	,[MessageGroupName] [varchar](125) NOT NULL
	,[Active] [bit] NOT NULL DEFAULT (0)
	,CONSTRAINT pk_PMId PRIMARY KEY (MessageGroupId)
	)
GO

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
GO


--- Ensure the message being attached to a product has already been created and is real
ALTER TABLE [allocation].[MessageTemplates] ADD CONSTRAINT FK_MG_MGId CHECK ([allocation].[udf_CheckforMessageGroup](MessageGroupId)='1'); 

PRINT 'New [allocation].[MessageGroup] table created with all constraints!'

--- This table allows you to assign specific amounts of virtual inventory.

CREATE TABLE [allocation].[VirtualInventory](
	[VirtualInventoryId] [int] IDENTITY(1,1) NOT NULL
	,[UserId] [int] NOT NULL
	,[GersSku] nvarchar(9) NOT NULL
	,[COGS] money NOT NULL
	,[Name] nvarchar(250) NOT NULL
	,[MessageGroupId] [int] NOT NULL
	,[InventoryTypeId] [int] NOT NULL
	,[Active] [bit] NOT NULL DEFAULT(0)
	,[ReleaseDate] [datetime] NOT NULL
	--,[Cascading] [bit] NOT NULL DEFAULT(0)
	,[IsDeleted] [bit] NOT NULL DEFAULT(0)
	,[StartDate] [datetime] NOT NULL
	,[EndDate] [datetime] NOT NULL
	,[DateCreated] [datetime] DEFAULT(GETDATE()) NOT NULL
	,CONSTRAINT pk_VIId PRIMARY KEY (VirtualInventoryId)
	)
GO

PRINT 'New [allocation].[VirtualInventory] table created!';

GO

/*CREATE TABLE [allocation].[CascadeType](
	[CascadeTypeId] [int] IDENTITY(1,1) NOT NULL
	,[Description] nvarchar(100) NOT NULL
	,CONSTRAINT pk_CascadeTypeId PRIMARY KEY (CascadeTypeId)
	)
GO


*/

ALTER TABLE [allocation].[VirtualInventory] ADD CONSTRAINT FK_MG_GroupId FOREIGN KEY (MessageGroupId) REFERENCES [allocation].[MessageGroup] (MessageGroupId)



ALTER TABLE [allocation].[VirtualInventory] ADD CONSTRAINT FK_VI_UserId FOREIGN KEY (UserId) REFERENCES [dbo].[Users] (User_Id)

ALTER TABLE [allocation].[VirtualInventory] ADD CONSTRAINT FK_VI_ProductGersSKU FOREIGN KEY (GersSKU) REFERENCES [catalog].[GersItm] (GersSKU)

CREATE TABLE [allocation].[MessageDestination](
	[LocationId] [int] IDENTITY(1,1) NOT NULL
	,[Destination] nvarchar(100) NOT NULL
	,CONSTRAINT pk_LocationId PRIMARY KEY (LocationId)
	)
GO

ALTER TABLE [allocation].[MessageTemplates] ADD CONSTRAINT FK_MD_LocationId FOREIGN KEY (LocationId) REFERENCES [allocation].[MessageDestination] (LocationId)

CREATE TABLE [allocation].[VirtualInventoryType](
	[InventoryTypeId] [int] IDENTITY(1,1) NOT NULL
	,[Description] nvarchar(100) NOT NULL
	,CONSTRAINT pk_InventoryTypeId PRIMARY KEY (InventoryTypeId)
	)
GO

ALTER TABLE [allocation].[VirtualInventory] ADD CONSTRAINT FK_VIT_InventoryTypeId FOREIGN KEY (InventoryTypeId) REFERENCES [allocation].[VirtualInventoryType] (InventoryTypeId)

PRINT 'Create staggered/cascading virtual inventory association table...'

--- Create a table that stores the next virtual inventory ID to move to once the original is depleted

CREATE TABLE [allocation].[Block](
	[BlockId] [int] IDENTITY(1,1) NOT NULL
	--,[GersSku] nvarchar(9) NOT NULL
	--,[VirtualInventoryId] [int] NOT NULL
	--,[ChildVirtualInventoryId] [int] NOT NULL -- same as parent ID for the first entry OR even if it's the only entry
	--,[CascadeTypeId] [int] NOT NULL
	--,[Ordinal] [int] NOT NULL
	--,[ActiveDate] datetime NULL -- keep track of when the cascade happened so we have historical purchase trend
	,[ProcessDate] [datetime] NOT NULL
	,[DelayDate] [datetime] NULL
	,[Quantity] [int] NOT NULL
	,[IsDeleted] [bit] NOT NULL DEFAULT(0)
	--,[ProcessingEndDate] [datetime] NOT NULL
	,CONSTRAINT pk_CascadeBlockId PRIMARY KEY (BlockId)
	)
GO

ALTER TABLE [allocation].[Block] ADD CONSTRAINT FK_VIT_VInvId FOREIGN KEY (VirtualInventoryId) REFERENCES [allocation].[VirtualInventory] (VirtualInventoryId)


CREATE TABLE [ALLOCATION].[BlockVirtualInventory](
	[BlockId] [int] NOT NULL,
	[VirtualInventoryId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BlockId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [uc_BlockId] UNIQUE NONCLUSTERED 
(
	[BlockId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [uc_BlVI] UNIQUE NONCLUSTERED 
(
	[BlockId] ASC,
	[VirtualInventoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [ALLOCATION].[BlockVirtualInventory]  WITH CHECK ADD  CONSTRAINT [FK_BVI_BlockId] FOREIGN KEY([BlockId])
REFERENCES [ALLOCATION].[Block] ([BlockId])
GO

ALTER TABLE [ALLOCATION].[BlockVirtualInventory] CHECK CONSTRAINT [FK_BVI_BlockId]
GO

ALTER TABLE [ALLOCATION].[BlockVirtualInventory]  WITH CHECK ADD  CONSTRAINT [FK_BVI_VirtualInventoryId] FOREIGN KEY([VirtualInventoryId])
REFERENCES [ALLOCATION].[VirtualInventory] ([VirtualInventoryId])
GO

ALTER TABLE [ALLOCATION].[BlockVirtualInventory] CHECK CONSTRAINT [FK_BVI_VirtualInventoryId]
GO

ALTER TABLE [ALLOCATION].[BlockVirtualInventory]  WITH CHECK ADD  CONSTRAINT [FK_VIT_BVInvId] FOREIGN KEY([VirtualInventoryId])
REFERENCES [ALLOCATION].[VirtualInventory] ([VirtualInventoryId])
GO

ALTER TABLE [ALLOCATION].[BlockVirtualInventory] CHECK CONSTRAINT [FK_VIT_BVInvId]
GO



--ALTER TABLE [allocation].[VirtualInventory] ADD CONSTRAINT FK_VIT_BLVInvId FOREIGN KEY (VirtualInventoryId) REFERENCES [allocation].[BlockVirtualInventory] (VirtualInventoryId)
--ALTER TABLE [allocation].[Block] ADD CONSTRAINT FK_VIT_BLVInvId FOREIGN KEY (BlockId) REFERENCES [allocation].[BlockVirtualInventory] (BlockId)

PRINT 'Create order to virtual inventory association table for customer care, historical tracking and reporting purposes...'

--- Create a table that associates orders to fake inventory by OrderId


CREATE TABLE [allocation].[VirtualOrders](
	[VirtualOrderId] [int] IDENTITY(1,1) NOT NULL
	,[BlockId] int NOT NULL
	,[GersSku] nvarchar(9) NOT NULL
	,[OutletId] nvarchar(100) NOT NULL --- grab from the catalog.GersStock table
	,[OrderId] [int] NOT NULL
	,[OrderDetailId] [int] NOT NULL	--- grab from the catalog.GersStock or salesorder.orderdetail table upon order creation
	,[ProcessDate] datetime NOT NULL
	,[MessageGroupId] [int] NOT NULL
	,CONSTRAINT pk_VirtualOrderId PRIMARY KEY (VirtualOrderId)
	)
GO

ALTER TABLE [allocation].[VirtualOrders] ADD CONSTRAINT FK_VO_CascadeId FOREIGN KEY (BlockId) REFERENCES [allocation].[Block] (BlockId)

ALTER TABLE [catalog].[GersStock] ADD [BlockId] int

ALTER TABLE [catalog].[GersStock] ADD CONSTRAINT FK_GS_CascadeId FOREIGN KEY (BlockId) REFERENCES [allocation].[Block] (BlockId)

CREATE NONCLUSTERED INDEX [NCL_catalog_GersStock_GersSku] ON [catalog].[GersStock] ([GersSku]) INCLUDE ([BlockId]) WITH (DATA_COMPRESSION = PAGE)
GO

PRINT '[allocation] script complete!'




        IF @trancount = 0   
            COMMIT;
    END TRY
    BEGIN CATCH
        DECLARE @error int, @message varchar(4000), @xstate int;
        SELECT @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();
        IF @xstate = -1
            rollback;
        IF @xstate = 1 and @trancount = 0
            rollback
        IF @xstate = 1 and @trancount > 0
            rollback transaction allocationschema;

        RAISERROR ('ALLOCATIONTOOL: %d: %s', 16, 1, @error, @message) ;
    END CATCH
END

