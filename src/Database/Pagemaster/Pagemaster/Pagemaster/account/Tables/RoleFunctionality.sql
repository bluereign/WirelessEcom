CREATE TABLE [account].[RoleFunctionality] (
    [RoleGuid]          UNIQUEIDENTIFIER NOT NULL,
    [FunctionalityGuid] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_RoleFunctionality] PRIMARY KEY CLUSTERED ([RoleGuid] ASC, [FunctionalityGuid] ASC) WITH (FILLFACTOR = 80)
);

