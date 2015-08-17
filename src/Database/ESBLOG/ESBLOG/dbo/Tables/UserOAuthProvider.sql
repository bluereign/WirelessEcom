﻿CREATE TABLE [dbo].[UserOAuthProvider] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [UserAuthId]         INT            NOT NULL,
    [Provider]           VARCHAR (8000) NULL,
    [UserId]             VARCHAR (8000) NULL,
    [UserName]           VARCHAR (8000) NULL,
    [FullName]           VARCHAR (8000) NULL,
    [DisplayName]        VARCHAR (8000) NULL,
    [FirstName]          VARCHAR (8000) NULL,
    [LastName]           VARCHAR (8000) NULL,
    [Email]              VARCHAR (8000) NULL,
    [BirthDate]          DATETIME       NULL,
    [BirthDateRaw]       VARCHAR (8000) NULL,
    [Country]            VARCHAR (8000) NULL,
    [Culture]            VARCHAR (8000) NULL,
    [Gender]             VARCHAR (8000) NULL,
    [Language]           VARCHAR (8000) NULL,
    [MailAddress]        VARCHAR (8000) NULL,
    [Nickname]           VARCHAR (8000) NULL,
    [PostalCode]         VARCHAR (8000) NULL,
    [TimeZone]           VARCHAR (8000) NULL,
    [RefreshToken]       VARCHAR (8000) NULL,
    [RefreshTokenExpiry] DATETIME       NULL,
    [RequestToken]       VARCHAR (8000) NULL,
    [RequestTokenSecret] VARCHAR (8000) NULL,
    [Items]              VARCHAR (8000) NULL,
    [AccessToken]        VARCHAR (8000) NULL,
    [AccessTokenSecret]  VARCHAR (8000) NULL,
    [CreatedDate]        DATETIME       NOT NULL,
    [ModifiedDate]       DATETIME       NOT NULL,
    [RefId]              INT            NULL,
    [RefIdStr]           VARCHAR (8000) NULL,
    [Meta]               VARCHAR (8000) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);



