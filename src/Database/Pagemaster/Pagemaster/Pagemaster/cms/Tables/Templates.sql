CREATE TABLE [cms].[Templates] (
    [TemplateID]       BIGINT           IDENTITY (1, 1) NOT NULL,
    [ParentTemplateID] BIGINT           NULL,
    [TemplateGUID]     UNIQUEIDENTIFIER CONSTRAINT [DF_Templates_TemplateGUID] DEFAULT (newid()) NOT NULL,
    [TemplateKey]      VARCHAR (50)     NULL,
    [Name]             VARCHAR (50)     NOT NULL,
    [HTMLContent]      NTEXT            NULL,
    [LayoutTemplate]   BIT              NULL,
    [AllowEdit]        BIT              CONSTRAINT [DF_Templates_AllowEdit] DEFAULT ((0)) NOT NULL,
    [DynamicData]      BIT              CONSTRAINT [DF_Templates_DynamicData] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Templates] PRIMARY KEY CLUSTERED ([TemplateID] ASC)
);

