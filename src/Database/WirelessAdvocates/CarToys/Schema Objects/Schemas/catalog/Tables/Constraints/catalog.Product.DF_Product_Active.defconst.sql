ALTER TABLE [catalog].[Product]
    ADD CONSTRAINT [DF_Product_Active] DEFAULT ((0)) FOR [Active];

