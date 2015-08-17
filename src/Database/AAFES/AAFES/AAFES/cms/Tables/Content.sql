CREATE TABLE [cms].[Content] (
    [ContentID]     UNIQUEIDENTIFIER CONSTRAINT [DF_Content_ContentID] DEFAULT (newid()) NOT NULL,
    [TagID]         BIGINT           NOT NULL,
    [ImageGUID]     UNIQUEIDENTIFIER NOT NULL,
    [ContentType]   VARCHAR (50)     NULL,
    [BinaryContent] IMAGE            NULL,
    [Text]          NTEXT            NULL,
    [Reference]     VARCHAR (255)    NULL,
    [LinkURL]       VARCHAR (255)    NULL,
    [AltTag]        VARCHAR (255)    NULL,
    [Height]        INT              NULL,
    [Width]         INT              NULL,
    [ContentExists] BIT              NULL,
    [CacheInterval] INT              NULL,
    [CreatedBy]     VARCHAR (50)     NULL,
    [CreatedOn]     DATETIME         CONSTRAINT [DF_Content_CreatedOn_1] DEFAULT (getdate()) NULL,
    [ModifiedBy]    VARCHAR (50)     NULL,
    [ModifiedOn]    DATETIME         NULL,
    [Rel]           VARCHAR (50)     NULL,
    CONSTRAINT [PK_Content] PRIMARY KEY CLUSTERED ([ContentID] ASC)
);

