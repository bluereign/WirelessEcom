CREATE TABLE [cms].[ReleaseTemplateCarriers] (
    [ReleaseTemplateCarrierID] BIGINT IDENTITY (1, 1) NOT NULL,
    [ReleaseTemplateID]        BIGINT NOT NULL,
    [CarrierID]                BIGINT NOT NULL,
    CONSTRAINT [PK_ReleaseTemplateCarriers] PRIMARY KEY CLUSTERED ([ReleaseTemplateCarrierID] ASC),
    CONSTRAINT [FK_ReleaseTemplateCarriers_Carriers] FOREIGN KEY ([CarrierID]) REFERENCES [cms].[Carriers] ([CarrierID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ReleaseTemplateCarriers_ReleaseTemplates] FOREIGN KEY ([ReleaseTemplateID]) REFERENCES [cms].[ReleaseTemplates] ([ReleaseTemplateID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [cms].[ReleaseTemplateCarriers] NOCHECK CONSTRAINT [FK_ReleaseTemplateCarriers_Carriers];


GO
ALTER TABLE [cms].[ReleaseTemplateCarriers] NOCHECK CONSTRAINT [FK_ReleaseTemplateCarriers_ReleaseTemplates];

