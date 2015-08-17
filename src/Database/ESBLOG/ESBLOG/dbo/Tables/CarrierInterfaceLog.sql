﻿CREATE TABLE [dbo].[CarrierInterfaceLog] (
    [Id]              BIGINT       IDENTITY (1, 1) NOT NULL,
    [LoggedDateTime]  DATETIME     NULL,
    [ReferenceNumber] VARCHAR (50) NULL,
    [Channel]         VARCHAR (50) NULL,
    [Carrier]         VARCHAR (50) NULL,
    [Type]            VARCHAR (50) NULL,
    [RequestType]     VARCHAR (50) NULL,
    [Data]            TEXT         NOT NULL,
    [Compiled]        BIT          CONSTRAINT [DF_CarrierInterfaceLog_Compiled] DEFAULT ((0)) NULL,
    [Header] TEXT NULL, 
    CONSTRAINT [PK_CarrierInterfaceLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);

