CREATE TABLE [cms].[Environments] (
    [EnvironmentID]   BIGINT           IDENTITY (1, 1) NOT NULL,
    [EnvironmentGUID] UNIQUEIDENTIFIER CONSTRAINT [DF_Environments_EnvironmentGUID] DEFAULT (newid()) NOT NULL,
    [Name]            VARCHAR (50)     NULL,
    [Locked]          BIT              CONSTRAINT [DF_Environments_Locked] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Environments] PRIMARY KEY CLUSTERED ([EnvironmentID] ASC)
);

