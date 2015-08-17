CREATE TABLE [catalog].[Bundle] (
    [Id]        INT            IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (50)   NULL,
    [Bundle]    TEXT           NULL,
    [CreatedBy] VARCHAR (50)   NULL,
    [CreatedOn] DATETIME       NULL,
    [Active]    BIT            NULL,
    [BundleXml] NVARCHAR (MAX) NULL
);

