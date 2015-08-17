CREATE TABLE [merchtool].[Session] (
    [UniqueId]     INT            IDENTITY (1, 1) NOT NULL,
    [SessionId]    VARCHAR (1024) NOT NULL,
    [UserId]       INT            NOT NULL,
    [LastActionAt] DATETIME       NOT NULL,
    CONSTRAINT [PK_MerchToolSession] PRIMARY KEY CLUSTERED ([UniqueId] ASC)
);

