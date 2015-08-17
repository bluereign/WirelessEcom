CREATE TABLE [campaign].[SmsReachList] (
    [UniqueId]  INT           IDENTITY (1, 1) NOT NULL,
    [Country]   NCHAR (2)     NOT NULL,
    [CarrierId] INT           NOT NULL,
    [ShortName] VARCHAR (50)  NOT NULL,
    [LongName]  VARCHAR (255) NOT NULL,
    [Aka]       VARCHAR (MAX) NULL,
    CONSTRAINT [PK_SmsReachList] PRIMARY KEY CLUSTERED ([UniqueId] ASC)
);

