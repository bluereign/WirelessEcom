CREATE TABLE [websecurity].[BannedUsers] (
    [BannedUserId] INT           IDENTITY (1, 1) NOT NULL,
    [IP]           VARCHAR (50)  NULL,
    [FirstName]    VARCHAR (255) NULL,
    [LastName]     VARCHAR (255) NULL,
    [Address1]     VARCHAR (255) NULL,
    [Address2]     VARCHAR (255) NULL,
    [City]         VARCHAR (255) NULL,
    [State]        VARCHAR (255) NULL,
    [Zip]          VARCHAR (255) NULL,
    [Email]        VARCHAR (100) NULL
);

