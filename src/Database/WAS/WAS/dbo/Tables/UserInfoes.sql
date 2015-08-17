CREATE TABLE [dbo].[UserInfoes] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [FirstName]   NVARCHAR (50) NULL,
    [LastName]    NVARCHAR (50) NULL,
    [UserName]    NVARCHAR (50) NOT NULL,
    [Status]      INT           NOT NULL,
    [LastLoginOn] DATETIME      NULL,
    [LoginCount]  INT           NOT NULL,
    CONSTRAINT [PK_dbo.UserInfoes] PRIMARY KEY CLUSTERED ([Id] ASC)
);

