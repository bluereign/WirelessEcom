﻿ALTER TABLE [catalog].[Device]
    ADD CONSTRAINT [IX_Device_UniqueUPCByManufacturer] UNIQUE NONCLUSTERED ([UPC] ASC, [ManufacturerGuid] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];

