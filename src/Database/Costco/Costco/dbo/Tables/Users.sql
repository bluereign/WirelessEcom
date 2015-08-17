CREATE TABLE [dbo].[Users] (
    [User_ID]                  INT            IDENTITY (1, 1) NOT NULL,
    [st]                       INT            NULL,
    [st2]                      INT            NULL,
    [st3]                      INT            NULL,
    [SID]                      INT            NULL,
    [UserName]                 VARCHAR (100)  NULL,
    [Password]                 NVARCHAR (50)  NULL,
    [TimeLastSessionBegan]     DATETIME       NULL,
    [TimePreviousSessionBegan] DATETIME       NULL,
    [TimeLastAuthenticated]    DATETIME       NULL,
    [VisitingObject_ID]        INT            NULL,
    [IP]                       NVARCHAR (50)  NULL,
    [Host]                     NVARCHAR (100) NULL,
    [Browser]                  NVARCHAR (100) NULL,
    [HttpFrom]                 VARCHAR (1500) NULL,
    [FirstName]                NVARCHAR (30)  NULL,
    [MiddleInitial]            NVARCHAR (1)   NULL,
    [LastName]                 NVARCHAR (30)  NULL,
    [Company]                  NVARCHAR (50)  NULL,
    [Title]                    VARCHAR (50)   NULL,
    [Address1]                 NVARCHAR (60)  NULL,
    [Address2]                 NVARCHAR (60)  NULL,
    [City]                     NVARCHAR (50)  NULL,
    [ZIP]                      NVARCHAR (10)  NULL,
    [State]                    NVARCHAR (30)  NULL,
    [Country]                  NVARCHAR (30)  NULL,
    [YEARS_AT_ADDR]            INT            NULL,
    [MONTHS_AT_ADDr]           INT            NULL,
    [Email]                    VARCHAR (100)  NULL,
    [HomePhone]                NVARCHAR (30)  NULL,
    [WorkPhone]                NVARCHAR (30)  NULL,
    [Gender]                   NVARCHAR (10)  NULL,
    [DateCreated]              DATETIME       NULL,
    [ShipFirstName]            NVARCHAR (30)  NULL,
    [ShipMiddleInitial]        NVARCHAR (1)   NULL,
    [ShipLastName]             NVARCHAR (30)  NULL,
    [ShipCompany]              NVARCHAR (50)  NULL,
    [ShipAddress1]             NVARCHAR (70)  NULL,
    [ShipAddress2]             NVARCHAR (70)  NULL,
    [ShipCity]                 NVARCHAR (50)  NULL,
    [ShipState]                NVARCHAR (30)  NULL,
    [ShipCountry]              NVARCHAR (50)  NULL,
    [ShipZip]                  NVARCHAR (10)  NULL,
    [ShipPhone]                NVARCHAR (30)  NULL,
    [ShipFax]                  NVARCHAR (30)  NULL,
    [SelectedPaymentMethod]    NVARCHAR (50)  NULL,
    [AF_ID]                    INT            NULL,
    [AF_COUNT]                 INT            NULL,
    [st_id]                    INT            NULL,
    [restrictiongroup_id]      INT            NULL,
    [lang_id]                  SMALLINT       NULL,
    [country_id]               SMALLINT       NULL,
    [Shoppernumber]            CHAR (32)      NULL,
    [exported]                 INT            NULL,
    [SSN]                      VARCHAR (10)   NULL,
    [CarId]                    INT            NULL,
    [receive_email]            BIT            NULL,
    [receive_newsletter]       BIT            NULL,
    [CarYear]                  INT            NULL,
    [CUST_CD]                  VARCHAR (50)   NULL,
    [TimeCreated]              DATETIME       NULL,
    [wddxCart]                 TEXT           NULL,
    [IsOrderAssistanceOn]      BIT            DEFAULT ((0)) NOT NULL,
    [ShipBase]                 NVARCHAR (100) NULL,
    [MilitaryBase]             NVARCHAR (100) NULL,
    [AuthenticationId]         VARCHAR (100)  NULL,
    CONSTRAINT [PK_users_temp_2] PRIMARY KEY CLUSTERED ([User_ID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK__Users__MilitaryB__20B4E42B] FOREIGN KEY ([MilitaryBase]) REFERENCES [ups].[MilitaryBase] ([BaseName]),
    CONSTRAINT [FK__Users__ShipBase__1FC0BFF2] FOREIGN KEY ([ShipBase]) REFERENCES [ups].[MilitaryBase] ([BaseName])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_AuthenticationId]
    ON [dbo].[Users]([AuthenticationId] ASC) WHERE ([AuthenticationId] IS NOT NULL);


GO
CREATE NONCLUSTERED INDEX [Users_indx_DateCreate]
    ON [dbo].[Users]([DateCreated] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_users_temp_SearchUsers]
    ON [dbo].[Users]([Email] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [users_temp.IX_users_IP_UserName]
    ON [dbo].[Users]([IP] ASC, [UserName] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [users_temp.IX_users_IP]
    ON [dbo].[Users]([IP] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [users_temp.IX_users_Login]
    ON [dbo].[Users]([UserName] ASC, [Password] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [users_temp.IX_users_Authentication]
    ON [dbo].[Users]([User_ID] ASC, [st] ASC, [st2] ASC, [st3] ASC, [TimeLastAuthenticated] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [users_temp.IX_users_UserName]
    ON [dbo].[Users]([UserName] ASC) WITH (FILLFACTOR = 80);

