CREATE TABLE [logging].[InvalidCart] (
    [InvalidCartId]     INT           IDENTITY (1, 1) NOT NULL,
    [InvalidCartTypeId] INT           NULL,
    [ActivationType]    VARCHAR (50)  NULL,
    [CarrierId]         INT           NULL,
    [Message]           VARCHAR (MAX) NULL,
    [DateTimeCreated]   DATETIME      CONSTRAINT [DF_InvalidCart_DateTimeCreated] DEFAULT (getdate()) NOT NULL,
    [CampaignId]        INT           NULL,
    CONSTRAINT [PK_InvalidCart] PRIMARY KEY CLUSTERED ([InvalidCartId] ASC)
);

