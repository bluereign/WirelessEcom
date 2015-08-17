ALTER TABLE [catalog].[Image]
    ADD CONSTRAINT [DF_Image_ImageGuid] DEFAULT (newid()) FOR [ImageGuid];

