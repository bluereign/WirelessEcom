CREATE TABLE [account].[UserRole] (
    [UserId]   INT              NOT NULL,
    [RoleGuid] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleGuid] ASC) WITH (FILLFACTOR = 80)
);

