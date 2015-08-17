CREATE TABLE [cms].[Images] (
    [ImageID]             BIGINT           IDENTITY (1, 1) NOT NULL,
    [ImageGUID]           UNIQUEIDENTIFIER CONSTRAINT [DF_Images_ImageGUID] DEFAULT (newid()) NOT NULL,
    [Active]              BIT              NOT NULL,
    [CategoryID]          BIGINT           NULL,
    [TypeID]              BIGINT           NULL,
    [Name]                VARCHAR (50)     NOT NULL,
    [Note]                VARCHAR (1024)   NULL,
    [CreatedOn]           DATETIME         NULL,
    [CreatedBy]           VARCHAR (50)     NULL,
    [ModifiedOn]          DATETIME         NULL,
    [ModifiedBy]          VARCHAR (50)     NULL,
    [ApprovedRequestedOn] DATETIME         NULL,
    [ApprovedOn]          DATETIME         NULL,
    [BinaryContent]       IMAGE            NULL,
    [Height]              INT              NULL,
    [Width]               INT              NULL,
    [AltTag]              VARCHAR (255)    NULL,
    [LinkURL]             VARCHAR (255)    NULL,
    [Rel]                 VARCHAR (50)     NULL,
    CONSTRAINT [PK_Images] PRIMARY KEY CLUSTERED ([ImageID] ASC),
    CONSTRAINT [FK_Images_Categories] FOREIGN KEY ([CategoryID]) REFERENCES [cms].[Categories] ([CategoryID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_Images_Content] FOREIGN KEY ([ImageGUID]) REFERENCES [cms].[Content] ([ContentID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_Images_Types] FOREIGN KEY ([TypeID]) REFERENCES [cms].[Types] ([TypeID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [cms].[Images] NOCHECK CONSTRAINT [FK_Images_Categories];


GO
ALTER TABLE [cms].[Images] NOCHECK CONSTRAINT [FK_Images_Content];


GO
ALTER TABLE [cms].[Images] NOCHECK CONSTRAINT [FK_Images_Types];

