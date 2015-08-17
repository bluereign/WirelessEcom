CREATE TABLE [dbo].[Channels] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (50) NULL,
    [Description] NVARCHAR (50) NULL,
    CONSTRAINT [PK_dbo.Channels] PRIMARY KEY CLUSTERED ([Id] ASC)
);



