CREATE TABLE [logging].[MilitaryAuthentication] (
    [MilitaryAuthentication] INT           IDENTITY (1, 1) NOT NULL,
    [UrlPath]                VARCHAR (500) NULL,
    [IsAuthSuccessful]       BIT           CONSTRAINT [DF_MilitaryAuthentication_IsAuthSuccessful] DEFAULT ((0)) NOT NULL,
    [AuthData]               VARCHAR (500) NULL,
    [Timestamp]              DATETIME      CONSTRAINT [DF_MilitaryAuthentication_Timestamp] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_MilitaryAuthentication] PRIMARY KEY CLUSTERED ([MilitaryAuthentication] ASC)
);

