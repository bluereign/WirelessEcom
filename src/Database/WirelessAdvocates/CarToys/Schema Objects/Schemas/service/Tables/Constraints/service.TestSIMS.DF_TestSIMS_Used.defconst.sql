ALTER TABLE [service].[TestSIMS]
    ADD CONSTRAINT [DF_TestSIMS_Used] DEFAULT ((0)) FOR [Used];

