CREATE TABLE [cms].[CarrierImages] (
    [CarrierImageID] BIGINT IDENTITY (1, 1) NOT NULL,
    [ImageID]        BIGINT NOT NULL,
    [CarrierID]      BIGINT NOT NULL,
    CONSTRAINT [PK_CarrierImages] PRIMARY KEY CLUSTERED ([CarrierImageID] ASC),
    CONSTRAINT [FK_CarrierImages_Carriers] FOREIGN KEY ([CarrierID]) REFERENCES [cms].[Carriers] ([CarrierID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_CarrierImages_Images] FOREIGN KEY ([ImageID]) REFERENCES [cms].[Images] ([ImageID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [cms].[CarrierImages] NOCHECK CONSTRAINT [FK_CarrierImages_Carriers];


GO
ALTER TABLE [cms].[CarrierImages] NOCHECK CONSTRAINT [FK_CarrierImages_Images];

