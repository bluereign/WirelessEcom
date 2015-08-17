CREATE TABLE [catalog].[rebate_good] (
    [RebateGuid]          UNIQUEIDENTIFIER NOT NULL,
    [Title]               NVARCHAR (100)   NOT NULL,
    [Amount]              MONEY            NOT NULL,
    [Active]              BIT              NOT NULL,
    [URL]                 NVARCHAR (200)   NULL,
    [Type]                NVARCHAR (25)    NULL,
    [DisplayType]         NVARCHAR (25)    NULL,
    [Description]         NVARCHAR (MAX)   NULL,
    [SpecialInstructions] NVARCHAR (MAX)   NULL
);

