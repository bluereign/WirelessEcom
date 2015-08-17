BEGIN
    SET NOCOUNT ON;
    DECLARE @trancount int;
    SET @trancount = @@trancount;
    BEGIN TRY
        IF @trancount = 0
            BEGIN TRANSACTION
              else
            save transaction setuppagemaster;

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Campaigns]') AND type in (N'U'))
DROP TABLE [dbo].[Campaigns];

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CssProps]') AND type in (N'U'))
DROP TABLE [dbo].[CssProps];

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MtSessions]') AND type in (N'U'))
DROP TABLE [dbo].[MtSessions];

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MtUsers]') AND type in (N'U'))
DROP TABLE [dbo].[MtUsers];

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SmsMessages]') AND type in (N'U'))
DROP TABLE [dbo].[SmsMessages];

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SmsReachList]') AND type in (N'U'))
DROP TABLE [dbo].[SmsReachList];


IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'campaign')
  BEGIN
    EXEC ('CREATE SCHEMA campaign;');
  END;

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'merchtool')
  BEGIN
    EXEC ('CREATE SCHEMA merchtool;');
  END;


------------------------------------------------------------------------------
-- CAMPAIGN TABLE
------------------------------------------------------------------------------

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[campaign].[Campaign]') AND type in (N'U'))
BEGIN
CREATE TABLE [campaign].[Campaign](
	[CampaignId] [int] IDENTITY(1,1) NOT NULL,
	[CampaignName] [varchar](255) NOT NULL,
	[StartDateTime] [datetime] NOT NULL,
	[EndDateTime] [datetime] NOT NULL,
	[SmsMessage] [varchar](165) NULL,
	[Disclaimer] [varchar](max) NULL,
	[Subdomain] [varchar](255) NOT NULL,
	[LogoImage] [varbinary](max) NOT NULL,
	[BgImage] [varbinary](max) NULL,
	[AdImage] [varbinary](max) NULL,
	[Version] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Campaign] PRIMARY KEY CLUSTERED 
(
	[CampaignId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY];



ALTER TABLE [campaign].[Campaign] ADD  CONSTRAINT [DF_Campaign_Version]  DEFAULT ((0)) FOR [Version];


ALTER TABLE [campaign].[Campaign] ADD  CONSTRAINT [DF_Campaign_IsActive]  DEFAULT ((1)) FOR [IsActive];

END

------------------------------------------------------------------------------
-- CSSPROPS TABLE
------------------------------------------------------------------------------

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[campaign].[CssProperty]') AND type in (N'U'))
BEGIN
CREATE TABLE [campaign].[CssProperty](
	[CssPropertyId] [int] IDENTITY(1,1) NOT NULL,
	[CampaignId] [int] NOT NULL,
	[FormField] [varchar](50) NOT NULL,
	[Value] [varchar](255) NOT NULL
) ON [PRIMARY];
END




------------------------------------------------------------------------------
-- MERCHTOOLS SESSIONS TABLE
------------------------------------------------------------------------------

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[merchtool].[Session]') AND type in (N'U'))
BEGIN
CREATE TABLE [merchtool].[Session](
	[UniqueId] [int] IDENTITY(1,1) NOT NULL,
	[SessionId] [varchar](1024) NOT NULL,
	[UserId] [int] NOT NULL,
	[LastActionAt] [datetime] NOT NULL,
 CONSTRAINT [PK_MerchToolSession] PRIMARY KEY CLUSTERED 
(
	[UniqueId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY];
END


------------------------------------------------------------------------------
-- MERCHTOOLS USERS TABLE
------------------------------------------------------------------------------

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[merchtool].[User]') AND type in (N'U'))
BEGIN
CREATE TABLE [merchtool].[User](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](max) NOT NULL,
	[Password] [varchar](max) NOT NULL,
	[Roles] [varchar](255) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_MerchToolUser] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY];



ALTER TABLE [merchtool].[User] ADD  CONSTRAINT [DF_MerchToolUsers_IsActive]  DEFAULT ((0)) FOR [IsActive];
END

------------------------------------------------------------------------------
-- SMS MESSAGES TABLE
------------------------------------------------------------------------------

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[campaign].[SmsMessage]') AND type in (N'U'))
BEGIN
CREATE TABLE [campaign].[SmsMessage](
	[MessageId] [int] IDENTITY(1,1) NOT NULL,
	[PhoneNumber] [varchar](10) NOT NULL,
	[CarrierId] [int] NOT NULL,
	[Message] [varchar](160) NOT NULL,
	[RunDate] [date] NOT NULL,
	[SmsMessageId] [varchar](255) NULL,
	[ResultCode] [int] NULL,
	[Result] [varchar](255) NULL,
 CONSTRAINT [PK_SmsMessage] PRIMARY KEY CLUSTERED 
(
	[MessageId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY];

END


------------------------------------------------------------------------------
-- SMS REACH LIST TABLE
------------------------------------------------------------------------------

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[campaign].[SmsReachList]') AND type in (N'U'))
BEGIN
CREATE TABLE [campaign].[SmsReachList](
	[UniqueId] [int] IDENTITY(1,1) NOT NULL,
	[Country] [nchar](2) NOT NULL,
	[CarrierId] [int] NOT NULL,
	[ShortName] [varchar](50) NOT NULL,
	[LongName] [varchar](255) NOT NULL,
	[Aka] [varchar](max) NULL,
 CONSTRAINT [PK_SmsReachList] PRIMARY KEY CLUSTERED 
(
	[uniqueId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY];



END


ALTER TABLE [salesorder].[order] ADD CampaignId int

ALTER TABLE [catalog].[sessionstockreservation] ADD CampaignId int

ALTER TABLE [logging].[ReservedStock] ADD CampaignId int

ALTER TABLE [logging].[InvalidCart] ADD CampaignId int

ALTER TABLE [campaign].[Campaign]
ADD [HeaderImage] [varbinary](max) NULL,
[AdUrl] [varchar](255) NULL

ALTER TABLE salesorder.[Order]
ADD SmsOptIn BIT NOT NULL DEFAULT(0)

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
            rollback transaction setuppagemaster;

        RAISERROR ('PAGEMASTERSETUP: %d: %s', 16, 1, @error, @message) ;
    END CATCH
END

