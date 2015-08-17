CREATE TABLE [ups].[MilitaryBranch] (
    [BranchId]    INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (3)   NOT NULL,
    [DisplayName] NVARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([BranchId] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [MilBranchDispPreName_index]
    ON [ups].[MilitaryBranch]([Name] ASC, [DisplayName] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [MilBranchDispName_index]
    ON [ups].[MilitaryBranch]([DisplayName] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [MilBranchName_index]
    ON [ups].[MilitaryBranch]([Name] ASC);

