ALTER TABLE [catalog].[Image]
    ADD CONSTRAINT [DF_Image_Ordinal] DEFAULT ((0)) FOR [Ordinal];

