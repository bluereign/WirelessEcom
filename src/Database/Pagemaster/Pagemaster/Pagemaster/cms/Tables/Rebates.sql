CREATE TABLE [cms].[Rebates] (
    [RebateGUID]      UNIQUEIDENTIFIER CONSTRAINT [DF_Rebate_RebateGUID] DEFAULT (newid()) NOT NULL,
    [Active]          BIT              NOT NULL,
    [CarrierID]       BIGINT           NULL,
    [Number]          INT              NULL,
    [Name]            VARCHAR (50)     NULL,
    [LinkDescription] VARCHAR (2048)   NOT NULL,
    [Filename]        VARCHAR (255)    NOT NULL,
    [AltTag]          VARCHAR (255)    NULL,
    [StartDateTime]   DATETIME         NOT NULL,
    [EndDateTime]     DATETIME         NOT NULL,
    [ImageGUID]       UNIQUEIDENTIFIER NOT NULL,
    [Keywords]        NVARCHAR (1024)  NULL,
    [CreatedBy]       VARCHAR (50)     NULL,
    [CreatedOn]       DATETIME         CONSTRAINT [DF_Rebate_CreatedOn_1] DEFAULT (getdate()) NULL,
    [ModifiedBy]      VARCHAR (50)     NULL,
    [ModifiedOn]      DATETIME         NULL,
    CONSTRAINT [PK_Rebates] PRIMARY KEY CLUSTERED ([RebateGUID] ASC)
);

