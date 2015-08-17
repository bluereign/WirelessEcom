CREATE TABLE [merchtool].[User] (
    [UserId]   INT           IDENTITY (1, 1) NOT NULL,
    [Username] VARCHAR (MAX) NOT NULL,
    [Password] VARCHAR (MAX) NOT NULL,
    [Roles]    VARCHAR (255) NOT NULL,
    [IsActive] BIT           CONSTRAINT [DF_MerchToolUsers_IsActive] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_MerchToolUser] PRIMARY KEY CLUSTERED ([UserId] ASC)
);

