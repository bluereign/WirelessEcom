CREATE TABLE [dbo].[Users]
(
[User_ID] [int] NOT NULL IDENTITY(1, 1),
[st] [int] NULL,
[st2] [int] NULL,
[st3] [int] NULL,
[SID] [int] NULL,
[UserName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeLastSessionBegan] [datetime] NULL,
[TimePreviousSessionBegan] [datetime] NULL,
[TimeLastAuthenticated] [datetime] NULL,
[VisitingObject_ID] [int] NULL,
[IP] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Host] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Browser] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HttpFrom] [varchar] (1500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleInitial] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[YEARS_AT_ADDR] [int] NULL,
[MONTHS_AT_ADDr] [int] NULL,
[Email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HomePhone] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkPhone] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ShipFirstName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipMiddleInitial] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipLastName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipCompany] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipAddress1] [nvarchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipAddress2] [nvarchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipCity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipState] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipCountry] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipZip] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipPhone] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipFax] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SelectedPaymentMethod] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AF_ID] [int] NULL,
[AF_COUNT] [int] NULL,
[st_id] [int] NULL,
[restrictiongroup_id] [int] NULL,
[lang_id] [smallint] NULL,
[country_id] [smallint] NULL,
[Shoppernumber] [char] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[exported] [int] NULL,
[SSN] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarId] [int] NULL,
[receive_email] [bit] NULL,
[receive_newsletter] [bit] NULL,
[CarYear] [int] NULL,
[CUST_CD] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeCreated] [datetime] NULL,
[wddxCart] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsOrderAssistanceOn] [bit] NOT NULL CONSTRAINT [DF__Users__IsOrderAs__745AE5AF] DEFAULT ((0)),
[ShipBase] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MilitaryBase] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthenticationId] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_users_temp_2] PRIMARY KEY CLUSTERED  ([User_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Users_indx_DateCreate] ON [dbo].[Users] ([DateCreated]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_users_temp_SearchUsers] ON [dbo].[Users] ([Email]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [users_temp.IX_users_IP] ON [dbo].[Users] ([IP]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [users_temp.IX_users_IP_UserName] ON [dbo].[Users] ([IP], [UserName]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [users_temp.IX_users_Authentication] ON [dbo].[Users] ([User_ID], [st], [st2], [st3], [TimeLastAuthenticated]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [users_temp.IX_users_UserName] ON [dbo].[Users] ([UserName]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [users_temp.IX_users_Login] ON [dbo].[Users] ([UserName], [Password]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'dbo', 'TABLE', N'Users', 'COLUMN', N'User_ID'
GO
